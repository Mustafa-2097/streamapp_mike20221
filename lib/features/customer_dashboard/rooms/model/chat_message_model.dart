class ChatMessageModel {
  final String id;
  final String roomId;
  final String userId;
  final String content;
  final String? parentMessageId;
  final bool isEdited;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final ChatUserModel? user;
  final int replyCount;
  final int reactionCount;
  final List<ChatMessageReactionModel> reactions;

  ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.content,
    this.parentMessageId,
    required this.isEdited,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    required this.replyCount,
    required this.reactionCount,
    required this.reactions,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      roomId: json['roomId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      parentMessageId: json['parentMessageId'],
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      user: json['user'] != null ? ChatUserModel.fromJson(json['user']) : null,
      replyCount: json['_count'] != null ? (json['_count']['replies'] ?? 0) : 0,
      reactionCount: json['_count'] != null ? (json['_count']['reactions'] ?? 0) : 0,
      reactions: json['reactions'] != null
          ? (json['reactions'] as List)
              .map((e) => ChatMessageReactionModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

class ChatUserModel {
  final String id;
  final String name;
  final String username;
  final String? profilePhoto;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.username,
    this.profilePhoto,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      profilePhoto: json['profilePhoto'],
    );
  }
}

class ChatMessageReactionModel {
  final String id;
  final String messageId;
  final String userId;
  final String emoji;
  final String createdAt;

  ChatMessageReactionModel({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  factory ChatMessageReactionModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageReactionModel(
      id: json['id'] ?? '',
      messageId: json['messageId'] ?? '',
      userId: json['userId'] ?? '',
      emoji: json['emoji'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
