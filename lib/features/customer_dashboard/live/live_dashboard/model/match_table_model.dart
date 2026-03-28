class MatchTableModel {
  final String? leagueId;
  final String? season;
  final String? group;
  final List<StandingEntry> standings;

  MatchTableModel({this.leagueId, this.season, this.group, required this.standings});

  factory MatchTableModel.fromJson(Map<String, dynamic> json) {
    return MatchTableModel(
      leagueId: json['leagueId']?.toString(),
      season: json['season']?.toString(),
      group: json['group']?.toString(),
      standings: (json['standings'] as List<dynamic>?)
              ?.map((e) => StandingEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StandingEntry {
  final int? position;
  final String? team;
  final int? played;
  final int? won;
  final int? drawn;
  final int? lost;
  final int? goalsFor;
  final int? goalsAgainst;
  final int? goalDifference;
  final int? points;
  final String? form;
  final String? description;

  StandingEntry({
    this.position,
    this.team,
    this.played,
    this.won,
    this.drawn,
    this.lost,
    this.goalsFor,
    this.goalsAgainst,
    this.goalDifference,
    this.points,
    this.form,
    this.description,
  });

  factory StandingEntry.fromJson(Map<String, dynamic> json) {
    return StandingEntry(
      position: json['position'] as int?,
      team: json['team']?.toString(),
      played: json['played'] as int?,
      won: json['won'] as int?,
      drawn: json['drawn'] as int?,
      lost: json['lost'] as int?,
      goalsFor: json['goalsFor'] as int?,
      goalsAgainst: json['goalsAgainst'] as int?,
      goalDifference: json['goalDifference'] as int?,
      points: json['points'] as int?,
      form: json['form']?.toString(),
      description: json['description']?.toString(),
    );
  }

  /// Determines the left-edge accent color from the description string.
  /// CL = blue, EL = orange, Conference = green, Relegation = red, null = transparent
  String get qualificationType {
    final d = description?.toLowerCase() ?? '';
    if (d.contains('champions league')) return 'cl';
    if (d.contains('europa league')) return 'el';
    if (d.contains('conference')) return 'conf';
    if (d.contains('relegation')) return 'rel';
    return '';
  }
}
