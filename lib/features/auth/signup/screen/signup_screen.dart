import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());

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

              // Title
              const Text(
                "Welcome to Eduline",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Let’s join to Eduline learning ecosystem & meet our professional mentor. It’s Free!",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // Email
              _inputLabel("Email Address"),
              _inputField(
                controller: controller.emailController,
                hint: "pristia@gmail.com",
              ),

              const SizedBox(height: 20),

              // Name
              _inputLabel("Full Name"),
              _inputField(
                controller: controller.nameController,
                hint: "Pristia Candra",
              ),

              const SizedBox(height: 20),

              // Password
              _inputLabel("Password"),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  onChanged: controller.validatePassword,
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

              const SizedBox(height: 20),

              // Password strength
              Obx(
                () => Row(
                  children: [
                    Icon(
                      controller.isPasswordStrong.value
                          ? Icons.check_circle
                          : Icons.info,
                      color: controller.isPasswordStrong.value
                          ? Colors.green
                          : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "At least 8 characters with a combination of letters and numbers",
                        style: TextStyle(
                          color: controller.isPasswordStrong.value
                              ? Colors.green
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (controller.isPasswordStrong.value)
                      const Text(
                        "Strong",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sign Up Button
              Center(
                child: CustomButton(
                  text: "Sign Up",
                  onPressed: controller.signUp,
                ),
              ),

              const SizedBox(height: 20),

              // Sign In
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(SignInScreen()),
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Sign In",
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
