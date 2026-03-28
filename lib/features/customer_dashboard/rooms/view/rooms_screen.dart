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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
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
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
    // Handle banner image URL replacement for local development if needed
    String imageUrl = room.bannerImage ?? "";
    if (imageUrl.contains("localhost")) {
      imageUrl = imageUrl.replaceFirst("localhost", "10.0.30.59");
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          // Circular Avatar with Status Dot
          Stack(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.groups, color: Colors.white, size: 30),
                        )
                      : const Icon(Icons.groups, color: Colors.white, size: 30),
                ),
              ),
              // Blue online/status dot
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

          SizedBox(width: 16.w),

          // Room Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (room.memberCount > 0)
                  Text(
                    "${room.memberCount} members",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),

          // Join Button
          ElevatedButton(
            onPressed: () async {
              final success = await Get.find<RoomsController>().joinRoom(room.id);
              if (success) {
                Get.snackbar("Success", "Joined ${room.name} successfully",
                    snackPosition: SnackPosition.BOTTOM);
                Get.to(() => RoomChatScreen(
                      roomId: room.id,
                      roomName: room.name,
                      roomImage: imageUrl,
                    ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              elevation: 0,
            ),
            child: Text(
              'Join',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
