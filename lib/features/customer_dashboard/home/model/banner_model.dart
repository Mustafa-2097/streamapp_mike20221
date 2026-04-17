class BannerModel {
  final String id;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
