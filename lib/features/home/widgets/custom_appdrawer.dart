import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/features/subscription/view/subscription_screen.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/images_path.dart';

class CustomAppDrawer extends StatelessWidget {
  final void Function()? onLogoutTap;
  const CustomAppDrawer({super.key, this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    //final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: AppColors.textColor,
      child: SafeArea(
        child: Container(
          color: AppColors.textColor,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: sw*0.076),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(ImagesPath.logo, width: 82, height: 70),
              SizedBox(height: 20),
              /// Personal Info Section
              Text(
                'personal_info'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              _DrawerItem(
                icon: Icons.person_outline,
                label: 'Personal Data',
                onTap: () {},
              ),
              _DrawerItem(
                icon: Icons.star_border,
                label: 'Bookmarks',
                onTap: () {},
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
                  color: Colors.white,
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
                  color: Colors.white,
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
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onLogoutTap ?? () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFDF1C41), width: 1.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
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
            ],
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
