class RecentMatchItem {
  final int score1;
  final String team1;
  final String flag1;
  final int score2;
  final String team2;
  final String flag2;

  RecentMatchItem({
    required this.score1,
    required this.team1,
    required this.flag1,
    required this.score2,
    required this.team2,
    required this.flag2,
  });
}

class RecentMatchesData {
  final List<RecentMatchItem> matches;

  RecentMatchesData({required this.matches});

  factory RecentMatchesData.sample() {
    return RecentMatchesData(
      matches: [
        RecentMatchItem(
          score1: 0,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 2,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 0,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 2,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 0,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 2,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 2,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 1,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 0,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 2,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 2,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 0,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 0,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 2,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 2,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 0,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 0,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 2,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
        RecentMatchItem(
          score1: 2,
          team1: 'Poland',
          flag1: '🇵🇱',
          score2: 0,
          team2: 'Argentina',
          flag2: '🇦🇷',
        ),
      ],
    );
  }
}
