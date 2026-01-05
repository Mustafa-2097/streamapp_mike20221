import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/features/auth/login/screen/login_screen.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/const/images_path.dart';

class OnboardingScreenFourth extends StatelessWidget {
  const OnboardingScreenFourth({super.key});

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
        child: Column(
          children: [
            const Spacer(),

            Image.asset(ImagesPath.logo, width: 223, height: 190),

            const SizedBox(height: 80),

            RichText(
              text: TextSpan(
                style: appTextStyleHeading(fontSize: 24, color: Colors.white),
                children: const [
                  TextSpan(text: 'EXPERIENCE SPORTS - '),
                  TextSpan(
                    text: 'LIVE',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text(
              "Real-time action. Real excitement",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 40),

            CustomButton(
              text: "Login",
              textColor: Colors.white,
              color: Color(0xFF131720),
              onPressed: () {
                Get.to(SignInScreen());
              },
            ),
            SizedBox(height: 20),
            CustomButton(text: "Register Now", onPressed: () {}),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
