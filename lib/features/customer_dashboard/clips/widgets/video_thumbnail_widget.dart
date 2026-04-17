import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:testapp/core/utils/url_helper.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const VideoThumbnailWidget({super.key, required this.videoUrl});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    final sanitizedUrl = UrlHelper.sanitizeUrl(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(Uri.parse(sanitizedUrl))
      ..initialize().then((_) {
        if (mounted) {
          _controller.setVolume(0); // Mute
          _controller.play(); // Play briefly to force frame loading
          
          _controller.addListener(_videoListener);
          
          setState(() {
            _isInitialized = true;
          });
        }
      }).catchError((error) {
        debugPrint("Thumbnail Loading Error: $error");
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
  }

  void _videoListener() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      _controller.removeListener(_videoListener);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey[900],
        child: const Icon(Icons.play_circle_outline, color: Colors.white24, size: 40),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white54,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
