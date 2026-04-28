import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/clips/controller/comment_controller.dart';
import 'package:testapp/features/customer_dashboard/clips/model/comment_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCommentBottomSheet(BuildContext context, String clipId) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentBottomSheet(clipId: clipId),
  );
}

class CommentBottomSheet extends StatelessWidget {
  final String clipId;
  const CommentBottomSheet({super.key, required this.clipId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClipCommentController(clipId: clipId), tag: clipId);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF121418),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Comments",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey[800], thickness: 1),

          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comments  ${controller.formattedTotalCount.value}",
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.commentsList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (controller.commentsList.isEmpty) {
                return const Center(
                  child: Text(
                    "No comments yet",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetchComments(),
                color: Colors.white,
                backgroundColor: const Color(0xFF2C2C2C),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.commentsList.length,
                  itemBuilder: (context, index) {
                    final comment = controller.commentsList[index];
                    return _CommentTile(
                        comment: comment, controller: controller);
                  },
                ),
              );
            }),
          ),

          // Input field
          _CommentInput(controller: controller),
        ],
      ),
    ),
  );
}
}

class _CommentTile extends StatelessWidget {
  final ClipComment comment;
  final ClipCommentController controller;

  const _CommentTile({required this.comment, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                  image: DecorationImage(
                    image: NetworkImage(
                      comment.user.profilePhoto
                          .replaceAll('localhost', '10.0.30.59')
                          .replaceAll('127.0.0.1', '10.0.30.59'),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: comment.user.profilePhoto.isEmpty
                    ? const Icon(Icons.person, color: Colors.white54, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${comment.user.name}: ",
                            style: const TextStyle(
                              color: Colors.yellow, // Custom color for username
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: comment.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _actionIcon(
                          comment.userStatus.isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          comment.likeCount.toString(),
                          comment.userStatus.isLiked
                              ? Colors.blue
                              : Colors.grey,
                          () => controller.toggleCommentAction(
                            comment.commentId,
                            "LIKE",
                          ),
                        ),
                        const SizedBox(width: 16),
                        _actionIcon(
                          comment.userStatus.isDisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_alt_outlined,
                          comment.dislikeCount.toString(),
                          comment.userStatus.isDisliked
                              ? Colors.red
                              : Colors.grey,
                          () => controller.toggleCommentAction(
                            comment.commentId,
                            "DISLIKE",
                          ),
                        ),
                        const SizedBox(width: 24),
                        if (!comment.commentId.startsWith("TEMP"))
                          GestureDetector(
                            onTap: () => controller.startReply(comment),
                            child: Row(
                              children: const [
                                Icon(Icons.reply, color: Colors.grey, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  "Reply",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    // Inner Replies
                    if (comment.replies.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _RepliesList(
                          replies: comment.replies,
                          controller: controller,
                          parentCommentId: comment.commentId,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(
    IconData icon,
    String count,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(count, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _RepliesList extends StatelessWidget {
  final List<ClipComment> replies;
  final ClipCommentController controller;
  final String parentCommentId;

  const _RepliesList({
    required this.replies,
    required this.controller,
    required this.parentCommentId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: replies
          .map(
            (reply) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                      image: DecorationImage(
                        image: NetworkImage(
                          reply.user.profilePhoto
                              .replaceAll('localhost', '10.0.30.59')
                              .replaceAll('127.0.0.1', '10.0.30.59'),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: reply.user.profilePhoto.isEmpty
                        ? const Icon(Icons.person,
                            color: Colors.white54, size: 12)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${reply.user.name}: ",
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: reply.content,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _replyActionIcon(
                              reply.userStatus.isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined,
                              reply.likeCount.toString(),
                              reply.userStatus.isLiked
                                  ? Colors.blue
                                  : Colors.grey,
                              () => controller.toggleCommentAction(
                                reply.commentId,
                                "LIKE",
                                parentId: parentCommentId,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _replyActionIcon(
                              reply.userStatus.isDisliked
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_alt_outlined,
                              reply.dislikeCount.toString(),
                              reply.userStatus.isDisliked
                                  ? Colors.red
                                  : Colors.grey,
                              () => controller.toggleCommentAction(
                                reply.commentId,
                                "DISLIKE",
                                parentId: parentCommentId,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _replyActionIcon(
    IconData icon,
    String count,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(count, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final ClipCommentController controller;
  const _CommentInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF121418),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (controller.replyingToCommentId.value.isEmpty)
              return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black26,
              child: Row(
                children: [
                  Text(
                    "Replying to @${controller.replyingToUserName.value}",
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: controller.cancelReply,
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF38354B),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: controller.commentController,
                    focusNode: controller.commentFocusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: controller.submitComment,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
