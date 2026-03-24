import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/upcoming_match_model.dart';
import '../../../profile/controller/bookmarks_controller.dart';

class LiveUpcomingCard extends StatelessWidget {
  final UpcomingMatchModel match;
  final bool isReminded;
  final VoidCallback? onRemindTap;

  const LiveUpcomingCard({
    super.key,
    required this.match,
    required this.isReminded,
    this.onRemindTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildActualCountdown(),
              const Spacer(),
              Obx(() {
                final isBookmarked = Get.find<BookmarkController>()
                    .isMatchBookmarked(match.id);
                return Row(
                  children: [
                    if (isBookmarked)
                      const Icon(
                        Icons.bookmark,
                        color: Colors.amber,
                        size: 20,
                      ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _team(match.homeTeam, match.homeLogo),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      match.dayHeader,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      match.league,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _remindButton(
                      isReminded: isReminded,
                      onTap: onRemindTap ?? () {},
                    ),
                  ],
                ),
              ),
              _team(match.awayTeam, match.awayLogo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActualCountdown() {
    String? timeStr = match.timeRemaining;

    // Optional: If timestamp exists and timeRemaining is null, calculate it!
    if (timeStr == null || timeStr.isEmpty) {
      final ts = int.tryParse(match.timestamp);
      if (ts != null) {
        final matchDate = DateTime.fromMillisecondsSinceEpoch(ts);
        final diff = matchDate.difference(DateTime.now());
        if (diff.isNegative) {
          timeStr = null;
        } else {
          final h = diff.inHours;
          final m = diff.inMinutes % 60;
          final s = diff.inSeconds % 60;
          timeStr = "${h}H ${m}M ${s}S";
        }
      }
    }

    if (timeStr != null && timeStr.isNotEmpty) {
      final parts = timeStr.split(' ');
      return Row(children: parts.map((part) => _timeChip(part)).toList());
    }

    return _timeChip("SOON");
  }

  Widget _timeChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _team(String name, String logo) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: logo.startsWith('http')
                  ? Image.network(
                      logo
                          .replaceAll('localhost', '10.0.30.59')
                          .replaceAll('127.0.0.1', '10.0.30.59'),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.sports_soccer, color: Colors.grey),
                    )
                  : Image.asset(
                      logo,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.sports_soccer, color: Colors.grey),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _remindButton({
    required bool isReminded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isReminded ? Colors.amber : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 16, color: Colors.black),
            const SizedBox(width: 4),
            const Text(
              "Remind",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
