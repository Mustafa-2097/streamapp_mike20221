import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../model/news_model.dart';

class NewsController extends GetxController {
  static NewsController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;
  var isLoading = false.obs;
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

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(ApiEndpoints.news);
      final newsModel = NewsModel.fromJson(response);
      if (newsModel.success == true && newsModel.data?.articles != null) {
        newsList.assignAll(newsModel.data!.articles!);
      }
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
