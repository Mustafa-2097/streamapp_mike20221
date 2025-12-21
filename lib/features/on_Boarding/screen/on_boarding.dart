import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/icons_path.dart';
import '../../../core/const/images_path.dart';
import 'onboarding_second.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 60), () {
      Get.off(() => const OnboardingSecond());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ImagesPath.logo, width: 223, height: 190),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const Spacer(),

          // Loading indicator at bottom
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
