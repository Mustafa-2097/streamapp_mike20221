class LiveTvComment {
  final String commentId;
  final String liveTvId;
  final String userId;
  final String content;
  final String? parentCommentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CommentUser user;
  final int replyCount;
  final List<LiveTvComment> replies;
  final int likeCount;
  final int dislikeCount;
  final CommentUserStatus userStatus;

  LiveTvComment({
    required this.commentId,
    required this.liveTvId,
    required this.userId,
    required this.content,
    this.parentCommentId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.replyCount,
    required this.replies,
    required this.likeCount,
    required this.dislikeCount,
    required this.userStatus,
  });

  factory LiveTvComment.fromJson(Map<String, dynamic> json) {
    return LiveTvComment(
      commentId: json['id'] ?? '',
      liveTvId: json['liveTvId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      parentCommentId: json['parentCommentId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      user: CommentUser.fromJson(json['user'] ?? {}),
      replyCount: json['replyCount'] ?? 0,
      replies: (json['replies'] as List? ?? [])
          .map((e) => LiveTvComment.fromJson(e))
          .toList(),
      likeCount: json['likeCount'] ?? 0,
      dislikeCount: json['dislikeCount'] ?? 0,
      userStatus: CommentUserStatus.fromJson(json['userStatus'] ?? {}),
    );
  }
}

class CommentUser {
  final String id;
  final String name;
  final String profilePhoto;

  CommentUser({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }
}

class CommentUserStatus {
  final bool isLiked;
  final bool isDisliked;

  CommentUserStatus({
    required this.isLiked,
    required this.isDisliked,
  });

  factory CommentUserStatus.fromJson(Map<String, dynamic> json) {
    return CommentUserStatus(
      isLiked: json['isLiked'] ?? false,
      isDisliked: json['isDisliked'] ?? false,
    );
  }
}
