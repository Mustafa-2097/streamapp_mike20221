import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/const/app_colors.dart';
import '../../model/onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Column(
      children: [
        /// ----------- Image -----------
        Stack(
          children: [
            Image.asset(
              data.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Bottom shadow/gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140, // shadow height
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xFF0D0D0C),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),


        /// ----------- Title + Subtitle -----------
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              SizedBox(height: sh * 0.025),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF6F7F9)
                ),
              ),
              SizedBox(height: sh * 0.005),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bgColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
