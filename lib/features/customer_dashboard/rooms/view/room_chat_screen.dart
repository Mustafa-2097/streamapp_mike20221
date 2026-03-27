import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';

class RoomChatScreen extends StatelessWidget {
  final String roomName;
  final String roomImage;

  const RoomChatScreen({
    super.key,
    required this.roomName,
    required this.roomImage,
  });

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: AssetImage(roomImage),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent, // Based on screenshot
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
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    _buildMessage(
                      isMe: false,
                      name: "Salena",
                      message: "Hey brother how are you doing today?",
                      image: roomImage,
                    ),
                    _buildMessage(
                      isMe: true,
                      name: "Sakib",
                      message: "I'm doing good man Thanks what about you?",
                      image: "assets/images/clip2.png", // Using another clip as dummy user
                    ),
                    _buildMessage(
                      isMe: false,
                      name: "Ripon",
                      message: "I'm good man Check out this video",
                      image: "assets/images/clip3.png",
                    ),
                    _buildMessage(
                      isMe: false,
                      name: "Ruhan",
                      message: "I'm good man Check out this video",
                      image: "assets/images/clip1.png",
                    ),
                    _buildMessage(
                      isMe: false,
                      name: "Rakib",
                      message: "I'm good man Check out this video",
                      image: "assets/images/clip2.png",
                    ),
                    _buildMessage(
                      isMe: true,
                      name: "Sakib",
                      message: "I'm doing good man Thanks what about you?",
                      image: "assets/images/clip2.png",
                    ),
                  ],
                ),
              ),
              
              // Input Bar
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage({required bool isMe, required String name, required String message, required String image}) {
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
                  backgroundImage: AssetImage(image),
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
          
          Container(
            constraints: BoxConstraints(maxWidth: 0.65.sw),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isMe ? Colors.white10 : Colors.white12,
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
          
          if (isMe) ...[
            SizedBox(width: 8.w),
            Column(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: AssetImage(image),
                ),
                SizedBox(height: 4.h),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputBar() {
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
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Text Message',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.emoji_emotions_outlined, color: Colors.white70, size: 24.sp),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.send_rounded, color: Colors.blueAccent, size: 24.sp),
            ),
          ],
        ),
      ),
    );
  }
}
