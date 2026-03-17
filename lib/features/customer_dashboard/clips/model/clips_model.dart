class ClipModel {
  final String clipId;
  final String userId;
  final String videoUrl;
  final String title;
  final List<String> tags;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ClipUser user;
  final ClipCount count;
  final String timeAgo;
  final String formattedViews;
  final String shareUrl;
  final SocialLinks socialLinks;
  final Engagement engagement;
  final UserStatus userStatus;

  ClipModel({
    required this.clipId,
    required this.userId,
    required this.videoUrl,
    required this.title,
    required this.tags,
    required this.viewCount,
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

  factory ClipModel.fromJson(Map<String, dynamic> json) {
    return ClipModel(
      clipId: json['clipId'] ?? '',
      userId: json['userId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      title: json['title'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      user: ClipUser.fromJson(json['user'] ?? {}),
      count: ClipCount.fromJson(json['_count'] ?? {}),
      timeAgo: json['timeAgo'] ?? '',
      formattedViews: json['formattedViews'] ?? '',
      shareUrl: json['shareUrl'] ?? '',
      socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
      engagement: Engagement.fromJson(json['engagement'] ?? {}),
      userStatus: UserStatus.fromJson(json['userStatus'] ?? {}),
    );
  }
}

class ClipUser {
  final String id;
  final String name;
  final String profilePhoto;

  ClipUser({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });

  factory ClipUser.fromJson(Map<String, dynamic> json) {
    return ClipUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }
}

class ClipCount {
  final int comments;
  final int actions;
  final int bookmarks;

  ClipCount({
    required this.comments,
    required this.actions,
    required this.bookmarks,
  });

  factory ClipCount.fromJson(Map<String, dynamic> json) {
    return ClipCount(
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
  final String clipId;
  final int likes;
  final int dislikes;
  final int shares;
  final int comments;
  final int bookmarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  Engagement({
    required this.id,
    required this.clipId,
    required this.likes,
    required this.dislikes,
    required this.shares,
    required this.comments,
    required this.bookmarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Engagement.fromJson(Map<String, dynamic> json) {
    return Engagement(
      id: json['id'] ?? '',
      clipId: json['clipId'] ?? '',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      shares: json['shares'] ?? 0,
      comments: json['comments'] ?? 0,
      bookmarks: json['bookmarks'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
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
