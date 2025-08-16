import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

// -----------------------------
// Tabellen
// -----------------------------

class ConversationsLocal extends Table {
  TextColumn get id => text()(); // UUID (String)
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get userId => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class MessagesLocal extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get role => text()(); // 'user' | 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class MessageSectionsLocal extends Table {
  TextColumn get id => text()();
  TextColumn get messageId => text()();
  IntColumn get idx => integer()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class ThreadsLocal extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get rootMessageId => text()();
  TextColumn get sectionId => text()();
  TextColumn get title => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class ThreadMessagesLocal extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get role => text()(); // 'user' | 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class SyncState extends Table {
  TextColumn get tableKey => text()(); // z.B. 'messages'
  DateTimeColumn get lastPulledAt => dateTime().nullable()();
  TextColumn get cursor => text().nullable()();
  @override
  Set<Column> get primaryKey => {tableKey};
}

// -----------------------------
// Datenbank-Klasse
// -----------------------------

@DriftDatabase(
  tables: [
    ConversationsLocal,
    MessagesLocal,
    MessageSectionsLocal,
    ThreadsLocal,
    ThreadMessagesLocal,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  @override
  int get schemaVersion => 1;
}

// -----------------------------
// Connection
// -----------------------------

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'focuspilot.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
