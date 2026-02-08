import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_back_icon.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get isSignUp from arguments
    final arguments = Get.arguments ?? {};
    final isSignUp = arguments['isSignUp'] ?? false;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3A0F0F),
              Color(0xFF0B0B0B),
              Color(0xFF000000),
            ],
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

                const Spacer(),

                Center(
                  child: Column(
                    children: [
                      Image.asset(IconsPath.success, width: 120, height: 120),

                      const SizedBox(height: 30),

                      Text(
                        isSignUp ? "ACCOUNT CREATED!" : "SUCCESS!",
                        style: appTextStyleHeading(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        isSignUp
                            ? "Your account has been created successfully."
                            : "Your password has been changed successfully.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 33),

                      CustomButton(
                        text: isSignUp ? "Continue to Login" : "Back to Login",
                        onPressed: () {
                          Get.offAll(() => SignInScreen());
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
