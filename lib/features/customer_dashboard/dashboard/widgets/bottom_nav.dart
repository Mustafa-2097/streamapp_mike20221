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
              _buildNavItem(0, 'Home', outlinedIcon: "assets/icons/home.png", filledIcon: "assets/icons/home_selected.png"),
              _buildNavItem(1, 'Clips', outlinedIcon: "assets/icons/clips.png", filledIcon: "assets/icons/clips_selected.png"),
              _buildNavItem(2, 'Live', outlinedIcon: "assets/icons/live.png", filledIcon: "assets/icons/live_selected.png"),
              _buildNavItem(3, 'Replay', outlinedIcon: "assets/icons/replay.png", filledIcon: "assets/icons/replay_selected.png"),
              _buildNavItem(4, 'Rooms', fallbackIcon: Icons.chat_bubble_outline),
              _buildNavItem(5, 'Profile', outlinedIcon: "assets/icons/profile.png", filledIcon: "assets/icons/profile_selected.png"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, {String? outlinedIcon, String? filledIcon, IconData? fallbackIcon}) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        decoration: isSelected
            ? BoxDecoration(borderRadius: BorderRadius.circular(12.r))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h),
            if (outlinedIcon != null && filledIcon != null)
              Image.asset(
                isSelected ? filledIcon : outlinedIcon,
                color: isSelected ? AppColors.primaryColor : AppColors.bgColor,
                width: 24.w,
                height: 24.h,
              )
            else if (fallbackIcon != null)
              Icon(
                fallbackIcon,
                color: isSelected ? AppColors.primaryColor : AppColors.bgColor,
                size: 24.w,
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
