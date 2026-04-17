import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';
import '../model/plan_model.dart';
import '../../data/customer_api_service.dart';
import 'paypal_webview_screen.dart';

class PaymentScreen extends StatefulWidget {
  final PlanModel plan;

  const PaymentScreen({super.key, required this.plan});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'PayPal';
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Fetch profile to get userId
      final profileResponse = await CustomerApiService.getProfile();
      final data = profileResponse['data'];
      if (data == null || data['id'] == null) {
        throw Exception("Could not find user ID to process payment");
      }
      final userId = data['id'].toString();

      // Create checkout session
      final checkoutResponse = await CustomerApiService.createCheckoutSession(
        planId: widget.plan.id,
        userId: userId,
      );

      if (checkoutResponse['success'] == true && checkoutResponse['data'] != null) {
        final approvalUrl = checkoutResponse['data']['approvalUrl'];
        if (approvalUrl != null) {
          // Open the WebView and wait for the result
          final paymentResult = await Get.to(() => PaypalWebViewScreen(approvalUrl: approvalUrl));
          
          if (paymentResult == true) {
            // Only show success dialog IF we returned a true success state
            if (mounted) {
              _showSuccessDialog();
            }
          } else {
            Get.snackbar('Cancelled', 'Payment was not completed.', colorText: Colors.black, backgroundColor: AppColors.primaryColor, snackPosition: SnackPosition.TOP);
          }
        }
      } else {
        Get.snackbar(
          'Error',
          checkoutResponse['message'] ?? 'Payment failed to initiate',
          colorText: Colors.black,
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Error already handled in ApiService globally
      debugPrint("Payment Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      backgroundColor: Colors.grey.shade900,
      title: 'Success!',
      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60.r),
          SizedBox(height: 16.h),
          Text(
            'Your payment was processed successfully. Your subscription will be updated shortly!',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
        onPressed: () {
          Get.back(); // close dialog
          Get.back(); // close payment screen
        },
        child: Text('Done', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldBg(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        'CHECKOUT',
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

              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  children: [
                    // Order Summary
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.plan.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.plan.formattedPrice,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Billing Cycle: ${widget.plan.billingCycle}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Divider(color: Colors.white12),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.plan.formattedPrice,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Payment Method
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    // PayPal Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'PayPal';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: _selectedPaymentMethod == 'PayPal'
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _selectedPaymentMethod == 'PayPal'
                                ? AppColors.primaryColor
                                : Colors.white12,
                            width: _selectedPaymentMethod == 'PayPal' ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.paypal, color: Colors.blueAccent, size: 30.r),
                            SizedBox(width: 16.w),
                            Text(
                              'PayPal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            if (_selectedPaymentMethod == 'PayPal')
                              Icon(Icons.check_circle, color: AppColors.primaryColor, size: 24.r),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Pay Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: _isProcessing
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Pay ${widget.plan.formattedPrice}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
