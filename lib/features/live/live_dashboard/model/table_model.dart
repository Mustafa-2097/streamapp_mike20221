class TeamStanding {
  final int position;
  final String teamName;
  final String flag; // Can be emoji or asset path
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
    required this.flag,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  int get goalDifference => goalsFor - goalsAgainst;
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
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String tournament;
  final String stage;
  final List<GroupStanding> groups;

  TableData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.tournament,
    required this.stage,
    required this.groups,
  });

  factory TableData.sample() {
    return TableData(
      homeTeam: 'England',
      awayTeam: 'Germany',
      homeScore: 2,
      awayScore: 1,
      tournament: 'world cup 2020',
      stage: 'Group Stage • Group B',
      groups: [
        GroupStanding(
          groupName: 'Group A',
          teams: [
            TeamStanding(
              position: 1,
              teamName: 'England',
              flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
              played: 14,
              wins: 10,
              draws: 2,
              losses: 2,
              goalsFor: 32,
              goalsAgainst: 12,
              points: 32,
            ),
            TeamStanding(
              position: 2,
              teamName: 'Germany',
              flag: '🇩🇪',
              played: 14,
              wins: 9,
              draws: 2,
              losses: 3,
              goalsFor: 28,
              goalsAgainst: 14,
              points: 29,
            ),
            TeamStanding(
              position: 3,
              teamName: 'Brazil',
              flag: '🇧🇷',
              played: 15,
              wins: 8,
              draws: 3,
              losses: 4,
              goalsFor: 25,
              goalsAgainst: 15,
              points: 27,
            ),
            TeamStanding(
              position: 4,
              teamName: 'Spain',
              flag: '🇪🇸',
              played: 15,
              wins: 7,
              draws: 2,
              losses: 6,
              goalsFor: 22,
              goalsAgainst: 18,
              points: 23,
            ),
          ],
        ),
      ],
    );
  }
}
