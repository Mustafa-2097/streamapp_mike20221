import 'package:flutter/material.dart';
import '../model/clips_model.dart';

class ClipCard extends StatelessWidget {
  final ClipItem clip;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final bool showBookmarkIcon;

  const ClipCard({
    super.key,
    required this.clip,
    required this.isBookmarked,
    required this.onBookmark,
    this.showBookmarkIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(clip.imageUrl, fit: BoxFit.cover),
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
                  clip.views,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


