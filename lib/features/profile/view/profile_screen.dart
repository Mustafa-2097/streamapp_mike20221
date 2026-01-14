import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/features/profile/view/pages/bookmark_screen.dart';
import 'package:testapp/features/profile/view/pages/personal_data.dart';
import '../../../core/common/widgets/scaffold_bg.dart';
import '../../../core/const/app_colors.dart';
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
                
                    // Name + Username
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Personal Info Section
                        Text(
                          'personal_info'.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _DrawerItem(
                          icon: Icons.person_outline,
                          label: 'Personal Data',
                          onTap: () => Get.to(() => PersonalData()),
                        ),
                        _DrawerItem(
                          icon: Icons.star_border,
                          label: 'Bookmarks',
                          onTap: () => Get.to(() => BookmarkScreen()),
                        ),
                        _DrawerItem(
                          icon: Icons.payment_outlined,
                          label: 'Notification',
                          onTap: () {},
                        ),
                        _DrawerItem(
                          icon: Icons.payment_outlined,
                          label: 'Subscription',
                          onTap: () => Get.to(() => SubscriptionPage()),
                        ),
                        _DrawerItem(
                          icon: Icons.payment_outlined,
                          label: 'Payment History',
                          onTap: () {},
                        ),
                
                        SizedBox(height: 18.h),
                
                        /// General Section
                        Text(
                          'General',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _DrawerItem(
                          icon: Icons.language_outlined,
                          label: 'Language',
                          onTap: () {},
                        ),
                        _DrawerItem(
                          icon: Icons.notifications_outlined,
                          label: 'Push Notification',
                          onTap: () {},
                        ),
                
                        SizedBox(height: 18.h),
                
                        /// About Section
                        Text(
                          'about'.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _DrawerItem(
                          icon: Icons.contact_mail_outlined,
                          label: 'Contact Us',
                          onTap: () {},
                        ),
                        _DrawerItem(
                          icon: Icons.help_outline,
                          label: 'Support Center',
                          onTap: () {},
                        ),
                        _DrawerItem(
                          icon: Icons.lock_outline,
                          label: 'Privacy & Policy',
                          onTap: () {},
                        ),
                
                        SizedBox(height: 18.h),
                
                        /// Logout Button
                        SizedBox(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFFDF1C41), width: 1.3),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
                            ),
                            icon: Icon(Icons.logout, color: Color(0xFFDF1C41), size: 22.r, fontWeight: FontWeight.bold),
                            label: Text(
                              'logout'.tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                      ],
                    ),
                
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onTap;

  const _DrawerItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: Colors.white),
            SizedBox(width: 16.w),
            Text(
              label.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
