import 'package:get/get.dart';
import '../../clips/model/clips_model.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["Live", "Replay", "Clips", "News"];
  final RxList<ClipItem> clipBookmarks = <ClipItem>[].obs;

  bool isBookmarked(ClipItem clip) {
    return clipBookmarks.any((c) => c.id == clip.id);
  }
  void toggleClip(ClipItem clip) {
    if (isBookmarked(clip)) {
      clipBookmarks.removeWhere((c) => c.id == clip.id);
    } else {
      clipBookmarks.add(clip);
    }
  }

  // Mock Data for Live Matches
  var liveBookmarks = [
    {"team1": "Betis", "team2": "Barcelona", "date": "Mon, Marc 23, 21", "time": "Soon"},
    {"team1": "Betis", "team2": "Barcelona", "date": "Mon, Marc 23, 21", "time": "Soon"},
    {"team1": "Betis", "team2": "Barcelona", "date": "Mon, Marc 23, 21", "time": "Soon"},
  ].obs;

  // Mock Data for Replays
  var replayBookmarks = [
    {"title": "Brazil VS Spain - Best Goals & Highlights", "duration": "5:52", "views": "2.1M views", "time": "2 hours ago"},
    {"title": "Brazil VS Spain - Best Goals & Highlights", "duration": "5:52", "views": "2.1M views", "time": "2 hours ago"},
    {"title": "Brazil VS Spain - Best Goals & Highlights", "duration": "5:52", "views": "2.1M views", "time": "2 hours ago"},
  ].obs;

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeLive(int index) => liveBookmarks.removeAt(index);
  void removeReplay(int index) => replayBookmarks.removeAt(index);
  void removeClip(int index) => clipBookmarks.removeAt(index);

}