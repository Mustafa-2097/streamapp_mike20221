import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../live/live_video/controller/video_controller.dart';

class openTvOne extends StatelessWidget {
  openTvOne({super.key});

  final VideoLiveController controller = Get.put(VideoLiveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ TOP VIDEO SECTION
            _videoPreviewSection(),

            // ✅ DETAILS + COMMENTS
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF0E0E0E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleAndDropdown(),
                      const SizedBox(height: 6),
                      _viewsRow(),
                      const SizedBox(height: 12),
                      _actionRow(),
                      const SizedBox(height: 12),
                      _hashtagsRow(),
                      const SizedBox(height: 16),
                      const Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _commentsList(),
                      const SizedBox(height: 90), // spacing for input bar
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ COMMENT INPUT
      bottomNavigationBar: _commentInputBar(),
    );
  }

  // ------------------------------ VIDEO PREVIEW ------------------------------
  Widget _videoPreviewSection() {
    return Stack(
      children: [
        // Preview Image Placeholder
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/WFZ1wpL/soccer.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Top Overlay (Live + viewers)
        Positioned(
          top: 12,
          left: 12,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "Live",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.remove_red_eye, size: 14, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  "205K",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // Bottom progress bar + time
        Positioned(
          bottom: 6,
          left: 12,
          right: 12,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "02:55 / 04:26",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  Icon(Icons.fullscreen, color: Colors.white, size: 18),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.55,
                  minHeight: 4,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------ TITLE + DROPDOWN ------------------------------
  Widget _titleAndDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Text(
            "Brazil VS Spain || World Cup Live Match",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _viewsRow() {
    return const Text(
      "125K views • 1 day ago",
      style: TextStyle(color: Colors.white54, fontSize: 12),
    );
  }

  // ------------------------------ ACTION ROW ------------------------------
  Widget _actionRow() {
    return Row(
      children: [
        Obx(
              () => _actionItem(
            icon: controller.isLiked.value
                ? Icons.thumb_up
                : Icons.thumb_up_alt_outlined,
            label: _formatCount(controller.likesCount.value),
            onTap: controller.toggleLike,
          ),
        ),
        const SizedBox(width: 16),
        Obx(
              () => _actionItem(
            icon: Icons.thumb_down_alt_outlined,
            label: _formatCount(controller.dislikesCount.value),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        _actionItem(icon: Icons.share_outlined, label: "2.2K", onTap: () {}),
        const SizedBox(width: 16),
        _actionItem(icon: Icons.flag_outlined, label: "Report", onTap: () {}),
      ],
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------ HASHTAGS ------------------------------
  Widget _hashtagsRow() {
    return Wrap(
      spacing: 8,
      children: const [
        Text(
          "#football",
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
        Text(
          "#worldcup2022",
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
        Text(
          "#portugal",
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
        Text(
          "#switzerland",
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
      ],
    );
  }

  // ------------------------------ COMMENTS LIST ------------------------------
  Widget _commentsList() {
    final comments = [
      {"name": "alien.aa", "text": "shut down them please!!!"},
      {"name": "trunghieu1794", "text": "nice play bro!!! keep playing"},
      {"name": "alien.aa", "text": "shut down them please!!!"},
      {"name": "trunghieu1794", "text": "nice play bro!!! keep playing"},
      {"name": "alien.aa", "text": "shut down them please!!!"},
    ];

    return Column(
      children: comments.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade800,
                child: Text(
                  c["name"]![0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${c["name"]} ",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: c["text"],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ------------------------------ COMMENT INPUT ------------------------------
  Widget _commentInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: const Color(0xFF0E0E0E),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.send, color: Colors.white54),
        ],
      ),
    );
  }

  // ------------------------------ UTILS ------------------------------
  String _formatCount(int count) {
    if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
    if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}K";
    return "$count";
  }
}
