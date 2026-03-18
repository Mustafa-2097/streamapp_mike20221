import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/build_tabs_widget.dart';
import '../../../../../core/common/widgets/h2h_widget.dart';
import '../../../../../core/common/widgets/lineup_widget.dart';
import '../../../../../core/common/widgets/match_stats_widget.dart';
import '../../../../../core/common/widgets/table_widget.dart';
import '../controller/live_controller.dart';
import '../model/live_model.dart';
import '../model/recent_match_model.dart';
import '../model/upcoming_match_model.dart';

class LiveMatchesScreen extends StatelessWidget {
  LiveMatchesScreen({super.key, this.initialTab = 0});

  final int initialTab;
  final LiveMatchesController controller = Get.put(LiveMatchesController(), permanent: true);

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
                    /// UPCOMING
                    if (controller.isUpcoming) {
                      if (controller.isUpcomingLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildUpcomingList();
                    }

                    /// RECENT MATCH
                    if (controller.isRecentMatch) {
                      if (controller.isRecentMatchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _recentMatchList();
                    }

                    /// FOOTBALL
                    if (controller.isFootball) {
                      if (controller.isFootballLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _footballMatchList();
                    }

                    /// RUGBY
                    if (controller.isRugby) {
                      if (controller.isRugbyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _rugbyMatchList();
                    }

                    /// STATS
                    if (controller.isStats) {
                      return controller.statsData == null
                          ? const Center(child: CircularProgressIndicator())
                          : MatchStatsWidget(
                        statsData: controller.statsData!,
                      );
                    }

                    /// LINEUP
                    if (controller.isLineup) {
                      return controller.lineupData == null
                          ? const Center(child: CircularProgressIndicator())
                          : LineupWidget(
                        lineupData: controller.lineupData!,
                      );
                    }

                    /// TABLE
                    if (controller.isTable) {

                      if (controller.isTableLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.tableData == null) {
                        return const Center(
                          child: Text(
                            "No Table Data",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return TableWidget(
                        tableData: controller.tableData!,
                      );
                    }


                    /// H2H
                    if (controller.isH2H) {
                      return controller.h2hData == null
                          ? const Center(child: CircularProgressIndicator())
                          : H2HWidget(
                        h2hData: controller.h2hData!,
                      );
                    }

                    /// DEFAULT → LIVE
                    if (controller.isLoading && controller.matches.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return _buildMatchList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TABS (FIXED)

  // MATCH LIST
  Widget _buildMatchList() {
    if (controller.isLoading && controller.matches.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshMatches,
      child: ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.matches.length +
            (controller.isPaginationLoading ? 1 : 0),
        itemBuilder: (context, index) {
          /// bottom loader
          if (index == controller.matches.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return _matchCard(controller.matches[index]);
        },
      ),
    );
  }


  // MATCH CARD
  Widget _matchCard(MatchModel match) {
    return GestureDetector(
      // onTap: () => Get.to(VideoLiveScreen()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white24),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            /// Live + Views Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      match.viewCount,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            /// Teams + Score Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _team(match.homeTeam, match.homeLogo),
                Text(
                  "${match.homeScore}  -  ${match.awayScore}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _team(match.awayTeam, match.awayLogo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _team(String name, String badgeUrl) {
    final formattedBadgeUrl = badgeUrl
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59');

    return SizedBox(
      width: 90,
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: formattedBadgeUrl.isNotEmpty
                  ? Image.network(
                formattedBadgeUrl,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                /// prevents crash if image fails
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.sports_soccer),
              )
                  : const Icon(Icons.sports_soccer),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }



  Widget _buildUpcomingList() {
    if (controller.isUpcomingLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.upcomingMatches.isEmpty) {
      return const Center(
        child: Text(
          "No Upcoming Matches",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.upcomingMatches.length,
      itemBuilder: (context, index) {
        final match = controller.upcomingMatches[index];
        return _upcomingMatchCard(match);
      },
    );
  }


  Widget _upcomingMatchCard(UpcomingMatchModel match) {
    return Container(
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
              if (match.timeRemaining != null)
                _buildCountdownChips(match.timeRemaining!)
              else
                _timeChip("SOON"),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.visibility_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    match.viewCount,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _team(match.homeTeam, match.homeLogo),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      match.dayHeader,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _remindButton(
                      isReminded: controller.remindedMatchIds.contains(match.id),
                      onTap: () => controller.toggleReminder(match.id),
                    ),
                  ],
                ),
              ),
              _team(match.awayTeam, match.awayLogo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownChips(String timeString) {
    // Expected format: "1H 8M 10S"
    final parts = timeString.split(' ');
    return Row(
      children: parts.map((part) => _timeChip(part)).toList(),
    );
  }

  Widget _timeChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _recentMatchList() {
    if (controller.recentMatches.isEmpty) {
      return const Center(
        child: Text(
          "No Recent Matches",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.recentMatches.length,
      itemBuilder: (context, index) {
        return _recentMatchCard(controller.recentMatches[index]);
      },
    );
  }

  Widget _recentMatchCard(RecentMatchModel match) {
    return GestureDetector(
      // onTap: () => Get.to(VideoLiveScreen()),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    match.progress.isNotEmpty ? match.progress : "FT",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      match.viewCount,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _team(match.homeTeam, match.homeLogo),
                Text(
                  "${match.homeScore}  -  ${match.awayScore}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _team(match.awayTeam, match.awayLogo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _footballMatchList() {
    if (controller.footballMatches.isEmpty) {
      return const Center(
        child: Text(
          "No Football Matches",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.footballMatches.length,
      itemBuilder: (context, index) {
        return _upcomingMatchCard(controller.footballMatches[index]);
      },
    );
  }

  Widget _rugbyMatchList() {
    if (controller.rugbyMatches.isEmpty) {
      return const Center(
        child: Text(
          "No Rugby Matches",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.rugbyMatches.length,
      itemBuilder: (context, index) {
        return _upcomingMatchCard(controller.rugbyMatches[index]);
      },
    );
  }

  Widget _remindButton({required bool isReminded, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isReminded ? Colors.amber : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.notifications_none, size: 16, color: Colors.black),
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
      ),
    );
  }

}
