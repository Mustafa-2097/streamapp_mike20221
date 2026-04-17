import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../controller/banner_controller.dart';

class HomeCarouselSlider extends StatefulWidget {
  const HomeCarouselSlider({super.key});

  @override
  State<HomeCarouselSlider> createState() => _HomeCarouselSliderState();
}

class _HomeCarouselSliderState extends State<HomeCarouselSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final BannerController _bannerController = Get.put(BannerController());

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_bannerController.isLoading.value &&
          _bannerController.bannersList.isEmpty) {
        return SizedBox(
          height: 180.h,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      if (_bannerController.bannersList.isEmpty) {
        // Fallback if no banners from api
        return SizedBox(
          height: 180.h,
          child: const Center(
            child: Text(
              "No banners available",
              style: TextStyle(color: Colors.white54),
            ),
          ),
        );
      }

      return Column(
        children: [
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: _bannerController.bannersList.length,
            options: _carouselOptions,
            itemBuilder: (context, index, realIndex) {
              return _buildCarouselItem(index);
            },
          ),
          SizedBox(height: 10.h),
          _buildIndicator(),
        ],
      );
    });
  }

  /// Carousel configuration
  CarouselOptions get _carouselOptions {
    return CarouselOptions(
      height: 180.h,
      autoPlay: true,
      enlargeCenterPage: true,
      viewportFraction: 0.7,
      aspectRatio: 16 / 9,
      onPageChanged: (index, _) {
        setState(() => _currentIndex = index);
      },
    );
  }

  /// Single carousel item
  Widget _buildCarouselItem(int index) {
    final banner = _bannerController.bannersList[index];

    // Sanitize url if needed
    final imageUrl = banner.imageUrl
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59')
        .replaceFirst('undefined/', 'http://10.0.30.59:8000/');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[800],
            child: const Icon(Icons.error, color: Colors.white54),
          ),
        ),
      ),
    );
  }

  /// Dots indicator
  Widget _buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: _currentIndex,
      count: _bannerController.bannersList.length,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColors.primaryColor,
        dotColor: AppColors.bgColor,
        dotHeight: 8.h,
        dotWidth: 8.w,
      ),
      onDotClicked: (index) {
        _carouselController.animateToPage(index);
      },
    );
  }
}
