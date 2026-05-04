import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:testapp/core/utils/url_helper.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const VideoThumbnailWidget({super.key, required this.videoUrl});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  static final Map<String, Uint8List> _thumbnailCache = {};
  
  Uint8List? _thumbnailData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final sanitizedUrl = UrlHelper.sanitizeUrl(widget.videoUrl);

    // Check cache first
    if (_thumbnailCache.containsKey(sanitizedUrl)) {
      if (mounted) {
        setState(() {
          _thumbnailData = _thumbnailCache[sanitizedUrl];
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: sanitizedUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 50,
      );

      if (mounted) {
        if (uint8list != null) {
          _thumbnailCache[sanitizedUrl] = uint8list;
        }
        setState(() {
          _thumbnailData = uint8list;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("VideoThumbnailWidget Error: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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

    if (_hasError || _thumbnailData == null) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white24,
            size: 40,
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: Image.memory(
          _thumbnailData!,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
