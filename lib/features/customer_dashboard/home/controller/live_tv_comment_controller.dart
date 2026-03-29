import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/live_tv_comment_model.dart';
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
        // The endpoint is actually 'getLiveTvById' so we parse its data
        
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

    isPosting.value = true;
    try {
      final parentId = replyingToCommentId.value.isEmpty
          ? null
          : replyingToCommentId.value;

      final response = await CustomerApiService.postLiveTvComment(
        liveTvId: liveTvId,
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
      debugPrint("Error posting Live TV comment: $e");
    } finally {
      isPosting.value = false;
    }
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
            replyCount: old.replyCount,
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
