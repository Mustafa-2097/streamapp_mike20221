import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../model/news_model.dart';
import 'package:testapp/core/offline_storage/shared_pref.dart';

class NewsController extends GetxController {
  static NewsController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var page = 1;
  final int pageSize = 10; // previous: 5
  var newsList = <Article>[].obs;

  final List<String> categories = ["All", "Football", "BasketBall"];

  // Mock Data for Replays (Keep for now if needed, but we will use newsList for the API data)
  var newsData = [
    {
      "title": "Brazil VS Spain - Best Goals & Highlights",
      "date": "12 October 2026",
      "read": "12k read",
    },
    {
      "title": "Brazil VS Spain - Best Goals & Highlights",
      "date": "12 October 2026",
      "read": "12k read",
    },
    {
      "title": "Brazil VS Spain - Best Goals & Highlights",
      "date": "12 October 2026",
      "read": "12k read",
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    fetchNews();
  }
  // previous code: void changeTab(int index) => selectedTabIndex.value = index;

  void removeNews(int index) => newsData.removeAt(index);

  Future<void> fetchNews({bool isLoadMore = false}) async {
    if (isLoading.value || isLoadingMore.value) return;
    if (isLoadMore && !hasMore.value) return;

    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        page = 1;
        hasMore.value = true;
      }

      Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': pageSize.toString(),
      };

      if (selectedTabIndex.value > 0) {
        queryParams['category'] = categories[selectedTabIndex.value]
            .toLowerCase();
      }

      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await ApiService.get(
        ApiEndpoints.news,
        queryParameters: queryParams,
        headers: headers,
      );
      final newsModel = NewsModel.fromJson(response);

      if (newsModel.success == true && newsModel.data != null) {
        final newArticles = newsModel.data!;
        if (newArticles.isNotEmpty) {
          if (isLoadMore) {
            newsList.addAll(newArticles);
          } else {
            newsList.assignAll(newArticles);
          }
          page++;
          // If we got fewer articles than requested, we've reached the end
          if (newArticles.length < pageSize) {
            hasMore.value = false;
          }
        } else {
          hasMore.value = false;
        }
      }
      /*
      // Previous fetchNews implementation
      final response = await ApiService.get(
        ApiEndpoints.news,
        queryParameters: {
          'page': page.toString(),
          'limit': pageSize.toString(),
        },
      );
      final newsModel = NewsModel.fromJson(response);

      if (newsModel.success == true && newsModel.data?.articles != null) {
        final newArticles = newsModel.data!.articles!;
        if (newArticles.isNotEmpty) {
          if (isLoadMore) {
            newsList.addAll(newArticles);
          } else {
            newsList.assignAll(newArticles);
          }
          page++;
          // If we got fewer articles than requested, we've reached the end
          if (newArticles.length < pageSize) {
            hasMore.value = false;
          }
        } else {
          hasMore.value = false;
        }
      }
      */
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<Article?> fetchNewsById(String id) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.get(
        "${ApiEndpoints.news}/$id",
        headers: headers,
      );
      final newsModel = NewsModel.fromJson(response);
      if (newsModel.success == true &&
          newsModel.data != null &&
          newsModel.data!.isNotEmpty) {
        return newsModel.data!.first;
      }
    } catch (e) {
      print("Error fetching news by ID: $e");
    }
    return null;
  }

  Future<Comment?> postComment(
    String newsId,
    String comment, {
    String? parentId,
  }) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.post(
        ApiEndpoints.comments(newsId),
        headers: headers,
        body: {
          'content': comment,
          if (parentId != null) 'parentCommentId': parentId,
        },
      );
      if (response['success'] == true && response['data'] != null) {
        final newComment = Comment.fromJson(response['data']);
        // Update local article if it exists in newsList
        int index = newsList.indexWhere((a) => a.id == newsId);
        if (index != -1) {
          if (parentId == null) {
            // Main comment
            if (newsList[index].comments == null) {
              newsList[index].comments = [];
            }
            newsList[index].comments!.insert(0, newComment);
          } else {
            // Reply: find parent comment
            _addCommentToParent(newsList[index].comments, parentId, newComment);
          }
          newsList[index].commentCount =
              (newsList[index].commentCount ?? 0) + 1;
          newsList.refresh();
        }
        return newComment;
      }
    } catch (e) {
      print("Error posting comment: $e");
    }
    return null;
  }

  void _addCommentToParent(
    List<Comment>? comments,
    String parentId,
    Comment newComment,
  ) {
    if (comments == null) return;
    for (var comment in comments) {
      if (comment.id == parentId) {
        comment.replies ??= [];
        comment.replies!.insert(0, newComment);
        return;
      }
      if (comment.replies != null) {
        _addCommentToParent(comment.replies, parentId, newComment);
      }
    }
  }

  Future<Map<String, dynamic>?> toggleEngagement(
    String newsId,
    String type,
  ) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      print(
        "Toggling engagement: ${ApiEndpoints.engagement(newsId)} with body: {'type': $type}",
      );
      final response = await ApiService.post(
        ApiEndpoints.engagement(newsId),
        headers: headers,
        body: {'type': type},
      );
      print("Engagement response: $response");
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        int index = newsList.indexWhere((a) => a.id == newsId);
        if (index != -1) {
          newsList[index].likes = data['likes'];
          newsList[index].dislikes = data['dislikes'];
          if (type == 'like') {
            newsList[index].isLiked = !(newsList[index].isLiked ?? false);
            if (newsList[index].isLiked == true)
              newsList[index].isDisliked = false;
          } else if (type == 'dislike') {
            newsList[index].isDisliked = !(newsList[index].isDisliked ?? false);
            if (newsList[index].isDisliked == true)
              newsList[index].isLiked = false;
          }
          newsList.refresh();
        }
        return data;
      }
    } catch (e) {
      print("Error toggling engagement: $e");
    }
    return null;
  }

  Future<bool?> toggleBookmark(String newsId) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      print("Sending bookmark request: ${ApiEndpoints.bookmark(newsId)}");

      final response = await ApiService.post(
        ApiEndpoints.bookmark(newsId),
        headers: headers,
        body: {},
      );

      print("Bookmark Response: $response");

      if (response['success'] == true) {
        int index = newsList.indexWhere((a) => a.id == newsId);
        final bool isBookmarked = response['data']?['status'] ?? false;
        if (index != -1) {
          newsList[index].isBookmarked = isBookmarked;
          // newsList[index].bookmarks = response['data']?['bookmarks'] ?? newsList[index].bookmarks;
          newsList.refresh();
        }
        return isBookmarked;
      }
    } catch (e) {
      print("Error toggling bookmark: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> toggleCommentEngagement(
    String commentId,
    String type,
  ) async {
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await ApiService.post(
        ApiEndpoints.commentEngagement(commentId),
        headers: headers,
        body: {'type': type},
      );
      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      }
    } catch (e) {
      print("Error toggling comment engagement: $e");
    }
    return null;
  }
}
