import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../home/view/news_details_screen.dart';
import '../controller/news_controller.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});
  final controller = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Assuming you have a custom back button or standard one
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),
      body: ScaffoldBg(
        // Ensure your ScaffoldBg has the dark color: Color(0xFF15171E)
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              _buildCategoryTabs(controller),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() {
                  if (controller.selectedTabIndex.value == 0) {
                    return _buildReplayList(controller);
                  } else {
                    return const Center(
                        child: Text("No Data", style: TextStyle(color: Colors.white)));
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildCategoryTabs(NewsController controller) {
    return SizedBox(
      height: 32.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // Yellow for selected, Dark Slate for unselected
                  color: isSelected ? const Color(0xFFFFD700) : const Color(0xFF2C2F38),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildReplayList(NewsController controller) {
    return ListView.separated(
      itemCount: controller.newsData.length,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      separatorBuilder: (c, i) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final item = controller.newsData[index];
        return _buildSwipeableItem(item, index);
      },
    );
  }

  // Wrapper to handle the "Swipe to Bookmark" effect seen in the image
  Widget _buildSwipeableItem(Map item, int index) {
    return Dismissible(
      key: ValueKey(item['title'] ?? index),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: Icon(Icons.bookmark, color: const Color(0xFFFFD700), size: 28.sp),
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(NewsDetailsScreen());
        },
        child: _buildNewsCard(item),
      ),
    );
  }

  // --- Specific Card Design ---
  Widget _buildNewsCard(Map item) {
    return Container(
      color: Colors.transparent, // Ensures hit testing works
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align top
        children: [
          // 1. TEXT SECTION (Left Side)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item['title'] ?? "NBA approves december 22 start for reduced 72 - ga ...",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      item['date'] ?? "12 October 2026",
                      style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Icon(Icons.circle, size: 3.sp, color: Colors.grey[600]),
                    ),
                    Text(
                      item['read'] ?? "12k read",
                      style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 16.w), // Spacing between text and image

          // 2. IMAGE SECTION (Right Side)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              "assets/images/replay2.png", // Replace with item['image'] if available
              width: 100.w,
              height: 70.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}