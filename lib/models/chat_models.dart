import 'package:meta/meta.dart';

@immutable
class ChatThread {
  final String id;
  final String userId;
  final String? title;
  final String kind; // z.B. 'main', 'side', 'journal', 'project'
  final DateTime createdAt;

  const ChatThread({
    required this.id,
    required this.userId,
    required this.kind,
    required this.createdAt,
    this.title,
  });

  factory ChatThread.fromMap(Map<String, dynamic> map) {
    return ChatThread(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String?,
      kind: map['kind'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

@immutable
class ChatMessage {
  final String id;
  final String threadId;
  final String userId;
  final String role; // 'user', 'assistant', 'system'
  final String content;
  final bool isError;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.role,
    required this.content,
    required this.isError,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      threadId: map['thread_id'] as String,
      userId: map['user_id'] as String,
      role: map['role'] as String,
      content: map['content'] as String,
      isError: (map['is_error'] as bool?) ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'thread_id': threadId,
      'user_id': userId,
      'role': role,
      'content': content,
      'is_error': isError,
    };
  }
}
