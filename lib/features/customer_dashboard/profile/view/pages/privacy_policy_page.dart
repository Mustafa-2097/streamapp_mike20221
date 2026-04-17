import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "PRIVACY POLICY",
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
                    "Privacy Policy for TotalMix Media",
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

                  const SectionTitle("Welcome"),
                  const SectionText(
                    "Welcome to TotalMix Media (“we,” “our,” or “us”).\n\n"
                    "TotalMix Media is committed to protecting your privacy. "
                    "This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application, website, and services.\n\n"
                    "By using TotalMix Media, you agree to the terms of this Privacy Policy.",
                  ),

                  const SectionTitle("Information We Collect"),
                  const SectionText(
                    "• Name, email, account details\n"
                    "• Usage data (videos watched, device info, IP address)\n"
                    "• Payment data (handled by secure third-party providers)",
                  ),

                  const SectionTitle("How We Use Information"),
                  const SectionText(
                    "• Provide streaming services\n"
                    "• Process subscriptions\n"
                    "• Improve platform performance\n"
                    "• Communicate updates",
                  ),

                  const SectionTitle("Data Sharing"),
                  const SectionText(
                    "We do not sell your data. We only share with:\n\n"
                    "• Service providers\n"
                    "• Legal authorities (if required)",
                  ),

                  const SectionTitle("Security"),
                  const SectionText(
                    "We use industry-standard protections, but no system is fully secure.",
                  ),

                  const SectionTitle("Children"),
                  const SectionText("Not intended for users under 13."),

                  const SectionTitle("Contact"),
                  const SectionText("support@totalmixmedia.com"),
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
      padding: EdgeInsets.only(top: 20.r, bottom: 8.r),
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
