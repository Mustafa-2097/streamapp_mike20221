import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testapp/core/network/api_endpoints.dart';
import 'package:testapp/core/network/api_service.dart';
import 'package:testapp/core/offline_storage/shared_pref.dart';
import 'package:testapp/features/customer_dashboard/replay/model/replay_model.dart';
import '../../../profile/controller/bookmarks_controller.dart';

class VideoLiveController extends GetxController {
  var isLoading = false.obs;
  var replay = Rxn<ReplayModel>();

  Future<void> fetchReplay(String id) async {
    try {
      isLoading.value = true;
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await ApiService.get(ApiEndpoints.singleReplay(id), headers: headers);

      if (response['success'] == true) {
        replay.value = ReplayModel.fromJson(response['data']);
      }
    } catch (e) {
      print("Error fetching replay: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAction(String type) async {
    if (replay.value == null) return;

    final originalReplay = replay.value!;
    final replayId = originalReplay.replayId;
    final status = originalReplay.userStatus;
    final engagement = originalReplay.engagement;

    // Optimistic Update for LIKE/DISLIKE (optional, but keep for better feel)
    if (type == "LIKE") {
      if (status.isLiked) {
        status.isLiked = false;
        engagement.likes--;
      } else {
        status.isLiked = true;
        engagement.likes++;
        if (status.isDisliked) {
          status.isDisliked = false;
          engagement.dislikes--;
        }
      }
    } else if (type == "DISLIKE") {
      if (status.isDisliked) {
        status.isDisliked = false;
        engagement.dislikes--;
      } else {
        status.isDisliked = true;
        engagement.dislikes++;
        if (status.isLiked) {
          status.isLiked = false;
          engagement.likes--;
        }
      }
    }
    // Note: No optimistic update for SHARE to match user request

    replay.refresh();

    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final body = {
        "replayId": replayId,
        "type": type,
      };

      final response = await ApiService.post(ApiEndpoints.replaysAction, headers: headers, body: body);

      if (response['success'] == true) {
        // Sync with server state
        final syncResponse = await ApiService.get(ApiEndpoints.singleReplay(replayId), headers: headers);
        if (syncResponse['success'] == true) {
          replay.value = ReplayModel.fromJson(syncResponse['data']);
        }
      }
    } catch (e) {
      // Revert optimistic update on error
      replay.value = originalReplay;
      replay.refresh();
      print("Error toggling replay action: $e");
    }
  }

  Future<void> shareReplay() async {
    if (replay.value == null) return;
    
    final r = replay.value!;
    final String shareLink = "${ApiEndpoints.baseUrl.replaceAll('/api/v1', '')}/replays/${r.replayId}"
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');

    try {
      await Share.share("${r.title}\n\n$shareLink");
      // This will now sync with server and only increment if server says so
      await toggleAction("SHARE");
    } catch (e) {
      print("Error sharing: $e");
    }
  }


  Future<void> toggleBookmark() async {
    if (replay.value == null) return;

    final originalReplay = replay.value!;
    final replayId = originalReplay.replayId;
    final status = originalReplay.userStatus;

    // Optimistic Update
    status.isBookmarked = !status.isBookmarked;
    replay.refresh();

    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final body = {
        "replayId": replayId,
      };

      final response = await ApiService.post(ApiEndpoints.replaysBookmark, headers: headers, body: body);

      if (response['success'] == true) {
        // Refresh Bookmark list if controller exists
        if (Get.isRegistered<BookmarkController>()) {
          Get.find<BookmarkController>().fetchReplayBookmarks();
        }
      }
    } catch (e) {
      // Revert on error
      replay.value = originalReplay;
      replay.refresh();
      print("Error toggling replay bookmark: $e");
    }
  }
}

