import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../widgets/show_comments_bottom_sheet.dart';
import '../../clips/model/clips_model.dart';
import '../../clips/controller/clips_controller.dart';
import '../../profile/controller/bookmarks_controller.dart';
import 'package:testapp/core/network/api_endpoints.dart';

class OpenReelsVideo extends StatefulWidget {
  final List<ClipModel> clips;
  final int initialIndex;

  const OpenReelsVideo({
    super.key,
    required this.clips,
    required this.initialIndex,
  });

  @override
  State<OpenReelsVideo> createState() => _OpenReelsVideoState();
}

class _OpenReelsVideoState extends State<OpenReelsVideo> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clipsController = Get.find<ClipsController>();
    Get.put(BookmarkController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        return PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemCount: clipsController.clipsList.length,
          itemBuilder: (context, index) {
            final clip = clipsController.clipsList[index];
            return ClipPageView(clip: clip);
          },
        );
      }),
    );
  }
}

class ClipPageView extends StatelessWidget {
  final ClipModel clip;

  const ClipPageView({super.key, required this.clip});

  String _fixUrl(String url) {
    return url
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Background (Placeholder for VideoPlayer)
        Container(
          color: Colors.black,
          child: Image.network(
            _fixUrl(clip.videoUrl),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
        ),

        // 2. Dark Gradient Overlay
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black54,
                Colors.black87,
              ],
              stops: [0.0, 0.6, 0.8, 1.0],
            ),
          ),
        ),

        // 3. Top Section (Back button)
        Positioned(
          top: 50,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Get.back(),
          ),
        ),

        // 4. Right Sidebar (Action Buttons)
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Profile Photo
              // CircleAvatar(
              //   radius: 22,
              //   backgroundImage: NetworkImage(_fixUrl(clip.user.profilePhoto)),
              // ),
              const SizedBox(height: 25),

              // Bookmark
              SideButton(
                icon: Icons.bookmark,
                label: "", // No count needed
                activeColor: const Color(0xFFFFD700),
                initialIsActive: clip.userStatus.isBookmarked,
                size: 32,
                onTap: () {
                  clip.userStatus.isBookmarked = !clip.userStatus.isBookmarked;
                  // Ensure the list changes so that if we go back to ClipsScreen it reflects the change
                  Get.find<ClipsController>().clipsList.refresh();
                  Get.find<BookmarkController>().toggleClip(clip);
                },
              ),
              const SizedBox(height: 20),


              // Like
              SideButton(
                icon: Icons.thumb_up,
                label: clip.engagement.likes.toString(),
                initialIsActive: clip.userStatus.isLiked,
                onTap: () => Get.find<ClipsController>().toggleAction(
                  clip.clipId,
                  "LIKE",
                ),
              ),
              const SizedBox(height: 20),

              // Dislike
              SideButton(
                icon: Icons.thumb_down,
                label: clip.engagement.dislikes.toString(),
                initialIsActive: clip.userStatus.isDisliked,
                activeColor: Colors.redAccent,
                onTap: () => Get.find<ClipsController>().toggleAction(
                  clip.clipId,
                  "DISLIKE",
                ),
              ),
              const SizedBox(height: 20),

              // Comment Button
              GestureDetector(
                onTap: () {
                  showCommentBottomSheet(context, clip.clipId);
                },
                child: Column(
                  children: [
                    const Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 32,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      clip.engagement.comments.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Share Icon
              GestureDetector(
                onTap: () {
                  final shareLink = ApiEndpoints.shareClip(clip.clipId)
                      .replaceAll('localhost', '10.0.30.59')
                      .replaceAll('127.0.0.1', '10.0.30.59');
                  Share.share("${clip.title}\n\n$shareLink");
                  Get.find<ClipsController>().toggleAction(
                    clip.clipId,
                    "SHARE",
                  );
                },
                child: Column(
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: const Icon(
                        Icons.reply,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      clip.engagement.shares.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 5. Bottom Info Section
        Positioned(
          left: 15,
          bottom: 20,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                clip.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    clip.formattedViews,
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text("•", style: TextStyle(color: Colors.grey[300])),
                  ),
                  Text(
                    clip.timeAgo,
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (clip.tags.isNotEmpty)
                Text(
                  clip.tags.map((t) => "#$t").join(" "),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class SideButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool initialIsActive;
  final VoidCallback? onTap;

  const SideButton({
    super.key,
    required this.icon,
    required this.label,
    this.size = 32,
    this.activeColor = const Color.fromARGB(255, 14, 126, 255),
    this.inactiveColor = Colors.white,
    this.initialIsActive = false,
    this.onTap,
  });

  @override
  State<SideButton> createState() => _SideButtonState();
}

class _SideButtonState extends State<SideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) => _controller.reverse());
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.icon,
              color: widget.initialIsActive
                  ? widget.activeColor
                  : widget.inactiveColor,
              size: widget.size,
              shadows: const [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 4.0,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
