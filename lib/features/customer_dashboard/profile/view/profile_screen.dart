import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../../home/widgets/personal_details.dart';
import '../../subscription/view/subscription_screen.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "PROFILE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// ================= USER IMAGE =================
                  Obx(() {
                    final profile = controller.profile.value;
                    final photoUrl = profile?.profilePhoto;
                    final hasPhoto = photoUrl != null && photoUrl.trim().isNotEmpty;

                    return Container(
                      width: 90.w,
                      height: 90.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withOpacity(0.1),
                        border: Border.all(color: Colors.white24, width: 2),
                        image: hasPhoto
                            ? DecorationImage(
                                image: NetworkImage(photoUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: !hasPhoto
                          ? Icon(Icons.person, size: 50.r, color: Colors.white)
                          : null,
                    );
                  }),

                  SizedBox(height: 10),

                  /// ================= NAME & EMAIL =================
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final profile = controller.profile.value;

                    return Column(
                      children: [
                        Text(
                          profile?.name ?? "User",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          profile?.email ?? "No email",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subTextColor,
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 10),

                  /// ================= PLAN STATUS =================
                  /*
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade800,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Your Plan Status",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.primaryColor,
                              ),
                              child: Text(
                                "Upgrade",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Text(
                                "Basic",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              "Plan expire: dd/mm/yyyy",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  */

                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade800,
                    ),
                    child: Obx(() {
                      final profile = controller.profile.value;
                      final sub = profile?.subscription;
                      final planName = sub?.plan?.name ?? "No Active Plan";
                      final endDate = sub?.formattedEndDate ?? "N/A";

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Your Plan Status",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.primaryColor,
                                ),
                                child: InkWell(
                                  onTap: () => Get.to(() => SubscriptionPage()),
                                  child: Text(
                                    "Upgrade",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  planName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                "Plan expire: $endDate",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),

                  SizedBox(height: 16),

                  /// ================= PERSONAL DETAILS =================
                  const PersonalDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
