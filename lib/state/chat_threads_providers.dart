import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_models.dart';
import '../repositories/chat_repository.dart';
import 'chat_providers.dart';

final chatThreadsProvider =
    StateNotifierProvider<ChatThreadsNotifier, AsyncValue<List<ChatThread>>>(
  (ref) {
    final repo = ref.watch(chatRepositoryProvider);
    return ChatThreadsNotifier(repo);
  },
);

class ChatThreadsNotifier
    extends StateNotifier<AsyncValue<List<ChatThread>>> {
  final ChatRepository _repo;

  ChatThreadsNotifier(this._repo)
      : super(const AsyncValue.loading()) {
    loadThreads();
  }

  Future<void> loadThreads() async {
    try {
      final threads = await _repo.listThreadsForCurrentUser();
      state = AsyncValue.data(threads);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ChatThread> createThread({
    required String kind,
    String? title,
  }) async {
    final thread = await _repo.createThread(kind: kind, title: title);
    final current = state.value ?? const <ChatThread>[];
    state = AsyncValue.data([thread, ...current]);
    return thread;
  }
}
