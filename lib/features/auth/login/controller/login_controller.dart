import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../../customer_dashboard/dashboard/customer_dashboard.dart';
import '../../data/auth_api_service.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  // Form validation key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Email validation method
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation method
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> signIn() async {
    // First validate the form
    if (!formKey.currentState!.validate()) {
      return;
    }

    debugPrint('Sign In Attempt Started');
    debugPrint('Email: ${emailController.text.trim()}');
    debugPrint('Password: ${passwordController.text.trim()}');

    try {
      isLoading.value = true;

      final response = await AuthApiService.login(
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

        Get.snackbar(
          "Success",
          response['message'] ?? 'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        debugPrint('Navigating to CustomerDashboard');
        Get.offAll(() => CustomerDashboard());
      } else {
        debugPrint('Login failed: ${response['message']}');
        Get.snackbar(
          "Error",
          response['message'] ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Exception during sign in: $e');
      debugPrint('Exception type: ${e.runtimeType}');

      // Error already handled in ApiService, but show a fallback message
      Get.snackbar(
        "Connection Error",
        "Unable to connect to server. Please check your internet connection.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint('Sign In Process Completed');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}