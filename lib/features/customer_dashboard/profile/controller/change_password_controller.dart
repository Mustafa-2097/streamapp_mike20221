import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/const/app_colors.dart';
import 'package:testapp/core/offline_storage/shared_pref.dart';
import 'package:testapp/features/auth/forgot_pass/screen/otp_screen.dart';
import 'package:testapp/features/auth/forgot_pass/screen/reset_screen.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
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
      Get.snackbar(
        "Error",
        "Please enter your email",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    Get.to(() => VerifyOtpScreen());
  }

  final isLoading = false.obs;

  // ---------------- RESET PASSWORD ----------------
  Future<void> handleChangePassword() async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
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

    if (newPasswordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters long",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (oldPasswordController.text == newPasswordController.text) {
      Get.snackbar(
        "Error",
        "New password cannot be the same as old password",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      debugPrint("Sending change password request...");
      final response = await CustomerApiService.changePassword(
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );
      debugPrint("Change password request response: $response");

      if (response['success'] == true) {
        // Clear session and redirect to Login
        await SharedPreferencesHelper.clear();

        Get.snackbar(
          "Success",
          "Password changed successfully. Please log in again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );

        // Redirect to Login Screen
        Get.offAll(() => SignInScreen());
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to change password",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      debugPrint("Error changing password: $e");
      Get.snackbar(
        "Error",
        "Failed to change password. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
      );
    } finally {
      isLoading.value = false;
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
