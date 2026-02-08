import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import '../../../../../core/const/app_colors.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "NOTIFICATION",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "All Notification",
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey.shade50),
                      ),
                      const Spacer(),
                      Switch(
                        value: true,
                        activeThumbColor: Colors.white,
                        activeTrackColor: AppColors.primaryColor,
                        onChanged: (value) {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
