class MatchInfoModel {
  final Venue? venue;
  final Tournament? tournament;
  final Performance? performance;

  MatchInfoModel({this.venue, this.tournament, this.performance});

  factory MatchInfoModel.fromJson(Map<String, dynamic> json) {
    return MatchInfoModel(
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      tournament: json['tournament'] != null ? Tournament.fromJson(json['tournament']) : null,
      performance: json['performance'] != null ? Performance.fromJson(json['performance']) : null,
    );
  }
}

class Venue {
  final String? stadium;
  final String? city;
  final String? capacity;

  Venue({this.stadium, this.city, this.capacity});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      stadium: json['stadium']?.toString(),
      city: json['city']?.toString(),
      capacity: json['capacity']?.toString(),
    );
  }
}

class Tournament {
  final String? name;
  final String? stage;

  Tournament({this.name, this.stage});

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      name: json['name']?.toString(),
      stage: json['stage']?.toString(),
    );
  }
}

class Performance {
  final TeamPerformance? home;
  final TeamPerformance? away;

  Performance({this.home, this.away});

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      home: json['home'] != null ? TeamPerformance.fromJson(json['home']) : null,
      away: json['away'] != null ? TeamPerformance.fromJson(json['away']) : null,
    );
  }
}

class TeamPerformance {
  final String? name;
  final String? logo;
  final List<String> form;
  final List<RecentMatchInfoModel> recentMatches;

  TeamPerformance({this.name, this.logo, required this.form, required this.recentMatches});

  factory TeamPerformance.fromJson(Map<String, dynamic> json) {
    return TeamPerformance(
      name: json['name']?.toString(),
      logo: json['logo']?.toString(),
      form: (json['form'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      recentMatches: (json['recentMatches'] as List<dynamic>?)
              ?.map((e) => RecentMatchInfoModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class RecentMatchInfoModel {
  final String? id;
  final String? opponent;
  final String? opponentLogo;
  final String? homeScore;
  final String? awayScore;
  final String? teamScore;
  final String? opponentScore;
  final bool isHome;
  final String? resultCode;
  final String? date;

  RecentMatchInfoModel({this.id, this.opponent, this.opponentLogo, this.homeScore, this.awayScore, this.teamScore, this.opponentScore, this.isHome = true, this.resultCode, this.date});

  factory RecentMatchInfoModel.fromJson(Map<String, dynamic> json) {
    return RecentMatchInfoModel(
      id: json['id']?.toString(),
      opponent: json['opponent']?.toString(),
      opponentLogo: json['opponentLogo']?.toString(),
      homeScore: json['homeScore']?.toString(),
      awayScore: json['awayScore']?.toString(),
      teamScore: json['teamScore']?.toString(),
      opponentScore: json['opponentScore']?.toString(),
      isHome: json['isHome'] as bool? ?? true,
      resultCode: json['resultCode']?.toString(),
      date: json['date']?.toString(),
    );
  }
}
