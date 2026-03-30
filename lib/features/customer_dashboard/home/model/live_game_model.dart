class LiveGame {
  final String id;
  final String title;
  final String commentary;
  final String link;
  final String thumbnail;
  final String opponent01;
  final String opponent02;
  final DateTime dateTime;
  final bool commentsEnabled;
  final int likes;
  final int dislikes;
  final int viewers;
  final int shares;
  final String status;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentCount;
  final bool liked;
  final bool disliked;

  LiveGame({
    required this.id,
    required this.title,
    required this.commentary,
    required this.link,
    required this.thumbnail,
    required this.opponent01,
    required this.opponent02,
    required this.dateTime,
    required this.commentsEnabled,
    required this.likes,
    required this.dislikes,
    required this.viewers,
    required this.shares,
    required this.status,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
    required this.commentCount,
    required this.liked,
    required this.disliked,
  });

  factory LiveGame.fromJson(Map<String, dynamic> json) {
    return LiveGame(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      commentary: json['commentary'] ?? '',
      link: json['link'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      opponent01: json['opponent_01'] ?? '',
      opponent02: json['opponent_02'] ?? '',
      dateTime: json['dateTime'] != null 
          ? DateTime.parse(json['dateTime']) 
          : DateTime.now(),
      commentsEnabled: json['commentsEnabled'] ?? false,
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      viewers: (json['viewers'] is int)
          ? json['viewers']
          : (json['viewers'] is List ? (json['viewers'] as List).length : 0),
      shares: json['shares'] ?? 0,
      status: json['status'] ?? 'UPCOMING',
      isPremium: json['isPremium'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      commentCount: json['_count']?['comments'] ?? json['comments'] ?? 0,
      liked: json['liked'] ?? false,
      disliked: json['disliked'] ?? false,
    );
  }
}
