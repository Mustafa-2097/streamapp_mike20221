class UpcomingMatchModel {
  final String homeTeam;
  final String awayTeam;
  final String homeBadge;
  final String awayBadge;
  final String date;
  final String time;

  UpcomingMatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeBadge,
    required this.awayBadge,
    required this.date,
    required this.time,
  });

  factory UpcomingMatchModel.fromJson(Map<String, dynamic> json) {
    return UpcomingMatchModel(
      homeTeam: json['strHomeTeam'] ?? '',
      awayTeam: json['strAwayTeam'] ?? '',
      homeBadge: json['strHomeTeamBadge'] ?? '',
      awayBadge: json['strAwayTeamBadge'] ?? '',
      date: json['dateEvent'] ?? '',
      time: json['strTime'] ?? '',
    );
  }
}
