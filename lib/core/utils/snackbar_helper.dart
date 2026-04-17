import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static const Color _bg = AppColors.primaryColor;
  static const Color _text = Colors.black;

  static void error(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: _bg,
      colorText: _text,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
    );
  }

  static void success(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: _bg,
      colorText: _text,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
    );
  }

  static void info(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: _bg,
      colorText: _text,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white70),
    );
  }
}
