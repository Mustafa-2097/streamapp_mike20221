import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
import 'package:testapp/features/auth/widgets/input_field.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                CustomBackIcon(onBack: () => Get.back()),

                const SizedBox(height: 20),

                // Title
                Center(
                  child: const Text(
                    "Welcome to Eduline",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: const Text(
                    "Join our learning ecosystem & meet professional mentors. It’s Free!",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Username
                InputField(
                  controller: controller.nameController,
                  hint: "Username",
                ),
                const SizedBox(height: 20),

                // Email
                InputField(
                  controller: controller.emailController,
                  hint: "Email Address",
                ),
                const SizedBox(height: 20),

                // Password
                Obx(
                  () => InputField(
                    controller: controller.passwordController,
                    hint: "Password",
                    obscureText: controller.isPasswordHidden.value,
                    onChanged: controller.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password
                Obx(() => InputField(
                    controller: controller.confirmPasswordController,
                    hint: "Confirm Password",
                    obscureText: controller.isPasswordHidden.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password strength
                Obx(() => Row(
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
                          "At least 8 characters with letters and numbers",
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
                    text: "Register Now",
                    color: Colors.white,
                    textColor: Colors.black,
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
                            text: "Login Now",
                            style: TextStyle(
                              color: Colors.yellow,
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
      ),
    );
  }
}
