import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/const/images_path.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../login/screen/login_screen.dart';
import '../../widgets/input_field.dart';
import '../controller/forgot_pass_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

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
                Center(child: Image.asset(ImagesPath.logo, height: 80)),

                const SizedBox(height: 40),

                Center(
                  child: const Text(
                    "Don't worry! It occurs. Please enter the email address linked with your account.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Email Field (reusing same inputField)
                InputField(
                  controller: controller.emailController,
                  hint: "Email Address",
                ),

                const SizedBox(height: 40),

                // Continue Button
                Center(
                  child: CustomButton(
                    text: "Send Code",
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: controller.sendOtp,
                  ),
                ),
                SizedBox(height: 60),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(SignInScreen()),
                    child: RichText(
                      text: const TextSpan(
                        text: "Remember Password? ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: "Login",
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
