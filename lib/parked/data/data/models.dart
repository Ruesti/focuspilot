// Lightweight Models für UI/Services. (Optional – du kannst auch direkt mit Drift-DataClasses arbeiten.)


enum Role { user, assistant }


class ConversationModel {
final String id;
final String title;
final String userId;
final DateTime updatedAt;
final bool deleted;
ConversationModel({
required this.id,
required this.title,
required this.userId,
required this.updatedAt,
this.deleted = false,
});
}


class MessageModel {
final String id;
final String conversationId;
final Role role;
final String content;
final DateTime updatedAt;
final bool deleted;
MessageModel({
required this.id,
required this.conversationId,
required this.role,
required this.content,
required this.updatedAt,
this.deleted = false,
});
}