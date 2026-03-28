class MatchSummaryModel {
  final List<TimelineEvent> timeline;
  final SummaryStats? stats;

  MatchSummaryModel({required this.timeline, this.stats});

  factory MatchSummaryModel.fromJson(Map<String, dynamic> json) {
    return MatchSummaryModel(
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => TimelineEvent.fromJson(e))
              .toList() ?? [],
      stats: json['stats'] != null ? SummaryStats.fromJson(json['stats']) : null,
    );
  }
}

class TimelineEvent {
  final String? minute;
  final String? player;
  final String? type;
  final String? teamSide;
  final String? score;

  TimelineEvent({this.minute, this.player, this.type, this.teamSide, this.score});

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      minute: json['minute']?.toString(),
      player: json['player']?.toString(),
      type: json['type']?.toString(),
      teamSide: json['teamSide']?.toString(),
      score: json['score']?.toString(),
    );
  }
}

class SummaryStats {
  final String? possession;
  final TeamStatPair? shotsOnGoal;
  final String? corners;
  final TeamStatPair? yellowCards;
  final TeamStatPair? redCards;

  SummaryStats({
    this.possession,
    this.shotsOnGoal,
    this.corners,
    this.yellowCards,
    this.redCards,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    return SummaryStats(
      possession: json['possession']?.toString(),
      shotsOnGoal: json['shotsOnGoal'] != null ? TeamStatPair.fromJson(json['shotsOnGoal']) : null,
      corners: json['corners']?.toString(),
      yellowCards: json['yellowCards'] != null ? TeamStatPair.fromJson(json['yellowCards']) : null,
      redCards: json['redCards'] != null ? TeamStatPair.fromJson(json['redCards']) : null,
    );
  }
}

class TeamStatPair {
  final String? home;
  final String? away;

  TeamStatPair({this.home, this.away});

  factory TeamStatPair.fromJson(Map<String, dynamic> json) {
    return TeamStatPair(
      home: json['home']?.toString(),
      away: json['away']?.toString(),
    );
  }
}
