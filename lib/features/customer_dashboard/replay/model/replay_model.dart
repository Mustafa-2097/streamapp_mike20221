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
  final bool isPremium;

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
    required this.isPremium,
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
      viewCount: int.tryParse(json['viewCount']?.toString() ?? '') ?? 0,
      category: json['category'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      user: ReplayUser.fromJson(json['user'] is Map ? json['user'] : {}),
      count: ReplayCount.fromJson(json['_count'] is Map ? json['_count'] : {}),
      timeAgo: json['timeAgo'] ?? '',
      formattedViews: json['formattedViews'] ?? '',
      shareUrl: json['shareUrl'] ?? '',
      socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
      engagement: Engagement.fromJson(json['engagement'] is Map ? json['engagement'] : {}),
      userStatus: UserStatus.fromJson(json['userStatus'] is Map ? json['userStatus'] : {}),
      isPremium: json['isPremium'] ?? false,
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
      comments: int.tryParse(json['comments']?.toString() ?? '') ?? 0,
      actions: int.tryParse(json['actions']?.toString() ?? '') ?? 0,
      bookmarks: int.tryParse(json['bookmarks']?.toString() ?? '') ?? 0,
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
      likes: int.tryParse(json['likes']?.toString() ?? '') ?? 0,
      dislikes: int.tryParse(json['dislikes']?.toString() ?? '') ?? 0,
      shares: int.tryParse(json['shares']?.toString() ?? '') ?? 0,
      comments: int.tryParse(json['comments']?.toString() ?? '') ?? 0,
      bookmarks: int.tryParse(json['bookmarks']?.toString() ?? '') ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      formattedComments: (json['formattedComments'] ?? '0').toString(),
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
