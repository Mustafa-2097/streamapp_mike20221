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
        title: Text(
          "TERMS AND CONDITIONS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Don’t Blow Your Licence App\nLast updated: 21/12/2025",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 16),

                      SectionTitle("1. Introduction"),
                      SectionText(
                          "Welcome to Don’t Blow Your Licence (“we”, “us”, “our”).\n"
                              "These Terms & Conditions govern your access to and use of the Don’t Blow Your Licence mobile application and any related services or content (the “App”).\n\n"
                              "By downloading, accessing, or using the App, you agree to be bound by these Terms & Conditions. If you do not agree, you must not use the App."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("2. Purpose of the App"),
                      SectionText(
                          "Don’t Blow Your Licence is an educational and preventative behaviour-change tool designed to help users understand the risks, consequences, and impacts of drink and drug driving, and to support safer decision-making.\n\n"
                              "The App:\n\n"
                              "• Is educational only\n"
                              "• Does not provide legal, medical, psychological, or clinical advice\n"
                              "• Is not a substitute for professional treatment, legal advice, or court-mandated programs unless explicitly stated"
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("3. Eligibility"),
                      SectionText(
                          "To use the App, you must:\n\n"
                              "• Be at least 16 years of age; and\n"
                              "• If you are under 18 years of age, have the consent of a parent or legal guardian to use the App and to the collection, use, and storage of your information in accordance with our Privacy Policy; and\n"
                              "• Be legally capable of entering into this agreement, either personally or through a parent or legal guardian.\n\n"
                              "By accessing or using the App, you confirm that you meet these eligibility requirements."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("4. Parental / Guardian Responsibility"),
                      SectionText(
                          "If you are under 18, your parent or legal guardian:\n\n"
                              "• Is responsible for reviewing these Terms & Conditions\n"
                              "• Accepts responsibility for your use of the App\n"
                              "• Consents to the collection and use of your information as described in the Privacy Policy"
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("5. User Responsibilities"),
                      SectionText(
                          "By using the App, you agree that you will:\n\n"
                              "• Use the App lawful purposes only\n"
                              "• Provide accurate information where required\n"
                              "• Not misuse, copy, modify, distribute, or attempt to reverse engineer the App\n"
                              "• Not interfere with the App’s security, systems, or functionality\n\n"
                              "You acknowledge that all decisions and actions related to driving and road use remain your personal responsibility at all times."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("6. No Guarantee of Outcomes"),
                      SectionText(
                          "While the App is designed to support reflection, awareness, and safer choices, we do not guarantee:\n\n"
                              "• Behavioural change\n"
                              "• Avoidance of drink or drug driving\n"
                              "• Prevention of licence loss\n"
                              "• Avoidance of legal or personal consequences\n\n"
                              "Outcomes depend on individual choices and circumstances"
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("7. Intellectual Property"),
                      SectionText(
                          "All content within the App — including text, videos, graphics, exercises, branding, and logos — is owned by or licensed to Don’t Blow Your Licence and is protected under Australian and international intellectual property laws."
                              "\n\nYou may not reproduce, distribute, modify, or commercialise any content without prior written consent."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("8. Payments & Subscriptions & Purchases (if applicable)"),
                      SectionText(
                          "If the App includes paid features, subscriptions, or in-app purchases:\n\n"
                              "• Prices will be clearly disclosed before purchase\n"
                              "• Payments are processed through third-party platforms (such as Apple App Store or Google Play)\n"
                              "• Refunds are subject to the policies of those platforms, except where required by Australian Consumer Law"
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("9. Privacy & Data Collection"),
                      SectionText(
                          "Your privacy is important to us.\n"
                              "Use of the App is also governed by our Privacy Policy, which explains:\n\n"
                              "• What information we collect\n"
                              "• How it is used and stored\n"
                              "• How we protect your information\n"
                              "• Your rights under Australian privacy laws\n\n"
                              "By using the App, you consent to the handling of your information as described in the Privacy Policy."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("10. Users Under 18"),
                      SectionText(
                          "The App may be used by individuals aged 16 years and over."
                              "If you are under 18 years of age:\n\n"
                              "• You may only use the App with parental or guardian consent\n"
                              "• We take additional care to minimise data collection\n"
                              "• We do not knowingly sell, trade, or misuse personal information of minors\n\n"
                              "Parents or guardians may contact us to request access to, correction of, or deletion of a minor’s information, subject to legal requirements."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("11. Third-Party Links"),
                      SectionText(
                          "The App may include links to third-party websites or services. We are not responsible for:\n\n"
                              "• The content, accuracy, or availability of third-party services\n"
                              "• Any loss or damage arising from third-party use\n\n"
                              "Accessing third-party services is at your own risk."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("12. Limitation of Liability"),
                      SectionText(
                          "To the maximum extent permitted by law: \n\n"
                              "• We exclude all warranties not expressly stated\n"
                              "• We are not liable for indirect, incidental, or consequential loss\n"
                              "• We are not responsible for decisions or actions taken based on App content\n\n"
                              "Nothing in these Terms limits rights under Australian Consumer Law."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("13. Suspension or Termination"),
                      SectionText(
                          "We may suspend or terminate your access to the App if: \n\n"
                              "• You breach these Terms\n"
                              "• The App is discontinued\n"
                              "• Required by law or regulation\n\n"
                              "Upon termination, your right to use the App immediately ceases."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("14. Changes to These Terms"),
                      SectionText(
                          "We may update these Terms & Conditions from time to time. "
                              "Continued use of the App after changes are published constitutes acceptance of the updated Terms."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("15. Governing Law"),
                      SectionText(
                          "These Terms are governed by the laws of Victoria, Australia, and any disputes will be subject to the exclusive jurisdiction of Victorian courts."
                      ),
                      SizedBox(height: 10.h),
                      Divider(),

                      SectionTitle("16. Contact Us"),
                      // RichText(
                      //   text: TextSpan(
                      //     style: TextStyle(fontSize: 14.sp, color: Colors.black),
                      //     children: [
                      //       const TextSpan(
                      //         text: "Email: at@drinkdrivevictoria.com.au\n",
                      //       ),
                      //       const TextSpan(
                      //         text: "Website: ",
                      //       ),
                      //       TextSpan(
                      //         text: "www.dontblowyourlicence.com.au",
                      //         style: const TextStyle(
                      //           color: Colors.blue,
                      //           decoration: TextDecoration.underline,
                      //         ),
                      //         recognizer: TapGestureRecognizer()
                      //           ..onTap = () {
                      //             _launchUrl("https://www.dontblowyourlicence.com.au");
                      //           },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
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
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
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
      style: TextStyle(fontSize: 14.sp, height: 1.5, color: Colors.white),
    );
  }
}
