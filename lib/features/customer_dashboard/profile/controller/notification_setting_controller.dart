import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';

class NotificationSettingController extends GetxController {
  var isLoading = false.obs;
  
  var clips = true.obs;
  var replay = true.obs;
  var matchAlert = true.obs;

  final String _fcmToken = "BFjeQPy8TKkDFaVp-nl3KKkLFWqR6BRrz5F-w6RU4ubd4MutISeQyriiVFAEKuq4eWDFWJqnZDb9rVXblk-dR-8";

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getNotificationSettings();
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        clips.value = (data['clips'] ?? true) as bool;
        replay.value = (data['replay'] ?? true) as bool;
        matchAlert.value = (data['matchAlert'] ?? true) as bool;
      }
    } catch (e) {
      debugPrint("Error fetching notification settings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleSetting(String key, bool value) async {
    try {
      // Optimistic update
      if (key == 'clips') clips.value = value;
      if (key == 'replay') replay.value = value;
      if (key == 'matchAlert') matchAlert.value = value;

      final body = {
        'clips': clips.value,
        'replay': replay.value,
        'matchAlert': matchAlert.value,
        'fcmToken': _fcmToken,
      };

      final response = await CustomerApiService.updateNotificationSettings(body);
      if (response['success'] != true) {
        // Rollback on failure
        fetchSettings();
      }
    } catch (e) {
      debugPrint("Error updating notification settings: $e");
      fetchSettings();
    }
  }
}
