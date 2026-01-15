import 'package:get/get.dart';

class NewsController extends GetxController {
  static NewsController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["All", "Football", "BasketBall"];

  // Mock Data for Replays
  var newsData = [
    {"title": "Brazil VS Spain - Best Goals & Highlights", "date": "12 October 2026", "read": "12k read"},
    {"title": "Brazil VS Spain - Best Goals & Highlights", "date": "12 October 2026", "read": "12k read"},
    {"title": "Brazil VS Spain - Best Goals & Highlights", "date": "12 October 2026", "read": "12k read"},
  ].obs;

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeNews(int index) => newsData.removeAt(index);
}