import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    // Refresh to get latest 'seen' status from backend (from previous visits)
    controller.refreshNotifications();
    
    // Mark as seen when entering the page (for the backend)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "notification".tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (controller.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No notifications yet",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "We'll notify you when something arrives",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                controller.refreshNotifications();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              color: Colors.white,
              backgroundColor: AppColors.textColor,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                itemCount: controller.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.notifications[index];

                  return GestureDetector(
                    onTap: () {
                      if (!item.seen) {
                        controller.markAsRead(item.id);
                      }
                      // You can add navigation to specific content here
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Notification Image
                        item.image != null && item.image!.trim().isNotEmpty
                            ? Image.network(
                                item.image!,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  "assets/images/notification_img.png",
                                  height: 70,
                                  width: 70,
                                ),
                              )
                            : Image.asset(
                                "assets/images/notification_img.png",
                                height: 70,
                                width: 70,
                              ),
                        const SizedBox(width: 16),

                        // Notification content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: item.seen
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.body,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${_formatDate(item.createdAt)} • ${_formatTime(item.createdAt)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // New Notification Dot (Blue)
                        if (!item.seen)
                          Container(
                            height: 8,
                            width: 8,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return "Today";
    } else if (notificationDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('d MMM yyyy').format(date);
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  void dispose() {
    // Locally mark all as seen when leaving the page
    controller.markNotificationsAsSeenLocally();
    super.dispose();
  }
}
