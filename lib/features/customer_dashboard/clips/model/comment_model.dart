import '../../clips/model/clips_model.dart';

class ClipComment {
  final String commentId;
  final String clipId;
  final String userId;
  final String content;
  final String? parentCommentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ClipUser user;
  int replyCount;
  List<ClipComment> replies;
  int likeCount;
  int dislikeCount;
  CommentUserStatus userStatus;

  ClipComment({
    required this.commentId,
    required this.clipId,
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

  factory ClipComment.fromJson(Map<String, dynamic> json) {
    return ClipComment(
      commentId: json['id'] ?? json['commentId'] ?? '',
      clipId: json['clipId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      parentCommentId: json['parentCommentId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      user: ClipUser.fromJson(json['user'] ?? {}),
      replyCount: json['_count']?['replies'] ?? 0,
      replies: (json['replies'] as List?)
              ?.map((e) => ClipComment.fromJson(e))
              .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
      dislikeCount: json['dislikeCount'] ?? 0,
      userStatus: CommentUserStatus.fromJson(json['userStatus'] ?? {}),
    );
  }
}

class CommentUserStatus {
  bool isLiked;
  bool isDisliked;

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
