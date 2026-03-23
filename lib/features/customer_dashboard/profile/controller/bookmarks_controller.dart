import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../clips/model/clips_model.dart';
import '../../news/controller/news_controller.dart';
import '../../replay/model/replay_model.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["Upcoming Live", "Replay", "Clips", "News"];
  final RxList<ClipModel> clipBookmarks = <ClipModel>[].obs;
  final RxList<ReplayModel> replayBookmarks = <ReplayModel>[].obs;
  final RxList<Map<String, dynamic>> newsBookmarks =
      <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsBookmarks();
    fetchClipBookmarks();
    fetchReplayBookmarks();
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

  Future<void> fetchClipBookmarks() async {
    try {
      isLoading.value = true;
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.get(
        ApiEndpoints.myClipBookmarks,
        headers: headers,
      );
      if (response['success'] == true && response['data'] != null) {
        List data = response['data'];
        clipBookmarks.value = data
            .map((e) => ClipModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print("Error fetching clip bookmarks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReplayBookmarks() async {
    try {
      isLoading.value = true;
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.get(
        ApiEndpoints.myReplayBookmarks,
        headers: headers,
      );
      if (response['success'] == true && response['data'] != null) {
        List data = response['data'];
        replayBookmarks.value = data
            .map((e) => ReplayModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print("Error fetching replay bookmarks: $e");
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

  Future<void> toggleClip(ClipModel clip) async {
    // Optimistic Update
    bool wasBookmarked = isBookmarked(clip);
    if (wasBookmarked) {
      clipBookmarks.removeWhere((c) => c.clipId == clip.clipId);
    } else {
      clipBookmarks.add(clip);
    }

    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final body = {"clipId": clip.clipId};
      final response = await ApiService.post(
        ApiEndpoints.clipBookmark,
        body: body,
        headers: headers,
      );

      if (response['success'] != true) {
        // Revert optimistic update on failure
        if (wasBookmarked) {
          clipBookmarks.add(clip);
        } else {
          clipBookmarks.removeWhere((c) => c.clipId == clip.clipId);
        }
      }
    } catch (e) {
      // Revert optimistic update on error
      if (wasBookmarked) {
        clipBookmarks.add(clip);
      } else {
        clipBookmarks.removeWhere((c) => c.clipId == clip.clipId);
      }
      print("Error toggling clip bookmark: $e");
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

  // Mock Data for Replays (Removed)
  // var replayBookmarks = [...]

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeLive(int index) => liveBookmarks.removeAt(index);

  Future<void> removeReplay(int index) async {
    if (index < replayBookmarks.length) {
      final replay = replayBookmarks[index];
      try {
        final String? token = await SharedPreferencesHelper.getToken();
        final headers = {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        };
        final body = {"replayId": replay.replayId};
        final response = await ApiService.post(
          ApiEndpoints.replaysBookmark,
          body: body,
          headers: headers,
        );
        if (response['success'] == true) {
          replayBookmarks.removeAt(index);
        }
      } catch (e) {
        print("Error removing replay bookmark: $e");
      }
    }
  }

  Future<void> removeClip(int index) async {
    if (index < clipBookmarks.length) {
      final clip = clipBookmarks[index];
      try {
        final String? token = await SharedPreferencesHelper.getToken();
        final headers = {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        };
        final response = await ApiService.delete(
          ApiEndpoints.deleteClipBookmark(clip.clipId),
          headers: headers,
        );
        if (response['success'] == true) {
          clipBookmarks.removeAt(index);
        }
      } catch (e) {
        print("Error deleting clip bookmark: $e");
      }
    }
  }

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
