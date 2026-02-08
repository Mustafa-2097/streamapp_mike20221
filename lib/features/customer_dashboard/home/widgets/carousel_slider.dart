import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/const/app_colors.dart';

class HomeCarouselSlider extends StatefulWidget {
  const HomeCarouselSlider({super.key});

  @override
  State<HomeCarouselSlider> createState() => _HomeCarouselSliderState();
}

class _HomeCarouselSliderState extends State<HomeCarouselSlider> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  int _currentIndex = 0;

  final List<String> _imageUrls = [
    'assets/images/slider.png',
    'assets/images/slider.png',
    'assets/images/slider.png',
    'assets/images/slider.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: _imageUrls.length,
          options: _carouselOptions,
          itemBuilder: (context, index, realIndex) {
            return _buildCarouselItem(index);
          },
        ),
        SizedBox(height: 10.h),
        _buildIndicator(),
      ],
    );
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
    return Container(
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
        child: Image.asset(
          _imageUrls[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Dots indicator
  Widget _buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: _currentIndex,
      count: _imageUrls.length,
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
