import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const/images_path.dart';
import '../view/notification_page.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            /// Menu icon - FIXED
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white, size: 32),
            ),

            /// Logo section
            Image.asset(ImagesPath.logo, height: 60, width: 50),

            const Spacer(),

            /// Notification icon
            IconButton(
              onPressed: () => Get.to(() => NotificationPage()),
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),

            /// Search icon
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
            ),

            /// Profile avatar
            CircleAvatar(
                radius: 12.r,
                child: Icon(Icons.person, size: 20.r, color: Colors.black)
            )
          ],
        ),
      ),
    );
  }
}