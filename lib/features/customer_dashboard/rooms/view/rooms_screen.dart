import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/rooms_controller.dart';
import '../model/chat_room_model.dart';
import 'room_chat_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomsController controller = Get.put(RoomsController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Rooms',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (controller.roomsList.isEmpty) {
                    return Center(
                      child: Text(
                        "No rooms available",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchRooms,
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      itemCount: controller.roomsList.length,
                      itemBuilder: (context, index) {
                        final room = controller.roomsList[index];
                        return _buildRoomItem(room);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomItem(ChatRoomModel room) {
    // Handle banner image URL replacement for local development
    String imageUrl = room.bannerImage ?? "";
    if (imageUrl.contains("localhost")) {
      imageUrl = imageUrl.replaceFirst("localhost", "10.0.30.59");
    }

    final bool isArchived = room.isArchived;

    return GestureDetector(
      onTap: room.isJoined
          ? () => Get.to(() => RoomChatScreen(
                roomId: room.id,
                roomName: room.name,
                roomImage: imageUrl,
                isArchived: isArchived,
              ))
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // Avatar (with opacity if archived)
            Opacity(
              opacity: isArchived ? 0.5 : 1.0,
              child: Stack(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isArchived ? Colors.grey : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.groups,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          : const Icon(
                              Icons.groups,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                  if (!isArchived)
                    Positioned(
                      right: 2.w,
                      top: 2.h,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            // Info (with opacity if archived)
            Expanded(
              child: Opacity(
                opacity: isArchived ? 0.5 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        color: isArchived ? Colors.grey : Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isArchived)
                      Text(
                        "Archived",
                        style: TextStyle(
                          color: Colors.redAccent.withOpacity(0.8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (room.memberCount > 0)
                      Text(
                        "${room.memberCount} members",
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                  ],
                ),
              ),
            ),

            // Join/Closed Button
            if (!room.isJoined)
              ElevatedButton(
                onPressed: isArchived
                    ? null
                    : () async {
                        final RoomsController controller =
                            Get.find<RoomsController>();
                        final success = await controller.joinRoom(room.id);
                        if (success) {
                          Get.snackbar(
                            "Success",
                            "Joined ${room.name} successfully",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.black,
                            margin: EdgeInsets.all(15.w),
                            borderRadius: 15.r,
                          );
                          controller.fetchRooms();
                          Get.to(() => RoomChatScreen(
                                roomId: room.id,
                                roomName: room.name,
                                roomImage: imageUrl,
                                isArchived: isArchived,
                              ));
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isArchived
                      ? Colors.white.withOpacity(0.1)
                      : AppColors.primaryColor,
                  disabledBackgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: isArchived ? Colors.white38 : Colors.black,
                  disabledForegroundColor: Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: isArchived
                        ? const BorderSide(color: Colors.white12)
                        : BorderSide.none,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  elevation: 0,
                ),
                child: Text(
                  isArchived ? 'Closed' : 'Join',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
