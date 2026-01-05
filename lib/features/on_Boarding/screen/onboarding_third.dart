import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/custom_button.dart';
import 'package:testapp/core/const/icons_path.dart';
import 'package:testapp/core/const/images_path.dart';
import 'package:testapp/features/on_Boarding/screen/onboarding4.dart';

class OnboardingThird extends StatelessWidget {
  const OnboardingThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImagesPath.onboard3,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 20),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: 'ALL '),
                TextSpan(
                  text: 'SPORTS',
                  style: TextStyle(color: Colors.yellow),
                ),
                TextSpan(text: ' IN ONE APP'),
              ],
            ),
          ),

          SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Stream every victory in real time. From legendary rivalries to unforgettable highlights.',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),

          Image.asset(IconsPath.slider2, width: 30, height: 30),

          const SizedBox(height: 40),

          CustomButton(
            text: "Get Started",
            onPressed: () {
              Get.to(OnboardingScreenFourth());
            },
          ),

          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.white),
                children: [
                  TextSpan(text: 'By continuing, you agree to our '),
                  TextSpan(
                    text: 'Terms & Privacy Policy',
                    style: TextStyle(
                      color: Color(0xFFE3AE34),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
