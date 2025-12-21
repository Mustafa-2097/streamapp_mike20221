import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../controller/forgot_pass_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),

              const SizedBox(height: 20),

              const Text(
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create a new password",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              const Text("New Password"),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: controller.newPasswordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Confirm Password"),
              const SizedBox(height: 8),
              TextField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              SizedBox(height: 80),

              Center(
                child: CustomButton(
                  text: "Submit",
                  onPressed: controller.resetPassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
