import 'package:flutter/material.dart';
import '../model/clips_model.dart';
import 'video_thumbnail_widget.dart';
import 'package:testapp/core/utils/url_helper.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: VideoThumbnailWidget(
                videoUrl: UrlHelper.sanitizeUrl(clip.videoUrl),
              ),
            ),

            /// Bookmark icon (ONLY when enabled)
            if (showBookmarkIcon)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBookmark,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
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
