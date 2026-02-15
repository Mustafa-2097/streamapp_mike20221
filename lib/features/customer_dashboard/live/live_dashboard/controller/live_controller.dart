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

class LiveMatchesController extends GetxController {
  final tabs = [
    "All",
    "Upcoming",
    "Recent Match",
    "Football",
    "Stats",
    "Line-Ups",
    "Table",
    "H2H"
  ];

  int selectedTab = 0;

  bool get isLive => selectedTab == 0;
  bool get isUpcoming => selectedTab == 1;
  bool get isRecentMatch => selectedTab == 2;
  bool get isStats => selectedTab == 4;
  bool get isLineup => selectedTab == 5;
  bool get isTable => selectedTab == 6;
  bool get isH2H => selectedTab == 7;

  MatchStatsData? statsData;
  LineupData? lineupData;
  TableData? tableData;
  H2HData? h2hData;
  RecentMatchesData? recentMatchesData;

  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;
  bool isPaginationLoading = false;

  List<MatchModel> matches = [];

  final ScrollController scrollController = ScrollController();

  List<UpcomingMatchModel> upcomingMatches = [];
  bool isUpcomingLoading = false;
  bool isTableLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches(isRefresh: true);

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

  void setTab(int index) {
    selectedTab = index;

    if (isUpcoming && upcomingMatches.isEmpty) {
      fetchUpcomingMatches();
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

      final response = await CustomerApiService.getLiveScores(page: currentPage);

      final List list = (response['data']?['livescore'] ?? []) as List;

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

  Future<void> refreshMatches() async {
    await fetchLiveMatches(isRefresh: true);
  }

  /// ================= Upcoming =================
  Future<void> fetchUpcomingMatches() async {
    try {
      isUpcomingLoading = true;
      update();

      final response = await CustomerApiService.getUpcomingMatches(leagueId: "4328");
      print("Upcoming Response: $response");

      final List list = (response['data']?['events'] ?? []) as List;

      upcomingMatches = list.map((e) => UpcomingMatchModel.fromJson(e)).toList();
    } catch (e) {
      print("Upcoming API error: $e");
    } finally {
      isUpcomingLoading = false;
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


  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}


