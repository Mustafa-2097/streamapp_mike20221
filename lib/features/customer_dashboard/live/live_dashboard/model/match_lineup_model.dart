class MatchLineupModel {
  final List<SubstitutionEvent> substitutions;
  final TeamSubstitutes substitutes;
  final TeamInjuries injuries;

  MatchLineupModel({
    required this.substitutions,
    required this.substitutes,
    required this.injuries,
  });

  factory MatchLineupModel.fromJson(Map<String, dynamic> json) {
    return MatchLineupModel(
      substitutions: (json['substitutions'] as List<dynamic>?)
              ?.map((e) => SubstitutionEvent.fromJson(e))
              .toList() ??
          [],
      substitutes: json['substitutes'] != null
          ? TeamSubstitutes.fromJson(json['substitutes'])
          : TeamSubstitutes(home: [], away: []),
      injuries: json['injuries'] != null
          ? TeamInjuries.fromJson(json['injuries'])
          : TeamInjuries(home: [], away: []),
    );
  }
}

class SubstitutionEvent {
  final String? minute;
  final String? playerOff;
  final String? playerOn;
  final String? teamSide;

  SubstitutionEvent({this.minute, this.playerOff, this.playerOn, this.teamSide});

  factory SubstitutionEvent.fromJson(Map<String, dynamic> json) {
    return SubstitutionEvent(
      minute: json['minute']?.toString(),
      playerOff: json['playerOff']?.toString(),
      playerOn: json['playerOn']?.toString(),
      teamSide: json['teamSide']?.toString(),
    );
  }
}

class SubstitutePlayer {
  final String? no;
  final String? name;
  final String? teamSide;

  SubstitutePlayer({this.no, this.name, this.teamSide});

  factory SubstitutePlayer.fromJson(Map<String, dynamic> json) {
    return SubstitutePlayer(
      no: json['no']?.toString(),
      name: json['name']?.toString(),
      teamSide: json['teamSide']?.toString(),
    );
  }
}

class TeamSubstitutes {
  final List<SubstitutePlayer> home;
  final List<SubstitutePlayer> away;

  TeamSubstitutes({required this.home, required this.away});

  factory TeamSubstitutes.fromJson(Map<String, dynamic> json) {
    return TeamSubstitutes(
      home: (json['home'] as List<dynamic>?)
              ?.map((e) => SubstitutePlayer.fromJson(e))
              .toList() ??
          [],
      away: (json['away'] as List<dynamic>?)
              ?.map((e) => SubstitutePlayer.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class InjuryRecord {
  final String? name;
  final String? injury;
  final String? date;
  final String? teamSide;

  InjuryRecord({this.name, this.injury, this.date, this.teamSide});

  factory InjuryRecord.fromJson(Map<String, dynamic> json) {
    return InjuryRecord(
      name: json['name']?.toString(),
      injury: json['injury']?.toString(),
      date: json['date']?.toString(),
      teamSide: json['teamSide']?.toString(),
    );
  }
}

class TeamInjuries {
  final List<InjuryRecord> home;
  final List<InjuryRecord> away;

  TeamInjuries({required this.home, required this.away});

  factory TeamInjuries.fromJson(Map<String, dynamic> json) {
    return TeamInjuries(
      home: (json['home'] as List<dynamic>?)
              ?.map((e) => InjuryRecord.fromJson(e))
              .toList() ??
          [],
      away: (json['away'] as List<dynamic>?)
              ?.map((e) => InjuryRecord.fromJson(e))
              .toList() ??
          [],
    );
  }
}
