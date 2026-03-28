import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/chat_message_model.dart';
import '../model/chat_room_model.dart';
import '../../../../core/network/socket_service.dart';
import '../../../../core/const/app_colors.dart';

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
      
      // Check if message already exists by ID
      final existingIndex = messagesList.indexWhere((m) => m.id == newMessage.id);
      if (existingIndex != -1) return;

      // Check if it matches a temporary message (same user and content)
      final tempIndex = messagesList.indexWhere((m) => 
          m.id.startsWith('temp_') && 
          m.userId == newMessage.userId && 
          m.content == newMessage.content);

      if (tempIndex != -1) {
        messagesList[tempIndex] = newMessage;
        messagesList.refresh();
      } else {
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

    final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
    final userProfile = Get.find<ProfileController>().profile.value;
    
    // Create optimistic message
    final tempMsg = ChatMessageModel(
      id: tempId,
      roomId: roomId,
      userId: currentUserId.value,
      content: content,
      isEdited: false,
      isDeleted: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      user: userProfile != null ? ChatUserModel(
        id: userProfile.id,
        name: userProfile.name ?? "Me",
        username: userProfile.email.split('@').first,
        profilePhoto: userProfile.profilePhoto,
      ) : null,
      replyCount: 0,
      reactionCount: 0,
      reactions: [],
    );

    // Add immediately to UI
    messagesList.insert(0, tempMsg);
    messageController.clear();
    onTyping(""); 

    try {
      // isSending.value = true; // No longer blocking the button with a flag
      final response = await CustomerApiService.sendMessage(
        roomId: roomId,
        content: content,
      );

      if (response['success'] == true) {
        // We'll let the socket "new_message" add the real one and then remove this temp one?
        // Or we replace it now if we have the real ID
        final realMsg = ChatMessageModel.fromJson(response['data']);
        final index = messagesList.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messagesList[index] = realMsg;
          messagesList.refresh();
        }
      } else {
        messagesList.removeWhere((m) => m.id == tempId);
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to send message",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      messagesList.removeWhere((m) => m.id == tempId);
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
    }
  }

  Future<void> toggleReaction(String messageId, String emoji) async {
    final msgIndex = messagesList.indexWhere((m) => m.id == messageId);
    if (msgIndex == -1) return;

    final originalMsg = messagesList[msgIndex];
    final currentUserIdValue = currentUserId.value;
    if (currentUserIdValue.isEmpty) return;

    List<ChatMessageReactionModel> updatedReactions = List.from(originalMsg.reactions);
    int newReactionCount = originalMsg.reactionCount;

    final existingReactionIndex =
        updatedReactions.indexWhere((r) => r.userId == currentUserIdValue);

    if (existingReactionIndex != -1) {
      final existingEmoji = updatedReactions[existingReactionIndex].emoji;
      if (existingEmoji == emoji) {
        // Toggle off (remove)
        updatedReactions.removeAt(existingReactionIndex);
        if (newReactionCount > 0) newReactionCount--;
      } else {
        // Switch emoji (replace)
        updatedReactions[existingReactionIndex] = ChatMessageReactionModel(
          id: updatedReactions[existingReactionIndex].id,
          messageId: messageId,
          userId: currentUserIdValue,
          emoji: emoji,
          createdAt: DateTime.now().toIso8601String(),
        );
        // Count stays same
      }
    } else {
      // Add new emoji
      updatedReactions.add(ChatMessageReactionModel(
        id: "temp_reac_${DateTime.now().millisecondsSinceEpoch}",
        messageId: messageId,
        userId: currentUserIdValue,
        emoji: emoji,
        createdAt: DateTime.now().toIso8601String(),
      ));
      newReactionCount++;
    }

    // Apply optimistic update
    messagesList[msgIndex] = originalMsg.copyWith(
      reactions: updatedReactions,
      reactionCount: newReactionCount,
    );
    messagesList.refresh();

    try {
      final response = await CustomerApiService.toggleMessageReaction(
        messageId: messageId,
        emoji: emoji,
      );

      if (response['success'] != true) {
        // If API fails, revert by fetching history
        await fetchMessagesHistory();
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to update reaction",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      await fetchMessagesHistory();
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
