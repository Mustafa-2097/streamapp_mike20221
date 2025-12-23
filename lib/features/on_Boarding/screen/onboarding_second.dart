import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/core/const/images_path.dart';
import 'package:testapp/features/on_Boarding/screen/onboarding_third.dart';

class OnboardingSecond extends StatelessWidget {
  const OnboardingSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImagesPath.onboard2,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 20),

          const Text(
            'Best online courses in the world',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Now you can learn anywhere, anytime, even if there’s no internet',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          Image.asset(IconsPath.slider1, width: 30, height: 30),

          const SizedBox(height: 40),

          CustomButton(
            text: "Get Started",
            onPressed: () {
              Get.to(const OnboardingThird());
            },
          ),
        ],
      ),
    );
  }
}
