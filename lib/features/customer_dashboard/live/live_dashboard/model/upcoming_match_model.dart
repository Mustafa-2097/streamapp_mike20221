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
  });

  factory UpcomingMatchModel.fromJson(Map<String, dynamic> json) {
    return UpcomingMatchModel(
      id: json['id']?.toString() ?? '',
      homeTeam: json['homeTeam'] ?? '',
      awayTeam: json['awayTeam'] ?? '',
      homeLogo: json['logo']?['home'] ?? '',
      awayLogo: json['logo']?['away'] ?? '',
      status: json['status'] ?? '',
      homeScore: json['homeScore']?.toString() ?? '-',
      awayScore: json['awayScore']?.toString() ?? '-',
      viewCount: json['viewCount'] ?? '',
      timeRemaining: json['timeRemaining'],
      dayHeader: json['dayHeader'] ?? '',
      timestamp: json['timestamp'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
