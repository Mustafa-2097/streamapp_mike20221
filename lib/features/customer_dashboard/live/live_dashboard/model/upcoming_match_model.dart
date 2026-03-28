class UpcomingMatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final String status;
  final String homeScore;
  final String awayScore;
  final String viewCount;
  final String? timeRemaining;
  final String dayHeader;
  final String timestamp;
  final String date;
  final String league;

  UpcomingMatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.status,
    required this.homeScore,
    required this.awayScore,
    required this.viewCount,
    this.timeRemaining,
    required this.dayHeader,
    required this.timestamp,
    required this.date,
    required this.league,
  });

  factory UpcomingMatchModel.fromJson(Map<String, dynamic> json) {
    return UpcomingMatchModel(
      id:
          json['id']?.toString() ??
          json['matchId']?.toString() ??
          json['match_id']?.toString() ??
          '',
      homeTeam:
          json['homeTeam'] ??
          json['home_team'] ??
          json['team1'] ??
          json['home'] ??
          '',
      awayTeam:
          json['awayTeam'] ??
          json['away_team'] ??
          json['team2'] ??
          json['away'] ??
          '',
      homeLogo:
          json['logo']?['home'] ??
          json['homeLogo'] ??
          json['home_logo'] ??
          json['logo1'] ??
          '',
      awayLogo:
          json['logo']?['away'] ??
          json['awayLogo'] ??
          json['away_logo'] ??
          json['logo2'] ??
          '',
      status: json['status'] ?? 'Scheduled',
      homeScore: json['homeScore']?.toString() ?? '-',
      awayScore: json['awayScore']?.toString() ?? '-',
      viewCount: json['viewCount']?.toString() ?? '0',
      timeRemaining: json['timeRemaining'] ?? json['time_remaining'],
      dayHeader: json['dayHeader'] ?? json['day_header'] ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
      date: json['date'] ?? json['time'] ?? 'TBA',
      league: json['league']?.toString() ?? json['league_name']?.toString() ?? 'Upcoming',
    );
  }
}
