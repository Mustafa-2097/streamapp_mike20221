import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../core/common/widgets/scaffold_bg.dart';
import '../../../../../core/const/app_colors.dart';
import '../../../../auth/widgets/input_field.dart';
import '../../controller/contact_us_controller.dart';

class ContactUsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ContactUsController());
  ContactUsPage({super.key});

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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// FULL NAME
                    InputField(
                      controller: controller.nameController,
                      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      hint: "UserName",
                      enabled: false,
                    ),
                    SizedBox(height: 15.h),

                    /// EMAIL
                    InputField(
                      controller: controller.emailController,
                      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      hint: "user@gmail.com",
                      enabled: false,
                    ),
                    SizedBox(height: 15.h),

                    /// MESSAGE BOX
                    InputField(
                      controller: controller.messageController,
                      hint: "Write your message...",
                      maxLines: 6,
                      contentPadding: EdgeInsets.all(16.w),
                      validator: (v) => controller.validateMessage(v!.trim()),
                    ),

                    SizedBox(height: 40.h),

                    /// SEND BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        backgroundColor: AppColors.bgColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // submit
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),

              ),
            ),
          ),
        ),
      ),

    );
  }
}
