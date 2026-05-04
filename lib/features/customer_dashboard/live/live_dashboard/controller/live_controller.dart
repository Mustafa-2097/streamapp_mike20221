import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/data/customer_api_service.dart';

import '../model/live_model.dart';
import '../model/match_stats_model.dart';
import '../model/lineup_model.dart';
import '../model/table_model.dart';
import '../model/h2h_model.dart';
import '../model/recent_match_model.dart';
import '../model/upcoming_match_model.dart';
import 'package:testapp/core/network/socket_service.dart';

class LiveMatchesController extends GetxController {
  final tabs = [
    "All",
    "Upcoming",
    "Recent Match",
    "Football",
    "Rugby",
    // "Stats",
    // "Line-Ups",
    // "Table",
    // "H2H"
  ];

  int selectedTab = 0;

  bool get isLive => selectedTab == 0;
  bool get isUpcoming => selectedTab == 1;
  bool get isRecentMatch => selectedTab == 2;
  bool get isFootball => selectedTab == 3;
  bool get isRugby => selectedTab == 4;
  bool get isStats => selectedTab == 5;
  bool get isLineup => selectedTab == 6;
  bool get isTable => selectedTab == 7;
  bool get isH2H => selectedTab == 8;

  MatchStatsData? statsData;
  LineupData? lineupData;
  TableData? tableData;
  H2HData? h2hData;
  List<RecentMatchModel> recentMatches = [];
  bool isRecentMatchLoading = false;
  List<UpcomingMatchModel> footballMatches = [];
  bool isFootballLoading = false;
  List<UpcomingMatchModel> rugbyMatches = [];
  bool isRugbyLoading = false;

  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;
  bool isPaginationLoading = false;

  List<MatchModel> matches = [];

  final ScrollController scrollController = ScrollController();
  final SocketService _socketService = Get.find<SocketService>();

