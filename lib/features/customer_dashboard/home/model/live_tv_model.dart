class LiveTvModel {
  final String id;
  final String title;
  final String link;
  final String thumbnail;
  final bool commentsEnabled;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final int shares;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentCount;
  final List<dynamic>? comments;

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
    this.comments,
  });

  factory LiveTvModel.fromJson(Map<String, dynamic> json) {
    return LiveTvModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      commentsEnabled: json['commentsEnabled'] ?? true,
      likes: json['likes'] ?? [],
      dislikes: json['dislikes'] ?? [],
      shares: json['shares'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      commentCount: json['_count'] != null 
          ? json['_count']['comments'] ?? 0 
          : (json['comments'] is List ? (json['comments'] as List).length : 0),
      comments: json['comments'],
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_count': {'comments': commentCount},
      'comments': comments,
    };
  }
}
