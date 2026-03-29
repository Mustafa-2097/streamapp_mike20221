class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? image;
  final bool seen;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.image,
    required this.seen,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      image: json["image"],
      seen: json["seen"] ?? false,
      createdAt: json["createdAt"] != null 
          ? DateTime.parse(json["createdAt"]) 
          : DateTime.now(),
    );
  }
}