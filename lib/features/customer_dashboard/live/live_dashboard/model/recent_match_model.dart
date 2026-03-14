class RecentMatchModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final String status;
  final String homeScore;
  final String awayScore;
  final String viewCount;
  final String progress;
  final String? timeRemaining;
  final String dayHeader;
  final String timestamp;
  final String date;

  RecentMatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.status,
    required this.homeScore,
    required this.awayScore,
    required this.viewCount,
    required this.progress,
    this.timeRemaining,
    required this.dayHeader,
    required this.timestamp,
    required this.date,
  });

  factory RecentMatchModel.fromJson(Map<String, dynamic> json) {
    return RecentMatchModel(
      id: json['id']?.toString() ?? '',
      homeTeam: json['homeTeam'] ?? '',
      awayTeam: json['awayTeam'] ?? '',
      homeLogo: json['logo']?['home'] ?? '',
      awayLogo: json['logo']?['away'] ?? '',
      status: json['status'] ?? '',
      homeScore: json['homeScore']?.toString() ?? '0',
      awayScore: json['awayScore']?.toString() ?? '0',
      viewCount: json['viewCount'] ?? '',
      progress: json['progress'] ?? '',
      timeRemaining: json['timeRemaining'],
      dayHeader: json['dayHeader'] ?? '',
      timestamp: json['timestamp'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
