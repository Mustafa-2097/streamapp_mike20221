import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:testapp/core/network/api_endpoints.dart';
import 'package:testapp/core/network/api_service.dart';
import 'package:testapp/core/offline_storage/shared_pref.dart';
import 'package:testapp/features/customer_dashboard/replay/model/replay_model.dart';
import '../../../profile/controller/bookmarks_controller.dart';

class VideoLiveController extends GetxController {
  var isLoading = false.obs;
  var replay = Rxn<ReplayModel>();
  
  VideoPlayerController? videoPlayerController;
  var isVideoInitialized = false.obs;
  var isPlaying = false.obs;

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }

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
        final fetchedReplay = ReplayModel.fromJson(response['data']);
        replay.value = fetchedReplay;
        
        // Initialize video player after fetching data
        await _initializeVideo(fetchedReplay.videoUrl);
      }
    } catch (e) {
      print("Error fetching replay: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initializeVideo(String url) async {
    final fixedUrl = url
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');
    
    try {
      videoPlayerController?.dispose(); // Clean up previous one if any
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(fixedUrl));
      
      await videoPlayerController!.initialize();
      isVideoInitialized.value = true;
      
      // Auto-play
      videoPlayerController!.play();
      isPlaying.value = true;
      
      videoPlayerController!.addListener(() {
         isPlaying.value = videoPlayerController!.value.isPlaying;
         update(); // Trigger UI update for player state
      });
      
    } catch (e) {
      print("Error initializing video: $e");
      isVideoInitialized.value = false;
    }
  }

  void togglePlayback() {
    if (videoPlayerController == null || !videoPlayerController!.value.isInitialized) return;
    
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController!.play();
      isPlaying.value = true;
    }
    update();
  }

  Future<void> toggleAction(String type) async {
    if (replay.value == null) return;

    final originalReplay = replay.value!;
    final replayId = originalReplay.replayId;
    final status = originalReplay.userStatus;
    final engagement = originalReplay.engagement;

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
        final syncResponse = await ApiService.get(ApiEndpoints.singleReplay(replayId), headers: headers);
        if (syncResponse['success'] == true) {
          replay.value = ReplayModel.fromJson(syncResponse['data']);
        }
      }
    } catch (e) {
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
        if (Get.isRegistered<BookmarkController>()) {
          Get.find<BookmarkController>().fetchReplayBookmarks();
        }
      }
    } catch (e) {
      status.isBookmarked = !status.isBookmarked; // Revert
      replay.refresh();
      print("Error toggling replay bookmark: $e");
    }
  }
}
