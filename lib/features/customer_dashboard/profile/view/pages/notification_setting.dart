import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import '../../../../../core/const/app_colors.dart';
import '../../controller/notification_setting_controller.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationSettingController controller =
        Get.put(NotificationSettingController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "NOTIFICATION",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildToggleRow("Clips", controller.clips.value,
                        (val) => controller.toggleSetting('clips', val)),
                    _divider(),
                    _buildToggleRow("Replay", controller.replay.value,
                        (val) => controller.toggleSetting('replay', val)),
                    _divider(),
                    _buildToggleRow("Match Alert", controller.matchAlert.value,
                        (val) => controller.toggleSetting('matchAlert', val)),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.withOpacity(0.2), height: 32.h);
  }

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade50),
        ),
        const Spacer(),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
