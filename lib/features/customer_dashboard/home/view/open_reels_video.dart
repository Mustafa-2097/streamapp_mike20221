import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
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

class ClipPageView extends StatefulWidget {
  final ClipModel clip;

  const ClipPageView({super.key, required this.clip});

  @override
  State<ClipPageView> createState() => _ClipPageViewState();
}

class _ClipPageViewState extends State<ClipPageView> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isMuted = false;

  @override
  bool get wantKeepAlive => true; // Essential for smooth scrolling in reels

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoUrl = UrlHelper.sanitizeUrl(widget.clip.videoUrl);
    debugPrint("Reel Playback Target: $videoUrl");

    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _videoController!.play();
            _videoController!.setLooping(true);
            _videoController!.setVolume(_isMuted ? 0 : 1.0);
          });
        }
      }).catchError((error) {
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

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController?.setVolume(_isMuted ? 0 : 1.0);
    });
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
               child: const Icon(Icons.play_arrow, color: Colors.white54, size: 80),
            ),
          ),

        // 3. Mute Toggle Button
        Positioned(
          top: 50,
          right: 15,
          child: IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 28),
            onPressed: _toggleMute,
          ),
        ),

        // 4. Dark Overlay (Bottom area)
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.transparent, Colors.black45, Colors.black87],
              stops: [0.0, 0.5, 0.75, 1.0],
            ),
          ),
        ),

        // 5. Navigation & UI
        Positioned(
          top: 50,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Get.back(),
          ),
        ),

        // 6. Interaction Sidebar
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfileIcon(),
              const SizedBox(height: 25),
              _buildSideButton(
                icon: Icons.bookmark,
                label: "",
                isActive: widget.clip.userStatus.isBookmarked,
                activeColor: Colors.amber,
                onTap: () {
                  widget.clip.userStatus.isBookmarked = !widget.clip.userStatus.isBookmarked;
                  Get.find<ClipsController>().clipsList.refresh();
                  Get.find<BookmarkController>().toggleClip(widget.clip);
                },
              ),
              const SizedBox(height: 20),
              _buildSideButton(
                icon: Icons.thumb_up,
                label: widget.clip.engagement.likes.toString(),
                isActive: widget.clip.userStatus.isLiked,
                onTap: () => Get.find<ClipsController>().toggleAction(widget.clip.clipId, "LIKE"),
              ),
              const SizedBox(height: 20),
              _buildSideButton(
                icon: Icons.thumb_down,
                label: widget.clip.engagement.dislikes.toString(),
                isActive: widget.clip.userStatus.isDisliked,
                activeColor: Colors.redAccent,
                onTap: () => Get.find<ClipsController>().toggleAction(widget.clip.clipId, "DISLIKE"),
              ),
              const SizedBox(height: 20),
              _buildIconButton(Icons.chat_bubble_rounded, widget.clip.engagement.comments.toString(), 
                  onTap: () => showCommentBottomSheet(context, widget.clip.clipId)),
              const SizedBox(height: 20),
              _buildIconButton(Icons.reply, widget.clip.engagement.shares.toString(), isMirrored: true, 
                  onTap: () {
                    final shareLink = UrlHelper.sanitizeUrl(widget.clip.shareUrl);
                    Share.share("${widget.clip.title}\n\n$shareLink");
                    Get.find<ClipsController>().toggleAction(widget.clip.clipId, "SHARE");
                  }),
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
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (widget.clip.tags.isNotEmpty)
                Text(
                  widget.clip.tags.map((t) => "#$t").join(" "),
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(radius: 10, backgroundColor: Colors.white24, child: const Icon(Icons.person, size: 12, color: Colors.white)),
                  const SizedBox(width: 8),
                  Text(
                    widget.clip.user.name,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
        const Icon(Icons.play_disabled_outlined, color: Colors.white24, size: 60),
        const SizedBox(height: 16),
        const Text("Unable to play video", style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
          onPressed: () {
            setState(() { _hasError = false; _isInitialized = false; });
            _initializeVideo();
          },
          child: const Text("Retry", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

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

  Widget _buildSideButton({required IconData icon, required String label, bool isActive = false, Color? activeColor, VoidCallback? onTap}) {
    return SideButton(
      icon: icon,
      label: label,
      initialIsActive: isActive,
      activeColor: activeColor ?? const Color.fromARGB(255, 14, 126, 255),
      onTap: onTap,
    );
  }

  Widget _buildIconButton(IconData icon, String label, {bool isMirrored = false, VoidCallback? onTap}) {
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
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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

class _SideButtonState extends State<SideButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
              color: widget.initialIsActive ? widget.activeColor : widget.inactiveColor,
              size: widget.size,
            ),
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}
