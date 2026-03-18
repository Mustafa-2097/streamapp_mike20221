import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../clips/model/clips_model.dart';
import '../../news/controller/news_controller.dart';
import '../../news/model/news_model.dart';
import '../../replay/model/replay_model.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["Live", "Replay", "Clips", "News"];
  final RxList<ClipModel> clipBookmarks = <ClipModel>[].obs;
  final RxList<ReplayModel> replayBookmarks = <ReplayModel>[].obs;
  final RxList<Map<String, dynamic>> newsBookmarks =
      <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isNewsLoading = false.obs;
  var isClipsLoading = false.obs;
  var isReplaysLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsBookmarks();
    fetchClipBookmarks();
    fetchReplayBookmarks();
  }

  Future<void> fetchNewsBookmarks() async {
    try {
      isNewsLoading.value = true;
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
        print("Raw News Bookmarks: ${response['data']}");
        
        dynamic dataNode = response['data'];
        List<dynamic> rawList = [];
        
        if (dataNode is List) {
          rawList = dataNode;
        } else if (dataNode is Map) {
          rawList = dataNode['bookmarks'] ?? dataNode['data'] ?? dataNode['news'] ?? [];
        }

        List<Map<String, dynamic>> rawBookmarks =
            List<Map<String, dynamic>>.from(rawList);
        List<Map<String, dynamic>> enrichedBookmarks = [];

        for (var bookmark in rawBookmarks) {
          // Case 1: Bookmark already has news object
          if (bookmark['news'] != null) {
            enrichedBookmarks.add(bookmark);
            continue;
          }

          // Case 2: Only newsId present, need to enrich
          final newsId = bookmark['newsId'] ?? bookmark['news_id'] ?? bookmark['id'];
          if (newsId != null) {
            try {
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
                    'isBookmarked': true,
                  },
                });
              } else {
                 print("Could not fetch article details for newsId: $newsId");
              }
            } catch (e) {
              print("Error enrichment on-fly for news $newsId: $e");
            }
          } else {
            print("Bookmark item missing news identifier: $bookmark");
          }
        }
        newsBookmarks.assignAll(enrichedBookmarks);
      }
    } catch (e) {
      print("Error fetching news bookmarks: $e");
    } finally {
      isNewsLoading.value = false;
    }
  }

  Future<void> fetchClipBookmarks() async {
    try {
      isClipsLoading.value = true;
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
      isClipsLoading.value = false;
    }
  }

  Future<void> fetchReplayBookmarks() async {
    try {
      isReplaysLoading.value = true;
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
      isReplaysLoading.value = false;
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

  Future<Article?> fetchBookmarkDetails(String bookmarkId) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.get(
        ApiEndpoints.bookmarkDetails(bookmarkId),
        headers: headers,
      );
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        if (data is Map<String, dynamic>) {
          if (data.containsKey('news')) {
            return Article.fromJson(data['news']);
          } else {
            return Article.fromJson(data);
          }
        }
      }
    } catch (e) {
      print("Error fetching news bookmark details: $e");
    }
    return null;
  }
}
