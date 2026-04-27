import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/const/images_path.dart';
import '../controller/live_game_controller.dart';
import '../controller/live_game_comment_controller.dart';
import '../model/live_game_model.dart';
import '../model/live_game_comment_model.dart';
import '../../profile/controller/profile_controller.dart';
import '../../subscription/view/subscription_screen.dart';
import '../../../../core/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpenLiveGame extends StatefulWidget {
  const OpenLiveGame({super.key});

  @override
  State<OpenLiveGame> createState() => _OpenLiveGameState();
}

class _OpenLiveGameState extends State<OpenLiveGame> {
  WebViewController? webController;
  final LiveGameController controller = Get.find<LiveGameController>();
  LiveGameCommentController? commentController;
  late Worker _worker;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    // Try initial load
    _initializeWebController();

    // Listen for data arrival if it wasn't ready in initState
    _worker = ever(controller.selectedLiveGame, (_) {
      if (webController == null) {
        setState(() {
          _initializeWebController();
        });
      }
    });
  }

  @override
  void dispose() {
    _worker.dispose();
    // Restore orientations when leaving
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
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

  void _initializeWebController() {
    final game = controller.selectedLiveGame.value;
    if (game != null) {
      webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              // Inject CSS to make the video full width
              // Use a local reference to avoid closure issues if necessary,
              // but here we can just use the instance variable since it's late and initialized.
              webController?.runJavaScript('''
                var style = document.createElement('style');
                style.innerHTML = 'video { width: 100% !important; height: 100% !important; object-fit: contain !important; } body { margin: 0; background: black; display: flex; align-items: center; justify-content: center; height: 100vh; }';
                document.head.appendChild(style);
              ''');
            },
          ),
        );
      
      webController!.loadRequest(Uri.parse(game.link));

      // Initialize comment controller for this game
      if (commentController == null) {
        commentController = Get.put(
          LiveGameCommentController(game.id),
          tag: "game_${game.id}",
        );
      }
    }
  }

  void _loadVideo(String url) {
    if (webController == null) return;
    webController!.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
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
                "Live Game",
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
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final game = controller.selectedLiveGame.value;
          if (game == null) {
            return const Center(
              child: Text(
                "Game details not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final profileController = Get.find<ProfileController>();
          final isUserPremium = profileController.profile.value?.isPremiumUser ?? false;
          final bool isLocked = game.isPremium && !isUserPremium;

          if (isLocked) {
            return _buildPremiumLockedScreen();
          }

          return Column(
            children: [
              /// VIDEO
              Stack(
                children: [
                  SizedBox(
                    height: isFullScreen
                        ? MediaQuery.of(context).size.height
                        : 240.h,
                    width: MediaQuery.of(context).size.width,
                    child: webController != null
                        ? WebViewWidget(controller: webController!)
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.redAccent,
                            ),
                          ),
                  ),

                  // Full-screen Overlays
                  if (isFullScreen) ...[
                    // Top Left: Logo & Live Badge
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(ImagesPath.logo, height: 40),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Live",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Top Right: Cast & Settings
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.cast, color: Colors.white70),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune, color: Colors.white70),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],

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

              /// DETAILS
              if (!isFullScreen)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              game.status,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          game.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _opponentBadge(game.opponent01),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "VS",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _opponentBadge(game.opponent02),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Action Bar (Like/Dislike/Share) - REMOVED AS REQUESTED
                        
                        // Comments section

                        // Comments section
                        const SizedBox(height: 20),
                        _commentsList(),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
      bottomNavigationBar: isFullScreen ? null : _commentInputBar(),
    );
  }

  // ---------------- COMMENTS LIST ----------------
  Widget _commentsList() {
    if (commentController == null) return const SizedBox.shrink();

    return Obx(() {
      if (commentController!.isLoading.value &&
          commentController!.commentsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
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

  // ---------------- COMMENT INPUT ----------------
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
              Obx(() {
                final userPhoto =
                    Get.find<ProfileController>().profile.value?.profilePhoto;
                return CircleAvatar(
                  radius: 18,
                  backgroundImage: userPhoto != null && userPhoto.isNotEmpty
                      ? NetworkImage(userPhoto)
                      : null,
                  backgroundColor: Colors.grey[800],
                  child: (userPhoto == null || userPhoto.isEmpty)
                      ? const Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 18,
                        )
                      : null,
                );
              }),
              const SizedBox(width: 12),
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
                icon: Icon(
                  Icons.send,
                  color: commentController!.isPosting.value
                      ? Colors.grey
                      : Colors.redAccent,
                ),
                onPressed: commentController!.isPosting.value
                    ? null
                    : commentController!.submitComment,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gameActionBar(LiveGame game) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionItem(
            game.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
            "${game.likes}",
            isActive: game.liked,
            activeColor: Colors.blueAccent,
            onTap: () => controller.toggleLike(game.id),
          ),
          _actionItem(
            game.disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
            "${game.dislikes}",
            isActive: game.disliked,
            activeColor: Colors.redAccent,
            onTap: () => controller.toggleDislike(game.id),
          ),
          _actionItem(
            Icons.comment_outlined,
            "${game.commentCount}",
            onTap: () {
              // Scroll to comments
            },
          ),
          _actionItem(
            Icons.share_outlined,
            "Share",
            onTap: () => controller.shareGame(game),
          ),
        ],
      ),
    );
  }

  Widget _actionItem(
    IconData icon,
    String label, {
    bool isActive = false,
    Color? activeColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: isActive ? activeColor : Colors.white70, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _opponentBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        name,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

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
              "This content is only available for premium subscribers. Upgrade your plan to enjoy exclusive live matches.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.to(() => const SubscriptionPage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
  final LiveGameComment comment;
  final LiveGameCommentController controller;

  const _CommentTile({required this.comment, required this.controller});

  @override
  Widget build(BuildContext context) {
    final photo = comment.user.profilePhoto
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[800],
                backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                child: photo.isEmpty
                    ? const Icon(Icons.person, color: Colors.white54, size: 18)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimeAgo(comment.createdAt),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.content,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
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

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "just now";
  }
}
