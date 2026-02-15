import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/customer_dashboard/live/live_dashboard/controller/live_controller.dart';
import '../../const/app_colors.dart';
import 'match_stats_widget.dart';

Widget buildTabs() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
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
                  onTap: () => controller.setTab(index), //
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.amber
                          : AppColors.subTextColor.withOpacity(0.2),
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
      ),
    ],
  );
}
