import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/replay_model.dart';

class ReplayController extends GetxController {
  static ReplayController get to => Get.find();

  // Selected category index
  var selectedTabIndex = 0.obs;

  final List<String> categories = ["All", "Replay", "Full Game"];

  var isLoading = false.obs;
  var errorMessage = "".obs;
  var replaysList = <ReplayModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReplays();
  }

  Future<void> fetchReplays({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      final response = await CustomerApiService.getReplays(page: page);
      print("Replays API Raw Response: $response");

      if (response['success'] == true) {
        dynamic dataNode = response['data'] ?? [];
        List<dynamic> rawList = [];

        if (dataNode is List) {
          rawList = dataNode;
        } else if (dataNode is Map) {
          if (dataNode.containsKey('data') && dataNode['data'] is List) {
            rawList = dataNode['data'];
          } else if (dataNode.containsKey('replays') && dataNode['replays'] is List) {
            rawList = dataNode['replays'];
          } else {
            rawList = [dataNode];
          }
        }

        final List<ReplayModel> fetchedReplays = rawList.map((json) {
          try {
            if (json == null) return null;
            return ReplayModel.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print("Error parsing single replay item: $e");
            return null;
          }
        }).whereType<ReplayModel>().toList();

        if (page == 1) {
          replaysList.assignAll(fetchedReplays);
        } else {
          replaysList.addAll(fetchedReplays);
        }
      }
    } catch (e) {
      print("Error fetching replays: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => selectedTabIndex.value = index;

  void removeReplay(int index) => replaysList.removeAt(index);
}