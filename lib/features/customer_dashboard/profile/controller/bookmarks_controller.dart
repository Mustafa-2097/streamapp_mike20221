import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../clips/model/clips_model.dart';
import '../../news/controller/news_controller.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["Live", "Replay", "Clips", "News"];
  final RxList<ClipModel> clipBookmarks = <ClipModel>[].obs;
  final RxList<Map<String, dynamic>> newsBookmarks =
      <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsBookmarks();
  }

  Future<void> fetchNewsBookmarks() async {
    try {
      isLoading.value = true;
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.get(
        ApiEndpoints.myBookmarks,
        headers: headers,
      );
      if (response['success'] == true && response['data'] != null) {
        List<Map<String, dynamic>> rawBookmarks =
            List<Map<String, dynamic>>.from(response['data']);
        List<Map<String, dynamic>> enrichedBookmarks = [];

        // For each bookmark, fetch the full news details if not present
        for (var bookmark in rawBookmarks) {
          final newsId = bookmark['newsId'];
          if (newsId != null) {
            try {
              // We use NewsController to fetch the specific article
              final article = await Get.find<NewsController>().fetchNewsById(
                newsId.toString(),
              );
              if (article != null) {
                enrichedBookmarks.add({
                  ...bookmark,
                  'news': {
                    'id': article.id,
                    'title': article.title,
                    'imageUrl': article.urlToImage,
                    'createdAt': article.publishedAt,
                    'author': article.author,
                    'isBookmarked': true, // It is in our bookmarks after all
                  },
                });
              }
            } catch (e) {
              print("Error enriched bookmark $newsId: $e");
            }
          }
        }
        newsBookmarks.assignAll(enrichedBookmarks);
      }
    } catch (e) {
      print("Error fetching news bookmarks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNewsBookmark(String bookmarkId, int index) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.delete(
        ApiEndpoints.deleteBookmark(bookmarkId),
        headers: headers,
      );
      if (response['success'] == true) {
        newsBookmarks.removeAt(index);
      }
    } catch (e) {
      print("Error deleting news bookmark: $e");
    }
  }

  bool isBookmarked(ClipModel clip) {
    return clipBookmarks.any((c) => c.clipId == clip.clipId);
  }

  void toggleClip(ClipModel clip) {
    if (isBookmarked(clip)) {
      clipBookmarks.removeWhere((c) => c.clipId == clip.clipId);
    } else {
      clipBookmarks.add(clip);
    }
  }

  // Mock Data for Live Matches
  var liveBookmarks = [
    {
      "team1": "Betis",
      "team2": "Barcelona",
      "date": "Mon, Marc 23, 21",
      "time": "Soon",
    },
    {
      "team1": "Betis",
      "team2": "Barcelona",
      "date": "Mon, Marc 23, 21",
      "time": "Soon",
    },
    {
      "team1": "Betis",
      "team2": "Barcelona",
      "date": "Mon, Marc 23, 21",
      "time": "Soon",
    },
  ].obs;

  // Mock Data for Replays
  var replayBookmarks = [
    {
      "title": "Brazil VS Spain - Best Goals & Highlights",
      "duration": "5:52",
      "views": "2.1M views",
      "time": "2 hours ago",
    },
    {
      "title": "Brazil VS Spain - Best Goals & Highlights",
      "duration": "5:52",
      "views": "2.1M views",
      "time": "2 hours ago",
    },
    {
      "title": "Brazil VS Spain - Best Goals & Highlights",
      "duration": "5:52",
      "views": "2.1M views",
      "time": "2 hours ago",
    },
  ].obs;

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeLive(int index) => liveBookmarks.removeAt(index);
  void removeReplay(int index) => replayBookmarks.removeAt(index);
  void removeClip(int index) => clipBookmarks.removeAt(index);

  void removeNews(int index) {
    if (index < newsBookmarks.length) {
      final bookmarkId = newsBookmarks[index]['id'];
      if (bookmarkId != null) {
        deleteNewsBookmark(bookmarkId.toString(), index);
      } else {
        newsBookmarks.removeAt(index);
      }
    }
  }
}
