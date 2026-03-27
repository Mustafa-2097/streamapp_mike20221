class MatchHeaderModel {
  final String? id;
  final String? idEvent;
  final String? idLeague;
  final String? strSeason;
  final String? strGroup;
  final String? homeTeam;
  final String? awayTeam;
  final Logos? logo;
  final String? status;
  final String? league;
  final String? idHomeTeam;
  final String? idAwayTeam;
  final String? homeScore;
  final String? awayScore;
  final String? viewCount;
  final String? progress;
  final String? matchMinute;
  final String? statusLabel;
  final String? matchStage;
  final String? timeRemaining;
  final String? dayHeader;
  final String? timestamp;
  final String? date;
  final String? time;

  MatchHeaderModel({
    this.id,
    this.idEvent,
    this.idLeague,
    this.strSeason,
    this.strGroup,
    this.homeTeam,
    this.awayTeam,
    this.logo,
    this.status,
    this.league,
    this.idHomeTeam,
    this.idAwayTeam,
    this.homeScore,
    this.awayScore,
    this.viewCount,
    this.progress,
    this.matchMinute,
    this.statusLabel,
    this.matchStage,
    this.timeRemaining,
    this.dayHeader,
    this.timestamp,
    this.date,
    this.time,
  });

  factory MatchHeaderModel.fromJson(Map<String, dynamic> json) {
    return MatchHeaderModel(
      id: json['id']?.toString(),
      idEvent: json['idEvent']?.toString(),
      idLeague: json['idLeague']?.toString(),
      strSeason: json['strSeason']?.toString(),
      strGroup: json['strGroup']?.toString(),
      homeTeam: json['homeTeam']?.toString(),
      awayTeam: json['awayTeam']?.toString(),
      logo: json['logo'] != null ? Logos.fromJson(json['logo']) : null,
      status: json['status']?.toString(),
      league: json['league']?.toString(),
      idHomeTeam: json['idHomeTeam']?.toString(),
      idAwayTeam: json['idAwayTeam']?.toString(),
      homeScore: json['homeScore']?.toString(),
      awayScore: json['awayScore']?.toString(),
      viewCount: json['viewCount']?.toString(),
      progress: json['progress']?.toString(),
      matchMinute: json['matchMinute']?.toString(),
      statusLabel: json['statusLabel']?.toString(),
      matchStage: json['matchStage']?.toString(),
      timeRemaining: json['timeRemaining']?.toString(),
      dayHeader: json['dayHeader']?.toString(),
      timestamp: json['timestamp']?.toString(),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
    );
  }
}

class Logos {
  final String? home;
  final String? away;

  Logos({this.home, this.away});

  factory Logos.fromJson(Map<String, dynamic> json) {
    return Logos(
      home: json['home']?.toString(),
      away: json['away']?.toString(),
    );
  }
}
