import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/show_comments_bottom_sheet.dart';
import '../../clips/model/clips_model.dart';
import '../../clips/controller/clips_controller.dart';
import '../../profile/controller/bookmarks_controller.dart';
import 'package:testapp/core/utils/url_helper.dart';

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
  final RxBool _isMuted = false.obs;
  final RxInt _activeIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _activeIndex.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BookmarkController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() => PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            onPageChanged: (index) => _activeIndex.value = index,
            itemCount: widget.clips.length,
            itemBuilder: (context, index) {
              final clip = widget.clips[index];
              return ClipPageView(
                key: ValueKey(clip.clipId), // Stable key to prevent unnecessary resets
                clip: clip,
                isMuted: _isMuted,
                isActive: _activeIndex.value == index,
              );
            },
          )),

          // Mute Toggle Button (Top Right Global)
          Positioned(
            top: 50,
            right: 15,
            child: Obx(() => IconButton(
              icon: Icon(
                _isMuted.value ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => _isMuted.value = !_isMuted.value,
            )),
          ),
          
          // Back Button (Top Left Global)
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}

class ClipPageView extends StatefulWidget {
  final ClipModel clip;
  final RxBool isMuted;
  final bool isActive;

  const ClipPageView({
    super.key,
    required this.clip,
    required this.isMuted,
    this.isActive = false,
  });

  @override
  State<ClipPageView> createState() => _ClipPageViewState();
}

