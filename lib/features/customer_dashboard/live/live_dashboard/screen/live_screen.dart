import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/build_tabs_widget.dart';
import '../../../../../core/common/widgets/h2h_widget.dart';
import '../../../../../core/common/widgets/lineup_widget.dart';
import '../../../../../core/common/widgets/match_stats_widget.dart';
import '../../../../../core/common/widgets/recent_matches_widget.dart';
import '../../../../../core/common/widgets/table_widget.dart';
import '../../live_video/screen/video_screen.dart';
import '../controller/live_controller.dart';
import '../model/live_model.dart';

class LiveMatchesScreen extends StatelessWidget {
  LiveMatchesScreen({super.key, this.initialTab = 0});

  final int initialTab;

  final LiveMatchesController controller = Get.put(
    LiveMatchesController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setTab(initialTab);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      //appBar: _buildAppBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "LIVE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Matches",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildTabs(),
              const SizedBox(height: 16),
              Expanded(
                child: GetBuilder<LiveMatchesController>(
                  builder: (controller) {
                    if (controller.isUpcoming) {
                      return _buildUpcomingList();
                    }
                    if (controller.isRecentMatch) {
                      return RecentMatchesWidget(recentMatchesData: controller.recentMatchesData);
                    }
                    if (controller.isStats) {
                      return MatchStatsWidget(statsData: controller.statsData);
                    }
                    if (controller.isLineup) {
                      return LineupWidget(lineupData: controller.lineupData);
                    }
                    if (controller.isTable) {
                      return TableWidget(tableData: controller.tableData);
                    }
                    if (controller.isH2H) {
                      return H2HWidget(h2hData: controller.h2hData);
                    }
                    return _buildMatchList(); // LIVE
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // APP BAR
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "LIVE",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: const [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 16),
        Icon(Icons.search, color: Colors.white),
        SizedBox(width: 16),
        CircleAvatar(radius: 14),
        SizedBox(width: 16),
      ],
    );
  }

  // TABS (FIXED)

  // MATCH LIST
  Widget _buildMatchList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.matches.length,
      itemBuilder: (context, index) {
        return _matchCard(controller.matches[index]);
      },
    );
  }

  // MATCH CARD
  Widget _matchCard(MatchModel match) {
    return GestureDetector(
      onTap: () {
        Get.to(VideoLiveScreen());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white24),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
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

  Widget _buildUpcomingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _upcomingMatchCard();
      },
    );
  }

  Widget _upcomingMatchCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          //  Time chips + Remind
          Row(
            children: [
              _timeChip("12H"),
              _timeChip("12M"),
              _timeChip("12S"),
              const Spacer(),
              _remindButton(),
            ],
          ),
          const SizedBox(height: 14),

          //  Teams + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _upcomingTeam("Betis"),
              Column(
                children: const [
                  Text(
                    "Mon, Mar 23, 21",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Soon",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _upcomingTeam("Real Madrid"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _remindButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Icon(Icons.notifications_none, size: 14, color: Colors.black),
          SizedBox(width: 4),
          Text(
            "Remind",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingTeam(String name) {
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
