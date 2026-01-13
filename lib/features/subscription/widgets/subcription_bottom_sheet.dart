import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
        maxHeight: MediaQuery.of(context).size.height * 0.9, // Limit max height to 90% of screen
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // This should now work properly
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Header with back button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Subscription Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '19:27',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey[800], thickness: 1),

          // Content - REMOVED Expanded widget
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Add this
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'SUBSCRIBE TO PREMIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Enjoy watching Full-HD videos, without restrictions and without ads',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),

                // Package Title
                Text(
                  'MONTHLY MEMBERSHIP',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),

                // Price Section
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$9.99 - \$7.99 /Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Save 20%',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'BEST VALUE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Feature Description
                Text(
                  'Under this package, you will be entitled to those feature',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20.h),

                // Feature List Title
                Text(
                  'Feature List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                // Feature Items
                ..._buildFeatureList(),
                SizedBox(height: 32.h),

                // Buy Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close bottom sheet
                      // Then process payment
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
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
                SizedBox(height: 20.h), // Extra padding at bottom
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
              Icons.check_circle,
              color: Colors.green,
              size: 18.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                feature,
                style: TextStyle(
                  color: Colors.white,
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