import 'package:flutter/material.dart';
import '../../../features/customer_dashboard/live/live_dashboard/model/lineup_model.dart';

class LineupWidget extends StatelessWidget {
  final LineupData lineupData;

  const LineupWidget({
    Key? key,
    required this.lineupData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Match header
        _buildHeader(),
        const SizedBox(height: 24),
        
        // Tabs for home/away
        _buildTeamTabs(),
        const SizedBox(height: 16),
        
        // Home team lineup
        _buildTeamLineup(lineupData.homeLineup),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          lineupData.tournament,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTeamHeader(
              lineupData.homeTeam,
              lineupData.homeScore,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${lineupData.homeScore}  -  ${lineupData.awayScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            _buildTeamHeader(
              lineupData.awayTeam,
              lineupData.awayScore,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          lineupData.stage,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamHeader(String teamName, int score) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white24,
          child: const Icon(
            Icons.sports_soccer,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teamName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamTabs() {
    return Row(
      children: [
        _tabButton(lineupData.homeTeam),
        const SizedBox(width: 8),
        _tabButton(lineupData.awayTeam),
      ],
    );
  }

  Widget _tabButton(String teamName) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          teamName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLineup(TeamLineup lineup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Substitutions
        _buildSection('SUBSTITUTIONS', lineup.startingPlayers.take(4).toList()),
        const SizedBox(height: 24),
        
        // Substitute players
        _buildSubstitutesSection('SUBSTITUTE PLAYERS', lineup.substitutes),
        const SizedBox(height: 24),
        
        // Injuries & Suspension
        _buildInjuriesSection('INJURIES & SUSPENSION', lineup.injuries),
      ],
    );
  }

  Widget _buildSection(String title, List<Player> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ...players.map((player) => _buildPlayerItem(player)).toList(),
      ],
    );
  }

  Widget _buildSubstitutesSection(String title, List<Player> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: players.map((player) => _buildSubstitutePlayerItem(player)).toList(),
        ),
      ],
    );
  }

  Widget _buildInjuriesSection(String title, List<InjuredPlayer> injuries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: injuries.map((injury) => _buildInjuryItem(injury)).toList(),
        ),
      ],
    );
  }

  Widget _buildPlayerItem(Player player) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                player.number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  player.position,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstitutePlayerItem(Player player) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              player.number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 50,
          child: Text(
            player.name,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInjuryItem(InjuredPlayer injury) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Center(
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              injury.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            Text(
              injury.status,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
