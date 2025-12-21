import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/core/const/images_path.dart';
import 'package:testapp/features/auth/signup/screen/signup_screen.dart';

class OnboardingThird extends StatelessWidget {
  const OnboardingThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: Image.asset(ImagesPath.onboard2, width: 350, height: 350),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 20),
          const Text(
            'Explore your new skill today',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Now you can learn anywhere, anytime, even if theres no internet',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 40),
          Image.asset(IconsPath.slider1, width: 30, height: 30),
          SizedBox(height: 40),
          CustomButton(
            text: "Get Started",
            onPressed: () {
              Get.to(SignUpScreen());
            },
          ),
        ],
      ),
    );
  }
}
