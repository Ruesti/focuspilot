// lib/repositories/chat_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_models.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  /// 🔹 Coach-Thread (ein fortlaufender Haupt-Chat, getrennt vom Rest)
  Future<ChatThread> getOrCreateCoachThread() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final userId = user.id;

    final existing = await _client
        .from('chat_threads')
        .select()
        .eq('user_id', userId)
        .eq('kind', 'coach_main')
        .limit(1);

    if (existing.isNotEmpty) {
      return ChatThread.fromMap(existing.first);
    }

    final inserted = await _client
        .from('chat_threads')
        .insert({
          'user_id': userId,
          'kind': 'coach_main',
          'title': 'Coach-Chat',
        })
        .select()
        .single();

    return ChatThread.fromMap(inserted);
  }

  /// 🔹 Alias für ältere Stellen
  Future<ChatThread> getOrCreateMainThread() => getOrCreateCoachThread();

  /// 🔹 Projekt-Thread pro Projekt (Haupt-Projektchat)
  Future<ChatThread> getOrCreateProjectThread(String projectId) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final existing = await _client
        .from('chat_threads')
        .select()
        .eq('user_id', user.id)
        .eq('project_id', projectId)
        .eq('kind', 'project_main')
        .limit(1);

    if (existing.isNotEmpty) {
      return ChatThread.fromMap(existing.first);
    }

    final project = await _client
        .from('projects')
        .select('name')
        .eq('id', projectId)
        .single();

    final title = 'Projekt: ${project['name']}';

    final inserted = await _client
        .from('chat_threads')
        .insert({
          'user_id': user.id,
          'kind': 'project_main',
          'title': title,
          'project_id': projectId,
        })
        .select()
        .single();

    return ChatThread.fromMap(inserted);
  }

  /// 🔹 Allgemeiner „Inbox“-Chat (nicht projektgebunden, ein Thread)
  Future<ChatThread> getOrCreateGeneralInboxThread() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final userId = user.id;

    final existing = await _client
        .from('chat_threads')
        .select()
        .eq('user_id', userId)
        .eq('kind', 'general_inbox')
        .limit(1);

    if (existing.isNotEmpty) {
      return ChatThread.fromMap(existing.first);
    }

    final inserted = await _client
        .from('chat_threads')
        .insert({
          'user_id': userId,
          'kind': 'general_inbox',
          'title': 'Allgemeiner Chat',
          'project_id': null,
        })
        .select()
        .single();

    return ChatThread.fromMap(inserted);
  }

  /// 🔹 Normale Chats wie in ChatGPT – NICHT projektgebunden
  Future<List<ChatThread>> listGeneralChats() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final res = await _client
        .from('chat_threads')
        .select()
        .eq('user_id', user.id)
        .filter('project_id', 'is', null)
        .eq('kind', 'chat')
        .order('created_at', ascending: false);

    return (res as List)
        .map((row) => ChatThread.fromMap(row))
        .toList();
  }

  /// 🔹 Neuen normalen Chat anlegen (wie „Neue Unterhaltung“)
  Future<ChatThread> createGeneralChat({String? title}) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final data = <String, dynamic>{
      'user_id': user.id,
      'kind': 'chat',
      'title': title,
      'project_id': null,
    };

    final inserted = await _client
        .from('chat_threads')
        .insert(data)
        .select()
        .single();

    return ChatThread.fromMap(inserted);
  }

  /// 🔹 Generische Thread-Erzeugung
  Future<ChatThread> createThread({
    required String kind,
    String? title,
    String? projectId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final data = <String, dynamic>{
      'user_id': user.id,
      'kind': kind,
      'title': title,
      'project_id': projectId,
    };

    final inserted = await _client
        .from('chat_threads')
        .insert(data)
        .select()
        .single();

    return ChatThread.fromMap(inserted);
  }

  /// 🔹 Thread einem Projekt zuordnen (für später: „in Projekt umwandeln“)
  Future<void> assignThreadToProject({
    required String threadId,
    required String projectId,
    String? newKind,
  }) async {
    final update = <String, dynamic>{
      'project_id': projectId,
    };
    if (newKind != null) {
      update['kind'] = newKind;
    }

    await _client
        .from('chat_threads')
        .update(update)
        .eq('id', threadId);
  }

  /// 🔹 Alle Threads des Users (Fallback)
  Future<List<ChatThread>> listThreadsForCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final res = await _client
        .from('chat_threads')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (res as List)
        .map((row) => ChatThread.fromMap(row))
        .toList();
  }

  /// 🔹 Nachrichten eines Threads laden
  Future<List<ChatMessage>> loadMessages(String threadId) async {
    final res = await _client
        .from('chat_messages')
        .select()
        .eq('thread_id', threadId)
        .order('created_at', ascending: true);

    return (res as List)
        .map((row) => ChatMessage.fromMap(row))
        .toList();
  }

  /// 🔹 Nachricht hinzufügen (User oder Assistant)
  Future<ChatMessage> addMessage({
    required String threadId,
    required String role,
    required String content,
    bool isError = false,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    final msg = ChatMessage(
      id: 'temp',
      threadId: threadId,
      userId: user.id,
      role: role,
      content: content,
      isError: isError,
      createdAt: DateTime.now(),
    );

    final inserted = await _client
        .from('chat_messages')
        .insert(msg.toInsertMap())
        .select()
        .single();

    return ChatMessage.fromMap(inserted);
  }
}
