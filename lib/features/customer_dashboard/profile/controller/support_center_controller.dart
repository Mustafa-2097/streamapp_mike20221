import 'package:get/get.dart';

class SupportCenterController extends GetxController {
  static SupportCenterController get instance => Get.find();

  var isLoading = false.obs;
  void toggle() => isLoading.value = !isLoading.value;

  /// -1 means all collapsed
  var expandedIndex = (-1).obs;

  final List<Map<String, String>> faqList = [
    {
      "title": "How do I reset my password?",
      "content":
      "To reset your password, go to the login screen and tap on 'Forgot Password'. Enter the email address associated with your account, and we will send you a secure link to create a new password."
    },
    {
      "title": "How can I update my account information?",
      "content":
      "You can update your personal details by navigating to the Profile section and tapping on 'Personal Data'. From there, you can change your name, date of birth, country, and profile picture."
    },
    {
      "title": "What should I do if I experience a technical issue?",
      "content":
      "If you experience any playback or streaming issues, please ensure your app is up to date and re-launch it. If the problem persists, navigate to 'Contact Us' in the Profile section and send a message to our support team."
    },
    {
      "title": "How do I manage my subscription?",
      "content":
      "To view or change your current plan, go to the Profile section and tap on 'Subscription'. Here you can upgrade your plan to unlock exclusive PPV events, live streams, and premium ad-free viewing."
    },
    {
      "title": "How do I securely log out of my account?",
      "content":
      "You can log out by scrolling to the bottom of the Profile page and tapping the 'Logout' button. You will be asked to confirm before your session is securely closed."
    },
  ];

  /// Toggle expanded item
  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // collapse
    } else {
      expandedIndex.value = index; // expand new item
    }
  }
}
