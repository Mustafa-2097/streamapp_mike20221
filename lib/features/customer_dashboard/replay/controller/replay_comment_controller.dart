import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/data/customer_api_service.dart';
import 'package:testapp/features/customer_dashboard/replay/model/replay_comment_model.dart';
import 'package:testapp/features/customer_dashboard/replay/model/replay_model.dart';
import 'package:testapp/features/customer_dashboard/profile/controller/profile_controller.dart';
import 'package:testapp/core/const/app_colors.dart';

class ReplayCommentController extends GetxController {
  final String replayId;

  ReplayCommentController({required this.replayId});

  var isLoading = false.obs;
  var isPosting = false.obs;
  var commentsList = <ReplayComment>[].obs;
  var totalComments = 0.obs;
  var formattedTotalCount = "0".obs;

  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  // For replies
  var replyingToCommentId = "".obs;
  var replyingToUserName = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  @override
  void onClose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchComments() async {
    isLoading.value = true;
    try {
      final response = await CustomerApiService.getReplayComments(replayId);
      if (response['success'] == true) {
        final data = response['data'];
        totalComments.value = data['totalCount'] ?? 0;
        formattedTotalCount.value = data['formattedTotalCount'] ?? "0";

        final List commentsData = data['comments'] ?? [];
        commentsList.value = commentsData
            .map((e) => ReplayComment.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    // --- OPTIMISTIC UI: PHASE 1 (INSTANT ADD) ---
    final profile = Get.find<ProfileController>().profile.value;
    if (profile == null) return;

    final String tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
    final optimisticComment = ReplayComment(
      commentId: tempId,
      replayId: replayId,
      userId: profile.id,
      content: content,
      parentCommentId: replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: ReplayUser(
        id: profile.id,
        name: profile.name ?? "",
        profilePhoto: profile.profilePhoto ?? "",
      ),
      replyCount: 0,
      replies: [],
      likeCount: 0,
      dislikeCount: 0,
      userStatus: ReplayCommentUserStatus(isLiked: false, isDisliked: false),
    );

    // Save context for possible rollback
    final originalContent = content;
    final parentId = replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value;

    // Immediately update UI
    if (parentId == null) {
      commentsList.insert(0, optimisticComment);
      totalComments.value++;
    } else {
      // Find parent and add to its replies list optimistically
      final parentIndex = commentsList.indexWhere((c) => c.commentId == parentId);
      if (parentIndex != -1) {
        final parent = commentsList[parentIndex];
        final updatedReplies = [...parent.replies, optimisticComment];
        commentsList[parentIndex] = ReplayComment(
          commentId: parent.commentId,
          replayId: parent.replayId,
          userId: parent.userId,
          content: parent.content,
          parentCommentId: parent.parentCommentId,
          createdAt: parent.createdAt,
          updatedAt: parent.updatedAt,
          user: parent.user,
          replyCount: parent.replyCount + 1,
          replies: updatedReplies,
          likeCount: parent.likeCount,
          dislikeCount: parent.dislikeCount,
          userStatus: parent.userStatus,
        );
      }
    }
    
    commentController.clear();
    cancelReply();
    commentFocusNode.unfocus();
    isPosting.value = true;

    try {
      final response = await CustomerApiService.postReplayComment(
        replayId: replayId,
        content: originalContent,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Success - server will give us the real list upon refresh
        await fetchComments();
        // If it was a reply, we might need to fetch replies for that parent to be sure
        if (parentId != null) {
          final parent = commentsList.firstWhereOrNull((c) => c.commentId == parentId);
          if (parent != null) await fetchReplies(parent);
        }
      } else {
        // Rollback on error
        _rollbackOptimistic(tempId, originalContent, parentId);
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to post comment",
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error posting comment: $e");
      _rollbackOptimistic(tempId, originalContent, parentId);
    } finally {
      isPosting.value = false;
    }
  }

  void _rollbackOptimistic(String tempId, String originalContent, String? parentId) {
    if (parentId == null) {
      commentsList.removeWhere((c) => c.commentId == tempId);
      totalComments.value--;
    } else {
      final parentIndex = commentsList.indexWhere((c) => c.commentId == parentId);
      if (parentIndex != -1) {
        final parent = commentsList[parentIndex];
        final updatedReplies = parent.replies.where((r) => r.commentId != tempId).toList();
        commentsList[parentIndex] = ReplayComment(
          commentId: parent.commentId,
          replayId: parent.replayId,
          userId: parent.userId,
          content: parent.content,
          parentCommentId: parent.parentCommentId,
          createdAt: parent.createdAt,
          updatedAt: parent.updatedAt,
          user: parent.user,
          replyCount: parent.replyCount - 1,
          replies: updatedReplies,
          likeCount: parent.likeCount,
          dislikeCount: parent.dislikeCount,
          userStatus: parent.userStatus,
        );
      }
    }
    commentController.text = originalContent; // Restore text
  }

  void startReply(ReplayComment comment) {
    replyingToCommentId.value = comment.commentId;
    replyingToUserName.value = comment.user.name;
    commentFocusNode.requestFocus();
  }

  void cancelReply() {
    replyingToCommentId.value = "";
    replyingToUserName.value = "";
  }

  Future<void> toggleCommentAction(
    String commentId,
    String type, {
    String? parentId,
  }) async {
    try {
      final response = await CustomerApiService.postReplayCommentAction(
        commentId: commentId,
        type: type,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Refresh to update counts and status
        await fetchComments();
        if (parentId != null) {
          final parent = commentsList.firstWhereOrNull((c) => c.commentId == parentId);
          if (parent != null) await fetchReplies(parent);
        }
      }
    } catch (e) {
      print("Error toggling comment action: $e");
    }
  }

  Future<void> fetchReplies(ReplayComment parentComment) async {
    try {
      final response = await CustomerApiService.getReplayCommentReplies(
        parentComment.commentId,
      );
      if (response['success'] == true) {
        final List repliesData = response['data'] ?? [];
        final List<ReplayComment> fetchedReplies = repliesData
            .map((e) => ReplayComment.fromJson(e))
            .toList();

        // Find parent and update replies
        final index = commentsList.indexWhere(
          (c) => c.commentId == parentComment.commentId,
        );
        if (index != -1) {
          final updatedComment = ReplayComment(
            commentId: parentComment.commentId,
            replayId: parentComment.replayId,
            userId: parentComment.userId,
            content: parentComment.content,
            parentCommentId: parentComment.parentCommentId,
            createdAt: parentComment.createdAt,
            updatedAt: parentComment.updatedAt,
            user: parentComment.user,
            replyCount: fetchedReplies.length,
            replies: fetchedReplies,
            likeCount: parentComment.likeCount,
            dislikeCount: parentComment.dislikeCount,
            userStatus: parentComment.userStatus,
          );
          commentsList[index] = updatedComment;
        }
      }
    } catch (e) {
      print("Error fetching replies: $e");
    }
  }
}
