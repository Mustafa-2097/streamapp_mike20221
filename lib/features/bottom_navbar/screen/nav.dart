import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/nav_controller.dart';

class AppBottomNav extends StatelessWidget {
  AppBottomNav({super.key});

  final BottomNavController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF0B0B0B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              label: "Clips",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Live"),
            BottomNavigationBarItem(icon: Icon(Icons.replay), label: "Replay"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
