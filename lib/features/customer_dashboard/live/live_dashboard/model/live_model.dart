class MatchModel {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String views;

  MatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.views,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      homeTeam: json['strHomeTeam'] ?? '',
      awayTeam: json['strAwayTeam'] ?? '',
      homeScore: int.tryParse(json['intHomeScore']?.toString() ?? '0') ?? 0,
      awayScore: int.tryParse(json['intAwayScore']?.toString() ?? '0') ?? 0,

      /// API has no views → keep dummy
      views: "LIVE",
    );
  }
}

