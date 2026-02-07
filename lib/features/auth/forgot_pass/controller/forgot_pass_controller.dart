import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:testapp/features/auth/forgot_pass/screen/otp_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/reset_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/success_screen.dart';

class ForgotPasswordController extends GetxController {
  // ---------------- EMAIL ----------------
  final emailController = TextEditingController();

  // ---------------- PASSWORD ----------------
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // ---------------- TIMER ----------------
  final secondsRemaining = 60.obs;
  final isResendEnabled = false.obs;

  // ---------------- SEND OTP ----------------
  void sendOtp() {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    Get.to(() => VerifyOtpScreen());
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

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
