import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/customer_api_service.dart';
import '../model/match_info_model.dart';
import '../model/match_summary_model.dart';
import '../model/match_header_model.dart';
import '../model/match_stats_model.dart';
import '../model/match_lineup_model.dart';
import '../model/match_table_model.dart';
import '../model/match_h2h_model.dart';

class MatchDetailsScreen extends StatefulWidget {
  final String matchId;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String matchTitle;

  const MatchDetailsScreen({
    super.key,
    required this.matchId,
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
  final List<String> tabs = [
    'Info',
    'Summary',
    /*'Highlight'*/ 'Stats',
    'Line-Ups',
    'Table',
    'H2H',
  ];

  MatchInfoModel? matchInfo;
  bool isLoadingInfo = true;
  String infoError = '';

  MatchSummaryModel? matchSummary;
  bool isLoadingSummary = true;
  String summaryError = '';

  MatchHeaderModel? matchHeader;
  bool isLoadingHeader = true;
  String headerError = '';

  @override
  void initState() {
    super.initState();
    _fetchMatchHeader();
    _fetchMatchInfo();
    _fetchMatchStats();
    _fetchMatchLineup();
    _fetchMatchTable();
    _fetchMatchH2H();
    _fetchMatchSummary();
  }

  Future<void> _fetchMatchHeader() async {
    try {
      final response = await CustomerApiService.getMatchHeader(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchHeader = MatchHeaderModel.fromJson(response['data']);
          isLoadingHeader = false;
        });
      } else {
        setState(() {
          headerError = response['message'] ?? 'Failed to load match header';
          isLoadingHeader = false;
        });
      }
    } catch (e) {
      setState(() {
        headerError = 'Failed to load match header';
        isLoadingHeader = false;
      });
    }
  }

