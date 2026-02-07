import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final controller = Get.find<OtpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3A0F0F),
              Color(0xFF0B0B0B),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackIcon(onBack: () => Get.back()),
                ),

                const SizedBox(height: 20),

                Text(
                  "OTP Verification",
                  style: appTextStyleHeading(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Enter the verification code we just sent on",
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  "your email address.",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 40),

                // ---------------- PIN CODE FIELD ----------------
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: Colors.white,
                  animationType: AnimationType.fade,
                  enableActiveFill: true,
                  animationDuration: const Duration(milliseconds: 300),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    inactiveColor: Colors.grey,
                    inactiveFillColor: AppColors.boxColor,
                    selectedColor: Colors.white,
                    selectedFillColor: AppColors.boxColor,
                    activeColor: Colors.white,
                    activeFillColor: AppColors.boxColor,
                  ),
                  onChanged: (value) {
                    controller.otp.value = value;
                  },
                  onCompleted: (value) {
                    controller.otp.value = value;
                  },
                ),

                const SizedBox(height: 30),

                // ---------------- TIMER / RESEND ----------------
                Obx(
                      () => controller.isResendEnabled.value
                      ? GestureDetector(
                    onTap: controller.resendOtp,
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                      : Text(
                    "Resend code in ${controller.secondsRemaining.value}s",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),

                CustomButton(
                  text: "Verify",
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: controller.verifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
