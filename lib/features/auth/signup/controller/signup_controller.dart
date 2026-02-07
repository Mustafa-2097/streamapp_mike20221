import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../data/auth_api_service.dart';
import '../../forgot_pass/screen/otp_screen.dart';

class SignUpController extends GetxController {
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
    // First validate the form
    if (!formKey.currentState!.validate()) {
      return;
    }

    debugPrint('Sign Up Attempt Started');
    debugPrint('Name: ${nameController.text.trim()}');
    debugPrint('Email: ${emailController.text.trim()}');
    debugPrint('Password: ${passwordController.text.trim()}');
    debugPrint('Confirm Password: ${confirmPasswordController.text.trim()}');

    try {
      isLoading.value = true;

      // Call the signup API
      final response = await AuthApiService.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      debugPrint('API Response: $response');

      if (response['success'] == true) {
        final data = response['data'];

        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = data['user'];

        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: $refreshToken');
        debugPrint('User Data: $user');

        // Save access token to SharedPreferences
        if (accessToken != null && accessToken.isNotEmpty) {
          await SharedPreferencesHelper.saveToken(accessToken);
          debugPrint('Access token saved to SharedPreferences');

          // Verify token was saved
          final savedToken = await SharedPreferencesHelper.getToken();
          debugPrint('Verified saved token: ${savedToken?.substring(0, 20)}...');
        }

        // If user role exists in response, save it
        if (user != null && user['role'] != null) {
          await SharedPreferencesHelper.saveRole(user['role']);
          debugPrint('User role saved: ${user['role']}');
        }

        // Show success dialog
        Get.to(() => VerifyOtpScreen());
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

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Icon
              Image.asset(IconsPath.success, height: 200),

              const SizedBox(height: 20),

              const Text(
                "Successfully Registered",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Your account has been created",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: "Continue",
                textColor: Colors.white,
                color: Color(0xFF131720),
                onPressed: () {
                  debugPrint('Navigating to SignInScreen');
                  Get.off(() => SignInScreen());
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
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