  List<UpcomingMatchModel> upcomingMatches = [];
  bool isUpcomingLoading = false;
  bool isTableLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches(isRefresh: true);
    _setupSocketListeners();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isPaginationLoading &&
          hasMore &&
          isLive) {
        fetchLiveMatches();
      }
    });
  }

  void _setupSocketListeners() {
    _socketService.on("matches:live", (data) {
      debugPrint("Socket: Live matches (matches:live) received.");
      try {
        if (data is List) {
          final newMatches = data.map((e) => MatchModel.fromJson(e)).toList();

          // If we are on first page (currentPage is incremented after fetch, 
          // so if currentPage is 2, we just fetched page 1)
          if (currentPage <= 2) {
            matches = newMatches;
            update();
          } else {
            // Intelligent merging: update scores of existing matches, don't break pagination
            for (var newMatch in newMatches) {
              final index = matches.indexWhere((m) => m.id == newMatch.id);
              if (index != -1) {
                matches[index] = newMatch;
              }
            }
            update();
          }
        }
      } catch (e) {
        debugPrint("Error parsing socket matches:live info: $e");
      }
    });
  }

  void setTab(int index) {
    selectedTab = index;

    if (isUpcoming && upcomingMatches.isEmpty) {
      fetchUpcomingMatches();
    }

    if (isRecentMatch && recentMatches.isEmpty) {
      fetchRecentMatches();
    }

    if (isFootball && footballMatches.isEmpty) {
      fetchFootballMatches();
    }

    if (isRugby && rugbyMatches.isEmpty) {
      fetchRugbyMatches();
    }

    if (isTable && tableData == null) {
      fetchLeagueTable();
    }

    update();
  }

  /// ================= LIVE =================
  Future<void> fetchLiveMatches({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        hasMore = true;
        matches.clear();
        isLoading = true;
      } else {
        isPaginationLoading = true;
      }

      update();

      final response = await CustomerApiService.getLiveMatches(
        page: currentPage,
      );

      final List list = (response['data'] ?? []) as List;

      final newMatches = list.map((e) => MatchModel.fromJson(e)).toList();

      if (newMatches.isEmpty) {
        hasMore = false;
      } else {
        matches.addAll(newMatches);
        currentPage++;
      }
    } catch (e) {
      print("Live API error: $e");
    } finally {
      isLoading = false;
      isPaginationLoading = false;
      update();
    }
  }

  final Set<String> remindedMatchIds = {};

  void toggleReminder(String matchId) {
    if (remindedMatchIds.contains(matchId)) {
      remindedMatchIds.remove(matchId);
    } else {
      remindedMatchIds.add(matchId);
    }
    update();
  }

  Future<void> refreshMatches() async {
    await fetchLiveMatches(isRefresh: true);
  }

  /// ================= Upcoming =================
  Future<void> fetchUpcomingMatches() async {
    try {
      isUpcomingLoading = true;
      update();

      final response = await CustomerApiService.getUpcomingMatchesAll(page: 1);
      print("Upcoming Response: $response");

      final List list = (response['data'] ?? []) as List;

      upcomingMatches = list
          .map((e) => UpcomingMatchModel.fromJson(e))
          .toList();
    } catch (e) {
      print("Upcoming API error: $e");
    } finally {
      isUpcomingLoading = false;
      update();
    }
  }

  /// ================= Recent Match =================
  Future<void> fetchRecentMatches() async {
    try {
      isRecentMatchLoading = true;
      update();

      final response = await CustomerApiService.getRecentMatches(page: 1);
      print("Recent Response: $response");

      final List list = (response['data'] ?? []) as List;

      recentMatches = list.map((e) => RecentMatchModel.fromJson(e)).toList();
    } catch (e) {
      print("Recent API error: $e");
    } finally {
      isRecentMatchLoading = false;
      update();
    }
  }

  /// ================= Football Match =================
  Future<void> fetchFootballMatches() async {
    try {
      isFootballLoading = true;
      update();

      final response = await CustomerApiService.getFootballMatches(page: 1);
      print("Football Response: $response");

      final List list = (response['data'] ?? []) as List;

      footballMatches = list
          .map((e) => UpcomingMatchModel.fromJson(e))
          .toList();
    } catch (e) {
      print("Football API error: $e");
    } finally {
      isFootballLoading = false;
      update();
    }
  }

  /// ================= Rugby Match =================
  Future<void> fetchRugbyMatches() async {
    try {
      isRugbyLoading = true;
      update();

      final response = await CustomerApiService.getRugbyMatches(page: 1);
      print("Rugby Response: $response");

      final List list = (response['data'] ?? []) as List;

      rugbyMatches = list.map((e) => UpcomingMatchModel.fromJson(e)).toList();
    } catch (e) {
      print("Rugby API error: $e");
    } finally {
      isRugbyLoading = false;
      update();
    }
  }

  Future<void> fetchLeagueTable() async {
    try {
      isTableLoading = true;
      update();

      final response = await CustomerApiService.getLeagueTable(
        leagueId: "4328",
        season: "2025-2026",
      );

      print("Table Response: $response");

      final data = response['data'];

      if (data != null) {
        tableData = TableData.fromJson(data);
      }
    } catch (e) {
      print("Table API error: $e");
    } finally {
      isTableLoading = false;
      update();
    }
  }

  /// Refreshes the currently active tab's data (e.g. after view count changes)
  Future<void> refreshCurrentTab() async {
    if (isLive) {
      await fetchLiveMatches(isRefresh: true);
    } else if (isUpcoming) {
      await fetchUpcomingMatches();
    } else if (isRecentMatch) {
      await fetchRecentMatches();
    } else if (isFootball) {
      await fetchFootballMatches();
    } else if (isRugby) {
      await fetchRugbyMatches();
    }
  }

  @override
  void onClose() {
    _socketService.off("matches:live");
    scrollController.dispose();
    super.onClose();
  }
}
