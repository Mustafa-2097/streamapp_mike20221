import 'package:get/get.dart';

class VideoLiveController extends GetxController {
  var isLiked = false.obs;
  var likesCount = 27800.obs;
  var dislikesCount = 3600.obs;

  void toggleLike() {
    isLiked.value = !isLiked.value;
    if (isLiked.value) {
      likesCount.value += 1;
    } else {
      likesCount.value -= 1;
    }
  }
}
