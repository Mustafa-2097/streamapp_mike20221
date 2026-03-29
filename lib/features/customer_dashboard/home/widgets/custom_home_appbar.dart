import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/images_path.dart';
import '../../profile/view/pages/personal_data.dart';
import '../../profile/controller/profile_controller.dart';
import '../view/notification_page.dart';
import '../controller/notification_controller.dart';
import '../../../../core/const/app_colors.dart';

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
            Obx(() {
              final notifCtrl = Get.find<NotificationController>();
              final count = notifCtrl.unseenCount.value;

              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Get.to(() => NotificationPage()),
                    icon:
                        const Icon(Icons.notifications_none, color: Colors.white),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor, // Yellow
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            }),

            /// Search icon
            IconButton(
              onPressed: () => showSearchOverlay(context),
              icon: Icon(Icons.search, color: Colors.white),
            ),

            /// Profile avatar
            GestureDetector(
              onTap: () {
                Get.to(PersonalData());
              },
              child: Obx(() {
                final profileCtrl = Get.find<ProfileController>();
                final photoUrl = profileCtrl.profile.value?.profilePhoto;

                return CircleAvatar(
                  radius: 12.r,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: photoUrl != null && photoUrl.isNotEmpty
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            width: 24.r,
                            height: 24.r,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 20.r,
                              color: Colors.black,
                            ),
                          )
                        : Icon(Icons.person, size: 20.r, color: Colors.black),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

void showSearchOverlay(BuildContext context) {
  final overlay = Overlay.of(context);
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Search...",
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => overlayEntry?.remove(),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay?.insert(overlayEntry);
}
