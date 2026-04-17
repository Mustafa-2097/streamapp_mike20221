import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:testapp/features/auth/forgot_pass/screen/otp_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/success_screen.dart';
import 'package:testapp/core/const/app_colors.dart';
import '../../data/auth_api_service.dart';

class ForgotPasswordController extends GetxController {
  // ---------------- EMAIL ----------------
  final emailController = TextEditingController();

  // ---------------- PASSWORD ----------------
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  final isLoading = false.obs;
  String? resetToken;

  // ---------------- SEND OTP ----------------
  Future<void> sendOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await AuthApiService.forgotPassword(
        email: emailController.text.trim(),
      );

      if (response['success'] == true) {
        Get.to(
          () => const VerifyOtpScreen(),
          arguments: {'email': emailController.text.trim(), 'isSignUp': false},
        );
        Get.snackbar(
          "Success",
          response['message'] ?? "OTP sent successfully",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to send OTP",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Error handled globally in ApiService
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- RESET PASSWORD ----------------
  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (resetToken == null) {
      Get.snackbar(
        "Error",
        "Session expired. Please verify OTP again.",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await AuthApiService.resetPassword(
        token: resetToken!,
        newPassword: newPasswordController.text,
      );

      if (response['success'] == true) {
        Get.offAll(() => const SuccessScreen());
        Get.snackbar(
          "Success",
          response['message'] ?? "Password reset successfully",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to reset password",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Error handled globally in ApiService
      debugPrint("Reset password error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
