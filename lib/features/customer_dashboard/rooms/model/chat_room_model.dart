class ChatRoomModel {
  final String id;
  final String name;
  final String? bannerImage;
  final String? description;
  final String? type;
  final String? matchId;
  final bool isArchived;
  final String? lastMessageAt;
  final String createdAt;
  final String updatedAt;
  final int memberCount;
  final List<dynamic>? members;
  final bool isJoined;

  ChatRoomModel({
    required this.id,
    required this.name,
    this.bannerImage,
    this.description,
    this.type,
    this.matchId,
    required this.isArchived,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    required this.memberCount,
    this.members,
    required this.isJoined,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bannerImage: json['bannerImage'],
      description: json['description'],
      type: json['type'],
      matchId: json['matchId'],
      isArchived: json['isArchived'] ?? false,
      lastMessageAt: json['lastMessageAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      memberCount: json['_count'] != null ? (json['_count']['members'] ?? 0) : 0,
      members: json['members'] != null ? List<dynamic>.from(json['members']) : null,
      isJoined: json['isJoined'] ?? false,
    );
  }
}
