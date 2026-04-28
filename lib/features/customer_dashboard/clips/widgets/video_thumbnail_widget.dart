import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:testapp/core/utils/url_helper.dart';
import 'package:testapp/core/utils/video_resource_manager.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const VideoThumbnailWidget({super.key, required this.videoUrl});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  static int _concurrentInitializations = 0;
  static const int _maxConcurrent = 3;

  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    VideoResourceManager().registerThumbnail(_releaseResources, _reInitialize);
  }

  Future<void> _initializeController() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    
    try {
      await _waitForSlot();
      
      // Check if we were unmounted while waiting for a slot
      if (!mounted) {
        _concurrentInitializations = (_concurrentInitializations - 1).clamp(0, _maxConcurrent);
        _isInitializing = false;
        return;
      }
      
      final sanitizedUrl = UrlHelper.sanitizeUrl(widget.videoUrl);
      final controller = VideoPlayerController.networkUrl(Uri.parse(sanitizedUrl));
      _controller = controller;

      await controller.initialize();
      
      // Successfully initialized
      if (mounted) {
        controller.setVolume(0);
        controller.play();
        controller.addListener(_videoListener);

        setState(() {
          _isInitialized = true;
          _hasError = false;
          _isInitializing = false;
        });
      } else {
        controller.dispose();
        _isInitializing = false;
      }
    } catch (error) {
      debugPrint("Thumbnail Loading Error: $error");
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
          _isInitializing = false;
        });
      } else {
        _isInitializing = false;
      }
    } finally {
      // We must decrement the counter once the "heavy" initialization work is done
      // (even if it failed or the widget was disposed).
      _concurrentInitializations = (_concurrentInitializations - 1).clamp(0, _maxConcurrent);
    }
  }

  Future<void> _waitForSlot() async {
    while (_concurrentInitializations >= _maxConcurrent) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
    }
    _concurrentInitializations++;
  }

  void _releaseResources() {
    if (mounted && _isInitialized && _controller != null) {
      _controller!.pause();
      _controller!.dispose();
      _controller = null;
      setState(() {
        _isInitialized = false;
      });
    }
  }

  void _reInitialize() {
    if (mounted && !_isInitialized) {
      _initializeController();
    }
  }

  void _videoListener() {
    final controller = _controller;
    if (controller != null && controller.value.isPlaying) {
      controller.pause();
      controller.removeListener(_videoListener);
    }
  }

  @override
  void dispose() {
    VideoResourceManager().unregisterThumbnail(_releaseResources, _reInitialize);
    final controller = _controller;
    if (controller != null) {
      controller.dispose();
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey[900],
        child: const Icon(
          Icons.play_circle_outline,
          color: Colors.white24,
          size: 40,
        ),
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

    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
