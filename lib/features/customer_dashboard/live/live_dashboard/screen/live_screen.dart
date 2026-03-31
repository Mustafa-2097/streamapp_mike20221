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
import '../widget/live_upcoming_card.dart';
import '../../../profile/controller/bookmarks_controller.dart';
import 'match_details_screen.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
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
                          : MatchStatsWidget(statsData: controller.statsData!);
                    }

                    /// LINEUP
                    if (controller.isLineup) {
                      return controller.lineupData == null
                          ? const Center(child: CircularProgressIndicator())
                          : LineupWidget(lineupData: controller.lineupData!);
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

                      return TableWidget(tableData: controller.tableData!);
                    }

                    /// H2H
                    if (controller.isH2H) {
                      return controller.h2hData == null
                          ? const Center(child: CircularProgressIndicator())
                          : H2HWidget(h2hData: controller.h2hData!);
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

  // MATCH LIST
  Widget _buildMatchList() {
    if (controller.isLoading && controller.matches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: controller.refreshMatches,
      child: ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount:
            controller.matches.length +
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
      onTap: () async {
        await Get.to(
          () => MatchDetailsScreen(
            matchId: match.id,
            homeTeam: match.homeTeam,
            awayTeam: match.awayTeam,
            homeScore: int.tryParse(match.homeScore) ?? 0,
            awayScore: int.tryParse(match.awayScore) ?? 0,
            matchTitle: "${match.homeTeam} vs ${match.awayTeam}",
          ),
        );
        controller.refreshCurrentTab();
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
            /// Live + Views Row
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
        return _upcomingMatchCardSwipeWrapper(context, match);
      },
    );
  }

  Widget _upcomingMatchCardSwipeWrapper(
    BuildContext context,
    UpcomingMatchModel match,
  ) {
    final bookmarkController = Get.isRegistered<BookmarkController>()
        ? Get.find<BookmarkController>()
        : Get.put(BookmarkController());

    return Obx(() {
      final isBookmarked = bookmarkController.isMatchBookmarked(match.id);
      return Dismissible(
        key: Key(match.id),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            bookmarkController.toggleMatchBookmark(match.id);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isBookmarked ? "Match unbookmarked!" : "Match bookmarked!",
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: isBookmarked ? Colors.redAccent : Colors.green,
              ),
            );
          }
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Icon(
            isBookmarked ? Icons.delete_outlined : Icons.bookmark_add_outlined,
            color: isBookmarked
                ? Colors.redAccent.withOpacity(0.8)
                : Colors.amber.withOpacity(0.8),
            size: 30,
          ),
        ),
        child: _upcomingMatchCard(match),
      );
    });
  }

  Widget _upcomingMatchCard(UpcomingMatchModel match) {
    return GestureDetector(
      onTap: () async {
        await Get.to(
          () => MatchDetailsScreen(
            matchId: match.id,
            homeTeam: match.homeTeam,
            awayTeam: match.awayTeam,
            homeScore: int.tryParse(match.homeScore) ?? 0,
            awayScore: int.tryParse(match.awayScore) ?? 0,
            matchTitle: "${match.homeTeam} vs ${match.awayTeam}",
          ),
        );
        controller.refreshCurrentTab();
      },
      child: LiveUpcomingCard(
        match: match,
      ),
    );
  }

  Widget _recentMatchList() {
    if (controller.recentMatches.isEmpty) {
      return const Center(
        child: Text("No Recent Matches", style: TextStyle(color: Colors.white)),
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
      onTap: () async {
        await Get.to(
          () => MatchDetailsScreen(
            matchId: match.id,
            homeTeam: match.homeTeam,
            awayTeam: match.awayTeam,
            homeScore: int.tryParse(match.homeScore) ?? 0,
            awayScore: int.tryParse(match.awayScore) ?? 0,
            matchTitle: "${match.homeTeam} vs ${match.awayTeam}",
          ),
        );
        controller.refreshCurrentTab();
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
        return _upcomingMatchCardSwipeWrapper(
          context,
          controller.footballMatches[index],
        );
      },
    );
  }

  Widget _rugbyMatchList() {
    if (controller.rugbyMatches.isEmpty) {
      return const Center(
        child: Text("No Rugby Matches", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.rugbyMatches.length,
      itemBuilder: (context, index) {
        return _upcomingMatchCardSwipeWrapper(
          context,
          controller.rugbyMatches[index],
        );
      },
    );
  }
}
