import 'replay_model.dart';

class ReplayComment {
  final String commentId;
  final String replayId;
  final String userId;
  final String content;
  final String? parentCommentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReplayUser user;
  final int replyCount;
  final List<ReplayComment> replies;
  final int likeCount;
  final int dislikeCount;
  final ReplayCommentUserStatus userStatus;

  ReplayComment({
    required this.commentId,
    required this.replayId,
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

  factory ReplayComment.fromJson(Map<String, dynamic> json) {
    return ReplayComment(
      commentId: json['commentId'] ?? '',
      replayId: json['replayId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      parentCommentId: json['parentCommentId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      user: ReplayUser.fromJson(json['user'] ?? {}),
      replyCount: json['_count']?['replies'] ?? 0,
      replies: (json['replies'] as List?)
              ?.map((e) => ReplayComment.fromJson(e))
              .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
      dislikeCount: json['dislikeCount'] ?? 0,
      userStatus: ReplayCommentUserStatus.fromJson(json['userStatus'] ?? {}),
    );
  }
}

class ReplayCommentUserStatus {
  final bool isLiked;
  final bool isDisliked;

  ReplayCommentUserStatus({
    required this.isLiked,
    required this.isDisliked,
  });

  factory ReplayCommentUserStatus.fromJson(Map<String, dynamic> json) {
    return ReplayCommentUserStatus(
      isLiked: json['isLiked'] ?? false,
      isDisliked: json['isDisliked'] ?? false,
    );
  }
}
