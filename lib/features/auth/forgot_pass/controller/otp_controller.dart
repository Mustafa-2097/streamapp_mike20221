import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/success_screen.dart';

class OtpController extends GetxController {
  final otp = ''.obs;
  final TextEditingController otpController = TextEditingController();

  // Timer
  final secondsRemaining = 30.obs;
  final isResendEnabled = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    secondsRemaining.value = 300;
    isResendEnabled.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
        isResendEnabled.value = true;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  void resendOtp() {
    otpController.clear();
    otp.value = '';
    startTimer();
  }

  void verifyOtp() {
    if (otp.value.length != 6) {
      Get.snackbar(
        "Invalid OTP",
        "Please enter the complete 6-digit OTP",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.off(() => SuccessScreen());
      return;
    }

    print("Entered OTP: ${otp.value}");
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
