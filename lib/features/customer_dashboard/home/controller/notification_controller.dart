import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../data/customer_api_service.dart';
import '../model/notification_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../../../core/const/app_colors.dart';

class NotificationController extends GetxController with WidgetsBindingObserver {
  var isLoading = false.obs;
  var notifications = <AppNotification>[].obs;
  var unseenCount = 0.obs;
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialData();
    _startPolling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App resumed: Refreshing notifications");
      fetchNotifications();
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (!isLoading.value) {
        fetchNotifications();
      }
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadInitialData() async {
    await fetchNotifications();
  }

  Future<void> fetchNotifications({bool showLoading = true}) async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) {
      debugPrint("No token found. Skipping notification fetch.");
      return;
    }

    try {
      if (showLoading) isLoading.value = true;
      debugPrint("Fetching notifications from: ${ApiEndpoints.notifications}");
      final response = await CustomerApiService.getNotifications();
      debugPrint("Notification Response: $response");
      
      if (response['success'] == true) {
        final List? data = response['data'];
        if (data != null) {
          final list = data.map((json) {
            try {
              return AppNotification.fromJson(json);
            } catch (e) {
              debugPrint("Error parsing single notification: $e, json: $json");
              return null;
            }
          }).whereType<AppNotification>().toList();
          
          notifications.assignAll(list);
          unseenCount.value = list.where((n) => !n.seen).length;
          debugPrint("Notifications loaded: ${notifications.length}, unseen: ${unseenCount.value}");
        } else {
          notifications.clear();
          debugPrint("No data field found in response");
        }
      } else {
        debugPrint("API success was false: ${response['message']}");
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      // Only show snackbar if it's not a standard logout/missing token issue
      if (e.toString().toLowerCase().contains("login") || e.toString().toLowerCase().contains("unauthorized")) {
         return;
      }
      Get.snackbar(
        "Notice", 
        "Failed to load notifications: $e",
        backgroundColor: AppColors.errorColor.withOpacity(0.7),
        colorText: Colors.black,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllAsSeen() async {
    try {
      final response = await CustomerApiService.markNotificationsAsSeen();
      if (response['success'] == true) {
        // Reset count locally so the yellow dot on home screen clears
        unseenCount.value = 0;
        
        // We do DOES NOT update the local notifications[] seen status here
        // This keeps the blue dots visible during this session as requested.
        // On next app start or page entry, fetchNotifications will get seen: true from backend.
      }
    } catch (e) {
      debugPrint("Error marking notifications as seen: $e");
    }
  }

  void refreshNotifications() {
    fetchNotifications(showLoading: false);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = AppNotification(
        id: notifications[index].id,
        title: notifications[index].title,
        body: notifications[index].body,
        image: notifications[index].image,
        seen: true,
        createdAt: notifications[index].createdAt,
      );
      notifications.refresh();
    }
  }

  void markNotificationsAsSeenLocally() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].seen) {
        notifications[i] = AppNotification(
          id: notifications[i].id,
          title: notifications[i].title,
          body: notifications[i].body,
          image: notifications[i].image,
          seen: true,
          createdAt: notifications[i].createdAt,
        );
      }
    }
    unseenCount.value = 0;
    notifications.refresh();
  }
}
