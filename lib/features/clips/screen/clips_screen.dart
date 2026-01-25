import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';

import '../../home/view/open_reels_video.dart';
import '../../profile/controller/bookmarks_controller.dart';
import '../model/clips_model.dart';
import '../widgets/clips_card.dart';

class ClipsScreen extends StatelessWidget {
  ClipsScreen({super.key});

  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adip...',
      views: '2.5M views',
    ),
    ClipItem(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Excepteur sint occaecat cupidatat non proiden...',
      views: '3.4M views',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bookmarkController = BookmarkController.to;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'CLIPS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 0.64,
              ),
              itemCount: _clips.length,
              itemBuilder: (context, index) {
                final clip = _clips[index];
                return Obx(()=> ClipCard(
                    clip: clip,
                    isBookmarked: bookmarkController.isBookmarked(clip),
                    onBookmark: () {
                      bookmarkController.toggleClip(clip);
                    },
                    showBookmarkIcon: true,
                  onTap: (){
                      Get.to(OpenReelsVideo());
                  },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
