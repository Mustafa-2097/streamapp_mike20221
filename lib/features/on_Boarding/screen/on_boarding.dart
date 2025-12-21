import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/icons_path.dart';
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

    Timer(const Duration(seconds: 2), () {
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(IconsPath.carIcon, width: 100, height: 100),
              const SizedBox(height: 20),
              const Text(
                'Theory test in my language',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "I must write the real test will be in English language and this app just helps you to understand the materials in your language",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
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
