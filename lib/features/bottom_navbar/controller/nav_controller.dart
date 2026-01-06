import 'package:get/get.dart';

import '../../home/screen/home_screen.dart';
import '../../live/live_dashboard/screen/live_screen.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  void changeIndex(int index) {
    if (currentIndex.value == index) return; // prevent reload

    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offAll(() => HomeScreen());
        break;
      // case 1:
      //   Get.offAll(() => ClipsScreen());
      //   break;
      case 2:
        Get.to(() => LiveMatchesScreen());
        break;
      // case 3:
      //   Get.offAll(() => ReplayScreen());
      //   break;
      // case 4:
      //   Get.offAll(() => ProfileScreen());
      // break;
    }
  }
}
