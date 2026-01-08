import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/const/app_colors.dart';
import '../controller/forgot_pass_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackIcon(onBack: () => Get.back()),
                ),

                SizedBox(height: 20),

                Text(
                  "OTP Verification",
                  style: appTextStyleHeading(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 30),

                Text(
                  "Enter the verification code we just sent on",
                  style: TextStyle(color: Colors.grey),
                ),

                Text(
                  " your email address.",
                  style: TextStyle(color: Colors.grey),
                ),

                SizedBox(height: 40),

                // ---------------- OTP BOXES ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _otpBox(
                      controller.otp1,
                      controller.otp1Focus,
                      nextFocus: controller.otp2Focus,
                    ),
                    _otpBox(
                      controller.otp2,
                      controller.otp2Focus,
                      nextFocus: controller.otp3Focus,
                      previousFocus: controller.otp1Focus,
                    ),
                    _otpBox(
                      controller.otp3,
                      controller.otp3Focus,
                      nextFocus: controller.otp4Focus,
                      previousFocus: controller.otp2Focus,
                    ),
                    _otpBox(
                      controller.otp4,
                      controller.otp4Focus,
                      previousFocus: controller.otp3Focus,
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // ---------------- TIMER / RESEND ----------------
                Obx(
                  () => controller.isResendEnabled.value
                      ? GestureDetector(
                          onTap: controller.resendOtp,
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Text(
                          "Resend code in ${controller.secondsRemaining.value}s",
                          style: TextStyle(color: Colors.grey),
                        ),
                ),

                SizedBox(height: 20),
                CustomButton(
                  text: "Verify",
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: controller.verifyOtp,
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpBox(
    TextEditingController controller,
    FocusNode focusNode, {
    FocusNode? nextFocus,
    FocusNode? previousFocus,
  }) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColors.boxColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            nextFocus.requestFocus();
          } else if (value.isEmpty && previousFocus != null) {
            previousFocus.requestFocus();
          }
        },
      ),
    );
  }
}
