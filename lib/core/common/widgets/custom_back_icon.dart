import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../const/app_colors.dart';

class CustomBackIcon extends StatelessWidget {
  final VoidCallback onBack;
  const CustomBackIcon({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onBack,
      child: Container(
        height: sh * 0.04,
        width: sw * 0.09,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
            border: Border.all(width: 1, color: AppColors.bgColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 18.r,
          color: AppColors.bgColor,
        ),
      ),
    );
  }
}
