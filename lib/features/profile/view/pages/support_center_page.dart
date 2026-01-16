import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import 'package:testapp/features/profile/controller/support_center_controller.dart';
import '../../../../core/const/app_colors.dart';

class SupportCenterPage extends StatelessWidget {
  SupportCenterPage({super.key});
  final controller = Get.put(SupportCenterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "SUPPORT CENTER",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
            child: ListView.separated(
              itemCount: controller.faqList.length,
              separatorBuilder: (_, _) => Divider(
                thickness: 1.3.w,
                color: AppColors.boxTextColor,
                height: 40.h,
              ),
              itemBuilder: (context, index) {
                return Obx(() {
                  final isExpanded = controller.expandedIndex.value == index;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleExpand(index),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                controller.faqList[index]["title"]!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isExpanded ? AppColors.primaryColor : Colors.white,
                                ),
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 28.r,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded) ...[
                        SizedBox(height: 10.h),
                        Text(
                          controller.faqList[index]["content"]!,
                          style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.boxTextColor),
                        ),
                      ],
                    ],
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
