import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';
import '../../../../core/network/socket_service.dart';

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

  final SocketService _socketService = Get.find<SocketService>();
  var isTyping = false.obs;
  var typingUser = "".obs;

  @override
  void onInit() {
    getCurrentUser().then((_) {
      _setupSocketConnection();
    });
    fetchRoomDetails();
    fetchMessagesHistory();
    super.onInit();
  }

  void _setupSocketConnection() {
    // Join rooms
    _socketService.joinRoom(roomId);
    if (currentUserId.isNotEmpty) {
      _socketService.joinUserRoom(currentUserId.value);
    }

    // Listen to events
    _socketService.on("new_message", (data) {
      debugPrint("Socket: New message received: $data");
      final newMessage = ChatMessageModel.fromJson(data);
      // Insert at index 0 because our list is newest-first (ListView reverse: true)
      if (!messagesList.any((m) => m.id == newMessage.id)) {
        messagesList.insert(0, newMessage);
      }
    });

    _socketService.on("new_reaction", (data) {
       debugPrint("Socket: New reaction received: $data");
       // For reactions, we could update the local list, but history fetch is safer for now.
       fetchMessagesHistory(); 
    });

    _socketService.on("reaction_removed", (data) {
       debugPrint("Socket: Reaction removed: $data");
       fetchMessagesHistory();
    });

    _socketService.on("message_deleted", (data) {
       debugPrint("Socket: Message deleted: $data");
       final String? deletedId = data['id'] ?? data['messageId'];
       if (deletedId != null) {
         messagesList.removeWhere((m) => m.id == deletedId);
       }
    });

    _socketService.on("user_typing", (data) {
      if (data['userId'] != currentUserId.value && data['roomId'] == roomId) {
        typingUser.value = data['userName'] ?? "Someone";
        isTyping.value = true;
      }
    });

    _socketService.on("user_stop_typing", (data) {
      if (data['userId'] != currentUserId.value && data['roomId'] == roomId) {
        isTyping.value = false;
      }
    });

    _socketService.on("user_joined", (data) {
       debugPrint("Socket: User joined: $data");
    });
  }

  void onTyping(String text) {
    if (text.isNotEmpty) {
      _socketService.emit("user_typing", {
        "roomId": roomId,
        "userId": currentUserId.value,
        "userName": Get.find<ProfileController>().profile.value?.name ?? "User",
      });
    } else {
      _socketService.emit("user_stop_typing", {
        "roomId": roomId,
        "userId": currentUserId.value,
      });
    }
  }

  @override
  void onClose() {
    _socketService.off("new_message");
    _socketService.off("new_reaction");
    _socketService.off("reaction_removed");
    _socketService.off("message_deleted");
    _socketService.off("user_typing");
    _socketService.off("user_stop_typing");
    _socketService.off("user_joined");

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
        onTyping(""); // Clear typing status
        // No need to call fetchMessagesHistory() here, socket will deliver the msg
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to send message",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
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
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to update reaction",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
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
