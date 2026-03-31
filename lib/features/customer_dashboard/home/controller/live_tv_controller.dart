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

  Future<void> fetchLiveTvs({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      final response = await CustomerApiService.getLiveTvChannels();
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        final List<LiveTvModel> list = data.map((json) => LiveTvModel.fromJson(json)).toList();
        liveTvs.assignAll(list);
        debugPrint("Live TVs fetched: ${liveTvs.length}");
      } else {
        debugPrint("Failed to fetch live TVs: ${response['message']}");
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
        debugPrint("Single Live TV fetched: ${selectedLiveTv.value?.title}");
      } else {
        debugPrint("Failed to fetch live TV detail: ${response['message']}");
      }
    } catch (e) {
      debugPrint("Error fetching live TV by ID: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleLike(String id) async {
    final original = selectedLiveTv.value;
    if (original == null || original.id != id) return;

    // --- OPTIMISTIC UPDATE ---
    final wasLiked = original.liked;
    final wasDisliked = original.disliked;

    selectedLiveTv.value = original.copyWith(
      liked: !wasLiked,
      likes: wasLiked ? original.likes - 1 : original.likes + 1,
      disliked: false,
      dislikes: wasDisliked ? original.dislikes - 1 : original.dislikes,
    );

    try {
      final response = await CustomerApiService.likeLiveTv(id);
      if (response['success'] == true) {
        final data = response['data'];
        // Update with final server data
        selectedLiveTv.value = original.copyWith(
          likes: data['likes'] ?? selectedLiveTv.value!.likes,
          dislikes: data['dislikes'] ?? selectedLiveTv.value!.dislikes,
          liked: data['liked'] ?? !wasLiked,
          disliked: data['disliked'] ?? false,
        );
        fetchLiveTvs(showLoading: false);
      } else {
        // Rollback
        selectedLiveTv.value = original;
      }
    } catch (e) {
      debugPrint("Error toggling like: $e");
      // Rollback
      selectedLiveTv.value = original;
    }
  }

  Future<void> toggleDislike(String id) async {
    final original = selectedLiveTv.value;
    if (original == null || original.id != id) return;

    // --- OPTIMISTIC UPDATE ---
    final wasDisliked = original.disliked;
    final wasLiked = original.liked;

    selectedLiveTv.value = original.copyWith(
      disliked: !wasDisliked,
      dislikes: wasDisliked ? original.dislikes - 1 : original.dislikes + 1,
      liked: false,
      likes: wasLiked ? original.likes - 1 : original.likes,
    );

    try {
      final response = await CustomerApiService.dislikeLiveTv(id);
      if (response['success'] == true) {
        final data = response['data'];
        // Update with final server data
        selectedLiveTv.value = original.copyWith(
          likes: data['likes'] ?? selectedLiveTv.value!.likes,
          dislikes: data['dislikes'] ?? selectedLiveTv.value!.dislikes,
          liked: data['liked'] ?? false,
          disliked: data['disliked'] ?? !wasDisliked,
        );
        fetchLiveTvs(showLoading: false);
      } else {
        // Rollback
        selectedLiveTv.value = original;
      }
    } catch (e) {
      debugPrint("Error toggling dislike: $e");
      // Rollback
      selectedLiveTv.value = original;
    }
  }

  Future<void> shareLiveTv(String id) async {
    final original = selectedLiveTv.value;
    if (original == null || original.id != id) return;

    // --- OPTIMISTIC UPDATE ---
    selectedLiveTv.value = original.copyWith(
      shares: original.shares + 1,
    );

    try {
      final response = await CustomerApiService.shareLiveTv(id);
      if (response['success'] == true) {
        // Success: the local state already has the incremented value, 
        // but we can fetch to be safe or update from response if server returns count.
        fetchLiveTvs(showLoading: false);
      } else {
        // Rollback
        selectedLiveTv.value = original;
      }
    } catch (e) {
      debugPrint("Error sharing: $e");
      // Rollback
      selectedLiveTv.value = original;
    }
  }
}
