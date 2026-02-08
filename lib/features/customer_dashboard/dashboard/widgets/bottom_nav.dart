import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/const/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.boxColor,
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: AppColors.boxColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, "assets/icons/home.png", "assets/icons/home_selected.png", 'Home'),
              _buildNavItem(1, "assets/icons/clips.png", "assets/icons/clips_selected.png", 'Clips'),
              _buildNavItem(2, "assets/icons/live.png", "assets/icons/live_selected.png",'Live'),
              _buildNavItem(3, "assets/icons/replay.png", "assets/icons/replay_selected.png",'Replay'),
              _buildNavItem(4, "assets/icons/profile.png", "assets/icons/profile_selected.png", 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String outlinedIcon, String filledIcon, String label) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: isSelected
            ? BoxDecoration(borderRadius: BorderRadius.circular(12.r))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h),
            Image.asset(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? AppColors.primaryColor : AppColors.bgColor,
              width: 26.w,
              height: 26.h,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : AppColors.bgColor,
                fontSize: 14.sp,
                fontFamily: "Roboto",
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
