import 'package:flutter/material.dart';
import '../../../features/customer_dashboard/live/live_dashboard/model/recent_match_model.dart';

class RecentMatchesWidget extends StatelessWidget {
  final List<RecentMatchModel> recentMatches;

  const RecentMatchesWidget({
    Key? key,
    required this.recentMatches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recentMatches.length,
      itemBuilder: (context, index) {
        return _buildMatchCard(recentMatches[index]);
      },
    );
  }

  Widget _buildMatchCard(RecentMatchModel match) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Score 1
            SizedBox(
              width: 30,
              child: Text(
                match.homeScore,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            // Team 1
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: match.homeLogo.isNotEmpty
                        ? Image.network(match.homeLogo, width: 24, height: 24)
                        : const Icon(Icons.sports_soccer, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      match.homeTeam,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // VS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                match.progress.isNotEmpty ? match.progress : 'vs',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Team 2
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      match.awayTeam,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: match.awayLogo.isNotEmpty
                        ? Image.network(match.awayLogo, width: 24, height: 24)
                        : const Icon(Icons.sports_soccer, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Score 2
            SizedBox(
              width: 30,
              child: Text(
                match.awayScore,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
