class MatchStat {
  final String label;
  final int homeValue;
  final int awayValue;

  MatchStat({
    required this.label,
    required this.homeValue,
    required this.awayValue,
  });
}

class MatchStatsData {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String tournament;
  final String stage;
  final List<MatchStat> stats;

  MatchStatsData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.tournament,
    required this.stage,
    required this.stats,
  });

  // Factory constructor with sample data
  factory MatchStatsData.sample() {
    return MatchStatsData(
      homeTeam: 'England',
      awayTeam: 'Germany',
      homeScore: 2,
      awayScore: 1,
      tournament: 'world cup 2026',
      stage: 'Group Stage • Group B',
      stats: [
        MatchStat(label: 'Shots on target', homeValue: 2, awayValue: 2),
        MatchStat(label: 'Shots off target', homeValue: 3, awayValue: 9),
        MatchStat(label: 'Blocked shots', homeValue: 3, awayValue: 3),
        MatchStat(label: 'Possession (%)', homeValue: 50, awayValue: 50),
        MatchStat(label: 'Corner kicks', homeValue: 4, awayValue: 0),
        MatchStat(label: 'Offsides', homeValue: 1, awayValue: 1),
        MatchStat(label: 'Fouls', homeValue: 20, awayValue: 13),
        MatchStat(label: 'Throw-ins', homeValue: 15, awayValue: 13),
        MatchStat(label: 'Yellow cards', homeValue: 2, awayValue: 2),
        MatchStat(label: 'Red cards', homeValue: 0, awayValue: 0),
        MatchStat(label: 'Crosses', homeValue: 15, awayValue: 22),
        MatchStat(label: 'Counter attacks', homeValue: 1, awayValue: 1),
        MatchStat(label: 'Goalkeeper saves', homeValue: 1, awayValue: 1),
        MatchStat(label: 'Goal kicks', homeValue: 14, awayValue: 5),
      ],
    );
  }
}

class MatchStatsModel {
  final MatchStatSet? match;
  final MatchStatSet? firstHalf;
  final MatchStatSet? secondHalf;

  MatchStatsModel({this.match, this.firstHalf, this.secondHalf});

  factory MatchStatsModel.fromJson(Map<String, dynamic> json) {
    return MatchStatsModel(
      match: json['match'] != null ? MatchStatSet.fromJson(json['match']) : null,
      firstHalf: json['firstHalf'] != null ? MatchStatSet.fromJson(json['firstHalf']) : null,
      secondHalf: json['secondHalf'] != null ? MatchStatSet.fromJson(json['secondHalf']) : null,
    );
  }
}

class MatchStatSet {
  final StatPair? shotsOnTarget;
  final StatPair? shotsOffTarget;
  final StatPair? blockedShots;
  final StatPair? possession;
  final StatPair? corners;
  final StatPair? offsides;
  final StatPair? fouls;
  final StatPair? throwins;
  final StatPair? yellowCards;
  final StatPair? redCards;
  final StatPair? crosses;
  final StatPair? counterAttacks;
  final StatPair? saves;
  final StatPair? goalKicks;

  MatchStatSet({
    this.shotsOnTarget,
    this.shotsOffTarget,
    this.blockedShots,
    this.possession,
    this.corners,
    this.offsides,
    this.fouls,
    this.throwins,
    this.yellowCards,
    this.redCards,
    this.crosses,
    this.counterAttacks,
    this.saves,
    this.goalKicks,
  });

  factory MatchStatSet.fromJson(Map<String, dynamic> json) {
    return MatchStatSet(
      shotsOnTarget: json['shotsOnTarget'] != null ? StatPair.fromJson(json['shotsOnTarget']) : null,
      shotsOffTarget: json['shotsOffTarget'] != null ? StatPair.fromJson(json['shotsOffTarget']) : null,
      blockedShots: json['blockedShots'] != null ? StatPair.fromJson(json['blockedShots']) : null,
      possession: json['possession'] != null ? StatPair.fromJson(json['possession']) : null,
      corners: json['corners'] != null ? StatPair.fromJson(json['corners']) : null,
      offsides: json['offsides'] != null ? StatPair.fromJson(json['offsides']) : null,
      fouls: json['fouls'] != null ? StatPair.fromJson(json['fouls']) : null,
      throwins: json['throwins'] != null ? StatPair.fromJson(json['throwins']) : null,
      yellowCards: json['yellowCards'] != null ? StatPair.fromJson(json['yellowCards']) : null,
      redCards: json['redCards'] != null ? StatPair.fromJson(json['redCards']) : null,
      crosses: json['crosses'] != null ? StatPair.fromJson(json['crosses']) : null,
      counterAttacks: json['counterAttacks'] != null ? StatPair.fromJson(json['counterAttacks']) : null,
      saves: json['saves'] != null ? StatPair.fromJson(json['saves']) : null,
      goalKicks: json['goalKicks'] != null ? StatPair.fromJson(json['goalKicks']) : null,
    );
  }

  List<Map<String, dynamic>> toStatsList() {
    int _parse(String? v) => int.tryParse(v ?? '0') ?? 0;
    return [
      if (shotsOnTarget != null) {'label': 'Shots on target', 'home': _parse(shotsOnTarget!.home), 'away': _parse(shotsOnTarget!.away)},
      if (shotsOffTarget != null) {'label': 'Shots off target', 'home': _parse(shotsOffTarget!.home), 'away': _parse(shotsOffTarget!.away)},
      if (blockedShots != null) {'label': 'Blocked shots', 'home': _parse(blockedShots!.home), 'away': _parse(blockedShots!.away)},
      if (possession != null) {'label': 'Possession (%)', 'home': _parse(possession!.home), 'away': _parse(possession!.away)},
      if (corners != null) {'label': 'Corner kicks', 'home': _parse(corners!.home), 'away': _parse(corners!.away)},
      if (offsides != null) {'label': 'Offsides', 'home': _parse(offsides!.home), 'away': _parse(offsides!.away)},
      if (fouls != null) {'label': 'Fouls', 'home': _parse(fouls!.home), 'away': _parse(fouls!.away)},
      if (throwins != null) {'label': 'Throw-ins', 'home': _parse(throwins!.home), 'away': _parse(throwins!.away)},
      if (yellowCards != null) {'label': 'Yellow cards', 'home': _parse(yellowCards!.home), 'away': _parse(yellowCards!.away)},
      if (redCards != null) {'label': 'Red cards', 'home': _parse(redCards!.home), 'away': _parse(redCards!.away)},
      if (crosses != null) {'label': 'Crosses', 'home': _parse(crosses!.home), 'away': _parse(crosses!.away)},
      if (counterAttacks != null) {'label': 'Counter attacks', 'home': _parse(counterAttacks!.home), 'away': _parse(counterAttacks!.away)},
      if (saves != null) {'label': 'Goalkeeper saves', 'home': _parse(saves!.home), 'away': _parse(saves!.away)},
      if (goalKicks != null) {'label': 'Goal kicks', 'home': _parse(goalKicks!.home), 'away': _parse(goalKicks!.away)},
    ];
  }
}

class StatPair {
  final String? home;
  final String? away;

  StatPair({this.home, this.away});

  factory StatPair.fromJson(Map<String, dynamic> json) {
    return StatPair(
      home: json['home']?.toString(),
      away: json['away']?.toString(),
    );
  }
}
