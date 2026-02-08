import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchDetailsScreen extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String matchTitle;

  const MatchDetailsScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchTitle,
  });

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  int selectedTab = 0;
  final List<String> tabs = ['Info', 'Summary', 'Highlights', 'Stats'];

  // Sample stats data
  final List<Map<String, dynamic>> stats = [
    {'label': 'Shots on target', 'home': 2, 'away': 2},
    {'label': 'Shots off target', 'home': 3, 'away': 9},
    {'label': 'Blocked shots', 'home': 3, 'away': 3},
    {'label': 'Possession (%)', 'home': 44, 'away': 56},
    {'label': 'Corner kicks', 'home': 4, 'away': 0},
    {'label': 'Offsides', 'home': 1, 'away': 1},
    {'label': 'Fouls', 'home': 20, 'away': 13},
    {'label': 'Throw-ins', 'home': 15, 'away': 13},
    {'label': 'Yellow cards', 'home': 5, 'away': 2},
    {'label': 'Red cards', 'home': 1, 'away': 0},
    {'label': 'Crosses', 'home': 15, 'away': 22},
    {'label': 'Counter attacks', 'home': 1, 'away': 1},
    {'label': 'Goalkeeper saves', 'home': 2, 'away': 1},
    {'label': 'Good kicks', 'home': 14, 'away': 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Matches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Match Title
                Text(
                  widget.matchTitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                // Match Card
                _buildMatchCard(),
                const SizedBox(height: 20),
                // Tabs
                _buildTabs(),
                const SizedBox(height: 16),
                // Tab Content
                if (selectedTab == 3) _buildStatsContent(),
                if (selectedTab != 3)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${tabs[selectedTab]} content coming soon',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // LIVE Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "LIVE",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          // Teams and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeam(widget.homeTeam),
              Column(
                children: [
                  Text(
                    "${widget.homeScore}  -  ${widget.awayScore}",
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Group Stage • Group B",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              _buildTeam(widget.awayTeam),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(String name) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(Icons.sports_soccer, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedTab == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.amber
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // First Half and Second Half buttons
          Row(
            children: [
              _buildHalfButton('Match', true),
              const SizedBox(width: 10),
              _buildHalfButton('1st Half', false),
              const SizedBox(width: 10),
              _buildHalfButton('2nd Half', false),
            ],
          ),
          const SizedBox(height: 16),
          // Stats List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return _buildStatRow(stats[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHalfButton(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white24,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(Map<String, dynamic> stat) {
    final home = stat['home'] as int;
    final away = stat['away'] as int;
    final label = stat['label'] as String;

    // Calculate bar widths for possession-like stats
    final maxValue = (home + away).toDouble();
    final homeWidth = maxValue > 0 ? (home / maxValue) * 100 : 50;
    final awayWidth = maxValue > 0 ? (away / maxValue) * 100 : 50;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                home.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Text(
                away.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: homeWidth.toInt(),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                flex: awayWidth.toInt(),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
