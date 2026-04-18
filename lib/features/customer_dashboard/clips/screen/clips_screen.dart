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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              )
            : null,
        actions: Navigator.canPop(context)
            ? [const SizedBox(width: 48)] // Balanced for centering
            : null,
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
                      // The true state is either if it's in the local session list OR it came from server as bookmarked
                      // But since we are toggling clip.userStatus.isBookmarked locally now, we can rely solely on that
                      // combined with controller's local list syncing.
                      final isBookmarked = clip.userStatus.isBookmarked;
                      return ClipCard(
                        clip: clip,
                        isBookmarked: isBookmarked,
                        onBookmark: () {
                          clip.userStatus.isBookmarked = !clip.userStatus.isBookmarked;
                          controller.clipsList.refresh(); // Ensure the Obx GridView.builder updates
                          bookmarkController.toggleClip(clip);
                        },
                        showBookmarkIcon: true,
                        onTap: () {
                          Get.to(() => OpenReelsVideo(
                                clips: controller.clipsList,
                                initialIndex: index,
                              ))?.then((_) {
                            // When returning from reels, trigger a refresh for the specific item
                            // to ensure view counts are updated in the UI.
                            controller.fetchSingleClip(clip.clipId).then((updated) {
                              if (updated != null) {
                                final idx = controller.clipsList
                                    .indexWhere((c) => c.clipId == clip.clipId);
                                if (idx != -1) {
                                  controller.clipsList[idx] = updated;
                                  controller.clipsList.refresh();
                                }
                              }
                            });
                          });
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
