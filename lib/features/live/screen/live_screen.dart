import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/live_controller.dart';
import '../model/live_model.dart';

class LiveMatchesScreen extends StatelessWidget {
  LiveMatchesScreen({super.key});

  final LiveMatchesController controller = Get.put(
    LiveMatchesController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabs(),
          const SizedBox(height: 16),
          Expanded(child: _buildMatchList()),
        ],
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "Matches",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: const [
        Icon(Icons.notifications_none),
        SizedBox(width: 16),
        Icon(Icons.search),
        SizedBox(width: 16),
        CircleAvatar(radius: 14),
        SizedBox(width: 16),
      ],
    );
  }

  // ================= TABS (FIXED) =================
  Widget _buildTabs() {
    return SizedBox(
      height: 40,
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
                    horizontal: 16,
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

  // ================= MATCH LIST =================
  Widget _buildMatchList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.matches.length,
      itemBuilder: (context, index) {
        return _matchCard(controller.matches[index]);
      },
    );
  }

  // ================= MATCH CARD =================
  Widget _matchCard(MatchModel match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "LIVE",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Spacer(),
              Text(
                match.views,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _team(match.homeTeam),
              Text(
                "${match.homeScore}  -  ${match.awayScore}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _team(match.awayTeam),
            ],
          ),
        ],
      ),
    );
  }

  Widget _team(String name) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(Icons.sports_soccer),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
