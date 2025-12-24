import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';

import 'package:testapp/features/auth/forgot_pass/screen/otp_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/reset_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/success_screen.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';

class ForgotPasswordController extends GetxController {
  // ---------------- EMAIL ----------------
  final emailController = TextEditingController();

  // ---------------- OTP CONTROLLERS ----------------
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();

  // ---------------- OTP FOCUS ----------------
  final otp1Focus = FocusNode();
  final otp2Focus = FocusNode();
  final otp3Focus = FocusNode();
  final otp4Focus = FocusNode();

  // ---------------- PASSWORD ----------------
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;

  // ---------------- TIMER ----------------
  final secondsRemaining = 60.obs;
  final isResendEnabled = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  // ---------------- SEND OTP ----------------
  void sendOtp() {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    startTimer();
    Get.to(() => VerifyOtpScreen());

    // Auto focus first box
    Future.delayed(
      const Duration(milliseconds: 300),
      () => otp1Focus.requestFocus(),
    );
  }

  // ---------------- VERIFY OTP ----------------
  void verifyOtp() {
    final otp = otp1.text + otp2.text + otp3.text + otp4.text;

    if (otp.length != 4) {
      Get.snackbar("Error", "Please enter the complete OTP");
      return;
    }

    Get.to(() => ResetPasswordScreen());
  }

  // ---------------- RESET PASSWORD ----------------
  void resetPassword() {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    Get.to(SuccessScreen());
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ---------------- TIMER ----------------
  void startTimer() {
    secondsRemaining.value = 60;
    isResendEnabled.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
        isResendEnabled.value = true;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  void resendOtp() {
    // TODO: API call
    startTimer();
    Get.snackbar("OTP Sent", "A new code has been sent to your email");

    otp1.clear();
    otp2.clear();
    otp3.clear();
    otp4.clear();

    otp1Focus.requestFocus();
  }

  @override
  void onClose() {
    _timer?.cancel();

    emailController.dispose();

    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();

    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();

    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