  Future<void> _fetchMatchSummary() async {
    try {
      final response = await CustomerApiService.getMatchSummary(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchSummary = MatchSummaryModel.fromJson(response['data']);
          isLoadingSummary = false;
        });
      } else {
        setState(() {
          summaryError = response['message'] ?? 'Failed to load match summary';
          isLoadingSummary = false;
        });
      }
    } catch (e) {
      setState(() {
        summaryError = 'Failed to load match summary';
        isLoadingSummary = false;
      });
    }
  }

  Future<void> _fetchMatchH2H() async {
    try {
      final response = await CustomerApiService.getMatchH2H(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchH2HData = MatchH2HModel.fromJson(response['data']);
          isLoadingH2H = false;
        });
      } else {
        setState(() {
          h2hError = response['message'] ?? 'Failed to load H2H';
          isLoadingH2H = false;
        });
      }
    } catch (e) {
      setState(() {
        h2hError = 'Failed to load H2H';
        isLoadingH2H = false;
      });
    }
  }

  Future<void> _fetchMatchTable() async {
    try {
      final response = await CustomerApiService.getMatchTable(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchTableData = MatchTableModel.fromJson(response['data']);
          isLoadingTable = false;
        });
      } else {
        setState(() {
          tableError = response['message'] ?? 'Failed to load table';
          isLoadingTable = false;
        });
      }
    } catch (e) {
      setState(() {
        tableError = 'Failed to load table';
        isLoadingTable = false;
      });
    }
  }

  Future<void> _fetchMatchLineup() async {
    try {
      final response = await CustomerApiService.getMatchLineup(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchLineup = MatchLineupModel.fromJson(response['data']);
          isLoadingLineup = false;
        });
      } else {
        setState(() {
          lineupError = response['message'] ?? 'Failed to load lineup';
          isLoadingLineup = false;
        });
      }
    } catch (e) {
      setState(() {
        lineupError = 'Failed to load lineup';
        isLoadingLineup = false;
      });
    }
  }

  Future<void> _fetchMatchStats() async {
    try {
      final response = await CustomerApiService.getMatchStats(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchStatsData = MatchStatsModel.fromJson(response['data']);
          isLoadingStats = false;
        });
      } else {
        setState(() {
          statsError = response['message'] ?? 'Failed to load match stats';
          isLoadingStats = false;
        });
      }
    } catch (e) {
      setState(() {
        statsError = 'Failed to load match stats';
        isLoadingStats = false;
      });
    }
  }

  Future<void> _fetchMatchInfo() async {
    try {
      final response = await CustomerApiService.getMatchInfo(matchId: widget.matchId);
      if (response['success'] == true) {
        setState(() {
          matchInfo = MatchInfoModel.fromJson(response['data']);
          isLoadingInfo = false;
        });
      } else {
        setState(() {
          infoError = response['message'] ?? 'Failed to load match info';
          isLoadingInfo = false;
        });
      }
    } catch (e) {
      setState(() {
        infoError = 'Failed to load match info';
        isLoadingInfo = false;
      });
    }
  }

  MatchStatsModel? matchStatsData;
  bool isLoadingStats = true;
  String statsError = '';

  MatchLineupModel? matchLineup;
  bool isLoadingLineup = true;
  String lineupError = '';

  MatchTableModel? matchTableData;
  bool isLoadingTable = true;
  String tableError = '';

  MatchH2HModel? matchH2HData;
  bool isLoadingH2H = true;
  String h2hError = '';

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
                  matchHeader?.league ?? widget.matchTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                // Match Card
                _buildMatchCard(),
                const SizedBox(height: 20),
                // Tabs
                _buildTabs(),
                const SizedBox(height: 16),
                // Tab Content
                if (tabs[selectedTab] == 'Info') _buildInfoContent(),
                if (tabs[selectedTab] == 'Summary') _buildSummaryContent(),
                if (tabs[selectedTab] == 'Highlight') _buildHighlightContent(),
                if (tabs[selectedTab] == 'Stats') _buildStatsContent(),
                if (tabs[selectedTab] == 'Line-Ups') _buildLineUpsContent(),
                if (tabs[selectedTab] == 'Table') _buildTableContent(),
                if (tabs[selectedTab] == 'H2H') _buildH2HContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard() {
    String badgeText = matchHeader?.statusLabel?.toUpperCase() ?? (selectedTab == 1 ? "FULL" : "LIVE 67'");
    String matchMin = matchHeader?.matchMinute ?? "";
    if (matchMin.isNotEmpty && badgeText == "LIVE") badgeText = "LIVE $matchMin'";
    bool isGreyBadge = badgeText == "UPCOMING" || badgeText == "FULL" || badgeText == "FINISHED";
    Color badgeColor = isGreyBadge ? Colors.grey[800]! : const Color(0xFFE54D4D);
    
    String hScore = matchHeader?.homeScore != null && matchHeader!.homeScore != "-" ? matchHeader!.homeScore! : (selectedTab == 1 ? "0" : widget.homeScore.toString());
    String aScore = matchHeader?.awayScore != null && matchHeader!.awayScore != "-" ? matchHeader!.awayScore! : (selectedTab == 1 ? "1" : widget.awayScore.toString());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Colors.white24),
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.red.withOpacity(0.15),
          ],
        ),
      ),
      child: Column(
        children: [
          // LIVE/FULL Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isGreyBadge)
                  const Icon(Icons.circle, color: Colors.white, size: 8),
                if (!isGreyBadge) const SizedBox(width: 8),
                Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Teams and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeam(matchHeader?.homeTeam ?? widget.homeTeam, matchHeader?.logo?.home, 'assets/images/england.png'),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hScore,
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "-",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        Text(
                          aScore,
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      matchHeader?.progress ?? (selectedTab == 1 ? "FULL" : "83min"),
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTeam(matchHeader?.awayTeam ?? widget.awayTeam, matchHeader?.logo?.away, 'assets/images/germany.png'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            matchHeader?.matchStage ?? "Group Stage • Group B",
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(String name, String? networkFlag, String fallbackAsset) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: networkFlag != null && networkFlag.isNotEmpty
                ? Image.network(
                    networkFlag,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(fallbackAsset, fit: BoxFit.contain),
                  )
                : Image.asset(
                    fallbackAsset,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContent() {
    if (isLoadingSummary) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    if (summaryError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(summaryError, style: const TextStyle(color: Colors.white70))),
      );
    }
    if (matchSummary == null) {
      return const SizedBox();
    }

    final stats = matchSummary!.stats;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Timeline Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: matchSummary!.timeline.map((event) {
                return Column(
                  children: [
                    _buildTimelineItem(
                      event.minute ?? "",
                      event.player ?? "",
                      event.score ?? "",
                      isHome: event.teamSide == "home",
                      type: _getEventType(event),
                    ),
                    if (event != matchSummary!.timeline.last)
                      _buildTimelineDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Mini Stats Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stats?.possession != null ? stats!.possession!.split('-')[0] : "50",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Possession (%)",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      stats?.possession != null ? (stats!.possession!.contains('-') ? stats.possession!.split('-')[1] : "50") : "50",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Custom Possession Bar
                Row(
                  children: [
                    Expanded(
                      flex: int.tryParse(stats?.possession?.split('-').first ?? "50") ?? 50,
                      child: _buildBarSegment(
                        const Color(0xFFE54D4D),
                        isStart: true,
                      ),
                    ),
                    Expanded(
                      flex: int.tryParse(stats?.possession?.split('-').last ?? "50") ?? 50,
                      child: _buildBarSegment(
                        Colors.white.withOpacity(0.2),
                        isEnd: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatChip(
                      stats?.shotsOnGoal?.home ?? "0",
                      Icons.sports_soccer,
                      stats?.shotsOnGoal?.away ?? "0",
                    ),
                    _buildStatChip(
                      stats?.yellowCards?.home ?? "0",
                      Icons.rectangle,
                      stats?.yellowCards?.away ?? "0",
                      iconColor: Colors.amber,
                    ),
                    _buildStatChip(
                      stats?.redCards?.home ?? "0",
                      Icons.rectangle,
                      stats?.redCards?.away ?? "0",
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _getEventType(TimelineEvent event) {
    if (event.type == "Goal") return "goal";
    if (event.type == "Card" && event.player != null && event.player!.contains("Red")) return "red";
    if (event.type == "Card") return "yellow";
    if (event.type == "subst") return "subst";
    return "";
  }

  Widget _buildTimelineItem(
    String time,
    String player,
    String score, {
    bool isHome = true,
    bool isCenter = false,
    String? type,
  }) {
    return Row(
      children: [
        // 1. Minute Column
        SizedBox(
          width: 35,
          child: Text(
            time,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 2. Home Player Column
        Expanded(
          child: isHome && !isCenter
              ? Text(
                  player,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
        ),

        // 3. Center Event Column (Scores / Icons)
        Container(
          width: 80, // Fixed width for center info
          alignment: Alignment.center,
          child: isCenter
              ? Text(
                  score,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                )
              : (type == "goal"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            score,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildEventIcon(type!),
                        ],
                      )
                    : (type != null
                          ? _buildEventIcon(type!)
                          : Text(
                              score,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ))),
        ),

        // 4. Away Player Column
        Expanded(
          child: !isHome && !isCenter
              ? Text(
                  player,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildEventIcon(String type) {
    if (type == "goal")
      return const Icon(Icons.sports_soccer, color: Colors.white, size: 14);
    if (type == "subst")
      return const Icon(Icons.sync, color: Colors.green, size: 14);
    if (type == "yellow")
      return Container(
        height: 14,
        width: 10,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    if (type == "red")
      return Container(
        height: 14,
        width: 10,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    return const SizedBox();
  }

  Widget _buildTimelineDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
    );
  }

  Widget _buildBarSegment(
    Color color, {
    bool isStart = false,
    bool isEnd = false,
  }) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: isStart ? const Radius.circular(3) : Radius.zero,
          right: isEnd ? const Radius.circular(3) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildStatChip(
    String left,
    IconData icon,
    String right, {
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            left,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(icon, color: iconColor ?? Colors.white54, size: 14),
          ),
          Text(
            right,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContent() {
    if (isLoadingInfo) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    if (infoError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(infoError, style: const TextStyle(color: Colors.white70))),
      );
    }
    if (matchInfo == null) {
      return const SizedBox();
    }

    final venue = matchInfo!.venue;
    
    // Fallback headers
    final dateValue = "TBA"; // The API response provided didn't explicitly include a match date at top level, maybe fallback or add logic
    final stadiumValue = venue?.stadium ?? "Unknown Stadium";
    final cityValue = venue?.city ?? "Unknown City";
    final capacityValue = venue?.capacity != null ? "~${venue!.capacity}" : "Unknown Capacity";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Grid
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildInfoItem(
                      Icons.calendar_month_outlined,
                      dateValue,
                    ),
                    const Spacer(),
                    _buildInfoItem(
                      Icons.stadium_outlined,
                      stadiumValue,
                      isRed: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildInfoItem(
                      Icons.location_on_outlined,
                      cityValue,
                      isRed: true,
                    ),
                    const Spacer(),
                    _buildInfoItem(Icons.people_outline, capacityValue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Performance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (matchInfo!.performance != null)
            _buildPerformanceCard(matchInfo!.performance!),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, {bool isRed = false}) {
    return SizedBox(
      width: Get.width * 0.4,
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isRed ? const Color(0xFFE54D4D) : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(Performance perf) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          if (perf.home != null)
            _buildTeamPerformance(perf.home!),
          if (perf.home != null && perf.away != null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white12, height: 1),
            ),
          if (perf.away != null)
            _buildTeamPerformance(perf.away!),
        ],
      ),
    );
  }

  Widget _buildTeamPerformance(TeamPerformance team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                team.name ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(children: team.form.map((e) => _buildFormIndicator(e)).toList()),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: team.recentMatches.map((m) => _buildMiniMatchCard(m, team.logo)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFormIndicator(String type) {
    final isWin = type == "W";
    final isDraw = type == "D";
    final color = isWin
        ? const Color(0xFF4CAF50)
        : isDraw
            ? Colors.orange
            : const Color(0xFFE54D4D);
            
    return Container(
      margin: const EdgeInsets.only(left: 4),
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          type,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniMatchCard(RecentMatchInfoModel match, String? teamLogo) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Image.network(
            match.isHome ? (teamLogo ?? '') : (match.opponentLogo ?? ''),
            width: 16,
            height: 12,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.flag, size: 12, color: Colors.white70),
          ),
          const SizedBox(width: 8),
          Text(
            "${match.homeScore ?? '0'} - ${match.awayScore ?? '0'}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Image.network(
            match.isHome ? (match.opponentLogo ?? '') : (teamLogo ?? ''),
            width: 16,
            height: 12,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.flag, size: 12, color: Colors.white70),
          ),
        ],
      ),
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

  Widget _buildTableContent() {
    if (isLoadingTable) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    if (tableError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(tableError, style: const TextStyle(color: Colors.white70))),
      );
    }
    final standings = matchTableData?.standings ?? [];
    if (standings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('No standings available', style: TextStyle(color: Colors.white70))),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                // Table Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                        child: Text(
                          "#",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          matchTableData?.season ?? "Season",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildTableHeaderCell("P"),
                      _buildTableHeaderCell("GD"),
                      _buildTableHeaderCell("PTS"),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 8),
                // Table Rows
                ...standings.map((entry) => _buildApiTableRow(entry)).toList(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Legend
          _buildTableLegend(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _qualificationColor(String type) {
    switch (type) {
      case 'cl': return const Color(0xFF3B82F6);    // Blue – Champions League
      case 'el': return const Color(0xFFF97316);    // Orange – Europa League
      case 'conf': return const Color(0xFF22C55E);  // Green – Conference
      case 'rel': return const Color(0xFFE54D4D);   // Red – Relegation
      default: return Colors.transparent;
    }
  }

  Widget _buildApiTableRow(StandingEntry entry) {
    final qualType = entry.qualificationType;
    final accentColor = _qualificationColor(qualType);
    final isHighlighted =
        entry.team == matchHeader?.homeTeam || entry.team == matchHeader?.awayTeam;

    return Column(
      children: [
        Container(
          decoration: isHighlighted
              ? BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                // Position with color accent bar
                SizedBox(
                  width: 30,
                  child: Row(
                    children: [
                      if (qualType.isNotEmpty)
                        Container(
                          width: 3,
                          height: 18,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      Text(
                        "${entry.position ?? ''}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Team Name
                Expanded(
                  child: Text(
                    entry.team ?? '',
                    style: TextStyle(
                      color: isHighlighted ? Colors.white : Colors.white70,
                      fontSize: 13,
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Played
                _buildTableCell("${entry.played ?? ''}"),
                // GD
                _buildTableCell(
                  entry.goalDifference != null
                      ? (entry.goalDifference! > 0 ? '+${entry.goalDifference}' : '${entry.goalDifference}')
                      : '-',
                ),
                // Points
                _buildTableCell("${entry.points ?? ''}"),
              ],
            ),
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.05), height: 1),
      ],
    );
  }

  Widget _buildTableLegend() {
    final items = [
      {'color': const Color(0xFF3B82F6), 'label': 'Champions League'},
      {'color': const Color(0xFFF97316), 'label': 'Europa League'},
      {'color': const Color(0xFF22C55E), 'label': 'Conference League'},
      {'color': const Color(0xFFE54D4D), 'label': 'Relegation'},
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item['label'] as String,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Container(
      width: 40,
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      width: 40,
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLineUpsContent() {
    if (isLoadingLineup) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    if (lineupError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(lineupError, style: const TextStyle(color: Colors.white70))),
      );
    }

    final lineup = matchLineup;
    final subs = lineup?.substitutions ?? [];
    final homeSubs = subs.where((s) => s.teamSide == 'home').toList();
    final awaySubs = subs.where((s) => s.teamSide == 'away').toList();
    final maxRows = homeSubs.length > awaySubs.length ? homeSubs.length : awaySubs.length;

    final homeSubPlayers = lineup?.substitutes.home ?? [];
    final awaySubPlayers = lineup?.substitutes.away ?? [];
    final allSubPlayers = [...homeSubPlayers, ...awaySubPlayers];

    final homeInjuries = lineup?.injuries.home ?? [];
    final awayInjuries = lineup?.injuries.away ?? [];
    final allInjuries = [...homeInjuries, ...awayInjuries];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Substitutions Section
          _buildLineUpsSection("SUBSTITUTIONS", [
            if (maxRows == 0)
              const Text('No substitutions', style: TextStyle(color: Colors.white54, fontSize: 13))
            else
              for (int i = 0; i < maxRows; i++)
                _buildApiSubstitutionRow(
                  i < homeSubs.length ? homeSubs[i] : null,
                  i < awaySubs.length ? awaySubs[i] : null,
                ),
          ]),
          const SizedBox(height: 16),
          // Substitute Players Section
          _buildLineUpsSection("SUBSTITUTE PLAYERS", [
            if (allSubPlayers.isEmpty)
              const Text('No substitute players listed', style: TextStyle(color: Colors.white54, fontSize: 13))
            else
              _buildApiSubstitutePlayersGrid(allSubPlayers),
          ]),
          const SizedBox(height: 16),
          // Injuries Section
          _buildLineUpsSection("INJURIES & SUSPENSION", [
            if (allInjuries.isEmpty)
              const Text('No injuries or suspensions', style: TextStyle(color: Colors.white54, fontSize: 13))
            else
              _buildApiInjuriesGrid(allInjuries),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildApiSubstitutionRow(SubstitutionEvent? home, SubstitutionEvent? away) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (home != null)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(home.minute ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.arrow_downward, color: Colors.red, size: 14),
                        const SizedBox(width: 4),
                        Text(home.playerOff ?? '', style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(home.playerOn ?? '', style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ]),
                    ],
                  ),
                ],
              ),
            )
          else
            const Expanded(child: SizedBox()),
          if (away != null)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(away.minute ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.arrow_downward, color: Colors.red, size: 14),
                          const SizedBox(width: 4),
                          Flexible(child: Text(away.playerOff ?? '', style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
                          const SizedBox(width: 4),
                          Flexible(child: Text(away.playerOn ?? '', style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApiSubstitutePlayersGrid(List<SubstitutePlayer> players) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 8,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              alignment: Alignment.center,
              child: Text(player.no ?? '-', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                player.name ?? 'Unknown',
                style: const TextStyle(color: Colors.white, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApiInjuriesGrid(List<InjuryRecord> injuries) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
      ),
      itemCount: injuries.length,
      itemBuilder: (context, index) {
        final injury = injuries[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.add_box, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(injury.name ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(injury.injury ?? '', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(injury.date ?? 'Unknown', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLineUpsSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildH2HContent() {
    if (isLoadingH2H) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    if (h2hError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(h2hError, style: const TextStyle(color: Colors.white70))),
      );
    }

    final h2h = matchH2HData;
    final overall = h2h?.overall;
    final lastFive = h2h?.lastFive;
    final history = h2h?.history ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Team logos header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildH2HTeamBadge(h2h?.homeLogo, h2h?.homeTeam ?? 'Home'),
              const Text('VS', style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold)),
              _buildH2HTeamBadge(h2h?.awayLogo, h2h?.awayTeam ?? 'Away'),
            ],
          ),
          const SizedBox(height: 24),
          // Stat Overview Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                if (overall != null)
                  _buildH2HSection("Overall", overall.homeWins, overall.draws, overall.awayWins),
                if (overall != null && lastFive != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white12, height: 1),
                  ),
                if (lastFive != null)
                  _buildH2HSection("Last 5", lastFive.homeWins, lastFive.draws, lastFive.awayWins),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // History
          if (history.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MATCH HISTORY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ...history.map((entry) => _buildH2HHistoryRow(entry)).toList(),
                ],
              ),
            ),
          if (history.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text('No head-to-head history available', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildH2HTeamBadge(String? logoUrl, String name) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
          ),
          child: logoUrl != null
              ? ClipOval(
                  child: Image.network(
                    logoUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white38, size: 28),
                  ),
                )
              : const Icon(Icons.shield, color: Colors.white38, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildH2HHistoryRow(H2HHistoryEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Column(
            children: [
              Text(
                entry.date ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                entry.status ?? 'FT',
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Teams and Scores
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.homeTeam ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      entry.homeScore ?? '-',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.awayTeam ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      entry.awayScore ?? '-',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildH2HSection(String title, int homeWins, int draws, int awayWins) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wins $homeWins",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Draws $draws",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Wins $awayWins",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Triple segment bar
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              if (homeWins > 0)
                Expanded(
                  flex: homeWins,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE54D4D),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              if (homeWins > 0 || draws > 0) const SizedBox(width: 4),
              if (draws > 0)
                Expanded(
                  flex: draws,
                  child: Container(color: Colors.white.withOpacity(0.15)),
                ),
              if (draws > 0 || awayWins > 0) const SizedBox(width: 4),
              if (awayWins > 0)
                Expanded(
                  flex: awayWins,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              if (homeWins == 0 && draws == 0 && awayWins == 0)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightContent() {
    final List<Map<String, String>> highlights = [
      {
        "title": "Full Match Highlights",
        "time": "10:24",
        "thumbnail": "assets/images/live01.png",
      },
      {
        "title": "Harry Kane Goal (27')",
        "time": "01:15",
        "thumbnail": "assets/images/live02.png",
      },
      {
        "title": "Florian Wirtz Solo Goal (63')",
        "time": "00:45",
        "thumbnail": "assets/images/live01.png",
      },
      {
        "title": "Best Saves & Skill Moments",
        "time": "03:12",
        "thumbnail": "assets/images/live02.png",
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: highlights.length,
        itemBuilder: (context, index) {
          final h = highlights[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(h['thumbnail']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          h['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white38,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              h['time']!,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsContent() {
    if (isLoadingStats) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    if (statsError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(statsError, style: const TextStyle(color: Colors.white70)),
        ),
      );
    }

    final statSet = matchStatsData?.match;
    final statsList = statSet?.toStatsList() ?? [];

    if (statsList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text('No stats available', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statsList.length,
              itemBuilder: (context, index) {
                return _buildStatRow(statsList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(Map<String, dynamic> stat) {
    final home = stat['home'] as int;
    final away = stat['away'] as int;
    final label = stat['label'] as String;

    final total = home + away;
    // Calculate ratio relative to each other (max 1.0 per half)
    final homeRatio = total > 0 ? (home / total) : 0.5;
    final awayRatio = total > 0 ? (away / total) : 0.5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                home.toRadixString(10),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                away.toRadixString(10),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Perfect Image-Matching Center-Growth Bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C35),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                // Left half (Home)
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C2C35),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(4),
                          ),
                        ),
                      ),
                      // White segment anchored to center-gap
                      FractionallySizedBox(
                        widthFactor: homeRatio.clamp(0.05, 1.0),
                        child: Container(
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Center-Gap
                const SizedBox(width: 6),
                // Right half (Away)
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C2C35),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(4),
                          ),
                        ),
                      ),
                      // Red segment anchored to center-gap
                      FractionallySizedBox(
                        widthFactor: awayRatio.clamp(0.05, 1.0),
                        child: Container(
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE54D4D),
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
