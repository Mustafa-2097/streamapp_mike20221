import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:testapp/features/auth/forgot_pass/screen/otp_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/reset_screen.dart';
import 'package:testapp/features/customer_dashboard/data/customer_api_service.dart';

class ChangePasswordController extends GetxController {
  // ---------------- EMAIL ----------------
  final emailController = TextEditingController();

  // ---------------- PASSWORD ----------------
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isOldPasswordHidden = true.obs;
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
  // ---------------- RESET PASSWORD ----------------
  Future<void> handleChangePassword() async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long");
      return;
    }

    if (oldPasswordController.text == newPasswordController.text) {
      Get.snackbar("Error", "New password cannot be the same as old password");
      return;
    }

    try {
      print("Sending change password request...");
      final response = await CustomerApiService.changePassword(
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );
      print("Change password request successful: $response");

      Get.back(); // Navigate back immediately
      Get.snackbar(
        "Success",
        "Password changed successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print("Error changing password: $e");
      // Get.snackbar(
      //   "Error",
      //   "Failed to change password: ${e.toString()}",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
