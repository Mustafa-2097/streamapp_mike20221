import 'package:flutter/material.dart';
import '../../../features/customer_dashboard/live/live_dashboard/model/table_model.dart';

class TableWidget extends StatelessWidget {
  final TableData tableData;
  const TableWidget({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Match header
        _buildHeader(),
        const SizedBox(height: 24),
        
        // Table sections
        ..._buildTableSections(),
      ],
    );
  }

  Widget _buildHeader() {

    /// If no match info → hide header
    if (tableData.homeTeam == null || tableData.awayTeam == null) {
      return Column(
        children: [
          Text(
            tableData.tournament,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tableData.stage,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    /// OLD HEADER (when live match exists)
    return Column(
      children: [
        Text(tableData.tournament),
        Text(
          '${tableData.homeScore} - ${tableData.awayScore}',
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

  List<Widget> _buildTableSections() {
    return tableData.groups.map((group) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupTitle(group.groupName),
          const SizedBox(height: 12),
          _buildStandingsTable(group),
          const SizedBox(height: 24),
          _buildSeeAllButton(),
          const SizedBox(height: 32),
        ],
      );
    }).toList();
  }

  Widget _buildGroupTitle(String groupName) {
    return Text(
      groupName,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildStandingsTable(GroupStanding group) {
    return Column(
      children: [
        // Header row
        _buildTableHeaderRow(),
        const SizedBox(height: 4),
        // Divider
        Container(
          height: 1,
          color: Colors.white12,
        ),
        const SizedBox(height: 4),
        // Team rows
        ...group.teams.map((team) => _buildTeamRow(team)).toList(),
      ],
    );
  }

  Widget _buildTableHeaderRow() {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '#',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Team',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(
            'P',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 35,
          child: Text(
            'GD',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 35,
          child: Text(
            'PTS',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamRow(TeamStanding team) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              team.position.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      team.badge,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.sports_soccer, size: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    team.teamName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              team.played.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              team.goalDifference > 0
                  ? '+${team.goalDifference}'
                  : team.goalDifference.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: team.goalDifference >= 0
                    ? Colors.green[300]
                    : Colors.red[300],
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              team.points.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: const Text(
          'See All',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
