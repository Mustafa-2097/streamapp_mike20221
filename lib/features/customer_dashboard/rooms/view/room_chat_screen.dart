import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/room_chat_controller.dart';
import '../model/chat_message_model.dart';

class RoomChatScreen extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String roomImage;

  const RoomChatScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.roomImage,
  });

  ImageProvider _buildImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Map localhost to server IP for testing
      String effectivePath = imagePath.replaceAll('localhost', '10.0.30.59');
      return NetworkImage(effectivePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controller for the specific room
    final controller = Get.put(RoomChatController(roomId), tag: roomId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white24,
                  backgroundImage: _buildImageProvider(roomImage),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Text(
              roomName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white12,
            height: 1.0,
          ),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Column(
            children: [
              // Date Header
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'Today',
                  style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                ),
              ),
              
              // Chat Messages
              Expanded(
                child: Obx(() {
                  final roomController = Get.find<RoomChatController>(tag: roomId);
                  
                  if (roomController.isMessagesLoading.value && roomController.messagesList.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                  }

                  if (roomController.messagesList.isEmpty) {
                    return Center(
                      child: Text(
                        "No messages yet. Say hi!",
                        style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: roomController.messagesList.length,
                    reverse: true, // Newest messages at bottom
                    itemBuilder: (context, index) {
                      final message = roomController.messagesList[index];
                      final bool isMe = message.userId == roomController.currentUserId.value ||
                          (message.user?.id != null &&
                              message.user!.id == roomController.currentUserId.value);
                      
                      String userImage = message.user?.profilePhoto ?? "";
                      
                      return _buildMessage(
                        context: context,
                        isMe: isMe,
                        name: message.user?.name ?? "User",
                        message: message.content,
                        image: userImage,
                        messageId: message.id,
                        reactions: message.reactions,
                        totalReactions: message.reactionCount,
                      );
                    },
                  );
                }),
              ),
              
              // Input Bar
              _buildInputBar(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage({
    required BuildContext context,
    required bool isMe,
    required String name,
    required String message,
    required String image,
    required String messageId,
    required List<ChatMessageReactionModel> reactions,
    required int totalReactions,
  }) {
    // Unique emojis for the simplified list
    final Set<String> uniqueEmojis = reactions.map((r) => r.emoji).toSet();

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Column(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white24,
                  backgroundImage: image.isNotEmpty ? _buildImageProvider(image) : null,
                  child: image.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
                ),
                SizedBox(height: 4.h),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ],
            ),
            SizedBox(width: 8.w),
          ],
          
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onLongPressStart: (details) => 
                    _showReactionMenu(context, messageId, details.globalPosition, reactions),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 0.65.sw),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.white10 : Colors.white24,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(isMe ? 16.r : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16.r),
                    ),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
              if (totalReactions > 0)
                Positioned(
                  bottom: -14.h,
                  right: isMe ? null : 0,
                  left: isMe ? 0 : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white12, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...uniqueEmojis.map((emoji) => Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: Text(emoji, style: TextStyle(fontSize: 11.sp)),
                        )),
                        if (totalReactions > 1)
                          Text(
                            totalReactions.toString(),
                            style: TextStyle(color: Colors.white70, fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          if (isMe) ...[
            SizedBox(width: 8.w),
            Column(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white24,
                  backgroundImage: image.isNotEmpty ? _buildImageProvider(image) : null,
                  child: image.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
                ),
                SizedBox(height: 4.h),
                Text(
                  "Me",
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showReactionMenu(BuildContext context, String messageId, Offset position, List<ChatMessageReactionModel> messageReactions) {
    final emojis = ["👍", "❤️", "😂", "😮", "😢", "😡"];
    final menuWidth = 300.w;
    final menuHeight = 54.h;
    
    final controller = Get.find<RoomChatController>(tag: roomId);
    final String currentUserId = controller.currentUserId.value;
    final Set<String> activeEmojis = messageReactions
        .where((r) => r.userId == currentUserId)
        .map((r) => r.emoji)
        .toSet();

    double left = position.dx - (menuWidth / 2);
    if (left < 16.w) left = 16.w;
    if (left + menuWidth > 1.sw - 16.w) left = 1.sw - menuWidth - 16.w;
    
    double top = position.dy - menuHeight - 20.h;
    if (top < 100.h) top = position.dy + 20.h;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "ReactionMenu",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: menuWidth,
                  height: menuHeight,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: emojis.map((emoji) {
                      final bool isActive = activeEmojis.contains(emoji);
                      return GestureDetector(
                        onTap: () {
                          controller.toggleReaction(messageId, emoji);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.black45 : Colors.transparent,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: isActive ? 26.sp : 24.sp),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputBar(RoomChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Text Message',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.emoji_emotions_outlined, color: Colors.white70, size: 24.sp),
            ),
            Obx(() => IconButton(
              onPressed: controller.isSending.value ? null : () => controller.sendMessage(),
              icon: controller.isSending.value 
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(color: Colors.blueAccent, strokeWidth: 2),
                  )
                : Icon(Icons.send_rounded, color: Colors.blueAccent, size: 24.sp),
            )),
          ],
        ),
      ),
    );
  }
}
