import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../data/auth_api_service.dart';
import '../../forgot_pass/screen/otp_screen.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  // Text Controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  // Form validation key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Name validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    debugPrint('Sign Up Attempt Started');
    debugPrint('Name: ${nameController.text.trim()}');
    debugPrint('Email: ${emailController.text.trim()}');

    try {
      isLoading.value = true;

      final response = await AuthApiService.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      debugPrint('API Response: $response');

      if (response['success'] == true) {
        final data = response['data'];

        // Fix: Get email directly from data object
        final userEmail = data['email'] ?? emailController.text.trim();

        debugPrint('User registered successfully: $userEmail');
        debugPrint('User data: $data');

        // Navigate to OTP screen with user email
        Get.to(() => VerifyOtpScreen(), arguments: {
          'email': userEmail,
          'isSignUp': true,
        });
      } else {
        debugPrint('Signup failed: ${response['message']}');
        Get.snackbar(
          "Error",
          response['message'] ?? 'Signup failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Exception during sign up: $e');
      debugPrint('Exception type: ${e.runtimeType}');
      debugPrint('Stack trace: ${e.toString()}');

      Get.snackbar(
        "Connection Error",
        "Unable to connect to server. Please check your internet connection.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint('Sign Up Process Completed');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}