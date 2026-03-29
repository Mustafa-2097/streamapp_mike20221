import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/live_tv_model.dart';

class LiveTvController extends GetxController {
  var isLoading = false.obs;
  var liveTvs = <LiveTvModel>[].obs;
  var selectedLiveTv = Rxn<LiveTvModel>();
  var comments = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLiveTvs();
  }

  Future<void> fetchLiveTvs() async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getLiveTvChannels();
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        final List<LiveTvModel> list = data.map((json) => LiveTvModel.fromJson(json)).toList();
        liveTvs.assignAll(list);
        debugPrint("Live TVs fetched: ${liveTvs.length}");
        if (liveTvs.isEmpty) {
          Get.snackbar("Notice", "No live TV channels found", snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        debugPrint("Failed to fetch live TVs: ${response['message']}");
        Get.snackbar("Error", response['message'] ?? "Failed to load live TVs", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint("Error fetching live TVs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLiveTvById(String id) async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getLiveTvById(id);
      
      if (response['success'] == true && response['data'] != null) {
        selectedLiveTv.value = LiveTvModel.fromJson(response['data']);
        comments.assignAll(selectedLiveTv.value?.comments ?? []);
        debugPrint("Single Live TV fetched: ${selectedLiveTv.value?.title}");
      } else {
        debugPrint("Failed to fetch live TV detail: ${response['message']}");
        Get.snackbar("Error", response['message'] ?? "Failed to load TV details", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint("Error fetching live TV by ID: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
