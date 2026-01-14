import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import '../../../core/const/app_colors.dart';
import '../widgets/subscription_bottom_sheet.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldBg(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'SUBSCRIPTION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w), // For symmetry
                  ],
                ),
              ),
                
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'SUBSCRIBE TO PREMIUM',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.h),
                
              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Enjoy watching Full-HD videos, without restrictions and without ads',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),
                
              // Subscription Plans
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  children: [
                    // Plan 1
                    _buildPlanCard(
                      context: context,
                      originalPrice: '\$9.99',
                      discountedPrice: '\$7.99',
                      savePercent: '20%',
                    ),
                    SizedBox(height: 20.h),
                
                    // Plan 2
                    _buildPlanCard(
                      context: context,
                      originalPrice: '\$9.99',
                      discountedPrice: '\$7.99',
                      savePercent: '20%',
                      isMostPopular: true,
                    ),
                    SizedBox(height: 20.h),
                
                    // Plan 3
                    _buildPlanCard(
                      context: context,
                      originalPrice: '\$9.99',
                      discountedPrice: '\$7.99',
                      savePercent: '20%',
                    ),
                
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String originalPrice,
    required String discountedPrice,
    required String savePercent,
    bool isMostPopular = false,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              children: [
                Image.asset("assets/images/subscription_logo.png", width: 50, fit: BoxFit.cover),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      originalPrice,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey[400],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      discountedPrice,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '/Live',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Save $savePercent',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.grey.shade700),
          SizedBox(height: 10.h),

          // Features
          _buildFeatureRow('Watch all you want. Ad-free.'),
          SizedBox(height: 12.h),
          _buildFeatureRow('Allows streaming of 4K.'),
          SizedBox(height: 12.h),
          _buildFeatureRow('Video & Audio Quality is Better.'),
          SizedBox(height: 12.h),

          // See more button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                showSubscriptionBottomSheet(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'See more',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check,
          color: AppColors.primaryColor,
          size: 18.r,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}