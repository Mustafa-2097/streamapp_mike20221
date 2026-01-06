import 'package:get/get.dart';

import '../model/live_model.dart';

class LiveMatchesController extends GetxController {
  final tabs = ["All", "Upcoming", "Football", "Rugby"];

  int selectedTab = 0;

  bool get isUpcoming => selectedTab == 1;

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
