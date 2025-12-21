import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../controller/forgot_pass_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Verify Code",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter the code sent to your email",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

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

              const SizedBox(height: 30),

              // ---------------- TIMER / RESEND ----------------
              Obx(
                () => controller.isResendEnabled.value
                    ? GestureDetector(
                        onTap: controller.resendOtp,
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        "Resend code in ${controller.secondsRemaining.value}s",
                        style: const TextStyle(color: Colors.grey),
                      ),
              ),

              const SizedBox(height: 60),

              CustomButton(text: "Verify", onPressed: controller.verifyOtp),
            ],
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
        autofocus: focusNode == Get.find<ForgotPasswordController>().otp1Focus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
