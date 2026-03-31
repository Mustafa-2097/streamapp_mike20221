import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controller/video_controller.dart';
import '../../../replay/controller/replay_comment_controller.dart';
import '../../../replay/model/replay_comment_model.dart';

class VideoLiveScreen extends StatefulWidget {
  final String? replayId;
  const VideoLiveScreen({super.key, this.replayId});

  @override
  State<VideoLiveScreen> createState() => _VideoLiveScreenState();
}

class _VideoLiveScreenState extends State<VideoLiveScreen> {
  // Use tag to distinguish between multiple video controllers if needed (not here)
  final VideoLiveController controller = Get.put(VideoLiveController());
  ReplayCommentController? commentController;

  @override
  void initState() {
    super.initState();
    if (widget.replayId != null) {
      controller.fetchReplay(widget.replayId!);
      commentController = Get.put(
        ReplayCommentController(replayId: widget.replayId!),
      );
    }
  }

  String _fixUrl(String url) {
    return url
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final replay = controller.replay.value;
          if (replay == null) {
            return const Center(
              child: Text(
                "Video not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [
              // ✅ TOP VIDEO SECTION
              _videoPreviewSection(replay),

              // ✅ DETAILS + COMMENTS
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E0E0E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleAndDropdown(replay),
                        const SizedBox(height: 6),
                        _viewsRow(replay),
                        const SizedBox(height: 12),
                        _actionRow(replay),
                        const SizedBox(height: 12),
                        _hashtagsRow(replay),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Comments",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Obx(
                              () => Text(
                                commentController?.formattedTotalCount.value ??
                                    "0",
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _commentsList(replay.replayId),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),

      // ✅ COMMENT INPUT
      bottomNavigationBar: _commentInputBar(),
    );
  }

  // ------------------------------ VIDEO PREVIEW ------------------------------
  Widget _videoPreviewSection(replay) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() {
            if (controller.isVideoInitialized.value && controller.videoPlayerController != null) {
              return VideoPlayer(controller.videoPlayerController!);
            } else {
              // Return thumbnail until the video player is ready
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_fixUrl(replay.thumbnailUrl)),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          }),

          // Play/Pause Overlay Toggle
          Obx(() => GestureDetector(
            onTap: controller.togglePlayback,
            child: Container(
              color: Colors.transparent,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: !controller.isPlaying.value
                    ? const Icon(Icons.play_circle_filled, color: Colors.white70, size: 64)
                    : const SizedBox.shrink(),
              ),
            ),
          )),

          // Top Overlay (Live + viewers)
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        "Replay",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom progress bar + time
          Positioned(
            bottom: 6,
            left: 12,
            right: 12,
            child: Obx(() {
              final isInit = controller.isVideoInitialized.value;
              final player = controller.videoPlayerController;
              
              double progress = 0;
              String timeText = "00:00 / 00:00";
              
              if (isInit && player != null) {
                progress = player.value.position.inMilliseconds / 
                           player.value.duration.inMilliseconds.clamp(1, 999999999);
                
                timeText = "${_formatDuration(player.value.position)} / ${_formatDuration(player.value.duration)}";
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeText,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const Icon(Icons.fullscreen, color: Colors.white, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.yellow), // Yellow to match premium theme
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return d.inHours > 0 ? "${twoDigits(d.inHours)}:$minutes:$seconds" : "$minutes:$seconds";
  }

  // ------------------------------ TITLE + DROPDOWN ------------------------------
  Widget _titleAndDropdown(replay) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            replay.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _viewsRow(replay) {
    return Text(
      "${replay.formattedViews} • ${replay.timeAgo}",
      style: const TextStyle(color: Colors.white54, fontSize: 12),
    );
  }

  // ------------------------------ ACTION ROW ------------------------------
  Widget _actionRow(replay) {
    return Row(
      children: [
        _actionItem(
          icon: replay.userStatus.isLiked
              ? Icons.thumb_up
              : Icons.thumb_up_alt_outlined,
          label: _formatCount(replay.engagement.likes),
          onTap: () => controller.toggleAction("LIKE"),
        ),
        const SizedBox(width: 16),
        _actionItem(
          icon: replay.userStatus.isDisliked
              ? Icons.thumb_down
              : Icons.thumb_down_alt_outlined,
          label: _formatCount(replay.engagement.dislikes),
          onTap: () => controller.toggleAction("DISLIKE"),
        ),
        const SizedBox(width: 16),
        _actionItem(
          icon: Icons.share_outlined,
          label: _formatCount(replay.engagement.shares),
          onTap: controller.shareReplay,
        ),
        const SizedBox(width: 16),
        _actionItem(
          icon: replay.userStatus.isBookmarked
              ? Icons.bookmark
              : Icons.bookmark_outline,
          label: replay.userStatus.isBookmarked ? "Bookmarked" : "Bookmark",
          onTap: controller.toggleBookmark,
        ),
      ],
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------ HASHTAGS ------------------------------
  Widget _hashtagsRow(replay) {
    return Wrap(
      spacing: 8,
      children: replay.tags.map<Widget>((tag) {
        return Text(
          "#$tag",
          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
        );
      }).toList(),
    );
  }

  // ------------------------------ COMMENTS LIST ------------------------------
  Widget _commentsList(String replayId) {
    if (commentController == null) return const SizedBox.shrink();

    return Obx(() {
      if (commentController!.isLoading.value &&
          commentController!.commentsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (commentController!.commentsList.isEmpty) {
        return const Text(
          "No comments yet",
          style: TextStyle(color: Colors.white60, fontSize: 13),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: commentController!.commentsList.length,
        itemBuilder: (context, index) {
          final comment = commentController!.commentsList[index];
          return _CommentTile(comment: comment, controller: commentController!);
        },
      );
    });
  }

  // ------------------------------ COMMENT INPUT ------------------------------
  Widget _commentInputBar() {
    if (commentController == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (commentController!.replyingToCommentId.value.isEmpty)
              return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    "Replying to @${commentController!.replyingToUserName.value}",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: commentController!.cancelReply,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: commentController!.commentController,
                    focusNode: commentController!.commentFocusNode,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: "Add a comment...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(
                () => commentController!.isPosting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.redAccent,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.redAccent),
                        onPressed: commentController!.submitComment,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------ UTILS ------------------------------
  String _formatCount(int count) {
    if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
    if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}K";
    return "$count";
  }
}

class _CommentTile extends StatelessWidget {
  final ReplayComment comment;
  final ReplayCommentController controller;

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
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(
                  comment.user.profilePhoto
                      .replaceAll('localhost', '10.0.30.59')
                      .replaceAll('127.0.0.1', '10.0.30.59'),
                ),
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
                            text: "${comment.user.name} ",
                            style: const TextStyle(
                              color: Colors.redAccent,
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
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => controller.startReply(comment),
                          child: const Text(
                            "Reply",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
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

                    if (comment.replyCount > 0 && comment.replies.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () => controller.fetchReplies(comment),
                          child: Text(
                            "View ${comment.replyCount} ${comment.replyCount == 1 ? 'reply' : 'replies'}",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(count, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _RepliesList extends StatelessWidget {
  final List<ReplayComment> replies;
  final ReplayCommentController controller;
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
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                      reply.user.profilePhoto
                          .replaceAll('localhost', '10.0.30.59')
                          .replaceAll('127.0.0.1', '10.0.30.59'),
                    ),
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
                                text: "${reply.user.name} ",
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
                              reply.likeCount.toString(),
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
