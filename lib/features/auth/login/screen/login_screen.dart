import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/features/auth/forgot_pass/screen/forgot_password_screen.dart';
import 'package:testapp/features/auth/signup/screen/signup_screen.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../controller/login_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),

              const SizedBox(height: 20),

              Center(
                child: Image.asset(IconsPath.carIcon, width: 100, height: 100),
              ),
              Center(
                child: const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: const Text(
                  "Please login first to start your theory test",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),

              // Email
              _inputLabel("Email Address"),
              _inputField(
                controller: controller.emailController,
                hint: "pristia@gmail.com",
              ),

              const SizedBox(height: 20),

              // Password
              _inputLabel("Password"),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Remember me & Forgot password
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: controller.toggleRememberMe,
                    ),
                  ),
                  const Text("Remember me"),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Navigate to forgot password
                      Get.to(ForgotPasswordScreen());
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sign In Button
              Center(
                child: CustomButton(
                  text: "Sign In",
                  onPressed: controller.signIn,
                ),
              ),

              const SizedBox(height: 20),

              // Create account
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(SignUpScreen()),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don’t have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Create Account",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
