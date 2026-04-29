import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../../data/customer_api_service.dart';
import '../model/plan_model.dart';
import '../widgets/subscription_bottom_sheet.dart';
import 'payment_screen.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  List<PlanModel> plans = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    try {
      final response = await CustomerApiService.getPlans();
      if (response['success'] == true) {
        final List list = (response['data'] ?? []) as List;
        setState(() {
          plans = list.map((e) => PlanModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = response['message'] ?? 'Failed to load plans';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load plans';
        isLoading = false;
      });
    }
  }

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
                    SizedBox(width: 40.w),
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
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      )
                    : error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              error,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                  error = '';
                                });
                                _fetchPlans();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: _buildPlanCard(
                              context: context,
                              plan: plan,
                              isMostPopular:
                                  plan.isPremium &&
                                  plan.billingCycle == 'MONTHLY',
                            ),
                          );
                        },
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
    required PlanModel plan,
    bool isMostPopular = false,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PaymentScreen(plan: plan));
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Most Popular Badge
            if (isMostPopular)
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
  
            // Plan Name + Type Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _planTypeColor(plan.type).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: _planTypeColor(plan.type).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    plan.type,
                    style: TextStyle(
                      color: _planTypeColor(plan.type),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
  
            // Price Section
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/subscription_logo.png",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        plan.formattedPrice,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (plan.billingLabel.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Text(
                          plan.billingLabel,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Divider(color: Colors.grey.shade700),
            SizedBox(height: 10.h),
  
            // Features (show first 3)
            ...plan.features
                .take(3)
                .map(
                  (f) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildFeatureRow(f),
                  ),
                ),
  
            // See more button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showSubscriptionBottomSheet(context, plan: plan);
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
      ),
    );
  }

  Color _planTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'FREE':
        return Colors.grey;
      case 'PREMIUM':
        return const Color(0xFFF59E0B); // Amber
      case 'SUPERFAN':
        return const Color(0xFF8B5CF6); // Purple
      default:
        return Colors.white;
    }
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: AppColors.primaryColor, size: 18.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
