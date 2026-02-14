import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../model/news_model.dart';

class NewsController extends GetxController {
  static NewsController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var page = 1;
  final int pageSize = 5;
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

  void changeTab(int index) => selectedTabIndex.value = index;

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
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
