import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "TERMS AND CONDITIONS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Terms and Conditions for TotalMix Media",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const Text(
                    "Effective Date: April 8, 2026",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 24.h),

                  const SectionText(
                    "By using TotalMix Media, you agree to these terms.",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("1. Use of Service"),
                  const SectionText(
                    "You agree to use the app only for lawful purposes.\n"
                    "You may NOT:\n"
                    "• Stream or distribute pirated content\n"
                    "• Abuse chat features\n"
                    "• Attempt to hack or disrupt the app",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("2. Account Responsibility"),
                  const SectionText(
                    "You are responsible for:\n"
                    "• Maintaining your login credentials\n"
                    "• All activity under your account",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("3. Subscriptions & Access"),
                  const SectionText(
                    "• Some content may require payment (PPV or subscription)\n"
                    "• Access may be limited based on your plan",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("4. Content Ownership"),
                  const SectionText(
                    "All content on TotalMix Media is owned or licensed.\n"
                    "You may NOT:\n"
                    "• Copy, record, or redistribute content\n"
                    "• Use content for commercial purposes",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("5. Service Availability"),
                  const SectionText(
                    "We do not guarantee uninterrupted service.\n"
                    "Streaming quality may vary based on internet connection.",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("6. Termination"),
                  const SectionText(
                    "We may suspend or terminate accounts for:\n"
                    "• Violations of these terms\n"
                    "• Abusive behavior\n"
                    "• Illegal activity",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("7. Limitation of Liability"),
                  const SectionText(
                    "TotalMix Media is not liable for:\n"
                    "• Service interruptions\n"
                    "• Data loss\n"
                    "• Third-party service issues",
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.white24),

                  const SectionTitle("8. Changes to Terms"),
                  const SectionText("We may update these terms at any time."),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.r, bottom: 6.r),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        height: 1.5,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }
}
