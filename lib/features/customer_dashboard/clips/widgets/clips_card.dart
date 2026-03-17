import 'package:flutter/material.dart';
import '../model/clips_model.dart';

class ClipCard extends StatelessWidget {
  final ClipModel clip;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final bool showBookmarkIcon;
  final VoidCallback? onTap;

  const ClipCard({
    super.key,
    required this.clip,
    required this.isBookmarked,
    required this.onBookmark,
    this.showBookmarkIcon = true,
    this.onTap,
  });

  String _fixUrl(String url) {
    return url.replaceAll('localhost', '10.0.30.59').replaceAll('127.0.0.1', '10.0.30.59');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                _fixUrl(clip.videoUrl), // Since videoUrl is provided, we use it. If there was a thumbnail field, we'd use that.
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[900],
                  child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 40),
                ),
              ),
            ),

            /// Bookmark icon (ONLY when enabled)
            if (showBookmarkIcon)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onBookmark,
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
              ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clip.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    clip.formattedViews,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

