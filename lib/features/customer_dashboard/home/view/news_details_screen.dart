import 'package:flutter/material.dart';
import 'package:testapp/core/const/app_colors.dart';
import 'package:get/get.dart';
import '../../news/model/news_model.dart';
import '../../news/controller/news_controller.dart';
import '../../profile/controller/bookmarks_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../../../core/utils/url_helper.dart';

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
  Map<String, bool> expandedReplies = {}; // NEW: track expanded status

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
          fullArticle = await Get.find<BookmarkController>()
              .fetchBookmarkDetails(widget.bookmarkId!);
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
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // --- OPTIMISTIC UI: INSTANT ADD ---
    final profile = Get.find<ProfileController>().profile.value;
    if (profile == null) return;

    final String tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
    final parentId = replyingToComment?.id;

    final optimisticComment = Comment(
      id: tempId,
      newsId: currentArticle.id,
      userId: profile.id,
      userName: profile.name ?? "User",
      userImage: profile.profilePhoto,
      comment: text,
      parentId: parentId,
      createdAt: DateTime.now().toIso8601String(),
      likeCount: 0,
      dislikeCount: 0,
      isLiked: false,
      isDisliked: false,
      replies: [],
    );

    // Save context for possible rollback
    final originalText = text;
    final originalParentId = parentId;

    setState(() {
      if (parentId == null) {
        currentArticle.comments ??= [];
        currentArticle.comments!.insert(0, optimisticComment);
      } else {
        _addCommentToParentLocally(
          currentArticle.comments,
          parentId,
          optimisticComment,
        );
      }
      _commentController.clear();
      replyingToComment = null;
    });

    final newComment = await controller.postComment(
      currentArticle.id!,
      originalText,
      parentId: originalParentId,
    );

    if (newComment != null) {
      // Success: Replace temporary comment with real one from server
      setState(() {
        if (originalParentId == null) {
          int idx =
              currentArticle.comments?.indexWhere((c) => c.id == tempId) ?? -1;
          if (idx != -1) currentArticle.comments![idx] = newComment;
        } else {
          _replaceCommentInParentLocally(
            currentArticle.comments,
            originalParentId,
            tempId,
            newComment,
          );
        }
      });
    } else {
      // Error: Rollback UI
      setState(() {
        if (originalParentId == null) {
          currentArticle.comments?.removeWhere((c) => c.id == tempId);
        } else {
          _removeCommentFromParentLocally(
            currentArticle.comments,
            originalParentId,
            tempId,
          );
        }
        _commentController.text = originalText; // Restore text for another try
      });

      Get.snackbar(
        "Post Failed",
        "Could not sync comment with server. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
      );
    }
  }

  void _addCommentToParentLocally(
    List<Comment>? comments,
    String parentId,
    Comment newComment,
  ) {
    if (comments == null) return;
    for (var comment in comments) {
      if (comment.id == parentId) {
        comment.replies ??= [];
        comment.replies!.add(newComment); // Add to end of replies or start?
        return;
      }
      if (comment.replies != null) {
        _addCommentToParentLocally(comment.replies, parentId, newComment);
      }
    }
  }

  void _removeCommentFromParentLocally(
    List<Comment>? comments,
    String parentId,
    String tempId,
  ) {
    if (comments == null) return;
    for (var comment in comments) {
      if (comment.id == parentId) {
        comment.replies?.removeWhere((r) => r.id == tempId);
        return;
      }
      if (comment.replies != null) {
        _removeCommentFromParentLocally(comment.replies, parentId, tempId);
      }
    }
  }

  void _replaceCommentInParentLocally(
    List<Comment>? comments,
    String parentId,
    String tempId,
    Comment realComment,
  ) {
    if (comments == null) return;
    for (var comment in comments) {
      if (comment.id == parentId) {
        int idx = comment.replies?.indexWhere((r) => r.id == tempId) ?? -1;
        if (idx != -1) comment.replies![idx] = realComment;
        return;
      }
      if (comment.replies != null) {
        _replaceCommentInParentLocally(
          comment.replies,
          parentId,
          tempId,
          realComment,
        );
      }
    }
  }

  Future<void> _handleToggleEngagement(String type) async {
    // Article engagement is currently disabled per request
  }

  Future<void> _handleToggleBookmark() async {
    // --- OPTIMISTIC UI: INSTANT FEEDBACK ---
    final originalStatus = currentArticle.isBookmarked;
    setState(() {
      currentArticle.isBookmarked = !(originalStatus ?? false);
    });

    final newStatus = await controller.toggleBookmark(currentArticle.id!);
    if (newStatus != null) {
      // Success: Sync with exact server status if different
      if (currentArticle.isBookmarked != newStatus) {
        setState(() {
          currentArticle.isBookmarked = newStatus;
        });
      }

      // Refresh Bookmark Screen if controller is active
      try {
        if (Get.isRegistered<BookmarkController>()) {
          Get.find<BookmarkController>().fetchNewsBookmarks();
        }
      } catch (e) {
        debugPrint("BookmarkController not found: $e");
      }
    } else {
      // Error: Rollback UI
      setState(() {
        currentArticle.isBookmarked = originalStatus;
      });
      Get.snackbar(
        "Sync Error",
        "Failed to update bookmark status on server.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
      );
    }
  }

  Future<void> _handleToggleCommentEngagement(
    Comment comment,
    String type,
  ) async {
    // --- OPTIMISTIC UI: REACTIONS ---
    final originalIsLiked = comment.isLiked;
    final originalIsDisliked = comment.isDisliked;
    final originalLikeCount = comment.likeCount;
    final originalDislikeCount = comment.dislikeCount;

    setState(() {
      if (type == 'like') {
        if (comment.isLiked == true) {
          comment.isLiked = false;
          comment.likeCount = (comment.likeCount ?? 1) - 1;
        } else {
          comment.isLiked = true;
          comment.likeCount = (comment.likeCount ?? 0) + 1;
          if (comment.isDisliked == true) {
            comment.isDisliked = false;
            comment.dislikeCount = (comment.dislikeCount ?? 1) - 1;
          }
        }
      } else if (type == 'dislike') {
        if (comment.isDisliked == true) {
          comment.isDisliked = false;
          comment.dislikeCount = (comment.dislikeCount ?? 1) - 1;
        } else {
          comment.isDisliked = true;
          comment.dislikeCount = (comment.dislikeCount ?? 0) + 1;
          if (comment.isLiked == true) {
            comment.isLiked = false;
            comment.likeCount = (comment.likeCount ?? 1) - 1;
          }
        }
      }
      if (comment.likeCount! < 0) comment.likeCount = 0;
      if (comment.dislikeCount! < 0) comment.dislikeCount = 0;
    });
    // --- END OPTIMISTIC ---

    final data = await controller.toggleCommentEngagement(comment.id!, type);
    if (data != null) {
      setState(() {
        if (data.containsKey('likeCount')) {
          comment.likeCount = data['likeCount'];
        }
        if (data.containsKey('dislikeCount')) {
          comment.dislikeCount = data['dislikeCount'];
        }
        // Background update confirmed success. We keep our optimistic values if backend data matches.
      });
    } else {
      // Rollback
      setState(() {
        comment.isLiked = originalIsLiked;
        comment.isDisliked = originalIsDisliked;
        comment.likeCount = originalLikeCount;
        comment.dislikeCount = originalDislikeCount;
      });
      Get.snackbar(
        "Error",
        "Failed to sync reaction with server",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.black,
      );
    }
  }

  Future<void> _handleLoadReplies(Comment comment) async {
    if (comment.id == null) return;

    // If already expanded, collapse it
    if (expandedReplies[comment.id!] == true) {
      setState(() => expandedReplies[comment.id!] = false);
      return;
    }

    // Expand it
    setState(() => expandedReplies[comment.id!] = true);

    // If replies not loaded yet, fetch them (optional if already in model)
    if (comment.replies == null || comment.replies!.isEmpty) {
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
                        "Comments (${currentArticle.totalComments})",
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
                                color: Color(0xFFFFD700),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => replyingToComment = null),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Comment Input
                    Row(
                      children: [
                        Obx(() {
                          final userPhoto = Get.find<ProfileController>()
                              .profile
                              .value
                              ?.profilePhoto;
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[800],
                            backgroundImage: (userPhoto != null && userPhoto.trim().isNotEmpty)
                                ? NetworkImage(UrlHelper.sanitizeUrl(userPhoto))
                                : null,
                            child: (userPhoto == null || userPhoto.trim().isEmpty)
                                ? const Icon(Icons.person, size: 20, color: Colors.white)
                                : null,
                          );
                        }),
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
                      child: Obx(() {
                        final recommendations = controller.newsList
                            .where(
                              (a) =>
                                  a.id != currentArticle.id &&
                                  (a.category == currentArticle.category ||
                                      currentArticle.category == "All"),
                            )
                            .toList();

                        if (recommendations.isEmpty) {
                          return const Center(
                            child: Text(
                              "No related news found",
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendations.length,
                          separatorBuilder: (c, i) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = recommendations[index];
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
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCommentList(List<Comment> comments, {double padding = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.map((comment) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildCommentItem(comment),
              if (comment.replies != null &&
                  comment.replies!.isNotEmpty &&
                  expandedReplies[comment.id!] == true)
                _buildCommentList(comment.replies!, padding: 24),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final bool hasImage = comment.userImage != null && comment.userImage!.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.grey[800],
          backgroundImage: hasImage ? NetworkImage(UrlHelper.sanitizeUrl(comment.userImage!)) : null,
          child: !hasImage ? const Icon(Icons.person, size: 16, color: Colors.white) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
                    onTap: () =>
                        _handleToggleCommentEngagement(comment, 'like'),
                    child: Row(
                      children: [
                        Icon(
                          comment.isLiked == true
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          color: comment.isLiked == true
                              ? const Color(0xFFFFD700)
                              : Colors.grey[400],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${comment.likeCount ?? 0}",
                          style: TextStyle(
                            color: comment.isLiked == true
                                ? const Color(0xFFFFD700)
                                : Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () =>
                        _handleToggleCommentEngagement(comment, 'dislike'),
                    child: Row(
                      children: [
                        Icon(
                          comment.isDisliked == true
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          color: comment.isDisliked == true
                              ? Colors.redAccent
                              : Colors.grey[400],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${comment.dislikeCount ?? 0}",
                          style: TextStyle(
                            color: comment.isDisliked == true
                                ? Colors.redAccent
                                : Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Only show Reply and Load Replies for main comments
                  if (comment.parentId == null) ...[
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() => replyingToComment = comment);
                        FocusScope.of(context).unfocus(); // Scroll to input
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.reply, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Reply",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (comment.replies != null &&
                        comment.replies!.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      if (loadingReplies[comment.id!] == true)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () => _handleLoadReplies(comment),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Replies",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ],
              ),
            ],
          ),
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
