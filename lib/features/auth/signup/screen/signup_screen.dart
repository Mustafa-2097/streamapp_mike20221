import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';
import 'package:testapp/features/auth/widgets/input_field.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/const/images_path.dart';
import '../controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
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
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  CustomBackIcon(onBack: () => Get.back()),

                  const SizedBox(height: 20),

                  // Logo
                  Center(child: Image.asset(ImagesPath.logo, width: 110, height: 100, fit: BoxFit.cover)),
                  SizedBox(height: 30),

                  // Title
                  Center(
                    child: Text(
                      "HELLO! REGISTER TO GET STARTED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sw*0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Username with validation
                  InputField(
                    controller: controller.nameController,
                    hint: "Username",
                    validator: controller.validateName,
                  ),
                  const SizedBox(height: 20),

                  // Email with validation
                  InputField(
                    controller: controller.emailController,
                    hint: "Email Address",
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: 20),

                  // Password with validation
                  Obx(
                        () => InputField(
                      controller: controller.passwordController,
                      hint: "Password",
                      obscureText: controller.isPasswordHidden.value,
                      validator: controller.validatePassword,
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
                  const SizedBox(height: 20),

                  // Confirm Password with validation
                  Obx(() => InputField(
                    controller: controller.confirmPasswordController,
                    hint: "Confirm Password",
                    obscureText: controller.isConfirmPasswordHidden.value,
                    validator: controller.validateConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.isConfirmPasswordHidden.toggle(),
                    ),
                  )),

                  const SizedBox(height: 30),

                  // Sign Up Button
                  Obx(() => Center(
                    child: CustomButton(
                      text: controller.isLoading.value ? "Creating Account..." : "Register Now",
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.signUp();
                        }
                      },
                    ),
                  )),

                  const SizedBox(height: 20),

                  // Sign In
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('Navigating to SignInScreen');
                        Get.off(() => SignInScreen());
                      },
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
      ),
    );
  }
}