import 'package:get/get.dart';
import '../model/clips_model.dart';
import '../../data/customer_api_service.dart';
import 'package:testapp/core/network/api_endpoints.dart';
import 'package:testapp/core/const/app_colors.dart';

class ClipsController extends GetxController {
  static ClipsController get to => Get.find();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var clipsList = <ClipModel>[].obs;
  
  var currentPage = 1;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClips();
  }

  Future<void> fetchClips({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isLoadingMore.value || !hasMore.value) return;
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      currentPage = 1;
      clipsList.clear();
      hasMore.value = true;
    }

    try {
      final String url = "${ApiEndpoints.clips}?page=$currentPage";
      print("Fetching clips from: $url");
      
      final response = await CustomerApiService.getClips(page: currentPage);
      print("Clips API Response received: $response");
      
      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        final meta = response['meta'] ?? {};
        
        final List<ClipModel> fetchedClips = data.map((e) => ClipModel.fromJson(e)).toList();
        print("Fetched ${fetchedClips.length} clips");
        
        if (fetchedClips.isEmpty && !isLoadMore) {
          hasMore.value = false;
        } else {
          clipsList.addAll(fetchedClips);
          currentPage++;
          
          if (clipsList.length >= (meta['total'] ?? 0)) {
            hasMore.value = false;
          }
        }
      } else {
        String errorMsg = response['message'] ?? 'Unknown error';
        print("Clips API failed with message: $errorMsg");
        Get.snackbar("Error", errorMsg, backgroundColor: AppColors.errorColor);
      }
    } catch (e) {
      print("Exception in fetchClips: $e");
      // ApiService already shows a snackbar for network/http errors
    } finally {


      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshClips() async {
    await fetchClips();
  }

  Future<ClipModel?> fetchSingleClip(String clipId) async {
    try {
      final response = await CustomerApiService.getClipById(clipId);
      if (response['success'] == true) {
        return ClipModel.fromJson(response['data']);
      }
    } catch (e) {
      print("Error fetching single clip: $e");
    }
    return null;
  }

  Future<void> toggleAction(String clipId, String type) async {
    final index = clipsList.indexWhere((c) => c.clipId == clipId);
    if (index == -1) return;

    final clip = clipsList[index];
    
    // Optimistic Update: Update locally immediately
    if (type == "LIKE") {
      if (clip.userStatus.isLiked) {
        clip.userStatus.isLiked = false;
        clip.engagement.likes = (clip.engagement.likes - 1).clamp(0, 999999);
      } else {
        // If it was disliked, untoggle dislike first
        if (clip.userStatus.isDisliked) {
          clip.userStatus.isDisliked = false;
          clip.engagement.dislikes = (clip.engagement.dislikes - 1).clamp(0, 999999);
        }
        clip.userStatus.isLiked = true;
        clip.engagement.likes++;
      }
    } else if (type == "DISLIKE") {
      if (clip.userStatus.isDisliked) {
        clip.userStatus.isDisliked = false;
        clip.engagement.dislikes = (clip.engagement.dislikes - 1).clamp(0, 999999);
      } else {
        // If it was liked, untoggle like first
        if (clip.userStatus.isLiked) {
          clip.userStatus.isLiked = false;
          clip.engagement.likes = (clip.engagement.likes - 1).clamp(0, 999999);
        }
        clip.userStatus.isDisliked = true;
        clip.engagement.dislikes++;
      }
    } else if (type == "SHARE") {
      clip.engagement.shares++;
    }
    
    // Refresh the list to trigger Obx
    clipsList.refresh();

    try {
      final response = await CustomerApiService.performClipAction(
        clipId: clipId,
        type: type,
      );

      // Even after successful action, we fetch again to ensure we are perfectly in sync with server state
      if (response['success'] == true) {
        final updatedClip = await fetchSingleClip(clipId);
        if (updatedClip != null) {
          clipsList[index] = updatedClip;
        }
      }
    } catch (e) {
      print("Error toggling action $type: $e");
      // Optional: re-fetch on error to revert optimistic state
      fetchSingleClip(clipId).then((clip) {
         if (clip != null) clipsList[index] = clip;
      });
    }
  }
}
