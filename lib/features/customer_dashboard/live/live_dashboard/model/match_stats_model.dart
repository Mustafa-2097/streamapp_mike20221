class MatchStat {
  final String label;
  final int homeValue;
  final int awayValue;

  MatchStat({
    required this.label,
    required this.homeValue,
    required this.awayValue,
  });
}

class MatchStatsData {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String tournament;
  final String stage;
  final List<MatchStat> stats;

  MatchStatsData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.tournament,
    required this.stage,
    required this.stats,
  });

  // Factory constructor with sample data
  factory MatchStatsData.sample() {
    return MatchStatsData(
      homeTeam: 'England',
      awayTeam: 'Germany',
      homeScore: 2,
      awayScore: 1,
      tournament: 'world cup 2026',
      stage: 'Group Stage • Group B',
      stats: [
        MatchStat(label: 'Shots on target', homeValue: 2, awayValue: 2),
        MatchStat(label: 'Shots off target', homeValue: 3, awayValue: 9),
        MatchStat(label: 'Blocked shots', homeValue: 3, awayValue: 3),
        MatchStat(label: 'Possession (%)', homeValue: 50, awayValue: 50),
        MatchStat(label: 'Corner kicks', homeValue: 4, awayValue: 0),
        MatchStat(label: 'Offsides', homeValue: 1, awayValue: 1),
        MatchStat(label: 'Fouls', homeValue: 20, awayValue: 13),
        MatchStat(label: 'Throw-ins', homeValue: 15, awayValue: 13),
        MatchStat(label: 'Yellow cards', homeValue: 2, awayValue: 2),
        MatchStat(label: 'Red cards', homeValue: 0, awayValue: 0),
        MatchStat(label: 'Crosses', homeValue: 15, awayValue: 22),
        MatchStat(label: 'Counter attacks', homeValue: 1, awayValue: 1),
        MatchStat(label: 'Diskeeper saves', homeValue: 1, awayValue: 1),
        MatchStat(label: 'Goal kicks', homeValue: 14, awayValue: 5),
      ],
    );
  }
}
