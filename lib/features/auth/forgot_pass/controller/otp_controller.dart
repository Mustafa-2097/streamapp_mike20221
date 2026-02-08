import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../../customer_dashboard/dashboard/customer_dashboard.dart';
import '../../data/auth_api_service.dart';
import '../screen/success_screen.dart';

class OtpController extends GetxController {
  // User information
  final String email;
  final bool isSignUp;

  // OTP state
  final otp = ''.obs;
  final TextEditingController otpController = TextEditingController();

  // Timer state (5 minutes = 300 seconds)
  final minutesRemaining = 5.obs;
  final secondsRemaining = 0.obs;
  final isResendEnabled = false.obs;
  final isLoading = false.obs;

  Timer? _timer;

  OtpController({
    required this.email,
    this.isSignUp = false,
  });

  @override
  void onInit() {
    super.onInit();
    debugPrint('OTP Controller initialized for email: $email');
    debugPrint('isSignUp: $isSignUp');
    startTimer();
  }

  void startTimer() {
    // Set initial time to 5 minutes (300 seconds)
    minutesRemaining.value = 4; // 5 minutes = 4:59, 4:58, ..., 0:01, 0:00
    secondsRemaining.value = 59;
    isResendEnabled.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutesRemaining.value == 0 && secondsRemaining.value == 0) {
        // Timer expired
        timer.cancel();
        isResendEnabled.value = true;
        debugPrint('OTP timer expired for email: $email');
      } else {
        // Update timer
        if (secondsRemaining.value == 0) {
          minutesRemaining.value--;
          secondsRemaining.value = 59;
        } else {
          secondsRemaining.value--;
        }
      }
    });

    debugPrint('5-minute OTP timer started for: $email');
  }

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      debugPrint('Resending OTP to: $email');

      // Call resend OTP API
      final response = await AuthApiService.resendOtp(
        email: email,
        isSignUp: isSignUp,
      );

      if (response['success'] == true) {
        // Clear current OTP and restart timer
        otpController.clear();
        otp.value = '';
        startTimer();

        Get.snackbar(
          "OTP Resent",
          "New OTP has been sent to your email",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        debugPrint('OTP resent successfully to: $email');
      } else {
        Get.snackbar(
          "Failed",
          response['message'] ?? 'Failed to resend OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to resend OTP. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Error resending OTP: $e');
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> verifyOtp() async {
    if(isLoading.value) return;
    final enteredOtp = otp.value;

    if (enteredOtp.length != 6) {
      Get.snackbar(
        "Invalid OTP",
        "Please enter the complete 6-digit OTP",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      debugPrint('Verifying OTP: $enteredOtp for email: $email');
      debugPrint('isSignUp: $isSignUp');

      // Call OTP verification API
      final response = await AuthApiService.verifyOtp(
        email: email,
        otp: enteredOtp,
        isSignUp: isSignUp,
      );

      debugPrint('OTP Verification Response: $response');

      if (response['success'] == true) {
        final data = response['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        debugPrint('OTP Verification Successful');
        debugPrint('Access Token: ${accessToken?.substring(0, 20)}...');

        // Save token to SharedPreferences
        if (accessToken != null && accessToken.isNotEmpty) {
          await SharedPreferencesHelper.saveToken(accessToken);
          debugPrint('Access token saved to SharedPreferences');

          // Verify token was saved
          final savedToken = await SharedPreferencesHelper.getToken();
          debugPrint('Verified saved token: ${savedToken?.substring(0, 20)}...');

          // Save user role if available (might be in data directly)
          final userRole = data['role'] ?? data['user']?['role'];
          if (userRole != null) {
            await SharedPreferencesHelper.saveRole(userRole);
            debugPrint('User role saved: $userRole');
          }
        }

        // Navigate based on isSignUp flag
        if (isSignUp) {
          // For signup: Show success screen
          Get.offAll(() => SuccessScreen(), arguments: {
            'isSignUp': true,
          });
        } else {
          // For login or forgot password: Go to dashboard
          Get.offAll(() => CustomerDashboard());
        }
      } else {
        debugPrint('OTP verification failed: ${response['message']}');
        Get.snackbar(
          "Verification Failed",
          response['message'] ?? 'Invalid OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Exception during OTP verification: $e');
      debugPrint('Exception type: ${e.runtimeType}');
      debugPrint('Stack trace: ${e.toString()}');

      Get.snackbar(
        "Connection Error",
        "Failed to verify OTP. Please check your internet connection.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    debugPrint('OTP Controller disposed for email: $email');
    super.onClose();
  }
}