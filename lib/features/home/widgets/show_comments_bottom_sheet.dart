import 'package:flutter/material.dart';

void showCommentBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CommentBottomSheet(),
  );
}

class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF121418),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 10),
          const Text(
            "Comment",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey[800], thickness: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Comments  14.7K",
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCommentItem(
                  username: "alien.aa",
                  text: "shut down them please!!!!",
                  usernameColor: Colors.redAccent,
                  isSimple: true,
                ),

                const SizedBox(height: 16),

                _buildCommentItem(
                  username: "trunghieu1794",
                  text: "nice play pro!!!! keep playing",
                  usernameColor: Colors.yellowAccent[700]!,
                  likes: "3.2K",
                  dislikes: "368",
                ),

                const SizedBox(height: 16),

                _buildCommentItem(
                  username: "alien.aa",
                  text: "shut down them please!!!!",
                  usernameColor: Colors.redAccent,
                  likes: "3.2K",
                  dislikes: "368",
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 12),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: const Color(0xFF38354B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Reply.....",
                            style: TextStyle(color: Colors.grey[400], fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _buildCommentItem(
                  username: "trunghieu1794",
                  text: "nice play pro!!!! keep playing",
                  usernameColor: Colors.yellowAccent[700]!,
                  likes: "3.2K",
                  dislikes: "368",
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF121418), // Same as background
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF38354B),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({
    required String username,
    required String text,
    required Color usernameColor,
    String? likes,
    String? dislikes,
    bool isSimple = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$username: ",
                style: TextStyle(
                  color: usernameColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              TextSpan(
                text: text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (!isSimple) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              _actionIcon(Icons.thumb_up_alt_outlined, likes ?? "0"),
              const SizedBox(width: 16),
              _actionIcon(Icons.thumb_down_alt_outlined, dislikes ?? "0"),
              const SizedBox(width: 24),
              const Icon(Icons.reply, color: Colors.grey, size: 18),
              const SizedBox(width: 6),
              const Text(
                "Reply",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          )
        ]
      ],
    );
  }

  Widget _actionIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 18),
        const SizedBox(width: 6),
        Text(
          count,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}