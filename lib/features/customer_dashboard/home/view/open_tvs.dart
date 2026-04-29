import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/live_tv_controller.dart';
import '../controller/live_tv_comment_controller.dart';
import '../model/live_tv_comment_model.dart';
import '../../profile/controller/profile_controller.dart';
import '../../subscription/view/subscription_screen.dart';
import '../../../../core/const/app_colors.dart';

String _getTimeAgo(DateTime dateTime) {
  final duration = DateTime.now().difference(dateTime);
  if (duration.inDays >= 365) return "${(duration.inDays / 365).floor()}y ago";
  if (duration.inDays >= 30) return "${(duration.inDays / 30).floor()}mo ago";
  if (duration.inDays >= 7) return "${(duration.inDays / 7).floor()}w ago";
  if (duration.inDays >= 1) return "${duration.inDays}d ago";
  if (duration.inHours >= 1) return "${duration.inHours}h ago";
  if (duration.inMinutes >= 1) return "${duration.inMinutes}m ago";
  return "Just now";
}

class OpenTvs extends StatefulWidget {
  OpenTvs({super.key});

  @override
  State<OpenTvs> createState() => _OpenTvsState();
}

class _OpenTvsState extends State<OpenTvs> {
  final LiveTvController controller = Get.put(LiveTvController());
  LiveTvCommentController? commentController;
  late final WebViewController webController;
  String? _lastLoadedLink;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final vController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black);

    vController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          // Inject CSS to make the video full width
          vController.runJavaScript('''
            var style = document.createElement('style');
            style.innerHTML = 'video { width: 100% !important; height: 100% !important; object-fit: contain !important; } body { margin: 0; background: black; display: flex; align-items: center; justify-content: center; height: 100vh; }';
            document.head.appendChild(style);
          ''');
        },
      ),
    );
    webController = vController;
    _initSelection();
  }

  void _initSelection() {
    // Auto-select first channel if none selected
    if (controller.selectedLiveTv.value == null &&
        controller.liveTvs.isNotEmpty) {
      controller.selectedLiveTv.value = controller.liveTvs.first;
    }

    if (controller.selectedLiveTv.value != null) {
      final tv = controller.selectedLiveTv.value!;
      _lastLoadedLink = tv.link;
      webController.loadRequest(Uri.parse(tv.link));
      commentController = Get.put(
        LiveTvCommentController(liveTvId: tv.id),
        tag: tv.id,
      );
    }
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });

    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _loadVideo(String url) {
    webController.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    /// Load video ONLY when selectedLiveTv changes its link
    ever(controller.selectedLiveTv, (liveTv) {
      if (liveTv != null && mounted && liveTv.link != _lastLoadedLink) {
        _lastLoadedLink = liveTv.link;
        _loadVideo(liveTv.link);
        // Reset comment controller for new TV
        if (commentController != null) {
          Get.delete<LiveTvCommentController>(tag: commentController?.liveTvId);
        }
        commentController = Get.put(
          LiveTvCommentController(liveTvId: liveTv.id),
          tag: liveTv.id,
        );
        setState(() {});
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Live TV",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: Obx(() {
          // If we already have a selected live TV, don't show the full-screen loader
          // during background refreshes.
          if (controller.isLoading.value &&
              controller.selectedLiveTv.value == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          if (controller.selectedLiveTv.value == null) {
            return const Center(
              child: Text(
                "No Live Stream Available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final liveTv = controller.selectedLiveTv.value!;
          final profileController = Get.find<ProfileController>();
          final isUserPremium =
              profileController.profile.value?.isPremiumUser ?? false;
          final bool isLocked = liveTv.isPremium && !isUserPremium;

          if (isLocked) {
            return _buildPremiumLockedScreen();
          }

          return Column(
            children: [
              /// VIDEO
              SizedBox(
                height: isFullScreen
                    ? MediaQuery.of(context).size.height
                    : 240.h,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    WebViewWidget(controller: webController),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _toggleFullScreen,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// DETAILS
              if (!isFullScreen)
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (commentController != null) {
                        await commentController!.fetchComments();
                      }
                    },
                    color: Colors.white,
                    backgroundColor: const Color(0xFF2C2C2C),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  liveTv.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // const Icon(
                              //   Icons.keyboard_arrow_down,
                              //   color: Colors.white70,
                              // ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Live • Streaming",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// Action Row (Like, Dislike, Share)
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: _actionItem(
                                  icon: liveTv.liked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_alt_outlined,
                                  label: _formatCount(liveTv.likes),
                                  color: liveTv.liked
                                      ? const Color.fromARGB(255, 14, 126, 255)
                                      : Colors.white70,
                                  onTap: () => controller.toggleLike(liveTv.id),
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 60,
                                child: _actionItem(
                                  icon: liveTv.disliked
                                      ? Icons.thumb_down
                                      : Icons.thumb_down_alt_outlined,
                                  label: _formatCount(liveTv.dislikes),
                                  color: liveTv.disliked
                                      ? Colors.redAccent
                                      : Colors.white70,
                                  onTap: () =>
                                      controller.toggleDislike(liveTv.id),
                                ),
                              ),
                              // const SizedBox(width: 20),
                              // SizedBox(
                              //   width: 60,
                              //   child: _actionItem(
                              //     icon: Icons.share_outlined,
                              //     label: "Share",
                              //     onTap: () => controller.shareLiveTv(liveTv.id),
                              //   ),
                              // ),
                            ],
                          ),

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
                                  commentController
                                          ?.formattedTotalCount
                                          .value ??
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
                          _commentsList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (!isFullScreen) _commentInputBar(),
            ],
          );
        }),
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white70,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}K";
    }
    return count.toString();
  }

  // ---------------- COMMENT INPUT ----------------
  Widget _commentInputBar() {
    return Obx(() {
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
            if (commentController!.replyingToCommentId.value.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
              ),
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
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.redAccent),
                  onPressed: commentController!.isPosting.value
                      ? null
                      : commentController!.submitComment,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ---------------- COMMENTS LIST ----------------
  Widget _commentsList() {
    if (commentController == null) return const SizedBox.shrink();

    return Obx(() {
      if (commentController!.isLoading.value &&
          commentController!.commentsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      /* if (commentController!.commentsList.isEmpty) {
        return const Text(
          "No comments yet",
          style: TextStyle(color: Colors.white60, fontSize: 13),
        );
      } */

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

  /* // ---------------- COMMENT INPUT ----------------
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
  } */

  Widget _buildPremiumLockedScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_rounded,
                color: AppColors.primaryColor,
                size: 64.sp,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Premium Required",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "This channel is only available for premium subscribers. Upgrade your plan to enjoy exclusive live TV content.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.to(() => const SubscriptionPage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Upgrade Now",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final LiveTvComment comment;
  final LiveTvCommentController controller;

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
                    const SizedBox(height: 4),
                    Text(
                      _getTimeAgo(comment.createdAt),
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                    const SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     _actionIcon(
                    //       comment.userStatus.isLiked
                    //           ? Icons.thumb_up
                    //           : Icons.thumb_up_alt_outlined,
                    //       comment.likeCount.toString(),
                    //       comment.userStatus.isLiked
                    //           ? Colors.redAccent
                    //           : Colors.grey,
                    //       () => controller.toggleCommentAction(
                    //         comment.commentId,
                    //         "LIKE",
                    //       ),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     _actionIcon(
                    //       comment.userStatus.isDisliked
                    //           ? Icons.thumb_down
                    //           : Icons.thumb_down_alt_outlined,
                    //       comment.dislikeCount.toString(),
                    //       comment.userStatus.isDisliked
                    //           ? Colors.redAccent
                    //           : Colors.grey,
                    //       () => controller.toggleCommentAction(
                    //         comment.commentId,
                    //         "DISLIKE",
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     GestureDetector(
                    //       onTap: () => controller.startReply(comment),
                    //       child: const Text(
                    //         "Reply",
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

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
  final List<LiveTvComment> replies;
  final LiveTvCommentController controller;
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
                        ? const Icon(
                            Icons.person,
                            color: Colors.white54,
                            size: 12,
                          )
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
                        const SizedBox(height: 2),
                        Text(
                          _getTimeAgo(reply.createdAt),
                          style: const TextStyle(color: Colors.white38, fontSize: 9),
                        ),
                        const SizedBox(height: 6),
                        // Row(
                        //   children: [
                        //     _replyActionIcon(
                        //       reply.userStatus.isLiked
                        //           ? Icons.thumb_up
                        //           : Icons.thumb_up_alt_outlined,
                        //       reply.likeCount.toString(),
                        //       reply.userStatus.isLiked
                        //           ? Colors.redAccent
                        //           : Colors.grey,
                        //       () => controller.toggleCommentAction(
                        //         reply.commentId,
                        //         "LIKE",
                        //         parentId: parentCommentId,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 12),
                        //     _replyActionIcon(
                        //       reply.userStatus.isDisliked
                        //           ? Icons.thumb_down
                        //           : Icons.thumb_down_alt_outlined,
                        //       reply.dislikeCount.toString(),
                        //       reply.userStatus.isDisliked
                        //           ? Colors.redAccent
                        //           : Colors.grey,
                        //       () => controller.toggleCommentAction(
                        //         reply.commentId,
                        //         "DISLIKE",
                        //         parentId: parentCommentId,
                        //       ),
                        //     ),
                        //   ],
                        // ),
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../live/live_video/controller/video_controller.dart';
//
// class openTvs extends StatefulWidget {
//   final String? videoUrl;
//   final String? videoTitle;
//   final String? viewerCount;
//
//   const openTvs({
//     super.key,
//     this.videoUrl =
//     'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv2',
//     this.videoTitle = 'Brazil VS Spain || World Cup Live Match',
//     this.viewerCount = '205K',
//   });
//
//   @override
//   State<openTvs> createState() => _openTvOneState();
// }
//
// class _openTvOneState extends State<openTvs> {
//   final VideoLiveController liveController = Get.put(VideoLiveController());
//
//   late final WebViewController _webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.black)
//       ..loadRequest(Uri.parse(widget.videoUrl!));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ VIDEO (WEBVIEW)
//             _videoPreviewSection(),
//
//             // ✅ DETAILS + COMMENTS
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF0E0E0E),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(18),
//                     topRight: Radius.circular(18),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _titleAndDropdown(),
//                       const SizedBox(height: 6),
//                       _viewsRow(),
//                       const SizedBox(height: 12),
//                       _actionRow(),
//                       const SizedBox(height: 12),
//                       _hashtagsRow(),
//                       const SizedBox(height: 16),
//                       const Text(
//                         "Comments",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       _commentsList(),
//                       const SizedBox(height: 90),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _commentInputBar(),
//     );
//   }
//
//   // ---------------- VIDEO SECTION (WEBVIEW ONLY) ----------------
//   Widget _videoPreviewSection() {
//     return SizedBox(
//       height: 240,
//       width: double.infinity,
//       child: WebViewWidget(controller: _webViewController),
//     );
//   }
//
//   // ---------------- TITLE ----------------
//   Widget _titleAndDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             widget.videoTitle!,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
//       ],
//     );
//   }
//
//   Widget _viewsRow() {
//     return Text(
//       "${widget.viewerCount} views • Live",
//       style: const TextStyle(color: Colors.white54, fontSize: 12),
//     );
//   }
//
//   // ---------------- ACTIONS ----------------
//   Widget _actionRow() {
//     return Row(
//       children: [
//         Obx(() => _actionItem(
//           icon: liveController.isLiked.value
//               ? Icons.thumb_up
//               : Icons.thumb_up_alt_outlined,
//           label: _formatCount(liveController.likesCount.value),
//           onTap: liveController.toggleLike,
//         )),
//         const SizedBox(width: 16),
//         _actionItem(
//             icon: Icons.thumb_down_alt_outlined,
//             label: "Dislike",
//             onTap: () {}),
//         const SizedBox(width: 16),
//         _actionItem(
//             icon: Icons.share_outlined, label: "Share", onTap: () {}),
//         const SizedBox(width: 16),
//         _actionItem(
//             icon: Icons.flag_outlined, label: "Report", onTap: () {}),
//       ],
//     );
//   }
//
//   Widget _actionItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.white70),
//           const SizedBox(height: 4),
//           Text(label,
//               style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- HASHTAGS ----------------
//   Widget _hashtagsRow() {
//     return const Wrap(
//       spacing: 8,
//       children: [
//         Text("#football",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//         Text("#worldcup2022",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//         Text("#portugal",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//         Text("#switzerland",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//       ],
//     );
//   }
//
//   // ---------------- COMMENTS ----------------
//   Widget _commentsList() {
//     final comments = [
//       {"name": "alien.aa", "text": "shut down them please!!!"},
//       {"name": "trunghieu1794", "text": "nice play bro!!! keep playing"},
//     ];
//
//     return Column(
//       children: comments.map((c) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 10),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 14,
//                 backgroundColor: Colors.grey.shade800,
//                 child: Text(c["name"]![0].toUpperCase(),
//                     style: const TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "${c["name"]} ",
//                         style: const TextStyle(
//                             color: Colors.redAccent,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12),
//                       ),
//                       TextSpan(
//                         text: c["text"],
//                         style: const TextStyle(
//                             color: Colors.white70, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   // ---------------- COMMENT INPUT ----------------
//   Widget _commentInputBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       color: const Color(0xFF0E0E0E),
//       child: Row(
//         children: const [
//           CircleAvatar(
//             radius: 16,
//             backgroundColor: Colors.redAccent,
//             child: Icon(Icons.person, color: Colors.white, size: 18),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Add a comment...",
//                 hintStyle: TextStyle(color: Colors.white54),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Icon(Icons.send, color: Colors.white54),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- UTILS ----------------
//   String _formatCount(int count) {
//     if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
//     if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}K";
//     return "$count";
//   }
// }
