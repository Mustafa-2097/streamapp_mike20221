import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../news/model/news_model.dart';
import '../../news/controller/news_controller.dart';
import '../../profile/controller/bookmarks_controller.dart';

class NewsDetailsScreen extends StatefulWidget {
  final Article article;
  final String? bookmarkId;
  const NewsDetailsScreen({super.key, required this.article, this.bookmarkId});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final NewsController controller = Get.find<NewsController>();
  final TextEditingController _commentController = TextEditingController();
  late Article currentArticle;
  bool isLoading = false;
  Comment? replyingToComment;
  Map<String, bool> loadingReplies = {};

  @override
  void initState() {
    super.initState();
    currentArticle = widget.article;
    _fetchFullArticle();
  }

  Future<void> _fetchFullArticle() async {
    setState(() => isLoading = true);
    Article? fullArticle;
    if (widget.bookmarkId != null) {
      // If we have a bookmarkId, we use the bookmark details endpoint
      try {
        if (Get.isRegistered<BookmarkController>()) {
          fullArticle = await Get.find<BookmarkController>().fetchBookmarkDetails(widget.bookmarkId!);
        }
      } catch (e) {
        debugPrint("Error fetching bookmark details: $e");
      }
    }
    
    // Fallback to normal news fetch if bookmark fetch failed or was not needed
    if (fullArticle == null && currentArticle.id != null) {
      fullArticle = await controller.fetchNewsById(currentArticle.id!);
    }

    if (fullArticle != null) {
      setState(() {
        currentArticle = fullArticle!;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handlePostComment() async {
    if (_commentController.text.trim().isEmpty) return;
    final parentId = replyingToComment?.id;
    final newComment = await controller.postComment(
      currentArticle.id!,
      _commentController.text.trim(),
      parentId: parentId,
    );
    if (newComment != null) {
      setState(() {
        if (parentId == null) {
          currentArticle.comments ??= [];
          currentArticle.comments!.insert(0, newComment);
        } else {
          _addCommentToParentLocally(currentArticle.comments, parentId, newComment);
        }
        currentArticle.commentCount = (currentArticle.commentCount ?? 0) + 1;
        _commentController.clear();
        replyingToComment = null;
      });
    }
  }

  void _addCommentToParentLocally(List<Comment>? comments, String parentId, Comment newComment) {
    if (comments == null) return;
    for (var comment in comments) {
      if (comment.id == parentId) {
        comment.replies ??= [];
        comment.replies!.insert(0, newComment);
        return;
      }
      if (comment.replies != null) {
        _addCommentToParentLocally(comment.replies, parentId, newComment);
      }
    }
  }

  Future<void> _handleToggleEngagement(String type) async {
    // Article engagement is currently disabled per request
  }

  Future<void> _handleToggleBookmark() async {
    final newStatus = await controller.toggleBookmark(currentArticle.id!);
    if (newStatus != null) {
      setState(() {
        currentArticle.isBookmarked = newStatus;
      });
      // Refresh Bookmark Screen if controller is active
      try {
        if (Get.isRegistered<BookmarkController>()) {
          Get.find<BookmarkController>().fetchNewsBookmarks();
        }
      } catch (e) {
        debugPrint("BookmarkController not found: $e");
      }
    }
  }

  Future<void> _handleToggleCommentEngagement(Comment comment, String type) async {
    final data = await controller.toggleCommentEngagement(comment.id!, type);
    if (data != null) {
      setState(() {
        // If backend provides updated counts, use them
        if (data.containsKey('likeCount')) {
          comment.likeCount = data['likeCount'];
        }
        if (data.containsKey('dislikeCount')) {
          comment.dislikeCount = data['dislikeCount'];
        }

        // If backend provides 'status' (often used for toggle)
        bool newStatus = data['status'] ?? false;

        if (type == 'like') {
          // If backend didn't give likeCount, update locally based on status change
          if (!data.containsKey('likeCount')) {
            if (newStatus && !(comment.isLiked ?? false)) {
              comment.likeCount = (comment.likeCount ?? 0) + 1;
            } else if (!newStatus && (comment.isLiked ?? false)) {
              comment.likeCount = (comment.likeCount ?? 0) - 1;
              if (comment.likeCount! < 0) comment.likeCount = 0;
            }
          }
          comment.isLiked = newStatus;
          if (comment.isLiked == true) {
            comment.isDisliked = false;
          }
        } else if (type == 'dislike') {
          // Dislike handling
          if (!data.containsKey('dislikeCount')) {
            if (newStatus && !(comment.isDisliked ?? false)) {
              comment.dislikeCount = (comment.dislikeCount ?? 0) + 1;
            } else if (!newStatus && (comment.isDisliked ?? false)) {
              comment.dislikeCount = (comment.dislikeCount ?? 0) - 1;
              if (comment.dislikeCount! < 0) comment.dislikeCount = 0;
            }
          }
          comment.isDisliked = newStatus;
          if (comment.isDisliked == true) {
            comment.isLiked = false;
          }
        }
      });
    }
  }

  Future<void> _handleLoadReplies(Comment comment) async {
    if (comment.id == null) return;
    setState(() => loadingReplies[comment.id!] = true);
    try {
      final replies = await controller.fetchCommentReplies(comment.id!);
      setState(() {
        comment.replies = replies;
      });
    } catch (e) {
      debugPrint("Error loading replies: $e");
    } finally {
      setState(() => loadingReplies[comment.id!] = false);
    }
  }

  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF15171E);
    final Color inputColor = const Color(0xFF3E3B50);
    final Color yellowAccent = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          /*
          IconButton(
            icon: Icon(
              currentArticle.isLiked == true
                  ? Icons.thumb_up
                  : Icons.thumb_up_outlined,
              color: currentArticle.isLiked == true
                  ? yellowAccent
                  : Colors.white,
            ),
            onPressed: () => _handleToggleEngagement('like'),
          ),
          IconButton(
            icon: Icon(
              currentArticle.isDisliked == true
                  ? Icons.thumb_down
                  : Icons.thumb_down_outlined,
              color: currentArticle.isDisliked == true
                  ? Colors.redAccent
                  : Colors.white,
            ),
            onPressed: () => _handleToggleEngagement('dislike'),
          ),
          */
          IconButton(
            icon: Icon(
              currentArticle.isBookmarked == true
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: currentArticle.isBookmarked == true
                  ? yellowAccent
                  : Colors.white,
            ),
            onPressed: _handleToggleBookmark,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentArticle.title ?? "No Title",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentArticle.publishedAt != null &&
                                  currentArticle.publishedAt!.length >= 10
                              ? currentArticle.publishedAt!.substring(0, 10)
                              : "Unknown Date",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "${currentArticle.viewCount ?? 0} read",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (currentArticle.description != null)
                      Text(
                        currentArticle.description!,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (currentArticle.urlToImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          currentArticle.urlToImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.white),
                                ),
                              ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (currentArticle.content != null)
                      Text(
                        currentArticle.content!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Comments (${currentArticle.commentCount ?? 0})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey[700]),
                    const SizedBox(height: 10),

                    // Comments List
                    if (currentArticle.comments != null &&
                        currentArticle.comments!.isNotEmpty)
                      _buildCommentList(currentArticle.comments!)
                    else
                      const Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                    const SizedBox(height: 20),

                    if (replyingToComment != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 48, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              "Replying to ${replyingToComment!.userName}",
                              style: const TextStyle(
                                  color: Color(0xFFFFD700), fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => replyingToComment = null),
                              child: const Icon(Icons.close,
                                  color: Colors.grey, size: 14),
                            ),
                          ],
                        ),
                      ),

                    // Comment Input
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=12',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: inputColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _commentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Add a comment...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: _handlePostComment,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Recommendation",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: Obx(
                        () => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.newsList.length,
                          separatorBuilder: (c, i) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = controller.newsList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetailsScreen(article: item),
                                  ),
                                );
                              },
                              child: _buildRecommendationCard(
                                item.title ?? "No Title",
                                item.urlToImage ?? "",
                                item.publishedAt ?? "",
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCommentList(List<Comment> comments, {double padding = 0}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (c, i) =>
          SizedBox(height: padding > 0 ? 8 : 16), // Smaller spacing for replies
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: _buildCommentItem(comment),
            ),
            if (comment.replies != null && comment.replies!.isNotEmpty)
              _buildCommentList(comment.replies!, padding: padding + 24),
          ],
        );
      },
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${comment.userName ?? "User"}: ",
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              TextSpan(
                text: comment.comment ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            GestureDetector(
              onTap: () => _handleToggleCommentEngagement(comment, 'like'),
              child: Row(
                children: [
                  Icon(
                    comment.isLiked == true ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: comment.isLiked == true ? const Color(0xFFFFD700) : Colors.grey[400],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${comment.likeCount ?? 0}",
                    style: TextStyle(
                      color: comment.isLiked == true ? const Color(0xFFFFD700) : Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => _handleToggleCommentEngagement(comment, 'dislike'),
              child: Row(
                children: [
                  Icon(
                    comment.isDisliked == true ? Icons.thumb_down : Icons.thumb_down_outlined,
                    color: comment.isDisliked == true ? Colors.redAccent : Colors.grey[400],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${comment.dislikeCount ?? 0}",
                    style: TextStyle(
                      color: comment.isDisliked == true ? Colors.redAccent : Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                setState(() => replyingToComment = comment);
                FocusScope.of(context).unfocus(); // Scroll to input
                // Scroll calculation would go here if using a controller
              },
              child: Row(
                children: [
                  const Icon(Icons.reply, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "Reply",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (loadingReplies[comment.id!] == true)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
              )
            else
              GestureDetector(
                onTap: () => _handleLoadReplies(comment),
                child: Row(
                  children: [
                    const Icon(Icons.comment_outlined, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Replies",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(String title, String imageUrl, String date) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/images/news.png') as ImageProvider,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.length >= 10 ? date.substring(5, 10) : date,
              style: TextStyle(color: Colors.grey[400], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
