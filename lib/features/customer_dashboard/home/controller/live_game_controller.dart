import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/customer_api_service.dart';
import '../model/live_game_model.dart';
import '../../../../core/const/app_colors.dart';

class LiveGameController extends GetxController {
  var isLoading = false.obs;
  var liveGames = <LiveGame>[].obs;
  var selectedLiveGame = Rxn<LiveGame>();

  @override
  void onInit() {
    super.onInit();
    fetchLiveGames();
  }

  Future<void> fetchLiveGames() async {
    try {
      if (liveGames.isEmpty) {
        isLoading.value = true;
      }
      final response = await CustomerApiService.getLiveGames();
      
      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        liveGames.assignAll(data.map((json) => LiveGame.fromJson(json)).toList());
      } else {
        debugPrint("API error: ${response['message']}");
      }
    } catch (e) {
      debugPrint("Error fetching live games: $e");
      Get.snackbar(
        "Oops!", 
        "Something went wrong while fetching games",
        backgroundColor: AppColors.errorColor.withOpacity(0.7),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLiveGameById(String id) async {
    try {
      isLoading.value = true;
      final response = await CustomerApiService.getLiveGameById(id);
      
      if (response['success'] == true) {
        selectedLiveGame.value = LiveGame.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint("Error fetching single game: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleLike(String id) async {
    try {
      final response = await CustomerApiService.likeLiveGame(id);
      if (response['success'] == true) {
        // Update local state with new counts and status from response
        final data = response['data'];
        if (selectedLiveGame.value != null) {
          final updated = LiveGame(
            id: selectedLiveGame.value!.id,
            title: selectedLiveGame.value!.title,
            commentary: selectedLiveGame.value!.commentary,
            link: selectedLiveGame.value!.link,
            thumbnail: selectedLiveGame.value!.thumbnail,
            opponent01: selectedLiveGame.value!.opponent01,
            opponent02: selectedLiveGame.value!.opponent02,
            dateTime: selectedLiveGame.value!.dateTime,
            commentsEnabled: selectedLiveGame.value!.commentsEnabled,
            likes: data['likes'] ?? 0,
            dislikes: data['dislikes'] ?? 0,
            liked: data['liked'] ?? false,
            disliked: data['disliked'] ?? false,
            viewers: selectedLiveGame.value!.viewers,
            shares: selectedLiveGame.value!.shares,
            status: selectedLiveGame.value!.status,
            isPremium: selectedLiveGame.value!.isPremium,
            createdAt: selectedLiveGame.value!.createdAt,
            updatedAt: selectedLiveGame.value!.updatedAt,
            commentCount: selectedLiveGame.value!.commentCount,
          );
          selectedLiveGame.value = updated;
          
          // Also refresh the main list to keep home screen in sync
          fetchLiveGames();
        }
      }
    } catch (e) {
      debugPrint("Error toggling like: $e");
    }
  }

  Future<void> toggleDislike(String id) async {
    try {
      final response = await CustomerApiService.dislikeLiveGame(id);
      if (response['success'] == true) {
        final data = response['data'];
        if (selectedLiveGame.value != null) {
          final updated = LiveGame(
            id: selectedLiveGame.value!.id,
            title: selectedLiveGame.value!.title,
            commentary: selectedLiveGame.value!.commentary,
            link: selectedLiveGame.value!.link,
            thumbnail: selectedLiveGame.value!.thumbnail,
            opponent01: selectedLiveGame.value!.opponent01,
            opponent02: selectedLiveGame.value!.opponent02,
            dateTime: selectedLiveGame.value!.dateTime,
            commentsEnabled: selectedLiveGame.value!.commentsEnabled,
            likes: data['likes'] ?? 0,
            dislikes: data['dislikes'] ?? 0,
            liked: data['liked'] ?? false,
            disliked: data['disliked'] ?? false,
            viewers: selectedLiveGame.value!.viewers,
            shares: selectedLiveGame.value!.shares,
            status: selectedLiveGame.value!.status,
            isPremium: selectedLiveGame.value!.isPremium,
            createdAt: selectedLiveGame.value!.createdAt,
            updatedAt: selectedLiveGame.value!.updatedAt,
            commentCount: selectedLiveGame.value!.commentCount,
          );
          selectedLiveGame.value = updated;
          fetchLiveGames();
        }
      }
    } catch (e) {
      debugPrint("Error toggling dislike: $e");
    }
  }

  Future<void> shareGame(LiveGame game) async {
    try {
      final String text = "Check out this live game: ${game.title}\nWatch here: ${game.link}";
      
      // Open native share sheet
      final result = await Share.share(text);
      
      // If shared successfully (or just closed on some platforms), notify backend
      if (result.status == ShareResultStatus.success || 
          result.status == ShareResultStatus.dismissed) { 
        final response = await CustomerApiService.shareLiveGame(game.id);
        if (response['success'] == true) {
          if (selectedLiveGame.value != null && selectedLiveGame.value!.id == game.id) {
            // Optimistically or reactively update count (increment by 1)
            final current = selectedLiveGame.value!;
            selectedLiveGame.value = LiveGame(
              id: current.id,
              title: current.title,
              commentary: current.commentary,
              link: current.link,
              thumbnail: current.thumbnail,
              opponent01: current.opponent01,
              opponent02: current.opponent02,
              dateTime: current.dateTime,
              commentsEnabled: current.commentsEnabled,
              likes: current.likes,
              dislikes: current.dislikes,
              liked: current.liked,
              disliked: current.disliked,
              viewers: current.viewers,
              shares: current.shares + 1, // Locally increment
              status: current.status,
              isPremium: current.isPremium,
              createdAt: current.createdAt,
              updatedAt: current.updatedAt,
              commentCount: current.commentCount,
            );
          }
          fetchLiveGames(); // Refresh home list
        }
      }
    } catch (e) {
      debugPrint("Error during sharing: $e");
    }
  }

  void refreshGames() => fetchLiveGames();
}
