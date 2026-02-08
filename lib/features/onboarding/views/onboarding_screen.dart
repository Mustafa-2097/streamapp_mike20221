import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:testapp/features/onboarding/views/widgets/onboarding_page.dart';
import '../../../core/const/app_colors.dart';
import '../controllers/onboarding_controller.dart';
import '../model/onboarding_data.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF0D0D0C),
      body: Stack(
        children: [
          /// ---------------- PageView ----------------
          PageView.builder(
            controller: controller.pageController,
            itemCount: pages.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return OnboardingPage(data: pages[index]);
            },
          ),

          /// ---------------- Page Indicator ----------------
          Positioned(
            bottom: kBottomNavigationBarHeight * 4,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() {
                /// This ensures reactive update
                final page = controller.currentPage.value;
                return SmoothPageIndicator(
                  controller: controller.pageController,
                  count: pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.bgColor,
                    dotColor: AppColors.bgColor.withOpacity(0.16),
                    dotHeight: 10.h,
                    dotWidth: 10.w,
                    expansionFactor: 3,
                  ),
                );
              }),
            ),
          ),

          /// ---------------- Next / Study Now Button ----------------
          Positioned(
            bottom: kBottomNavigationBarHeight * 2.5,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() {
                final isLast = controller.currentPage.value == pages.length - 1;
                return GestureDetector(
                  onTap: controller.nextPage,
                  child: Container(
                    width: sw*0.9,
                    padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      isLast ? "Get Started" : "Next",
                      style: GoogleFonts.inter(fontSize: sw * 0.036, fontWeight: FontWeight.w700, color: AppColors.textColor),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
