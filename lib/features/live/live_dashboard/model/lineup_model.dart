class Player {
  final int number;
  final String name;
  final String position;

  Player({
    required this.number,
    required this.name,
    required this.position,
  });
}

class InjuredPlayer {
  final String name;
  final String status; // "Out Inj.", "Suspended", etc.

  InjuredPlayer({
    required this.name,
    required this.status,
  });
}

class TeamLineup {
  final String teamName;
  final List<Player> startingPlayers;
  final List<Player> substitutes;
  final List<InjuredPlayer> injuries;

  TeamLineup({
    required this.teamName,
    required this.startingPlayers,
    required this.substitutes,
    required this.injuries,
  });
}

class LineupData {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String tournament;
  final String stage;
  final TeamLineup homeLineup;
  final TeamLineup awayLineup;

  LineupData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.tournament,
    required this.stage,
    required this.homeLineup,
    required this.awayLineup,
  });

  factory LineupData.sample() {
    return LineupData(
      homeTeam: 'England',
      awayTeam: 'Germany',
      homeScore: 2,
      awayScore: 1,
      tournament: 'world cup 2020',
      stage: 'Group Stage • Group B',
      homeLineup: TeamLineup(
        teamName: 'England',
        startingPlayers: [
          Player(number: 1, name: 'Jordan Pickford', position: 'GK'),
          Player(number: 2, name: 'Kyle Walker', position: 'DEF'),
          Player(number: 5, name: 'John Stones', position: 'DEF'),
          Player(number: 6, name: 'Harry Maguire', position: 'DEF'),
          Player(number: 3, name: 'Luke Shaw', position: 'DEF'),
          Player(number: 4, name: 'Declan Rice', position: 'MID'),
          Player(number: 8, name: 'James Maddison', position: 'MID'),
          Player(number: 10, name: 'Harry Kane', position: 'FWD'),
          Player(number: 7, name: 'Bukayo Saka', position: 'FWD'),
          Player(number: 11, name: 'Raheem Sterling', position: 'FWD'),
        ],
        substitutes: [
          Player(number: 12, name: 'Aaron Ramsdale', position: 'GK'),
          Player(number: 13, name: 'Luke Shaw', position: 'DEF'),
          Player(number: 14, name: 'Kyle Walker', position: 'DEF'),
          Player(number: 15, name: 'Conor Coady', position: 'DEF'),
          Player(number: 16, name: 'Jonathan Tah', position: 'DEF'),
          Player(number: 17, name: 'Max Verstappen', position: 'MID'),
          Player(number: 18, name: 'Phil Foden', position: 'FWD'),
          Player(number: 19, name: 'Jadon Sancho', position: 'FWD'),
          Player(number: 20, name: 'Marcus Rashford', position: 'FWD'),
          Player(number: 21, name: 'Neco Williams', position: 'DEF'),
          Player(number: 22, name: 'Mason Mount', position: 'MID'),
          Player(number: 23, name: 'Reece James', position: 'DEF'),
        ],
        injuries: [
          InjuredPlayer(name: 'Marcus Rashford', status: 'Out Inj.'),
          InjuredPlayer(name: 'Jack Grealish', status: 'Suspended'),
          InjuredPlayer(name: 'Phil Foden', status: 'Out Inj.'),
        ],
      ),
      awayLineup: TeamLineup(
        teamName: 'Germany',
        startingPlayers: [
          Player(number: 1, name: 'Manuel Neuer', position: 'GK'),
          Player(number: 4, name: 'Antonio Rudiger', position: 'DEF'),
          Player(number: 2, name: 'Benjamin Pavard', position: 'DEF'),
          Player(number: 23, name: 'Niklas Süle', position: 'DEF'),
          Player(number: 3, name: 'David Raum', position: 'DEF'),
          Player(number: 6, name: 'Joshua Kimmich', position: 'MID'),
          Player(number: 8, name: 'Leon Goretzka', position: 'MID'),
          Player(number: 10, name: 'Serge Gnabry', position: 'FWD'),
          Player(number: 7, name: 'Kai Havertz', position: 'FWD'),
          Player(number: 9, name: 'Jamal Musiala', position: 'FWD'),
        ],
        substitutes: [
          Player(number: 12, name: 'Marc-André ter Stegen', position: 'GK'),
          Player(number: 15, name: 'Jonathan Tah', position: 'DEF'),
          Player(number: 16, name: 'Malick Tillman', position: 'DEF'),
          Player(number: 17, name: 'Felix Wiedwald', position: 'GK'),
          Player(number: 18, name: 'Pascal Groß', position: 'MID'),
          Player(number: 19, name: 'Niclas Füllkrug', position: 'FWD'),
          Player(number: 20, name: 'Maximilian Arnold', position: 'MID'),
          Player(number: 21, name: 'Can Uzun', position: 'FWD'),
          Player(number: 22, name: 'Jeremie Freuler', position: 'MID'),
          Player(number: 24, name: 'Thomas Müller', position: 'FWD'),
        ],
        injuries: [
          InjuredPlayer(name: 'Niko Schlotterbeck', status: 'Out Inj.'),
          InjuredPlayer(name: 'Jonathan Tah', status: 'Suspended'),
        ],
      ),
    );
  }
}
