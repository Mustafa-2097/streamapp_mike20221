import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact colors from the screenshot
    final Color backgroundColor = const Color(0xFF15171E);
    final Color inputColor = const Color(0xFF3E3B50);
    final Color yellowAccent = const Color(0xFFFFD700);
    final Color redAccent = Colors.redAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white), // Assuming a back button exists
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Title
              const Text(
                "All the numbers behind Cooper Flagg's historic start",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 2. Metadata (Date & Reads)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("12 October 2026", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  Text("12k read", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Intro Text
              Text(
                "From a 42-point game to 3rd all time in points by an 18-year-old, Flagg's rookie season is off to a historic start.",
                style: TextStyle(color: Colors.grey[300], fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),

              // 4. Main Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://english.news.cn/20260125/a7aad847dff1456f8a1a8b1344b705ca/20260125a7aad847dff1456f8a1a8b1344b705ca_2026012534f9350633db47728351d464902616e4.jpg', // Placeholder for basketball player
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 16),

              // 5. Body Text
              Text(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text.",
                style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 30),

              // 6. Comment Section Header
              const Center(
                child: Text(
                  "Comment",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[700]),
              const SizedBox(height: 10),

              // 7. Comments List
              _buildCommentItem(
                username: "trunghieu1794",
                content: "nice play pro!!!! keep playing",
                color: yellowAccent,
                likes: "3.2K",
                dislikes: "368",
              ),
              const SizedBox(height: 16),

              _buildCommentItem(
                username: "alien.aa",
                content: "shut down them please!!!!",
                color: redAccent,
                likes: "3.2K",
                dislikes: "368",
              ),

              // Nested Reply Input
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 12, bottom: 20),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: inputColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Reply.....", style: TextStyle(color: Colors.grey[500])),
                ),
              ),

              _buildCommentItem(
                username: "trunghieu1794",
                content: "nice play pro!!!! keep playing",
                color: yellowAccent,
                likes: "3.2K",
                dislikes: "368",
              ),
              const SizedBox(height: 20),

              // 8. Add a comment Input (Static at bottom of comments)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: inputColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Add a comment...", style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 9. Recommendation Section
              const Text(
                "Recommendation",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Horizontal List
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildRecommendationCard(
                      "Indonesian national team who beat Europe",
                      "https://english.news.cn/20260125/a7aad847dff1456f8a1a8b1344b705ca/20260125a7aad847dff1456f8a1a8b1344b705ca_2026012534f9350633db47728351d464902616e4.jpg",
                    ),
                    const SizedBox(width: 12),
                    _buildRecommendationCard(
                      "Indonesian national team who beat Europe",
                      "https://english.news.cn/20260125/a7aad847dff1456f8a1a8b1344b705ca/20260125a7aad847dff1456f8a1a8b1344b705ca_2026012534f9350633db47728351d464902616e4.jpg",
                    ),
                    const SizedBox(width: 12),
                    _buildRecommendationCard(
                      "Indonesian national team who beat Europe",
                      "https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=500",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for Comment Item
  Widget _buildCommentItem({
    required String username,
    required String content,
    required Color color,
    required String likes,
    required String dislikes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$username: ",
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              TextSpan(
                text: content,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.thumb_up_outlined, color: Colors.grey[400], size: 16),
            const SizedBox(width: 4),
            Text(likes, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            const SizedBox(width: 16),
            Icon(Icons.thumb_down_outlined, color: Colors.grey[400], size: 16),
            const SizedBox(width: 4),
            Text(dislikes, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            const SizedBox(width: 16),
            Icon(Icons.reply, color: Colors.grey[400], size: 16),
            const SizedBox(width: 4),
            Text("Reply", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        )
      ],
    );
  }

  // Helper for Recommendation Card
  Widget _buildRecommendationCard(String title, String imageUrl) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
            stops: [0.3, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "October 12",
              style: TextStyle(color: Colors.grey[400], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}