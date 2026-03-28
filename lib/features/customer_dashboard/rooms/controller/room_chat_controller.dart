import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';

class RoomChatController extends GetxController {
  final String roomId;
  RoomChatController(this.roomId);

  var isLoading = false.obs;
  var isMessagesLoading = false.obs;
  var isSending = false.obs;
  var room = Rxn<ChatRoomModel>();
  var messagesList = <ChatMessageModel>[].obs;
  var currentUserId = "".obs;

  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    getCurrentUser();
    fetchRoomDetails();
    fetchMessagesHistory();
    super.onInit();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    try {
      isSending.value = true;
      final response = await CustomerApiService.sendMessage(
        roomId: roomId,
        content: content,
      );

      if (response['success'] == true) {
        messageController.clear();
        await fetchMessagesHistory();
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to send message",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> toggleReaction(String messageId, String emoji) async {
    try {
      final response = await CustomerApiService.toggleMessageReaction(
        messageId: messageId,
        emoji: emoji,
      );

      if (response['success'] == true) {
        await fetchMessagesHistory();
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to update reaction",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> getCurrentUser() async {
    // Try to get ID from ProfileController if available
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>().profile.value;
      if (profile != null && profile.id.isNotEmpty) {
        currentUserId.value = profile.id;
        return;
      }
    }

    try {
      final response = await CustomerApiService.getProfile();
      if (response['success'] == true) {
        currentUserId.value = response['data']['id']?.toString() ?? "";
      }
    } catch (e) {
      print("Error fetching profile in RoomChatController: $e");
    }
  }

  Future<void> fetchRoomDetails() async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getSingleChatRoom(roomId);

      if (response['success'] == true) {
        room.value = ChatRoomModel.fromJson(response['data']);
      }
    } catch (e) {
      print("Error fetching room details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessagesHistory() async {
    try {
      isMessagesLoading.value = true;
      final response = await CustomerApiService.getRoomMessages(roomId);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        final messages = data.map((e) => ChatMessageModel.fromJson(e)).toList();
        // Since API returns oldest first, we reverse it to have newest at index 0
        // this works perfectly with reverse: true in ListView
        messagesList.assignAll(messages.reversed.toList());
      }
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      isMessagesLoading.value = false;
    }
  }
}
