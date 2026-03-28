class MatchH2HModel {
  final String? homeTeam;
  final String? awayTeam;
  final String? homeLogo;
  final String? awayLogo;
  final H2HRecord? overall;
  final H2HRecord? lastFive;
  final List<H2HHistoryEntry> history;

  MatchH2HModel({
    this.homeTeam,
    this.awayTeam,
    this.homeLogo,
    this.awayLogo,
    this.overall,
    this.lastFive,
    required this.history,
  });

  factory MatchH2HModel.fromJson(Map<String, dynamic> json) {
    return MatchH2HModel(
      homeTeam: json['homeTeam']?.toString(),
      awayTeam: json['awayTeam']?.toString(),
      homeLogo: json['homeLogo']?.toString(),
      awayLogo: json['awayLogo']?.toString(),
      overall: json['overall'] != null ? H2HRecord.fromJson(json['overall']) : null,
      lastFive: json['lastFive'] != null ? H2HRecord.fromJson(json['lastFive']) : null,
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => H2HHistoryEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class H2HRecord {
  final int homeWins;
  final int draws;
  final int awayWins;

  H2HRecord({required this.homeWins, required this.draws, required this.awayWins});

  factory H2HRecord.fromJson(Map<String, dynamic> json) {
    return H2HRecord(
      homeWins: json['homeWins'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      awayWins: json['awayWins'] as int? ?? 0,
    );
  }

  int get total => homeWins + draws + awayWins;
}

class H2HHistoryEntry {
  final String? date;
  final String? status;
  final String? homeTeam;
  final String? awayTeam;
  final String? homeScore;
  final String? awayScore;
  final String? tournament;

  H2HHistoryEntry({
    this.date,
    this.status,
    this.homeTeam,
    this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.tournament,
  });

  factory H2HHistoryEntry.fromJson(Map<String, dynamic> json) {
    return H2HHistoryEntry(
      date: json['date']?.toString(),
      status: json['status']?.toString(),
      homeTeam: json['homeTeam']?.toString(),
      awayTeam: json['awayTeam']?.toString(),
      homeScore: json['homeScore']?.toString(),
      awayScore: json['awayScore']?.toString(),
      tournament: json['tournament']?.toString(),
    );
  }
}
