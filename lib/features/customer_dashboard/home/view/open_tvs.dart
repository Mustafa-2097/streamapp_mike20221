import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controller/live_tv_controller.dart';

class OpenTvs extends StatelessWidget {
  OpenTvs({super.key});

  final LiveTvController controller = Get.put(LiveTvController());

  final WebViewController webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black);

  @override
  Widget build(BuildContext context) {
    /// Load video ONLY when selectedLiveTv changes
    ever(controller.selectedLiveTv, (liveTv) {
      if (liveTv != null) {
        webController.loadRequest(Uri.parse(liveTv.url));
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          }

          if (controller.selectedLiveTv.value == null) {
            return const Center(
              child: Text(
                "No Live Stream Available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final liveTv = controller.selectedLiveTv.value!;

          return Column(
            children: [
              /// VIDEO
              SizedBox(
                height: 240,
                width: double.infinity,
                child: WebViewWidget(controller: webController),
              ),

              /// DETAILS (DESIGN UNCHANGED)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                liveTv.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white70),
                          ],
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Live • Streaming",
                          style: TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),

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

                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: _commentInputBar(),
    );
  }

  // ---------------- COMMENTS ----------------
  Widget _commentsList() {
    final comments = [
      {"name": "alien.aa", "text": "shut down them please!!!"},
      {"name": "trunghieu1794", "text": "nice play bro!!! keep playing"},
    ];

    return Column(
      children: comments.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
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

  // ---------------- COMMENT INPUT ----------------
  Widget _commentInputBar() {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: const Color(0xFF0E0E0E),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add a comment...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.send, color: Colors.white54),
        ],
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../live/live_video/controller/video_controller.dart';
//
// class openTvs extends StatefulWidget {
//   final String? videoUrl;
//   final String? videoTitle;
//   final String? viewerCount;
//
//   const openTvs({
//     super.key,
//     this.videoUrl =
//     'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv2',
//     this.videoTitle = 'Brazil VS Spain || World Cup Live Match',
//     this.viewerCount = '205K',
//   });
//
//   @override
//   State<openTvs> createState() => _openTvOneState();
// }
//
// class _openTvOneState extends State<openTvs> {
//   final VideoLiveController liveController = Get.put(VideoLiveController());
//
//   late final WebViewController _webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.black)
//       ..loadRequest(Uri.parse(widget.videoUrl!));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ VIDEO (WEBVIEW)
//             _videoPreviewSection(),
//
//             // ✅ DETAILS + COMMENTS
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF0E0E0E),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(18),
//                     topRight: Radius.circular(18),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _titleAndDropdown(),
//                       const SizedBox(height: 6),
//                       _viewsRow(),
//                       const SizedBox(height: 12),
//                       _actionRow(),
//                       const SizedBox(height: 12),
//                       _hashtagsRow(),
//                       const SizedBox(height: 16),
//                       const Text(
//                         "Comments",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       _commentsList(),
//                       const SizedBox(height: 90),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _commentInputBar(),
//     );
//   }
//
//   // ---------------- VIDEO SECTION (WEBVIEW ONLY) ----------------
//   Widget _videoPreviewSection() {
//     return SizedBox(
//       height: 240,
//       width: double.infinity,
//       child: WebViewWidget(controller: _webViewController),
//     );
//   }
//
//   // ---------------- TITLE ----------------
//   Widget _titleAndDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             widget.videoTitle!,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
//       ],
//     );
//   }
//
//   Widget _viewsRow() {
//     return Text(
//       "${widget.viewerCount} views • Live",
//       style: const TextStyle(color: Colors.white54, fontSize: 12),
//     );
//   }
//
//   // ---------------- ACTIONS ----------------
//   Widget _actionRow() {
//     return Row(
//       children: [
//         Obx(() => _actionItem(
//           icon: liveController.isLiked.value
//               ? Icons.thumb_up
//               : Icons.thumb_up_alt_outlined,
//           label: _formatCount(liveController.likesCount.value),
//           onTap: liveController.toggleLike,
//         )),
//         const SizedBox(width: 16),
//         _actionItem(
//             icon: Icons.thumb_down_alt_outlined,
//             label: "Dislike",
//             onTap: () {}),
//         const SizedBox(width: 16),
//         _actionItem(
//             icon: Icons.share_outlined, label: "Share", onTap: () {}),
//         const SizedBox(width: 16),
//         _actionItem(
//             icon: Icons.flag_outlined, label: "Report", onTap: () {}),
//       ],
//     );
//   }
//
//   Widget _actionItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.white70),
//           const SizedBox(height: 4),
//           Text(label,
//               style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- HASHTAGS ----------------
//   Widget _hashtagsRow() {
//     return const Wrap(
//       spacing: 8,
//       children: [
//         Text("#football",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//         Text("#worldcup2022",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//         Text("#portugal",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//         Text("#switzerland",
//             style: TextStyle(color: Colors.redAccent, fontSize: 12)),
//       ],
//     );
//   }
//
//   // ---------------- COMMENTS ----------------
//   Widget _commentsList() {
//     final comments = [
//       {"name": "alien.aa", "text": "shut down them please!!!"},
//       {"name": "trunghieu1794", "text": "nice play bro!!! keep playing"},
//     ];
//
//     return Column(
//       children: comments.map((c) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 10),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 14,
//                 backgroundColor: Colors.grey.shade800,
//                 child: Text(c["name"]![0].toUpperCase(),
//                     style: const TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "${c["name"]} ",
//                         style: const TextStyle(
//                             color: Colors.redAccent,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12),
//                       ),
//                       TextSpan(
//                         text: c["text"],
//                         style: const TextStyle(
//                             color: Colors.white70, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   // ---------------- COMMENT INPUT ----------------
//   Widget _commentInputBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       color: const Color(0xFF0E0E0E),
//       child: Row(
//         children: const [
//           CircleAvatar(
//             radius: 16,
//             backgroundColor: Colors.redAccent,
//             child: Icon(Icons.person, color: Colors.white, size: 18),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Add a comment...",
//                 hintStyle: TextStyle(color: Colors.white54),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Icon(Icons.send, color: Colors.white54),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- UTILS ----------------
//   String _formatCount(int count) {
//     if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
//     if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}K";
//     return "$count";
//   }
// }
