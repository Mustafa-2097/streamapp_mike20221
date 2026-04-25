class LiveTvModel {
  final String id;
  final String title;
  final String link;
  final String thumbnail;
  final bool commentsEnabled;
  final int likes;
  final int dislikes;
  final int shares;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentCount;
  final dynamic comments;
  final bool isPremium;
  final bool liked;
  final bool disliked;

  LiveTvModel({
    required this.id,
    required this.title,
    required this.link,
    required this.thumbnail,
    required this.commentsEnabled,
    required this.likes,
    required this.dislikes,
    required this.shares,
    required this.createdAt,
    required this.updatedAt,
    required this.commentCount,
    this.isPremium = false,
    this.comments,
    this.liked = false,
    this.disliked = false,
  });

  factory LiveTvModel.fromJson(Map<String, dynamic> json) {
    return LiveTvModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      commentsEnabled: json['commentsEnabled'] ?? true,
      likes: json['likes'] is int ? json['likes'] : (int.tryParse(json['likes']?.toString() ?? '0') ?? 0),
      dislikes: json['dislikes'] is int ? json['dislikes'] : (int.tryParse(json['dislikes']?.toString() ?? '0') ?? 0),
      shares: json['shares'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      commentCount: json['_count'] != null 
          ? json['_count']['comments'] ?? 0 
          : (json['comments'] is int ? json['comments'] : (json['comments'] is List ? (json['comments'] as List).length : 0)),
      comments: json['comments'],
      liked: json['liked'] ?? false,
      disliked: json['disliked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'thumbnail': thumbnail,
      'commentsEnabled': commentsEnabled,
      'likes': likes,
      'dislikes': dislikes,
      'shares': shares,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'liked': liked,
      'disliked': disliked,
      '_count': {'comments': commentCount},
      'comments': comments,
    };
  }

  LiveTvModel copyWith({
    String? id,
    String? title,
    String? link,
    String? thumbnail,
    bool? commentsEnabled,
    int? likes,
    int? dislikes,
    int? shares,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? commentCount,
    dynamic comments,
    bool? liked,
    bool? disliked,
  }) {
    return LiveTvModel(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      thumbnail: thumbnail ?? this.thumbnail,
      commentsEnabled: commentsEnabled ?? this.commentsEnabled,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      shares: shares ?? this.shares,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      commentCount: commentCount ?? this.commentCount,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      disliked: disliked ?? this.disliked,
    );
  }
}
