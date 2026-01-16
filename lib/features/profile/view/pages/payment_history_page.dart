import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';
import '../../../../core/const/app_colors.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "PAYMENT HISTORY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 390,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade800,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Stripe box
                          Container(
                            height: 52,
                            width: 52,
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.asset(
                              "assets/images/stripe.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transfer from Stripe",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Transaction ID",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
                              Text(
                                "123456789",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$9.00",
                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.primaryColor,
                                ),
                                child: Text(
                                  "Confirmed",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "16 Sep 2026 11.21 AM",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
