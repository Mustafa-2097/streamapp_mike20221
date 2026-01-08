import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/const/app_colors.dart';
import '../../widgets/input_field.dart';
import '../controller/forgot_pass_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final controller = Get.find<ForgotPasswordController>();

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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                CustomBackIcon(onBack: () => Get.back()),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "Create New Password",
                    style: appTextStyleHeading(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    "Your new password must be unique from those previously used.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- NEW PASSWORD ----------------
                const SizedBox(height: 8),

                Obx(() => InputField(
                    controller: controller.newPasswordController,
                    hint: "New Password",
                    obscureText: controller.isPasswordHidden.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.isPasswordHidden.toggle(),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ---------------- CONFIRM PASSWORD ----------------
                const SizedBox(height: 8),

                Obx(() => InputField(
                  controller: controller.confirmPasswordController,
                  hint: "Confirm Password",
                  obscureText: controller.isConfirmPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () => controller.isConfirmPasswordHidden.toggle(),
                  ),
                ),
                ),

                SizedBox(height: 40),
                Center(
                  child: CustomButton(
                    text: "Reset Password",
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: controller.resetPassword,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
