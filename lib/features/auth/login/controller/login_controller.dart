import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../../../core/const/app_colors.dart';
import '../../../customer_dashboard/dashboard/customer_dashboard.dart';
import '../../data/auth_api_service.dart';
import '../../../../core/network/socket_service.dart';
import '../../../customer_dashboard/home/controller/notification_controller.dart';

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
          debugPrint(
            'Verified saved token: ${savedToken?.substring(0, 20)}...',
          );
        }

        // If user role exists in response, save it
        if (user != null && user['role'] != null) {
          await SharedPreferencesHelper.saveRole(user['role']);
          debugPrint('User role saved: ${user['role']}');
        }

        // Save User ID and Join User Room
        if (user != null && user['_id'] != null) {
          final userId = user['_id'];
          await SharedPreferencesHelper.saveUserId(userId);
          debugPrint('User ID saved: $userId');
          if (Get.isRegistered<SocketService>()) {
            Get.find<SocketService>().joinUserRoom(userId);
          }
        }

        // Refresh notifications after login
        if (Get.isRegistered<NotificationController>()) {
          Get.find<NotificationController>().fetchNotifications();
        }

        Get.snackbar(
          "Success",
          response['message'] ?? 'Login successful',
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );

        debugPrint('Navigating to CustomerDashboard');
        Get.offAll(() => CustomerDashboard());
      } else {
        debugPrint('Login failed: ${response['message']}');
        // Error snackbar is already shown by ApiService globally — no duplicate needed
      }
    } catch (e) {
      debugPrint('Exception during sign in: $e');
      debugPrint('Exception type: ${e.runtimeType}');
      // Error already handled in ApiService globally
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
