class LiveGameComment {
  final String id;
  final String userId;
  final String? liveGameId;
  final String content;
  final String? parentCommentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CommentUser user;
  final int totalLikes;
  final int totalDislikes;
  final bool liked;
  final bool disliked;
  final List<LiveGameComment> replies;

  LiveGameComment({
    required this.id,
    required this.userId,
    this.liveGameId,
    required this.content,
    this.parentCommentId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.totalLikes = 0,
    this.totalDislikes = 0,
    this.liked = false,
    this.disliked = false,
    this.replies = const [],
  });

  factory LiveGameComment.fromJson(Map<String, dynamic> json) {
    return LiveGameComment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      liveGameId: json['liveGameId'],
      content: json['content'] ?? '',
      parentCommentId: json['parentCommentId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      user: CommentUser.fromJson(json['user'] ?? {}),
      totalLikes: json['likes'] ?? 0,
      totalDislikes: json['dislikes'] ?? 0,
      liked: json['liked'] ?? false,
      disliked: json['disliked'] ?? false,
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((e) => LiveGameComment.fromJson(e))
              .toList()
          : [],
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
    String photo = json['profilePhoto'] ?? '';
    if (photo.contains('localhost')) {
      photo = photo.replaceFirst('localhost', '10.0.30.59');
    }
    return CommentUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePhoto: photo,
    );
  }
}
