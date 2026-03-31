import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/live_game_comment_model.dart';
import '../../profile/controller/profile_controller.dart';
import 'package:testapp/core/const/app_colors.dart';

class LiveGameCommentController extends GetxController {
  final String gameId;

  LiveGameCommentController(this.gameId);

  var isLoading = false.obs;
  var isPosting = false.obs;
  var commentsList = <LiveGameComment>[].obs;
  var totalComments = 0.obs;
  var formattedTotalCount = "0".obs;

  // For Replying
  var replyingToCommentId = "".obs;
  var replyingToUserName = "".obs;

  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getLiveGameComments(gameId);
      
      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        totalComments.value = data.length;
        formattedTotalCount.value = totalComments.value.toString();
        
        commentsList.value = data
            .map((e) => LiveGameComment.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching game comments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    // --- OPTIMISTIC UI: PHASE 1 (INSTANT ADD) ---
    final profile = Get.find<ProfileController>().profile.value;
    if (profile == null) return;

    final String tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
    final optimisticComment = LiveGameComment(
      id: tempId,
      userId: profile.id,
      content: text,
      parentCommentId: replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: CommentUser(
        id: profile.id,
        name: profile.name ?? "",
        profilePhoto: profile.profilePhoto ?? "",
      ),
      totalLikes: 0,
      totalDislikes: 0,
      liked: false,
      disliked: false,
      replies: [],
    );

    // Save context for rollback
    final originalText = text;
    final parentId = replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value;

    // Push local UI update first
    if (parentId == null) {
      commentsList.insert(0, optimisticComment);
      totalComments.value++;
    } else {
      // Find parent and add to its replies list optimistically
      final parentIndex = commentsList.indexWhere((c) => c.id == parentId);
      if (parentIndex != -1) {
        final parent = commentsList[parentIndex];
        final updatedReplies = [...parent.replies, optimisticComment];
        commentsList[parentIndex] = LiveGameComment(
          id: parent.id,
          userId: parent.userId,
          content: parent.content,
          parentCommentId: parent.parentCommentId,
          createdAt: parent.createdAt,
          updatedAt: parent.updatedAt,
          user: parent.user,
          totalLikes: parent.totalLikes,
          totalDislikes: parent.totalDislikes,
          liked: parent.liked,
          disliked: parent.disliked,
          replies: updatedReplies,
        );
      }
    }

    commentController.clear();
    cancelReply();
    commentFocusNode.unfocus();
    isPosting.value = true;
    // --- END OPTIMISTIC ---

    try {
      final response = await CustomerApiService.postLiveGameComment(
        gameId,
        originalText,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Success - clean up and sync with server list
        await fetchComments();
        if (parentId != null) {
          final replies = await fetchReplies(parentId);
          final index = commentsList.indexWhere((c) => c.id == parentId);
          if (index != -1) {
            final parent = commentsList[index];
            commentsList[index] = LiveGameComment(
              id: parent.id,
              userId: parent.userId,
              content: parent.content,
              parentCommentId: parent.parentCommentId,
              createdAt: parent.createdAt,
              updatedAt: parent.updatedAt,
              user: parent.user,
              totalLikes: parent.totalLikes,
              totalDislikes: parent.totalDislikes,
              liked: parent.liked,
              disliked: parent.disliked,
              replies: replies,
            );
          }
        }
      } else {
        // Rollback
        _rollbackOptimistic(tempId, originalText, parentId);
        Get.snackbar("Error", response['message'] ?? "Failed to post comment", backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error posting game comment: $e");
      _rollbackOptimistic(tempId, originalText, parentId);
    } finally {
      isPosting.value = false;
    }
  }

  void _rollbackOptimistic(String tempId, String originalText, String? parentId) {
    if (parentId == null) {
      commentsList.removeWhere((c) => c.id == tempId);
      totalComments.value--;
    } else {
      final parentIndex = commentsList.indexWhere((c) => c.id == parentId);
      if (parentIndex != -1) {
        final parent = commentsList[parentIndex];
        final updatedReplies = parent.replies.where((r) => r.id != tempId).toList();
        commentsList[parentIndex] = LiveGameComment(
          id: parent.id,
          userId: parent.userId,
          content: parent.content,
          parentCommentId: parent.parentCommentId,
          createdAt: parent.createdAt,
          updatedAt: parent.updatedAt,
          user: parent.user,
          totalLikes: parent.totalLikes,
          totalDislikes: parent.totalDislikes,
          liked: parent.liked,
          disliked: parent.disliked,
          replies: updatedReplies,
        );
      }
    }
    commentController.text = originalText;
  }

  void setReply(String commentId, String userName) {
    replyingToCommentId.value = commentId;
    replyingToUserName.value = userName;
    commentFocusNode.requestFocus();
  }

  void cancelReply() {
    replyingToCommentId.value = "";
    replyingToUserName.value = "";
  }

  Future<void> toggleAction(
    String commentId,
    String type, {
    String? parentId,
  }) async {
    try {
      final response = await CustomerApiService.postLiveGameCommentAction(
        commentId,
        type,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Simple refresh for now
        await fetchComments();
        if (parentId != null) {
          final replies = await fetchReplies(parentId);
          final index = commentsList.indexWhere((c) => c.id == parentId);
          if (index != -1) {
            final parent = commentsList[index];
            commentsList[index] = LiveGameComment(
              id: parent.id,
              userId: parent.userId,
              content: parent.content,
              parentCommentId: parent.parentCommentId,
              createdAt: parent.createdAt,
              updatedAt: parent.updatedAt,
              user: parent.user,
              totalLikes: parent.totalLikes,
              totalDislikes: parent.totalDislikes,
              liked: parent.liked,
              disliked: parent.disliked,
              replies: replies,
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error toggling action: $e");
    }
  }

  Future<List<LiveGameComment>> fetchReplies(String commentId) async {
    try {
      final response = await CustomerApiService.getLiveGameCommentReplies(
        commentId,
      );
      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        return data.map((e) => LiveGameComment.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching replies: $e");
    }
    return [];
  }

  @override
  void onClose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }
}
