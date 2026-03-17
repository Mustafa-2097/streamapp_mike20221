import 'package:get/get.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../model/replay_model.dart';

class ReplayController extends GetxController {
  static ReplayController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["All", "Replay", "Full Game"];

  var isLoading = false.obs;
  var replaysList = <ReplayModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReplays();
  }

  Future<void> fetchReplays() async {
    try {
      isLoading.value = true;
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await ApiService.get(ApiEndpoints.replays, headers: headers);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        replaysList.value = data.map((json) => ReplayModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error fetching replays: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeReplay(int index) => replaysList.removeAt(index);
}