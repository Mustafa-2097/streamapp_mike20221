import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/data/customer_api_service.dart';
import 'package:testapp/features/customer_dashboard/clips/model/comment_model.dart';
import 'package:testapp/features/customer_dashboard/clips/model/clips_model.dart';
import 'package:testapp/core/const/app_colors.dart';
import 'package:testapp/features/customer_dashboard/profile/controller/profile_controller.dart';

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

    final parentId = replyingToCommentId.value.isEmpty ? null : replyingToCommentId.value;

    // --- Optimistic Update Start ---
    final profile = ProfileController.instance.profile.value;
    final dummyComment = ClipComment(
      commentId: "TEMP_${DateTime.now().millisecondsSinceEpoch}",
      clipId: clipId,
      userId: profile?.id ?? "local",
      content: content,
      parentCommentId: parentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: ClipUser(
        id: profile?.id ?? "local",
        name: profile?.name ?? "User",
        profilePhoto: profile?.profilePhoto ?? "",
      ),
      replyCount: 0,
      replies: [],
      likeCount: 0,
      dislikeCount: 0,
      userStatus: CommentUserStatus(isLiked: false, isDisliked: false),
    );

    int insertionIndex = -1;

    if (parentId == null) {
      commentsList.insert(0, dummyComment);
      totalComments.value++;
      formattedTotalCount.value = "${totalComments.value}";
    } else {
      for (int i = 0; i < commentsList.length; i++) {
        if (commentsList[i].commentId == parentId) {
          commentsList[i].replies.add(dummyComment);
          commentsList[i].replyCount++;
          insertionIndex = i;
          break;
        }
      }
    }
    commentsList.refresh();

    final prevText = content;
    commentController.clear();
    cancelReply();
    commentFocusNode.unfocus();
    // --- Optimistic Update End ---

    isPosting.value = true;
    try {
      final response = await CustomerApiService.postComment(
        clipId: clipId,
        content: content,
        parentId: parentId,
      );

      if (response['success'] == true) {
        // Success: Refresh to get real IDs and server timestamps
        await fetchComments();
      } else {
        // Failure: Rollback
        _rollbackSubmission(dummyComment, parentId, insertionIndex, prevText);
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to post comment",
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      _rollbackSubmission(dummyComment, parentId, insertionIndex, prevText);
      print("Error posting comment: $e");
    } finally {
      isPosting.value = false;
    }
  }

  void _rollbackSubmission(ClipComment dummy, String? parentId, int index, String text) {
    if (parentId == null) {
      commentsList.removeWhere((c) => c.commentId == dummy.commentId);
      totalComments.value--;
      formattedTotalCount.value = "${totalComments.value}";
    } else if (index != -1) {
      commentsList[index].replies.removeWhere((r) => r.commentId == dummy.commentId);
      commentsList[index].replyCount--;
    }
    commentsList.refresh();
    commentController.text = text; // Keep text so user can retry
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
    // --- Optimistic Update Start ---
    ClipComment? target;
    ClipComment? parent;
    int? parentIdx;

    if (parentId == null) {
      target = commentsList.firstWhereOrNull((c) => c.commentId == commentId);
    } else {
      parentIdx = commentsList.indexWhere((c) => c.commentId == parentId);
      if (parentIdx != -1) {
        parent = commentsList[parentIdx];
        target = parent.replies.firstWhereOrNull((r) => r.commentId == commentId);
      }
    }

    if (target == null) return;

    final oldIsLiked = target.userStatus.isLiked;
    final oldIsDisliked = target.userStatus.isDisliked;
    final oldLikes = target.likeCount;
    final oldDislikes = target.dislikeCount;

    if (type == "LIKE") {
      if (target.userStatus.isLiked) {
        target.userStatus.isLiked = false;
        target.likeCount--;
      } else {
        target.userStatus.isLiked = true;
        target.likeCount++;
        if (target.userStatus.isDisliked) {
          target.userStatus.isDisliked = false;
          target.dislikeCount--;
        }
      }
    } else if (type == "DISLIKE") {
      if (target.userStatus.isDisliked) {
        target.userStatus.isDisliked = false;
        target.dislikeCount--;
      } else {
        target.userStatus.isDisliked = true;
        target.dislikeCount++;
        if (target.userStatus.isLiked) {
          target.userStatus.isLiked = false;
          target.likeCount--;
        }
      }
    }
    commentsList.refresh();
    // --- Optimistic Update End ---

    try {
      final response = await CustomerApiService.postCommentAction(
        commentId: commentId,
        type: type,
        parentId: parentId,
      );

      if (response['success'] != true) {
        // Rollback
        target.userStatus.isLiked = oldIsLiked;
        target.userStatus.isDisliked = oldIsDisliked;
        target.likeCount = oldLikes;
        target.dislikeCount = oldDislikes;
        commentsList.refresh();
      }
    } catch (e) {
      target.userStatus.isLiked = oldIsLiked;
      target.userStatus.isDisliked = oldIsDisliked;
      target.likeCount = oldLikes;
      target.dislikeCount = oldDislikes;
      commentsList.refresh();
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
