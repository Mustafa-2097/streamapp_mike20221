import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../controller/forgot_pass_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

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

              Center(
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: const Text(
                  "Enter your email to receive a verification code",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 50),

              const Text("Email Address"),
              const SizedBox(height: 20),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: "example@email.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              SizedBox(height: 50),

              Center(
                child: CustomButton(
                  text: "Continue",
                  onPressed: controller.sendOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
