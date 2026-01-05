import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bottom_navbar/controller/nav_controller.dart';
import '../../bottom_navbar/screen/nav.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔝 Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.menu, color: Colors.white),
                    Row(
                      children: [
                        Icon(Icons.notifications_none, color: Colors.white),
                        SizedBox(width: 12),
                        Icon(Icons.search, color: Colors.white),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🎥 Banner
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black26,
                  ),
                  child: const Center(
                    child: Text(
                      "LIVE RUGBY STREAMING",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🟡 Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      Chip(label: Text("All")),
                      SizedBox(width: 8),
                      Chip(label: Text("Football")),
                      SizedBox(width: 8),
                      Chip(label: Text("Cricket")),
                      SizedBox(width: 8),
                      Chip(label: Text("Tennis")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // 🔻 Bottom Nav
      bottomNavigationBar: AppBottomNav(),
    );
  }
}
