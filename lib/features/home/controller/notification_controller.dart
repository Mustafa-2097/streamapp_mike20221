// import 'package:get/get.dart';
// import '../model/notification_model.dart';
//
// class NotificationController extends GetxController {
//   var isLoading = false.obs;
//   var notifications = <AppNotification>[].obs;
//
//   int page = 1;
//   final int limit = 10;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchNotifications();
//   }
//
//   Future<void> fetchNotifications() async {
//     isLoading.value = true;
//     final data = await NotificationService.fetchNotifications(
//       page: page,
//       limit: limit,
//     );
//     notifications.assignAll(data);
//     isLoading.value = false;
//   }
//
//   void refreshNotifications() {
//     page = 1;
//     fetchNotifications();
//   }
// }


import 'package:get/get.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notifications = <AppNotification>[].obs;

  int page = 1;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    loadDummyNotifications();
  }

  Future<void> loadDummyNotifications() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));


    // Create 10 dummy notifications
    final dummyNotifications = List.generate(10, (index) {
      return AppNotification(
        id: (index + 1).toString(),
        title: _getNotificationTitle(index),
        message: _getNotificationMessage(index),
        isRead: index > 2, // First 3 notifications will be unread
        createdAt: DateTime.now().subtract(Duration(days: index)),
      );
    });

    notifications.assignAll(dummyNotifications);
    isLoading.value = false;
  }

  String _getNotificationTitle(int index) {
    final titles = [
      "Match Reminder",
      "Score Update",
      "Live Stream Starting",
      "Team News",
      "Match Highlights",
      "New Video Available",
      "Upcoming Fixture",
      "Player Transfer News",
      "League Update",
      "Subscription Renewal",
    ];
    return titles[index % titles.length];
  }

  String _getNotificationMessage(int index) {
    final messages = [
      "Brazil vs Spain match starts in 30 minutes. Don't miss the action!",
      "Brazil just scored! Current score: Brazil 2 - 1 Spain",
      "Live stream of Bangladesh vs Australia is starting now. Tune in!",
      "Team lineup announced for today's Rugby Championship match",
      "Watch highlights from yesterday's epic match between Springboks vs Argentina",
      "New analysis video available: Tactical breakdown of last night's game",
      "Next fixture: Argentina vs New Zealand scheduled for tomorrow",
      "Breaking: Star player transfer confirmed to Manchester United",
      "Important league update: Schedule changes for upcoming matches",
      "Your subscription will renew in 7 days. Manage your subscription settings",
    ];
    return messages[index % messages.length];
  }

  void refreshNotifications() {
    loadDummyNotifications();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = AppNotification(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        isRead: true,
        createdAt: notifications[index].createdAt,
      );
      notifications.refresh();
    }
  }
}