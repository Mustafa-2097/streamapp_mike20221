import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/live_tv_comment_model.dart';
import '../../profile/controller/profile_controller.dart';
import '../../../../core/const/app_colors.dart';

class LiveTvCommentController extends GetxController {
  final String liveTvId;

  LiveTvCommentController({required this.liveTvId});

  var isLoading = false.obs;
  var isPosting = false.obs;
  var commentsList = <LiveTvComment>[].obs;
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
      final response = await CustomerApiService.getLiveTvComments(liveTvId);
      if (response['success'] == true) {
        final data = response['data'];
        final List commentsData = data['comments'] ?? [];
        totalComments.value = commentsData.length;
        formattedTotalCount.value = totalComments.value.toString();
        
        commentsList.value = commentsData
            .map((e) => LiveTvComment.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching Live TV comments: $e");
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
    final optimisticComment = LiveTvComment(
      commentId: tempId,
      liveTvId: liveTvId,
      userId: profile.id,
      content: content,
      parentCommentId: replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: CommentUser(
        id: profile.id,
        name: profile.name ?? "",
        profilePhoto: profile.profilePhoto ?? "",
      ),
      replyCount: 0,
      replies: [],
      likeCount: 0,
      dislikeCount: 0,
      userStatus: CommentUserStatus(isLiked: false, isDisliked: false),
    );

    // Save context for rollback
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
        commentsList[parentIndex] = LiveTvComment(
          commentId: parent.commentId,
          liveTvId: parent.liveTvId,
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
    // --- END OPTIMISTIC ---

    try {
      final response = await CustomerApiService.postLiveTvComment(
        liveTvId: liveTvId,
        content: originalContent,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Success - server will give us the real list upon refresh
        await fetchComments();
        if (parentId != null) {
          final parent = commentsList.firstWhereOrNull((c) => c.commentId == parentId);
          if (parent != null) await fetchReplies(parent);
        }
      } else {
        // Rollback
        _rollbackOptimistic(tempId, originalContent, parentId);
        Get.snackbar("Error", response['message'] ?? "Failed to post comment", backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error posting Live TV comment: $e");
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
        commentsList[parentIndex] = LiveTvComment(
          commentId: parent.commentId,
          liveTvId: parent.liveTvId,
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

  void startReply(LiveTvComment comment) {
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
      final response = await CustomerApiService.postLiveTvCommentAction(
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
      debugPrint("Error toggling Live TV comment action: $e");
    }
  }

  Future<void> fetchReplies(LiveTvComment parentComment) async {
    try {
      final response = await CustomerApiService.getLiveTvCommentReplies(
        parentComment.commentId,
      );
      if (response['success'] == true) {
        final List repliesData = response['data'] ?? [];
        final List<LiveTvComment> fetchedReplies = repliesData
            .map((e) => LiveTvComment.fromJson(e))
            .toList();

        // Find parent and update replies
        final index = commentsList.indexWhere(
          (c) => c.commentId == parentComment.commentId,
        );
        if (index != -1) {
          final old = commentsList[index];
          commentsList[index] = LiveTvComment(
            commentId: old.commentId,
            liveTvId: old.liveTvId,
            userId: old.userId,
            content: old.content,
            parentCommentId: old.parentCommentId,
            createdAt: old.createdAt,
            updatedAt: old.updatedAt,
            user: old.user,
            replyCount: fetchedReplies.length,
            replies: fetchedReplies,
            likeCount: old.likeCount,
            dislikeCount: old.dislikeCount,
            userStatus: old.userStatus,
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching Live TV replies: $e");
    }
  }
}
