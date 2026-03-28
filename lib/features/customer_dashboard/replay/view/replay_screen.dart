import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../live/live_video/screen/video_screen.dart';
import '../controller/replay_controller.dart';
import '../model/replay_model.dart';

class ReplayScreen extends StatelessWidget {
  ReplayScreen({super.key});
  final controller = Get.put(ReplayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: Colors.white)
            : null,
        title: Text(
          "REPLAY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              _buildCategoryTabs(controller),
              SizedBox(height: 24.h),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  // Filter list based on selected tab
                  final filteredList = controller.replaysList.where((item) {
                    if (controller.selectedTabIndex.value == 1)
                      return item.category == "REPLAY";
                    if (controller.selectedTabIndex.value == 2)
                      return item.category == "FULL_GAME";
                    return true; // "All" tab
                  }).toList();

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Replays Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return _buildReplayList(controller, filteredList);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildCategoryTabs(ReplayController controller) {
    return SizedBox(
      height: 30.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFD700) : Colors.white12,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Text(
                  controller.categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildReplayList(ReplayController controller, List<ReplayModel> list) {
    return ListView.builder(
      itemCount: list.length,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {
            // Re-using OpenReelsVideo or a similar player if needed
            Get.to(() => VideoLiveScreen(replayId: item.replayId));
          },
          child: _buildReplayItem(item),
        );
      },
    );
  }

  String _fixUrl(String url) {
    return url
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');
  }

  // --- Specific Card Designs ---
  Widget _buildReplayItem(ReplayModel item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  _fixUrl(item.thumbnailUrl),
                  width: 145,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 145,
                    height: 85,
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    "00:00",
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Text(
                    item.category,
                    style: TextStyle(
                      color: Colors.grey.shade100,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
                Text(
                  "${item.formattedViews}  •  ${item.timeAgo}",
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
