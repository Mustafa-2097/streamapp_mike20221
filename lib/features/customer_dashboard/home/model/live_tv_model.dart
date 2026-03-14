class LiveTvModel {
  final String id;
  final String title;
  final String url;
  final String thumbnail;

  LiveTvModel({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnail,
  });

  factory LiveTvModel.fromJson(Map<String, dynamic> json) {
    return LiveTvModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnail: json['thumbnail'],
    );
  }
}
