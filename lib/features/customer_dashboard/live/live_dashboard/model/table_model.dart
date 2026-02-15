class TeamStanding {
  final int position;
  final String teamName;
  final String badge;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  TeamStanding({
    required this.position,
    required this.teamName,
    required this.badge,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  int get goalDifference => goalsFor - goalsAgainst;

  /// API → MODEL
  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      position: int.parse(json['intRank'] ?? '0'),
      teamName: json['strTeam'] ?? '',
      badge: json['strBadge'] ?? '',
      played: int.parse(json['intPlayed'] ?? '0'),
      wins: int.parse(json['intWin'] ?? '0'),
      draws: int.parse(json['intDraw'] ?? '0'),
      losses: int.parse(json['intLoss'] ?? '0'),
      goalsFor: int.parse(json['intGoalsFor'] ?? '0'),
      goalsAgainst: int.parse(json['intGoalsAgainst'] ?? '0'),
      points: int.parse(json['intPoints'] ?? '0'),
    );
  }
}

class GroupStanding {
  final String groupName;
  final List<TeamStanding> teams;

  GroupStanding({
    required this.groupName,
    required this.teams,
  });
}

class TableData {
  final String tournament;
  final String stage;
  final List<GroupStanding> groups;

  /// OPTIONAL (for header UI)
  final String? homeTeam;
  final String? awayTeam;
  final int? homeScore;
  final int? awayScore;

  TableData({
    required this.tournament,
    required this.stage,
    required this.groups,
    this.homeTeam,
    this.awayTeam,
    this.homeScore,
    this.awayScore,
  });

  /// ================= API PARSER =================
  factory TableData.fromJson(Map<String, dynamic> json) {
    final List tableList = json['table'] ?? [];

    final teams =
    tableList.map((e) => TeamStanding.fromJson(e)).toList();

    return TableData(
      tournament:
      tableList.isNotEmpty ? tableList.first['strLeague'] ?? '' : '',
      stage:
      tableList.isNotEmpty ? tableList.first['strSeason'] ?? '' : '',
      groups: [
        GroupStanding(
          groupName: "Standings",
          teams: teams,
        )
      ],

      /// Table API has NO match info
      homeTeam: null,
      awayTeam: null,
      homeScore: null,
      awayScore: null,
    );
  }
}

