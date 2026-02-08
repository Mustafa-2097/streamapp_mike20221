import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';

void showSubscriptionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.r),
      ),
    ),
    builder: (context) {
      return const SubscriptionBottomSheet();
    },
  );
}

class SubscriptionBottomSheet extends StatelessWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
              width: 60.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(11.r),
              ),
            ),
          ),

          // Content - REMOVED Expanded widget
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Add this
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'MONTHLY MEMBERSHIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Price Section
                Column(
                  children: [
                    Image.asset("assets/images/subscription_logo.png", width: 50, fit: BoxFit.cover),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$9.99',
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
                          '\$9.99',
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
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 70),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Save 20%',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Feature Description
                Text(
                  'Under this package, you will be entitled to those feature',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 20.h),

                // Feature List Title
                Text(
                  'Feature List',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                // Feature Items
                ..._buildFeatureList(),
                SizedBox(height: 16.h),

                // Buy Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close bottom sheet
                      // Then process payment
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h), // Extra padding at bottom
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      'Unlimited live streaming access',
      'Full match replays (30 days archive)',
      'Completely ad-free',
      'Full HD / 4K streaming (where available)',
      'Priority access to breaking news',
      'Faster streaming & reduced buffering',
    ];

    return features
        .map(
          (feature) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check,
              color: Colors.grey,
              size: 18.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                feature,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .toList();
  }
}