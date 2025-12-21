import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/on_Boarding/screen/on_boarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
