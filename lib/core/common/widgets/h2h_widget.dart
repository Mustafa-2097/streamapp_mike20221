import 'package:flutter/material.dart';
import '../../../features/live/live_dashboard/model/h2h_model.dart';

class H2HWidget extends StatelessWidget {
  final H2HData h2hData;

  const H2HWidget({
    Key? key,
    required this.h2hData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Match header
        _buildHeader(),
        const SizedBox(height: 24),
        
        // Overall stats
        _buildStatsSection('Overall', h2hData.homeOverallStats, h2hData.awayOverallStats),
        const SizedBox(height: 20),
        
        // Last 5 stats
        _buildStatsSection('Last 5', h2hData.homeLast5Stats, h2hData.awayLast5Stats),
        const SizedBox(height: 24),
        
        // Recent matches
        _buildRecentMatches(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          h2hData.tournament,
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
              h2hData.homeTeam,
              h2hData.homeScore,
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
                  '${h2hData.homeScore}  -  ${h2hData.awayScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            _buildTeamHeader(
              h2hData.awayTeam,
              h2hData.awayScore,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          h2hData.stage,
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

  Widget _buildStatsSection(String title, H2HStats homeStats, H2HStats awayStats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Wins',
                value: homeStats.wins,
                alignment: Alignment.centerLeft,
              ),
            ),
            Expanded(
              child: _buildStatCard(
                label: 'Draws',
                value: homeStats.draws,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              child: _buildStatCard(
                label: 'Wins',
                value: awayStats.wins,
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required int value,
    required Alignment alignment,
  }) {
    return Align(
      alignment: alignment,
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.history,
                color: Colors.white70,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              h2hData.tournament,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...h2hData.recentMatches.map((match) => _buildMatchItem(match)).toList(),
      ],
    );
  }

  Widget _buildMatchItem(H2HMatch match) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            match.date,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Home team
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white24,
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        match.homeTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${match.homeScore} - ${match.awayScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Away team
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        match.awayTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white24,
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
