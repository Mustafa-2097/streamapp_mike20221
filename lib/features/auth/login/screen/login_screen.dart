import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_back_icon.dart';
import 'package:testapp/features/auth/forgot_pass/screen/forgot_password_screen.dart';
import 'package:testapp/features/auth/signup/screen/signup_screen.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/const/images_path.dart';
import '../../widgets/input_field.dart';
import '../controller/login_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    // final sh = MediaQuery.of(context).size.height;
    // final sw = MediaQuery.of(context).size.width;
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

                Center(
                  child: Image.asset(ImagesPath.logo, width: 100, height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "WELCOME BACK! GLAD TO SEE",
                      style: appTextStyleHeading(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    "YOU, AGAIN!",
                    style: appTextStyleHeading(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const SizedBox(height: 30),

                // Email
                InputField(
                  controller: controller.emailController,
                  hint: "Email your email",
                ),

                const SizedBox(height: 20),

                // Password
                Obx(() => InputField(
                  controller: controller.passwordController,
                  hint: "Enter your password",
                  obscureText: controller.isPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.bgColor,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),

                const SizedBox(height: 16),

                // Remember me & Forgot password
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.to(ForgotPasswordScreen()),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFFFFD633),
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
                    text: "Login",
                    color: Colors.white,
                    textColor: Colors.black,
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
                            text: "Register Now",
                            style: TextStyle(
                              color: Colors.yellowAccent,
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
