class H2HMatch {
  final String tournament;
  final String date;
  final String homeTeam;
  final int homeScore;
  final String awayTeam;
  final int awayScore;

  H2HMatch({
    required this.tournament,
    required this.date,
    required this.homeTeam,
    required this.homeScore,
    required this.awayTeam,
    required this.awayScore,
  });
}

class H2HStats {
  final int wins;
  final int draws;
  final int losses;

  H2HStats({
    required this.wins,
    required this.draws,
    required this.losses,
  });
}

class H2HData {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String tournament;
  final String stage;
  final H2HStats homeOverallStats;
  final H2HStats awayOverallStats;
  final H2HStats homeLast5Stats;
  final H2HStats awayLast5Stats;
  final List<H2HMatch> recentMatches;

  H2HData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.tournament,
    required this.stage,
    required this.homeOverallStats,
    required this.awayOverallStats,
    required this.homeLast5Stats,
    required this.awayLast5Stats,
    required this.recentMatches,
  });

  factory H2HData.sample() {
    return H2HData(
      homeTeam: 'England',
      awayTeam: 'Germany',
      homeScore: 2,
      awayScore: 1,
      tournament: 'world cup 2026',
      stage: 'Group Stage • Group B',
      homeOverallStats: H2HStats(wins: 24, draws: 9, losses: 10),
      awayOverallStats: H2HStats(wins: 10, draws: 9, losses: 24),
      homeLast5Stats: H2HStats(wins: 2, draws: 0, losses: 3),
      awayLast5Stats: H2HStats(wins: 3, draws: 0, losses: 2),
      recentMatches: [
        H2HMatch(
          tournament: 'world cup 2026',
          date: '20 Jul',
          homeTeam: 'England',
          homeScore: 3,
          awayTeam: 'Germany',
          awayScore: 2,
        ),
        H2HMatch(
          tournament: 'Euro 2024',
          date: '15 Jun',
          homeTeam: 'England',
          homeScore: 1,
          awayTeam: 'Germany',
          awayScore: 2,
        ),
        H2HMatch(
          tournament: 'Friendly',
          date: '30 Mar',
          homeTeam: 'Germany',
          homeScore: 2,
          awayTeam: 'England',
          awayScore: 0,
        ),
        H2HMatch(
          tournament: 'World Cup 2022',
          date: '25 Nov',
          homeTeam: 'England',
          homeScore: 3,
          awayTeam: 'Germany',
          awayScore: 3,
        ),
      ],
    );
  }
}
