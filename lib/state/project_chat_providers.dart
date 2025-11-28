import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_models.dart';
import '../repositories/chat_repository.dart';
import '../services/gpt_service.dart';
import 'chat_providers.dart'; // für chatRepositoryProvider

class ProjectChatState {
  final String projectId;
  final ChatThread? thread;
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  ProjectChatState({
    required this.projectId,
    required this.thread,
    required this.messages,
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  ProjectChatState copyWith({
    ChatThread? thread,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ProjectChatState(
      projectId: projectId,
      thread: thread ?? this.thread,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }

  factory ProjectChatState.initial(String projectId) => ProjectChatState(
        projectId: projectId,
        thread: null,
        messages: const [],
        isLoading: true,
        isSending: false,
      );
}

class ProjectChatNotifier extends StateNotifier<ProjectChatState> {
  final ChatRepository _repo;

  ProjectChatNotifier({
    required ChatRepository repo,
    required String projectId,
  })  : _repo = repo,
        super(ProjectChatState.initial(projectId)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final thread = await _getOrCreateProjectThread(state.projectId);
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

  Future<ChatThread> _getOrCreateProjectThread(String projectId) async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('Nicht eingeloggt.');
    }

    // vorhandenen Projekt-Thread suchen
    final existing = await client
        .from('chat_threads')
        .select()
        .eq('user_id', user.id)
        .eq('project_id', projectId)
        .eq('kind', 'project_main')
        .limit(1);

    if (existing.isNotEmpty) {
      return ChatThread.fromMap(existing.first as Map<String, dynamic>);
    }

    // Projektname laden (optional, für den Titel)
    final project = await client
        .from('projects')
        .select('name')
        .eq('id', projectId)
        .single();

    final title = 'Projektchat: ${project['name']}';

    // neuen Thread anlegen
    return _repo.createThread(
      kind: 'project_main',
      title: title,
      projectId: projectId,
    );
  }

  Future<void> sendProjectMessage(String text) async {
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
      // vorerst noch dieselbe Funktion wie der Coach-Chat
      final replyText = await GPTService.sendPrompt(
        '[Projekt-ID: ${state.projectId}] $trimmed',
      );

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

/// family-Provider: ein State pro Projekt
final projectChatProvider = StateNotifierProvider.family<
    ProjectChatNotifier,
    ProjectChatState,
    String>((ref, projectId) {
  final repo = ref.watch(chatRepositoryProvider);
  return ProjectChatNotifier(repo: repo, projectId: projectId);
});
