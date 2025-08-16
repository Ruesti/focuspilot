import 'dart:async';
import 'package:drift/drift.dart';
import '../local/db.dart';

class SyncService {
  SyncService(this.db);
  final AppDatabase db;

  // ---- Public API ----

  Future<void> pullAll({required String conversationId}) async {
    // TODO: GET /pull?conversation_id=...&since=...
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await _setLastPullNow('messages');
    await _setLastPullNow('message_sections');
    await _setLastPullNow('threads');
    await _setLastPullNow('thread_messages');
  }

  Future<void> pushQueue() async {
    final dirtyMessages =
        await (db.select(db.messagesLocal)..where((t) => t.dirty.equals(true))).get();
    final dirtySections =
        await (db.select(db.messageSectionsLocal)..where((t) => t.dirty.equals(true))).get();
    final dirtyThreads =
        await (db.select(db.threadsLocal)..where((t) => t.dirty.equals(true))).get();
    final dirtyThreadMsgs =
        await (db.select(db.threadMessagesLocal)..where((t) => t.dirty.equals(true))).get();

    for (final m in dirtyMessages) {
      await _simulateNetwork();
      await _markClean(db.messagesLocal, m.id);
    }
    for (final s in dirtySections) {
      await _simulateNetwork();
      await _markClean(db.messageSectionsLocal, s.id);
    }
    for (final t in dirtyThreads) {
      await _simulateNetwork();
      await _markClean(db.threadsLocal, t.id);
    }
    for (final tm in dirtyThreadMsgs) {
      await _simulateNetwork();
      await _markClean(db.threadMessagesLocal, tm.id);
    }
  }

  Future<void> createLocalUserMessage({
    required String id,
    required String conversationId,
    required String content,
  }) async {
    await db.into(db.messagesLocal).insertOnConflictUpdate(MessagesLocalCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: const Value('user'),
      content: Value(content),
      updatedAt: Value(DateTime.now()),
      dirty: const Value(true),
    ));
  }

  Future<void> createLocalThreadMessage({
    required String id,
    required String threadId,
    required String content,
    bool isAssistant = false,
  }) async {
    await db
        .into(db.threadMessagesLocal)
        .insertOnConflictUpdate(ThreadMessagesLocalCompanion(
          id: Value(id),
          threadId: Value(threadId),
          role: Value(isAssistant ? 'assistant' : 'user'),
          content: Value(content),
          updatedAt: Value(DateTime.now()),
          dirty: const Value(true),
        ));
  }

  // ---- Intern ----

  Future<void> _markClean<T extends Table, D>(
    TableInfo<T, D> table,
    String id,
  ) async {
    final tn = table.actualTableName;

    if (tn == db.messagesLocal.actualTableName) {
      await (db.update(db.messagesLocal)..where((t) => t.id.equals(id)))
          .write(const MessagesLocalCompanion(dirty: Value(false)));
    } else if (tn == db.messageSectionsLocal.actualTableName) {
      await (db.update(db.messageSectionsLocal)..where((t) => t.id.equals(id)))
          .write(const MessageSectionsLocalCompanion(dirty: Value(false)));
    } else if (tn == db.threadsLocal.actualTableName) {
      await (db.update(db.threadsLocal)..where((t) => t.id.equals(id)))
          .write(const ThreadsLocalCompanion(dirty: Value(false)));
    } else if (tn == db.threadMessagesLocal.actualTableName) {
      await (db.update(db.threadMessagesLocal)..where((t) => t.id.equals(id)))
          .write(const ThreadMessagesLocalCompanion(dirty: Value(false)));
    } else {
      // ignore: avoid_print
      print('[_markClean] Unbekannte Tabelle: $tn');
    }
  }

  Future<void> _simulateNetwork() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
  }

  Future<void> _setLastPullNow(String table) async {
    await db.into(db.syncState).insertOnConflictUpdate(SyncStateCompanion(
      tableKey: Value(table),
      lastPulledAt: Value(DateTime.now()),
    ));
  }
}
