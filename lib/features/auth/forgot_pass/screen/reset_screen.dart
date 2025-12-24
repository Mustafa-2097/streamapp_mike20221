import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
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
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),

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
                  ),
                ),

                const SizedBox(height: 40),

                // ---------------- NEW PASSWORD ----------------
                const SizedBox(height: 8),

                Obx(
                  () => TextField(
                    controller: controller.newPasswordController,
                    obscureText: controller.isPasswordHidden.value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "New Password",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1C1C1C),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- CONFIRM PASSWORD ----------------
                const SizedBox(height: 8),

                TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1C1C1C),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
