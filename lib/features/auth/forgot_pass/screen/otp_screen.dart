import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get email passed from previous screen
    final arguments = Get.arguments ?? {};
    final userEmail = arguments['email'] ?? '';
    final isSignUp = arguments['isSignUp'] ?? false;

    // Create a new OTP controller instance for this screen
    final controller = Get.put(OtpController(
      email: userEmail,
      isSignUp: isSignUp,
    ));

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

                const SizedBox(height: 30),

                Text(
                  isSignUp ? "Verify Your Account" : "OTP Verification",
                  style: appTextStyleHeading(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Enter the verification code we just sent on",
                  style: TextStyle(color: Colors.grey),
                ),

                // Show email if available
                if (userEmail.isNotEmpty)
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    "your email address.",
                    style: TextStyle(color: Colors.grey),
                  ),

                const SizedBox(height: 30),

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
                    fieldHeight: 55,
                    fieldWidth: 45,
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

                const SizedBox(height: 20),

                // ---------------- TIMER / RESEND ----------------
                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Code expires in ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "${controller.minutesRemaining.value}:${controller.secondsRemaining.value.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: controller.secondsRemaining.value < 60
                              ? Colors.red
                              : Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                      () => controller.isResendEnabled.value
                      ? GestureDetector(
                    onTap: controller.resendOtp,
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  )
                      : Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ---------------- VERIFY BUTTON ----------------
                Obx(
                      () => CustomButton(
                    text: controller.isLoading.value ? "Verifying..." : "Verify",
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (controller.otp.value.length == 6) {
                        controller.verifyOtp();
                      } else {
                        Get.snackbar(
                          "Incomplete OTP",
                          "Please enter 6-digit OTP",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Loading indicator
                Obx(
                      () => controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}