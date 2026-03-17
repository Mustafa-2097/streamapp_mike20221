import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/data/customer_api_service.dart';
import 'package:testapp/features/customer_dashboard/clips/model/comment_model.dart';
import 'package:testapp/core/const/app_colors.dart';

class ClipCommentController extends GetxController {
  final String clipId;

  ClipCommentController({required this.clipId});

  var isLoading = false.obs;
  var isPosting = false.obs;
  var commentsList = <ClipComment>[].obs;
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
      final response = await CustomerApiService.getClipComments(clipId);
      if (response['success'] == true) {
        final data = response['data'];
        totalComments.value = data['totalCount'] ?? 0;
        formattedTotalCount.value = data['formattedTotalCount'] ?? "0";

        final List commentsData = data['comments'] ?? [];
        commentsList.value = commentsData
            .map((e) => ClipComment.fromJson(e))
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

    isPosting.value = true;
    try {
      final parentId = replyingToCommentId.value.isEmpty
          ? null
          : replyingToCommentId.value;

      final response = await CustomerApiService.postComment(
        clipId: clipId,
        content: content,
        parentId: parentId,
      );

      if (response['success'] == true) {
        commentController.clear();
        cancelReply();
        commentFocusNode.unfocus();
        // Refresh comments to show the new one
        await fetchComments();
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to post comment",
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error posting comment: $e");
    } finally {
      isPosting.value = false;
    }
  }

  void startReply(ClipComment comment) {
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
      final response = await CustomerApiService.postCommentAction(
        commentId: commentId,
        type: type,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Refresh to update counts and status
        await fetchComments();
      }
    } catch (e) {
      print("Error toggling comment action: $e");
    }
  }

  Future<void> fetchReplies(ClipComment parentComment) async {
    // If we wanted to fetch replies separately for a "View more replies" button
    try {
      final response = await CustomerApiService.getCommentReplies(
        parentComment.commentId,
      );
      if (response['success'] == true) {
        final List repliesData = response['data'] ?? [];
        final List<ClipComment> fetchedReplies = repliesData
            .map((e) => ClipComment.fromJson(e))
            .toList();

        // Find parent and update replies
        final index = commentsList.indexWhere(
          (c) => c.commentId == parentComment.commentId,
        );
        if (index != -1) {
          final updatedComment = ClipComment(
            commentId: parentComment.commentId,
            clipId: parentComment.clipId,
            userId: parentComment.userId,
            content: parentComment.content,
            parentCommentId: parentComment.parentCommentId,
            createdAt: parentComment.createdAt,
            updatedAt: parentComment.updatedAt,
            user: parentComment.user,
            replyCount: parentComment.replyCount,
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
