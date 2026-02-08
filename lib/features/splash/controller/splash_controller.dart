import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../../customer_dashboard/dashboard/customer_dashboard.dart';
import '../../onboarding/views/onboarding_screen.dart';

class SplashController extends GetxController {
  static SplashController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final onboardingDone = await SharedPreferencesHelper.isOnboardingCompleted();
      final token = await SharedPreferencesHelper.getToken();

      debugPrint('Onboarding Completed: $onboardingDone');
      debugPrint('Token: $token');

      if (!onboardingDone) {
        /// First launch → onboarding
        Get.offAll(() => OnboardingScreen());
      }
      else if (token == null || token.isEmpty) {
        /// Not logged in → login
        Get.offAll(() => SignInScreen());
      }
      else {
        /// Logged in → dashboard
        Get.offAll(() => CustomerDashboard());
      }
    } catch (e) {
      debugPrint('Splash error: $e');
      Get.offAll(() => SignInScreen());
    }
  }
}

