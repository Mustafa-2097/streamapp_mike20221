import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';

import '../../home/view/open_reels_video.dart';
import '../../profile/controller/bookmarks_controller.dart';
import '../controller/clips_controller.dart';
import '../widgets/clips_card.dart';

class ClipsScreen extends StatelessWidget {
  ClipsScreen({super.key});

  final ClipsController controller = Get.put(ClipsController());

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
        title: const Text(
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
            child: RefreshIndicator(
              onRefresh: () => controller.refreshClips(),
              child: Obx(() {
                if (controller.isLoading.value && controller.clipsList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.clipsList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No clips found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200 &&
                        controller.hasMore.value &&
                        !controller.isLoadingMore.value) {
                      controller.fetchClips(isLoadMore: true);
                    }
                    return false;
                  },
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.64,
                    ),
                    itemCount: controller.clipsList.length +
                        (controller.isLoadingMore.value ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.clipsList.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final clip = controller.clipsList[index];
                      return ClipCard(
                        clip: clip,
                        isBookmarked: bookmarkController.isBookmarked(clip),
                        onBookmark: () {
                          bookmarkController.toggleClip(clip);
                        },
                        showBookmarkIcon: true,
                        onTap: () {
                          Get.to(OpenReelsVideo(
                            clips: controller.clipsList,
                            initialIndex: index,
                          ));
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
