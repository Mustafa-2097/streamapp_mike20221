class ReplayModel {
  final String replayId;
  final String userId;
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String description;
  final List<String> tags;
  final int viewCount;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReplayUser user;
  final ReplayCount count;
  final String timeAgo;
  final String formattedViews;
  final String shareUrl;
  final SocialLinks socialLinks;
  final Engagement engagement;
  final UserStatus userStatus;

  ReplayModel({
    required this.replayId,
    required this.userId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.tags,
    required this.viewCount,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.count,
    required this.timeAgo,
    required this.formattedViews,
    required this.shareUrl,
    required this.socialLinks,
    required this.engagement,
    required this.userStatus,
  });

  factory ReplayModel.fromJson(Map<String, dynamic> json) {
    return ReplayModel(
      replayId: json['replayId'] ?? '',
      userId: json['userId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      user: ReplayUser.fromJson(json['user'] ?? {}),
      count: ReplayCount.fromJson(json['_count'] ?? {}),
      timeAgo: json['timeAgo'] ?? '',
      formattedViews: json['formattedViews'] ?? '',
      shareUrl: json['shareUrl'] ?? '',
      socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
      engagement: Engagement.fromJson(json['engagement'] ?? {}),
      userStatus: UserStatus.fromJson(json['userStatus'] ?? {}),
    );
  }
}

class ReplayUser {
  final String id;
  final String name;
  final String profilePhoto;

  ReplayUser({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });

  factory ReplayUser.fromJson(Map<String, dynamic> json) {
    return ReplayUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }
}

class ReplayCount {
  final int comments;
  final int actions;
  final int bookmarks;

  ReplayCount({
    required this.comments,
    required this.actions,
    required this.bookmarks,
  });

  factory ReplayCount.fromJson(Map<String, dynamic> json) {
    return ReplayCount(
      comments: json['comments'] ?? 0,
      actions: json['actions'] ?? 0,
      bookmarks: json['bookmarks'] ?? 0,
    );
  }
}

class SocialLinks {
  final String whatsapp;
  final String facebook;
  final String twitter;
  final String telegram;

  SocialLinks({
    required this.whatsapp,
    required this.facebook,
    required this.twitter,
    required this.telegram,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      whatsapp: json['whatsapp'] ?? '',
      facebook: json['facebook'] ?? '',
      twitter: json['twitter'] ?? '',
      telegram: json['telegram'] ?? '',
    );
  }
}

class Engagement {
  final String id;
  final String replayId;
  int likes;
  int dislikes;
  int shares;
  int comments;
  int bookmarks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String formattedComments;

  Engagement({
    required this.id,
    required this.replayId,
    required this.likes,
    required this.dislikes,
    required this.shares,
    required this.comments,
    required this.bookmarks,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedComments,
  });

  factory Engagement.fromJson(Map<String, dynamic> json) {
    return Engagement(
      id: json['id'] ?? '',
      replayId: json['replayId'] ?? '',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      shares: json['shares'] ?? 0,
      comments: json['comments'] ?? 0,
      bookmarks: json['bookmarks'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      formattedComments: json['formattedComments'] ?? '0',
    );
  }
}

class UserStatus {
  bool isLiked;
  bool isDisliked;
  bool isBookmarked;

  UserStatus({
    required this.isLiked,
    required this.isDisliked,
    required this.isBookmarked,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      isLiked: json['isLiked'] ?? false,
      isDisliked: json['isDisliked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}
