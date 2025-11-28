import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_models.dart';
import '../repositories/chat_repository.dart';
import '../services/gpt_service.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final client = Supabase.instance.client;
  return ChatRepository(client);
});

class ChatState {
  final ChatThread? thread;
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  ChatState({
    required this.thread,
    required this.messages,
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  ChatState copyWith({
    ChatThread? thread,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ChatState(
      thread: thread ?? this.thread,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }

  factory ChatState.initial() => ChatState(
        thread: null,
        messages: const [],
        isLoading: true,
        isSending: false,
      );
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repo;

  ChatNotifier(this._repo) : super(ChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final thread = await _repo.getOrCreateMainThread();
      final msgs = await _repo.loadMessages(thread.id);
      state = state.copyWith(
        thread: thread,
        messages: msgs,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Beliebigen Thread öffnen (z. B. aus dem Hub)
  Future<void> openThread(ChatThread thread) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final msgs = await _repo.loadMessages(thread.id);
      state = state.copyWith(
        thread: thread,
        messages: msgs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Neuen Thread erstellen und direkt öffnen
  Future<ChatThread> createAndOpenThread({
    required String kind,
    String? title,
  }) async {
    final thread = await _repo.createThread(kind: kind, title: title);
    await openThread(thread);
    return thread;
  }

  Future<void> sendUserMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending || state.thread == null) return;

    final thread = state.thread!;
    state = state.copyWith(isSending: true, error: null);

    // 1) User-Message in Supabase
    final userMsg = await _repo.addMessage(
      threadId: thread.id,
      role: 'user',
      content: trimmed,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
    );

    try {
      final user = Supabase.instance.client.auth.currentUser;
      final userName = user?.userMetadata?['display_name'] ??
          user?.userMetadata?['name'] ??
          'Du';

      final fullPrompt =
          '$userName schreibt: $trimmed\n\nAntwort bitte in Du-Form, ruhig, freundlich und konkret.';

      final replyText = await GPTService.sendPrompt(fullPrompt);

      final assistantMsg = await _repo.addMessage(
        threadId: thread.id,
        role: 'assistant',
        content: replyText,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isSending: false,
      );
    } catch (e) {
      final errorMsg = await _repo.addMessage(
        threadId: thread.id,
        role: 'assistant',
        content: 'Fehler: ${e.toString()}',
        isError: true,
      );

      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isSending: false,
        error: e.toString(),
      );
    }
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repo);
});
