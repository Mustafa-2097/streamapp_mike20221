import 'package:get/get.dart';

import '../model/live_model.dart';
import '../model/match_stats_model.dart';
import '../model/lineup_model.dart';
import '../model/table_model.dart';
import '../model/h2h_model.dart';
import '../model/recent_match_model.dart';

class LiveMatchesController extends GetxController {
  final tabs = ["All", "Upcoming", "Recent Match", "Football", "Starts", "Line-Ups", "Table", "H2H"];

  int selectedTab = 0;

  bool get isUpcoming => selectedTab == 1;
  bool get isRecentMatch => selectedTab == 2; // Recent Match tab
  bool get isStats => selectedTab == 4; // Starts tab
  bool get isLineup => selectedTab == 5; // Line-Ups tab
  bool get isTable => selectedTab == 6; // Table tab
  bool get isH2H => selectedTab == 7; // H2H tab

  late MatchStatsData statsData;
  late LineupData lineupData;
  late TableData tableData;
  late H2HData h2hData;
  late RecentMatchesData recentMatchesData;

  @override
  void onInit() {
    super.onInit();
    statsData = MatchStatsData.sample();
    lineupData = LineupData.sample();
    tableData = TableData.sample();
    h2hData = H2HData.sample();
    recentMatchesData = RecentMatchesData.sample();
  }

  final List<MatchModel> matches = [
    MatchModel(
      homeTeam: "Betis",
      awayTeam: "Barcelona",
      homeScore: 1,
      awayScore: 4,
      views: "205K Views",
    ),
    MatchModel(
      homeTeam: "Betis",
      awayTeam: "Barcelona",
      homeScore: 1,
      awayScore: 4,
      views: "205K Views",
    ),
    MatchModel(
      homeTeam: "Betis",
      awayTeam: "Barcelona",
      homeScore: 1,
      awayScore: 4,
      views: "205K Views",
    ),
  ];

  void changeTab(int index) {
    selectedTab = index;
    update(); // 🔥 rebuild tabs only
  }
}
