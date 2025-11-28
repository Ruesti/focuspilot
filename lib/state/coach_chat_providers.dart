import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_models.dart';
import '../repositories/chat_repository.dart';
import '../services/gpt_service.dart';
import 'chat_providers.dart'; // für chatRepositoryProvider

class CoachChatState {
  final ChatThread? thread;
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  CoachChatState({
    required this.thread,
    required this.messages,
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  CoachChatState copyWith({
    ChatThread? thread,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return CoachChatState(
      thread: thread ?? this.thread,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }

  factory CoachChatState.initial() => CoachChatState(
        thread: null,
        messages: const [],
        isLoading: true,
        isSending: false,
      );
}

class CoachChatNotifier extends StateNotifier<CoachChatState> {
  final ChatRepository _repo;

  CoachChatNotifier(this._repo) : super(CoachChatState.initial()) {
    _init();
  }

  Future<void> _init() async {
    try {
      // eigener Coach-Thread, unabhängig von normalen / Projekt-Chats
      final thread = await _repo.getOrCreateCoachThread();
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

  Future<void> sendCoachMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending || state.thread == null) return;

    final thread = state.thread!;
    state = state.copyWith(isSending: true, error: null);

    // 1) User-Nachricht speichern
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

      final prompt = '''
Du bist ein ruhiger, respektvoller Fokus-Coach für eine Person mit vielen Projekten und AD(H)S-Tendenzen.

Nutzername: $userName

Sprich den Nutzer in Du-Form an, ohne Druck, ohne Esoterik.
Hilf beim Sortieren von Gedanken, Prioritäten und schlechtem Gewissen.
Antwort locker, aber nicht flapsig. Kein Motivations-Guru-Sprech.

Nachricht vom Nutzer:
$trimmed
''';

      // eigene "Coach-Prompt"-Verpackung, aber gleiche Function
      final replyText = await GPTService.sendPrompt(prompt);

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
        content:
            'Da ist etwas schiefgelaufen:\n${e.toString()}\n\nDu kannst es gleich nochmal versuchen.',
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

final coachChatProvider =
    StateNotifierProvider<CoachChatNotifier, CoachChatState>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return CoachChatNotifier(repo);
});
