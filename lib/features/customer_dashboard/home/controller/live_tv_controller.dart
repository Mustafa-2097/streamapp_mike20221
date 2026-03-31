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
    try {
      final response = await CustomerApiService.likeLiveTv(id);
      if (response['success'] == true) {
        // Update local state if it's the selected one
        if (selectedLiveTv.value?.id == id) {
          final data = response['data'];
          selectedLiveTv.value = LiveTvModel(
            id: selectedLiveTv.value!.id,
            title: selectedLiveTv.value!.title,
            link: selectedLiveTv.value!.link,
            thumbnail: selectedLiveTv.value!.thumbnail,
            commentsEnabled: selectedLiveTv.value!.commentsEnabled,
            likes: data['likes'] ?? selectedLiveTv.value!.likes,
            dislikes: data['dislikes'] ?? selectedLiveTv.value!.dislikes,
            shares: selectedLiveTv.value!.shares,
            createdAt: selectedLiveTv.value!.createdAt,
            updatedAt: selectedLiveTv.value!.updatedAt,
            commentCount: selectedLiveTv.value!.commentCount,
            comments: selectedLiveTv.value!.comments,
            liked: data['liked'] ?? !selectedLiveTv.value!.liked,
            disliked: data['disliked'] ?? false,
          );
        }
        fetchLiveTvs(); // Refresh home list
      }
    } catch (e) {
      debugPrint("Error toggling like: $e");
    }
  }

  Future<void> toggleDislike(String id) async {
    try {
      final response = await CustomerApiService.dislikeLiveTv(id);
      if (response['success'] == true) {
        if (selectedLiveTv.value?.id == id) {
           final data = response['data'];
           selectedLiveTv.value = LiveTvModel(
            id: selectedLiveTv.value!.id,
            title: selectedLiveTv.value!.title,
            link: selectedLiveTv.value!.link,
            thumbnail: selectedLiveTv.value!.thumbnail,
            commentsEnabled: selectedLiveTv.value!.commentsEnabled,
            likes: data['likes'] ?? selectedLiveTv.value!.likes,
            dislikes: data['dislikes'] ?? selectedLiveTv.value!.dislikes,
            shares: selectedLiveTv.value!.shares,
            createdAt: selectedLiveTv.value!.createdAt,
            updatedAt: selectedLiveTv.value!.updatedAt,
            commentCount: selectedLiveTv.value!.commentCount,
            comments: selectedLiveTv.value!.comments,
            liked: data['liked'] ?? false,
            disliked: data['disliked'] ?? !selectedLiveTv.value!.disliked,
          );
        }
        fetchLiveTvs();
      }
    } catch (e) {
      debugPrint("Error toggling dislike: $e");
    }
  }

  Future<void> shareLiveTv(String id) async {
    try {
      final response = await CustomerApiService.shareLiveTv(id);
      if (response['success'] == true) {
        if (selectedLiveTv.value?.id == id) {
           selectedLiveTv.value = LiveTvModel(
            id: selectedLiveTv.value!.id,
            title: selectedLiveTv.value!.title,
            link: selectedLiveTv.value!.link,
            thumbnail: selectedLiveTv.value!.thumbnail,
            commentsEnabled: selectedLiveTv.value!.commentsEnabled,
            likes: selectedLiveTv.value!.likes,
            dislikes: selectedLiveTv.value!.dislikes,
            shares: selectedLiveTv.value!.shares + 1,
            createdAt: selectedLiveTv.value!.createdAt,
            updatedAt: selectedLiveTv.value!.updatedAt,
            commentCount: selectedLiveTv.value!.commentCount,
            comments: selectedLiveTv.value!.comments,
            liked: selectedLiveTv.value!.liked,
            disliked: selectedLiveTv.value!.disliked,
          );
        }
        fetchLiveTvs();
      }
    } catch (e) {
      debugPrint("Error sharing: $e");
    }
  }
}
