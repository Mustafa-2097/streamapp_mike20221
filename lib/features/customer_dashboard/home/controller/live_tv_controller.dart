import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/live_tv_model.dart';

class LiveTvController extends GetxController {
  var isLoading = false.obs;
  var liveTvList = <LiveTvModel>[].obs;

  Rxn<LiveTvModel> selectedLiveTv = Rxn<LiveTvModel>();

  @override
  void onInit() {
    fetchLiveTv();
    super.onInit();
  }

  void fetchLiveTv() async {
    try {
      isLoading.value = true;

      final response = await CustomerApiService.getLiveTvChannels();

      if (response['success'] == true) {
        final List data = response['data'];

        liveTvList.value =
            data.map((e) => LiveTvModel.fromJson(e)).toList();

        if (liveTvList.isNotEmpty) {
          selectedLiveTv.value = liveTvList.first;
        }
      }
    } catch (e) {
      print("Live TV Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}


