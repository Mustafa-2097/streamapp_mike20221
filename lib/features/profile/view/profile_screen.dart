import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/features/home/widgets/personal_details.dart';
import 'package:testapp/features/profile/view/pages/bookmark_screen.dart';
import 'package:testapp/features/profile/view/pages/contact_us_page.dart';
import 'package:testapp/features/profile/view/pages/notification_setting.dart';
import 'package:testapp/features/profile/view/pages/payment_history_page.dart';
import 'package:testapp/features/profile/view/pages/personal_data.dart';
import 'package:testapp/features/profile/view/pages/support_center_page.dart';
import 'package:testapp/features/profile/view/pages/terms_conditions_page.dart';
import '../../../core/common/widgets/scaffold_bg.dart';
import '../../../core/const/app_colors.dart';
import '../../home/view/notification_page.dart';
import '../../subscription/view/subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "PROFILE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// User Image
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 45.w,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(Icons.person, size: 50.r, color: Colors.white)
                        ),
                        // In the GestureDetector for camera icon:
                        GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(Icons.camera_enhance_outlined, size: 16.r, color: Colors.black),
                            ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                
                    /// Name + Username
                    Column(
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "User email",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.subTextColor),
                        )
                      ],
                    ),
                    SizedBox(height: 10),

                    /// Status box
                    Container(
                      height: 100,
                      width: 390,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade800,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Your Plan Status",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white),
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.primaryColor,
                                ),
                                child: Text(
                                  "Upgrade",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  "Basic",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                "Plan expire: dd/mm/yyyy",
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey.shade100),
                              ),
                            ],
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height: 16),

                    /// Personal Info section
                    PersonalDetails(),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}

