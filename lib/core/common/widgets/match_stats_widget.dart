import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../../features/live/live_dashboard/model/match_stats_model.dart';

class MatchStatsWidget extends StatelessWidget {
  final MatchStatsData statsData;

  const MatchStatsWidget({
    Key? key,
    required this.statsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header with tournament and score
        _buildHeader(),
        const SizedBox(height: 24),
        // Stats list
        ..._buildStatsList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Tournament name
        Text(
          statsData.tournament,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Match score
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTeamHeader(
              statsData.homeTeam,
              statsData.homeScore,
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
                  '${statsData.homeScore}  -  ${statsData.awayScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            _buildTeamHeader(
              statsData.awayTeam,
              statsData.awayScore,
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Stage info
        Text(
          statsData.stage,
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

  List<Widget> _buildStatsList() {
    return statsData.stats.map((stat) {
      final homePercent = _calculatePercentage(stat.homeValue, stat.awayValue);
      final awayPercent = _calculatePercentage(stat.awayValue, stat.homeValue);

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stat values with bars
            Row(
              children: [
                // Home value
                SizedBox(
                  width: 40,
                  child: Text(
                    stat.homeValue.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Home bar
                Expanded(
                  flex: 45,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    child: LinearProgressIndicator(
                      value: homePercent / 100,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                ),
                // Label
                Expanded(
                  flex: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      stat.label,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Away bar
                Expanded(
                  flex: 45,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                    child: LinearProgressIndicator(
                      value: awayPercent / 100,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Away value
                SizedBox(
                  width: 40,
                  child: Text(
                    stat.awayValue.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  double _calculatePercentage(int value, int otherValue) {
    final total = value + otherValue;
    if (total == 0) return 50.0;
    return (value / total) * 100;
  }
}
