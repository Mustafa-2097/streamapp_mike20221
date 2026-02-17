import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../../core/const/app_colors.dart';
import '../../../../../features/customer_dashboard/profile/controller/personal_data_controller.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalDataController controller = Get.put(PersonalDataController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "PROFILE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Obx(() {
            // Show a centered loader while fetching current profile
            if (controller.isInitializing.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Profile Avatar ───────────────────────────────────────
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() {
                            final localFile = controller.profileImageFile.value;
                            final networkUrl = controller.networkImageUrl.value;

                            ImageProvider? imageProvider;
                            if (localFile != null) {
                              imageProvider = FileImage(localFile);
                            } else if (networkUrl != null &&
                                networkUrl.isNotEmpty) {
                              imageProvider = NetworkImage(networkUrl);
                            }

                            return CircleAvatar(
                              radius: 45.w,
                              backgroundColor: AppColors.primaryColor,
                              backgroundImage: imageProvider,
                              child: imageProvider == null
                                  ? Icon(
                                Icons.person,
                                size: 50.r,
                                color: Colors.white,
                              )
                                  : null,
                            );
                          }),
                          GestureDetector(
                            onTap: () => controller.pickImage(),
                            child: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                Icons.camera_enhance_outlined,
                                size: 16.r,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Divider(),

                    // ── Name ─────────────────────────────────────────────────
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    TextField(
                      controller: controller.nameController,
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        hintStyle: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white38,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 20),

                    // ── Email (read-only) ─────────────────────────────────────
                    Text(
                      "Email",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    // ✅ Obx so it updates reactively once profile loads
                    Obx(() => Text(
                      controller.email.value.isNotEmpty
                          ? controller.email.value
                          : "email@gmail.com",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    )),
                    Divider(),
                    SizedBox(height: 20),

                    // ── Date of Birth ─────────────────────────────────────────
                    Text(
                      "Date of Birth",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Obx(
                              () => Text(
                            controller.selectedDate.value,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => controller.chooseDate(context),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 20),

                    // ── Country ───────────────────────────────────────────────
                    Text(
                      "Country",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () =>
                          controller.showCountryPickerSheet(context),
                      child: Row(
                        children: [
                          Obx(
                                () => Text(
                              controller.selectedCountry.value,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.white,
                            size: 30.r,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 20),

                    // ── Save Button ───────────────────────────────────────────
                    Obx(
                          () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.saveProfile(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}