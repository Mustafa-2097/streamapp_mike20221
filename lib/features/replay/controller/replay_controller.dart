import 'package:get/get.dart';

class ReplayController extends GetxController {
  static ReplayController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["All", "Replay", "Full Game"];

  // Mock Data for Replays
  var replayBookmarks = [
    {"title": "Brazil VS Spain - Best Goals & Highlights", "duration": "5:52", "views": "2.1M views", "time": "2 hours ago"},
    {"title": "Brazil VS Spain - Best Goals & Highlights", "duration": "5:52", "views": "2.1M views", "time": "2 hours ago"},
    {"title": "Brazil VS Spain - Best Goals & Highlights", "duration": "5:52", "views": "2.1M views", "time": "2 hours ago"},
  ].obs;

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeReplay(int index) => replayBookmarks.removeAt(index);
}