import 'package:get/get.dart';

class SupportCenterController extends GetxController {
  static SupportCenterController get instance => Get.find();

  var isLoading = false.obs;
  void toggle() => isLoading.value = !isLoading.value;

  /// -1 means all collapsed
  var expandedIndex = (-1).obs;

  /// FAQ List
  final List<Map<String, String>> faqList = [
    {
      "title": "How do I reset my password?",
      "content":
      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
    },
    {
      "title": "How can I update my account information?",
      "content":
      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint."
    },
    {
      "title": "What should I do if I experience a technical issue?",
      "content":
      "Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
    },
    {
      "title": "How do I delete my account?",
      "content":
      "Consequat sunt nostrud amet exercitation veniam velit mollit."
    },
    {
      "title": "Where can I find the latest updates on app features?",
      "content":
      "Consequat sunt nostrud amet exercitation veniam velit mollit."
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
