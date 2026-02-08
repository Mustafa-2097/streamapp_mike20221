import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/onboarding_data.dart';
import '../views/onboarding4.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void skip() {
    // Update current page value also
    currentPage.value = pages.length - 1;

    // Jump to last page
    pageController.jumpToPage(pages.length - 1);
  }

  Future<void> finishOnboarding() async {
    await SharedPreferencesHelper.setOnboardingCompleted();
    Get.offAll(() => WelcomeScreen());
  }
}
