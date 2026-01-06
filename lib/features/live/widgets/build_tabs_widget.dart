import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/live_controller.dart';

Widget buildTabs() {
  return SizedBox(
    height: 35,
    child: GetBuilder<LiveMatchesController>(
      builder: (controller) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.tabs.length,
          itemBuilder: (context, index) {
            final isSelected = controller.selectedTab == index;

            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.amber
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
