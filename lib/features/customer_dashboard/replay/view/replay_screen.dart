import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../../live/live_video/screen/video_screen.dart';
import '../controller/replay_controller.dart';
import '../model/replay_model.dart';
import '../../subscription/view/subscription_screen.dart';

class ReplayScreen extends StatelessWidget {
  ReplayScreen({super.key}) {
    // Force a fresh fetch if list is empty
    if (Get.isRegistered<ReplayController>()) {
      final controller = Get.find<ReplayController>();
      if (controller.replaysList.isEmpty) {
        controller.fetchReplays();
      }
    }
  }
  final controller = Get.put(ReplayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldBg(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              SizedBox(height: 20.h),
              _buildCategoryTabs(controller),
              SizedBox(height: 24.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => controller.fetchReplays(),
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  child: Obx(() {
                    if (controller.isLoading.value && controller.replaysList.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (controller.errorMessage.isNotEmpty &&
                        controller.replaysList.isEmpty) {
                      final bool isPremiumError = controller.errorMessage.value
                              .toLowerCase()
                              .contains("premium") ||
                          controller.errorMessage.value
                              .toLowerCase()
                              .contains("subscription") ||
                          controller.errorMessage.value
                              .toLowerCase()
                              .contains("active");

                      return ListView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        children: [
                          SizedBox(height: 60.h),
                          if (isPremiumError)
                            Container(
                              padding: EdgeInsets.all(24.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock_person_rounded,
                                      color: AppColors.primaryColor,
                                      size: 48.sp,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Text(
                                    "Premium Required",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    controller.errorMessage.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 32.h),
                                  ElevatedButton(
                                    onPressed: () => Get.to(
                                      () => const SubscriptionPage(),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.black,
                                      minimumSize: Size(double.infinity, 56.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Upgrade to Premium",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white24,
                                size: 64.sp,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            TextButton(
                              onPressed: () => controller.fetchReplays(),
                              child: const Text(
                                "Retry",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      );
                    }

                    // Filter list based on selected tab
                    final filteredList = controller.replaysList.where((item) {
                      final category = item.category.trim().toUpperCase();
                      final selectedTabIndex = controller.selectedTabIndex.value;
                      
                      if (selectedTabIndex == 1) {
                        return category == "REPLAY" || category == "FULL_GAME";
                      }
                      if (selectedTabIndex == 2) {
                        return category == "FULL_GAME";
                      }
                      return true; // "All" tab
                    }).toList();

                    if (filteredList.isEmpty && !controller.isLoading.value) {
                      return ListView(
                        children: [
                          SizedBox(height: 100.h),
                          const Center(
                            child: Text(
                              "No Replays Found",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }

                    return _buildReplayList(controller, filteredList);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    bool canPop = Navigator.canPop(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canPop)
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
          else
            const SizedBox(width: 48), // Placeholder to maintain centered title
          Text(
            "REPLAY",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48), 
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(ReplayController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: List.generate(
          controller.categories.length,
          (index) => Obx(() {
            bool isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white60,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildReplayList(ReplayController controller, List<ReplayModel> list) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildReplayItem(list[index]);
      },
    );
  }

  Widget _buildReplayItem(ReplayModel item) {
    return GestureDetector(
      onTap: () {
        Get.to(() => VideoLiveScreen(replayId: item.replayId))?.then((_) {
          // Refresh this specific replay item to update view counts/likes upon return
          controller.fetchSingleReplay(item.replayId).then((updated) {
            if (updated != null) {
              final index =
                  controller.replaysList.indexWhere((r) => r.replayId == item.replayId);
              if (index != -1) {
                controller.replaysList[index] = updated;
                controller.replaysList.refresh();
              }
            }
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _fixUrl(item.thumbnailUrl),
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200.h,
                      width: double.infinity,
                      color: Colors.white12,
                      child: const Icon(Icons.broken_image, color: Colors.white30),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.timeAgo,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white12,
                    image: item.user.profilePhoto.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(_fixUrl(item.user.profilePhoto)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: item.user.profilePhoto.isEmpty
                      ? Icon(Icons.person, color: Colors.white54, size: 20.r)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${item.user.name}  •  ${item.formattedViews}",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fixUrl(String url) {
    return url
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');
  }
}