class _ClipPageViewState extends State<ClipPageView>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _hasError = false;
  late Worker _muteWorker;

  @override
  bool get wantKeepAlive => true; // Essential for smooth scrolling in reels

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    // React to global mute toggle changes
    _muteWorker = ever(widget.isMuted, (bool muted) {
      if (widget.isActive) {
        _videoController?.setVolume(muted ? 0.0 : 1.0);
      }
    });
    // Increment view count when entering the clip
    Get.find<ClipsController>().incrementViewCount(widget.clip.clipId);
  }

  @override
  void didUpdateWidget(ClipPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Respond when this page becomes active or inactive
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        // Coming into view: play and restore correct volume
        _videoController?.play();
        _videoController?.setVolume(widget.isMuted.value ? 0.0 : 1.0);
      } else {
        // Going off screen: pause to release audio focus
        _videoController?.pause();
      }
    }
  }

  void _initializeVideo() {
    if (widget.clip.videoUrl.isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    final videoUrl = UrlHelper.sanitizeUrl(widget.clip.videoUrl);
    debugPrint("Reel Playback Target: $videoUrl");

    // mixWithOthers: false ensures Android requests audio focus properly
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
    )..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
                _videoController!.setLooping(true);
                // Only play + set volume if this page is currently visible
                if (widget.isActive) {
                  _videoController!.play();
                  _videoController!.setVolume(widget.isMuted.value ? 0.0 : 1.0);
                }
              });
            }
          })
          .catchError((error) {
            debugPrint("Reel Loading Error: $error");
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          });
  }

  @override
  void dispose() {
    _muteWorker.dispose();
    _videoController?.pause();
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. VIDEO PLAYER
        GestureDetector(
          onTap: _togglePlay,
          child: Center(
            child: _hasError
                ? _buildErrorWidget()
                : _isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : const CircularProgressIndicator(color: Colors.redAccent),
          ),
        ),

        // 2. Play/Pause Big Icon
        if (_isInitialized && !_videoController!.value.isPlaying && !_hasError)
          Center(
            child: GestureDetector(
              onTap: _togglePlay,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white54,
                size: 80,
              ),
            ),
          ),

        // 3. (REMOVED LOCAL MUTE BUTTON - NOW GLOBAL)

        // 4. Dark Overlay (Bottom area)
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black45,
                Colors.black87,
              ],
              stops: [0.0, 0.5, 0.75, 1.0],
            ),
          ),
        ),

        // 5. (REMOVED LOCAL BACK BUTTON - NOW GLOBAL)

        // 6. Interaction Sidebar
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _buildProfileIcon(),
              // const SizedBox(height: 25),
              _buildSideButton(
                icon: Icons.bookmark,
                label: "",
                isActive: widget.clip.userStatus.isBookmarked,
                activeColor: Colors.amber,
                onTap: () {
                  setState(() {
                    widget.clip.userStatus.isBookmarked =
                        !widget.clip.userStatus.isBookmarked;
                  });
                  Get.find<ClipsController>().clipsList.refresh();
                  Get.find<BookmarkController>().toggleClip(widget.clip);
                },
              ),
              const SizedBox(height: 20),
              _buildSideButton(
                icon: Icons.thumb_up,
                label: widget.clip.engagement.likes.toString(),
                isActive: widget.clip.userStatus.isLiked,
                onTap: () {
                  Get.find<ClipsController>().toggleAction(
                    widget.clip.clipId,
                    "LIKE",
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              _buildSideButton(
                icon: Icons.thumb_down,
                label: widget.clip.engagement.dislikes.toString(),
                isActive: widget.clip.userStatus.isDisliked,
                activeColor: Colors.redAccent,
                onTap: () {
                  Get.find<ClipsController>().toggleAction(
                    widget.clip.clipId,
                    "DISLIKE",
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              _buildIconButton(
                Icons.chat_bubble_rounded,
                widget.clip.engagement.comments.toString(),
                onTap: () async {
                  await showCommentBottomSheet(context, widget.clip.clipId);
                  final updatedClip = await Get.find<ClipsController>()
                      .fetchSingleClip(widget.clip.clipId);
                  if (updatedClip != null) {
                    final idx = Get.find<ClipsController>()
                        .clipsList
                        .indexWhere((c) => c.clipId == widget.clip.clipId);
                    if (idx != -1) {
                      Get.find<ClipsController>().clipsList[idx] = updatedClip;
                      Get.find<ClipsController>().clipsList.refresh();
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildIconButton(
                Icons.reply,
                widget.clip.engagement.shares.toString(),
                isMirrored: true,
                onTap: () {
                  final shareLink = UrlHelper.sanitizeUrl(widget.clip.shareUrl);
                  Share.share("${widget.clip.title}\n\n$shareLink");
                  Get.find<ClipsController>().toggleAction(
                    widget.clip.clipId,
                    "SHARE",
                  );
                },
              ),
            ],
          ),
        ),

        // 7. Info Overlay
        Positioned(
          left: 15,
          bottom: 25,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.clip.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (widget.clip.tags.isNotEmpty)
                Text(
                  widget.clip.tags.map((t) => "#$t").join(" "),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                        image: widget.clip.user.profilePhoto.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                  UrlHelper.sanitizeUrl(widget.clip.user.profilePhoto),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.clip.user.profilePhoto.isEmpty
                          ? Icon(Icons.person, color: Colors.white70, size: 14.r)
                          : null,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    widget.clip.user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.clip.timeAgo,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.play_disabled_outlined,
          color: Colors.white24,
          size: 60,
        ),
        const SizedBox(height: 16),
        const Text(
          "Unable to play video",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        if (widget.clip.videoUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.clip.videoUrl.split('/').last,
              style: const TextStyle(color: Colors.white24, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
          onPressed: () {
            setState(() {
              _hasError = false;
              _isInitialized = false;
            });
            _initializeVideo();
          },
          child: const Text("Retry", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  /*
  Widget _buildProfileIcon() {
     final photo = UrlHelper.sanitizeUrl(widget.clip.user.profilePhoto);
     return Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
           Container(
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: CircleAvatar(
                 radius: 20,
                 backgroundColor: Colors.grey[900],
                 backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                 child: photo.isEmpty ? const Icon(Icons.person, color: Colors.white38) : null,
              ),
           ),
           Positioned(
              bottom: -8,
              child: Container(
                 padding: const EdgeInsets.all(2),
                 decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                 child: const Icon(Icons.add, color: Colors.white, size: 14),
              ),
           ),
        ],
     );
  }
*/

  Widget _buildSideButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    Color? activeColor,
    VoidCallback? onTap,
  }) {
    return SideButton(
      icon: icon,
      label: label,
      isActive: isActive,
      activeColor: activeColor ?? const Color.fromARGB(255, 14, 126, 255),
      onTap: onTap,
    );
  }

  Widget _buildIconButton(
    IconData icon,
    String label, {
    bool isMirrored = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isMirrored ? math.pi : 0),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SideButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool isActive;
  final VoidCallback? onTap;

  const SideButton({
    super.key,
    required this.icon,
    required this.label,
    this.size = 32,
    this.activeColor = const Color.fromARGB(255, 14, 126, 255),
    this.inactiveColor = Colors.white,
    this.isActive = false,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) => _controller.reverse());
        if (widget.onTap != null) widget.onTap!();
      },
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.icon,
              color: widget.isActive
                  ? widget.activeColor
                  : widget.inactiveColor,
              size: widget.size,
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
              ),
            ),
          ],
        ],
      ),
    );
  }
}
