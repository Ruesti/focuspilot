import 'package:drift/drift.dart';
import 'db.dart';

class ConversationDao {
  ConversationDao(this.db);
  final AppDatabase db;

  Future<void> upsertConversation(ConversationsLocalCompanion row) async {
    await db.into(db.conversationsLocal).insertOnConflictUpdate(row);
  }

  Stream<List<ConversationsLocalData>> watchAll() =>
      (db.select(db.conversationsLocal)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)]))
      .watch();

  Future<ConversationsLocalData?> getById(String id) async =>
      (db.select(db.conversationsLocal)..where((t) => t.id.equals(id))).getSingleOrNull();
}

class MessageDao {
  MessageDao(this.db);
  final AppDatabase db;

  Stream<List<MessagesLocalData>> watchByConversation(String conversationId) =>
      (db.select(db.messagesLocal)
            ..where((t) => t.conversationId.equals(conversationId) & t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.updatedAt)]))
      .watch();

  Future<void> upsertMessage(MessagesLocalCompanion row) async {
    await db.into(db.messagesLocal).insertOnConflictUpdate(row);
  }
}

class SectionDao {
  SectionDao(this.db);
  final AppDatabase db;

  Stream<List<MessageSectionsLocalData>> watchByMessage(String messageId) =>
      (db.select(db.messageSectionsLocal)
            ..where((t) => t.messageId.equals(messageId) & t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.idx)]))
      .watch();

  Future<void> upsertSection(MessageSectionsLocalCompanion row) async {
    await db.into(db.messageSectionsLocal).insertOnConflictUpdate(row);
  }
}

class ThreadDao {
  ThreadDao(this.db);
  final AppDatabase db;

  Stream<List<ThreadsLocalData>> watchByConversation(String conversationId) =>
      (db.select(db.threadsLocal)
            ..where((t) => t.conversationId.equals(conversationId) & t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)]))
      .watch();

  Future<void> upsertThread(ThreadsLocalCompanion row) async {
    await db.into(db.threadsLocal).insertOnConflictUpdate(row);
  }
}

class ThreadMessageDao {
  ThreadMessageDao(this.db);
  final AppDatabase db;

  Stream<List<ThreadMessagesLocalData>> watchByThread(String threadId) =>
      (db.select(db.threadMessagesLocal)
            ..where((t) => t.threadId.equals(threadId) & t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.updatedAt)]))
      .watch();

  Future<void> upsertThreadMessage(ThreadMessagesLocalCompanion row) async {
    await db.into(db.threadMessagesLocal).insertOnConflictUpdate(row);
  }
}

class SyncStateDao {
  SyncStateDao(this.db);
  final AppDatabase db;

  Future<DateTime?> getLastPull(String table) async {
    final row = await (db.select(db.syncState)
          ..where((t) => t.tableKey.equals(table)))
        .getSingleOrNull();
    return row?.lastPulledAt;
  }

  Future<void> setLastPull(String table, DateTime? ts) async {
    await db.into(db.syncState).insertOnConflictUpdate(SyncStateCompanion(
      tableKey: Value(table),
      lastPulledAt: Value(ts),
    ));
  }
}
