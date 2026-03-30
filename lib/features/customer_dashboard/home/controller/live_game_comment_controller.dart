import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/live_game_comment_model.dart';

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

    try {
      isPosting.value = true;
      final response = await CustomerApiService.postLiveGameComment(
        gameId,
        text,
        parentId: replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value,
      );

      if (response['success'] == true) {
        commentController.clear();
        commentFocusNode.unfocus();
        cancelReply();
        fetchComments(); // Refresh list
      }
    } catch (e) {
      debugPrint("Error posting game comment: $e");
    } finally {
      isPosting.value = false;
    }
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

  Future<void> toggleAction(String commentId, String type, {String? parentId}) async {
    try {
      final response = await CustomerApiService.postLiveGameCommentAction(
        commentId,
        type,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Simple refresh for now
        fetchComments();
      }
    } catch (e) {
      debugPrint("Error toggling action: $e");
    }
  }

  Future<List<LiveGameComment>> fetchReplies(String commentId) async {
    try {
      final response = await CustomerApiService.getLiveGameCommentReplies(commentId);
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
