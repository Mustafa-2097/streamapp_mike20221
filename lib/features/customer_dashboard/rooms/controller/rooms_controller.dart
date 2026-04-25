import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../../data/customer_api_service.dart';
import '../model/chat_room_model.dart';

class RoomsController extends GetxController {
  var isLoading = false.obs;
  var roomsList = <ChatRoomModel>[].obs;

  @override
  void onInit() {
    fetchRooms();
    super.onInit();
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getChatRooms();

      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        final parsedRooms = data.map((e) => ChatRoomModel.fromJson(e)).toList();
        
        // Sort so that archived rooms appear at the bottom
        parsedRooms.sort((a, b) {
          if (a.isArchived == b.isArchived) return 0;
          return a.isArchived ? 1 : -1;
        });

        roomsList.value = parsedRooms;
      }
    } catch (e) {
      print("Error fetching rooms: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> joinRoom(String roomId) async {
    try {
      final response = await CustomerApiService.joinChatRoom(roomId);
      if (response['success'] == true) {
        return true;
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to join room",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
      );
      return false;
    }
  }
}
