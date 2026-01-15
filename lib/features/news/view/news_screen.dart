import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/features/news/controller/news_controller.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';

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
        leading: const BackButton(color: Colors.white),
        title: Text(
          "NEWS",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                  if (controller.selectedTabIndex.value == 0) {
                    return _buildReplayList(controller);
                  } else {
                    return const Center(child: Text("No Data", style: TextStyle(color: Colors.white)));
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

  Widget _buildReplayList(NewsController controller) {
    return ListView.builder(
      itemCount: controller.newsData.length,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      itemBuilder: (context, index) {
        final item = controller.newsData[index];
        return _buildReplayItem(item);
      },
    );
  }

  // --- Specific Card Designs ---
  Widget _buildReplayItem(Map item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset("assets/images/replay2.png", width: 90, height: 75, fit: BoxFit.cover),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text("${item['date']}  •  ${item['read']}", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
              ],
            ),
          )
        ],
      ),
    );
  }
}