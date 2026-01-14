import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/features/replay/controller/replay_controller.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';

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
        title: Text(
          "REPLAY",
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

  Widget _buildReplayList(ReplayController controller) {
    return ListView.builder(
      itemCount: controller.replayBookmarks.length,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      itemBuilder: (context, index) {
        final item = controller.replayBookmarks[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) => controller.removeReplay(index),
          background: _buildDeleteBackground(),
          child: _buildReplayItem(item),
        );
      },
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(right: 20.w),
      child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 35.r),
    );
  }

  // --- Specific Card Designs ---

  Widget _buildLiveCard(Map item) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ["12H", "12M", "12S"].map((t) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(4.r)),
              child: Text(t, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            )).toList(),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeam(item['team1'], Icons.sports_soccer),
              Column(
                children: [
                  Text(item['date'], style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                  Text(item['time'], style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                ],
              ),
              _buildTeam(item['team2'], Icons.sports_football),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplayItem(Map item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset("assets/images/replay2.png", width: 145, height: 85, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 5, right: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(item['duration'], style: TextStyle(color: Colors.white, fontSize: 10.sp)),
                ),
              )
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(11.r)),
                  child: Text("Highlights", style: TextStyle(color: Colors.grey.shade100, fontSize: 10.sp)),
                ),
                Text("${item['views']}  •  ${item['time']}", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTeam(String name, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 40.r),
        Text(name, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
      ],
    );
  }
}