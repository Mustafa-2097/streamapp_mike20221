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
        title: const Text(
          "Personal Data",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Obx(() {
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

                            return Container(
                              width: 90.w,
                              height: 90.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 2,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: imageProvider != null
                                  ? (localFile != null
                                      ? Image.file(
                                          localFile,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          networkUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.person,
                                            size: 50.r,
                                            color: Colors.white,
                                          ),
                                          loadingBuilder:
                                              (context, child, progress) =>
                                                  progress == null
                                                      ? child
                                                      : const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                        ))
                                  : Icon(
                                      Icons.person,
                                      size: 50.r,
                                      color: Colors.white,
                                    ),
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

                    SizedBox(height: 10.h),
                    const Divider(color: Colors.white12),

                    // ── Name ─────────────────────────────────────────────────
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    ),
                    SizedBox(height: 6.h),
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
                    const Divider(color: Colors.white12),
                    SizedBox(height: 20.h),

                    // ── Email (read-only) ─────────────────────────────────────
                    Text(
                      "Email",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    ),
                    SizedBox(height: 6.h),
                    Obx(
                      () => Text(
                        controller.email.value.isNotEmpty
                            ? controller.email.value
                            : "email@gmail.com",
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    ),
                    const Divider(color: Colors.white12),
                    SizedBox(height: 20.h),

                    // ── Date of Birth ─────────────────────────────────────────
                    Text(
                      "Date of Birth",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    ),
                    SizedBox(height: 6.h),
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
                    const Divider(color: Colors.white12),
                    SizedBox(height: 20.h),

                    // ── Country ───────────────────────────────────────────────
                    Text(
                      "Country",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () => controller.showCountryPickerSheet(context),
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
                    const Divider(color: Colors.white12),
                    SizedBox(height: 40.h),

                    // ── Save Button ───────────────────────────────────────────
                    Obx(() {
                      final hasChanges = controller.hasChanges;
                      final isSaving = controller.isLoading.value;
                      final isSaved = controller.buttonText.value == 'Saved!';

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (hasChanges && !isSaving) || isSaved
                              ? () => controller.saveProfile()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSaved
                                ? Colors.green
                                : (hasChanges ? Colors.white : Colors.white24),
                            disabledBackgroundColor: Colors.white10,
                            foregroundColor: isSaved || !hasChanges
                                ? Colors.white
                                : Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSaving) ...[
                                SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: const CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                              Text(
                                controller.buttonText.value,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: (hasChanges || isSaved)
                                      ? (isSaved ? Colors.white : Colors.black)
                                      : Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
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
