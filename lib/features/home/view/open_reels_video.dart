import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import '../widgets/show_comments_bottom_sheet.dart';

class OpenReelsVideo extends StatelessWidget {
  const OpenReelsVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/4/42/Football_in_Bloomington%2C_Indiana%2C_1995.jpg',
            fit: BoxFit.cover,
          ),

          // 2. Dark Gradient Overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black54,
                  Colors.black87
                ],
                stops: [0.0, 0.6, 0.8, 1.0],
              ),
            ),
          ),

          // 3. Top Search Bar
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  "Search here",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                  ),
                ),
              ],
            ),
          ),

          // 4. Right Sidebar (Action Buttons)
          Positioned(
            right: 10,
            bottom: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flag (Toggleable)
                const SideButton(icon: Icons.flag, label: ""),
                const SizedBox(height: 20),

                // Bookmark (Toggleable - Turns Yellow)
                const SideButton(
                    icon: Icons.bookmark,
                    label: "",
                    activeColor: Color(0xFFFFD700), // Gold
                    size: 35
                ),
                const SizedBox(height: 20),

                // Like (Toggleable - Turns Red)
                const SideButton(icon: Icons.thumb_up, label: "27.8K"),
                const SizedBox(height: 20),

                // Dislike (Toggleable)
                const SideButton(icon: Icons.thumb_down, label: "3.6K"),
                const SizedBox(height: 20),

                // --- COMMENT BUTTON (Stateless / No Toggle) ---
                GestureDetector(
                  onTap: () {
                    showCommentBottomSheet(context);
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.chat_bubble_rounded, // Using rounded to match design
                        color: Colors.white,
                        size: 32,
                        shadows: [
                          Shadow(offset: Offset(0, 1), blurRadius: 4.0, color: Colors.black54)
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "2.4K",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Share Icon
                GestureDetector(
                  onTap: (){
                    final message =
                        "test test test link";

                    Share.share(message);

                  },
                  child: Column(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: const Icon(Icons.reply, color: Colors.white, size: 35),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "2.2K",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. Bottom Info Section
          Positioned(
            left: 15,
            bottom: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Portugal 6-1 Switzerland: Ramos treble sees Selecao in...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "125K views",
                      style: TextStyle(color: Colors.grey[300], fontSize: 12),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text("•", style: TextStyle(color: Colors.grey[300])),
                    ),
                    Text(
                      "1 day ago",
                      style: TextStyle(color: Colors.grey[300], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "#football #worldcup2022 #portugal #switzerland",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Toggleable Buttons (Like, Dislike, Bookmark)
class SideButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final double size;
  final Color activeColor; // Color when enabled
  final Color inactiveColor; // Color when disabled
  final bool initialIsActive;

  const SideButton({
    super.key,
    required this.icon,
    required this.label,
    this.size = 32,
    this.activeColor = Colors.redAccent,
    this.inactiveColor = Colors.white,
    this.initialIsActive = false,
  });

  @override
  State<SideButton> createState() => _SideButtonState();
}

class _SideButtonState extends State<SideButton> with SingleTickerProviderStateMixin {
  late bool isActive;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isActive = widget.initialIsActive;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleState() {
    setState(() {
      isActive = !isActive;
    });
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleState,
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.icon,
              color: isActive ? widget.activeColor : widget.inactiveColor,
              size: widget.size,
              shadows: const [
                Shadow(offset: Offset(0, 1), blurRadius: 4.0, color: Colors.black54)
              ],
            ),
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            )
          ],
        ],
      ),
    );
  }
}