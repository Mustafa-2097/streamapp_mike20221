import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
import 'package:testapp/features/auth/signup/screen/signup_screen.dart';

class SignUpController extends GetxController {
  // Text Controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  final isPasswordHidden = true.obs;
  final isPasswordStrong = false.obs;

  // Password validation
  void validatePassword(String value) {
    final hasMinLength = value.length >= 8;
    final hasLetters = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumbers = value.contains(RegExp(r'[0-9]'));

    isPasswordStrong.value = hasMinLength && hasLetters && hasNumbers;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void signUp() {
    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (!isPasswordStrong.value) {
      Get.snackbar("Weak Password", "Please use a stronger password");
      return;
    }

    // Success popup
    showSuccessDialog();
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

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Continue",
                  onPressed: () {
                    Get.to(SignInScreen());
                  },
                ),
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
    super.onClose();
  }
}
