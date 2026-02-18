// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ConversationsLocalTable extends ConversationsLocal
    with TableInfo<$ConversationsLocalTable, ConversationsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    userId,
    updatedAt,
    dirty,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationsLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $ConversationsLocalTable createAlias(String alias) {
    return $ConversationsLocalTable(attachedDatabase, alias);
  }
}

class ConversationsLocalData extends DataClass
    implements Insertable<ConversationsLocalData> {
  final String id;
  final String title;
  final String userId;
  final DateTime updatedAt;
  final bool dirty;
  final bool deleted;
  const ConversationsLocalData({
    required this.id,
    required this.title,
    required this.userId,
    required this.updatedAt,
    required this.dirty,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['user_id'] = Variable<String>(userId);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ConversationsLocalCompanion toCompanion(bool nullToAbsent) {
    return ConversationsLocalCompanion(
      id: Value(id),
      title: Value(title),
      userId: Value(userId),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deleted: Value(deleted),
    );
  }

  factory ConversationsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationsLocalData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      userId: serializer.fromJson<String>(json['userId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'userId': serializer.toJson<String>(userId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  ConversationsLocalData copyWith({
    String? id,
    String? title,
    String? userId,
    DateTime? updatedAt,
    bool? dirty,
    bool? deleted,
  }) => ConversationsLocalData(
    id: id ?? this.id,
    title: title ?? this.title,
    userId: userId ?? this.userId,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deleted: deleted ?? this.deleted,
  );
  ConversationsLocalData copyWithCompanion(ConversationsLocalCompanion data) {
    return ConversationsLocalData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      userId: data.userId.present ? data.userId.value : this.userId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsLocalData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('userId: $userId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, userId, updatedAt, dirty, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationsLocalData &&
          other.id == this.id &&
          other.title == this.title &&
          other.userId == this.userId &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deleted == this.deleted);
}

class ConversationsLocalCompanion
    extends UpdateCompanion<ConversationsLocalData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> userId;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ConversationsLocalCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.userId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsLocalCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    required String userId,
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId);
  static Insertable<ConversationsLocalData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? userId,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (userId != null) 'user_id': userId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? userId,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return ConversationsLocalCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsLocalCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('userId: $userId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesLocalTable extends MessagesLocal
    with TableInfo<$MessagesLocalTable, MessagesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    role,
    content,
    updatedAt,
    dirty,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessagesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessagesLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $MessagesLocalTable createAlias(String alias) {
    return $MessagesLocalTable(attachedDatabase, alias);
  }
}

class MessagesLocalData extends DataClass
    implements Insertable<MessagesLocalData> {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final DateTime updatedAt;
  final bool dirty;
  final bool deleted;
  const MessagesLocalData({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.updatedAt,
    required this.dirty,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  MessagesLocalCompanion toCompanion(bool nullToAbsent) {
    return MessagesLocalCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: Value(role),
      content: Value(content),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deleted: Value(deleted),
    );
  }

  factory MessagesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesLocalData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  MessagesLocalData copyWith({
    String? id,
    String? conversationId,
    String? role,
    String? content,
    DateTime? updatedAt,
    bool? dirty,
    bool? deleted,
  }) => MessagesLocalData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    content: content ?? this.content,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deleted: deleted ?? this.deleted,
  );
  MessagesLocalData copyWithCompanion(MessagesLocalCompanion data) {
    return MessagesLocalData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessagesLocalData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conversationId, role, content, updatedAt, dirty, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesLocalData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.content == this.content &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deleted == this.deleted);
}

class MessagesLocalCompanion extends UpdateCompanion<MessagesLocalData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<bool> deleted;
  final Value<int> rowid;
  const MessagesLocalCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesLocalCompanion.insert({
    required String id,
    required String conversationId,
    required String role,
    required String content,
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       role = Value(role),
       content = Value(content);
  static Insertable<MessagesLocalData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return MessagesLocalCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesLocalCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageSectionsLocalTable extends MessageSectionsLocal
    with TableInfo<$MessageSectionsLocalTable, MessageSectionsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageSectionsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idxMeta = const VerificationMeta('idx');
  @override
  late final GeneratedColumn<int> idx = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    idx,
    title,
    body,
    updatedAt,
    dirty,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_sections_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageSectionsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _idxMeta,
        idx.isAcceptableOrUnknown(data['idx']!, _idxMeta),
      );
    } else if (isInserting) {
      context.missing(_idxMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageSectionsLocalData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageSectionsLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      idx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $MessageSectionsLocalTable createAlias(String alias) {
    return $MessageSectionsLocalTable(attachedDatabase, alias);
  }
}

class MessageSectionsLocalData extends DataClass
    implements Insertable<MessageSectionsLocalData> {
  final String id;
  final String messageId;
  final int idx;
  final String title;
  final String body;
  final DateTime updatedAt;
  final bool dirty;
  final bool deleted;
  const MessageSectionsLocalData({
    required this.id,
    required this.messageId,
    required this.idx,
    required this.title,
    required this.body,
    required this.updatedAt,
    required this.dirty,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['idx'] = Variable<int>(idx);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  MessageSectionsLocalCompanion toCompanion(bool nullToAbsent) {
    return MessageSectionsLocalCompanion(
      id: Value(id),
      messageId: Value(messageId),
      idx: Value(idx),
      title: Value(title),
      body: Value(body),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deleted: Value(deleted),
    );
  }

  factory MessageSectionsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageSectionsLocalData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      idx: serializer.fromJson<int>(json['idx']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'idx': serializer.toJson<int>(idx),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  MessageSectionsLocalData copyWith({
    String? id,
    String? messageId,
    int? idx,
    String? title,
    String? body,
    DateTime? updatedAt,
    bool? dirty,
    bool? deleted,
  }) => MessageSectionsLocalData(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    idx: idx ?? this.idx,
    title: title ?? this.title,
    body: body ?? this.body,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deleted: deleted ?? this.deleted,
  );
  MessageSectionsLocalData copyWithCompanion(
    MessageSectionsLocalCompanion data,
  ) {
    return MessageSectionsLocalData(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      idx: data.idx.present ? data.idx.value : this.idx,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageSectionsLocalData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('idx: $idx, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, idx, title, body, updatedAt, dirty, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageSectionsLocalData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.idx == this.idx &&
          other.title == this.title &&
          other.body == this.body &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deleted == this.deleted);
}

class MessageSectionsLocalCompanion
    extends UpdateCompanion<MessageSectionsLocalData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<int> idx;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<bool> deleted;
  final Value<int> rowid;
  const MessageSectionsLocalCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.idx = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageSectionsLocalCompanion.insert({
    required String id,
    required String messageId,
    required int idx,
    this.title = const Value.absent(),
    required String body,
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       messageId = Value(messageId),
       idx = Value(idx),
       body = Value(body);
  static Insertable<MessageSectionsLocalData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<int>? idx,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (idx != null) 'idx': idx,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageSectionsLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? messageId,
    Value<int>? idx,
    Value<String>? title,
    Value<String>? body,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return MessageSectionsLocalCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      idx: idx ?? this.idx,
      title: title ?? this.title,
      body: body ?? this.body,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (idx.present) {
      map['idx'] = Variable<int>(idx.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageSectionsLocalCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('idx: $idx, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThreadsLocalTable extends ThreadsLocal
    with TableInfo<$ThreadsLocalTable, ThreadsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThreadsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rootMessageIdMeta = const VerificationMeta(
    'rootMessageId',
  );
  @override
  late final GeneratedColumn<String> rootMessageId = GeneratedColumn<String>(
    'root_message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    rootMessageId,
    sectionId,
    title,
    updatedAt,
    dirty,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'threads_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThreadsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('root_message_id')) {
      context.handle(
        _rootMessageIdMeta,
        rootMessageId.isAcceptableOrUnknown(
          data['root_message_id']!,
          _rootMessageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rootMessageIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThreadsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThreadsLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      rootMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_message_id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $ThreadsLocalTable createAlias(String alias) {
    return $ThreadsLocalTable(attachedDatabase, alias);
  }
}

class ThreadsLocalData extends DataClass
    implements Insertable<ThreadsLocalData> {
  final String id;
  final String conversationId;
  final String rootMessageId;
  final String sectionId;
  final String title;
  final DateTime updatedAt;
  final bool dirty;
  final bool deleted;
  const ThreadsLocalData({
    required this.id,
    required this.conversationId,
    required this.rootMessageId,
    required this.sectionId,
    required this.title,
    required this.updatedAt,
    required this.dirty,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['root_message_id'] = Variable<String>(rootMessageId);
    map['section_id'] = Variable<String>(sectionId);
    map['title'] = Variable<String>(title);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ThreadsLocalCompanion toCompanion(bool nullToAbsent) {
    return ThreadsLocalCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      rootMessageId: Value(rootMessageId),
      sectionId: Value(sectionId),
      title: Value(title),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deleted: Value(deleted),
    );
  }

  factory ThreadsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThreadsLocalData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      rootMessageId: serializer.fromJson<String>(json['rootMessageId']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      title: serializer.fromJson<String>(json['title']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'rootMessageId': serializer.toJson<String>(rootMessageId),
      'sectionId': serializer.toJson<String>(sectionId),
      'title': serializer.toJson<String>(title),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  ThreadsLocalData copyWith({
    String? id,
    String? conversationId,
    String? rootMessageId,
    String? sectionId,
    String? title,
    DateTime? updatedAt,
    bool? dirty,
    bool? deleted,
  }) => ThreadsLocalData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    rootMessageId: rootMessageId ?? this.rootMessageId,
    sectionId: sectionId ?? this.sectionId,
    title: title ?? this.title,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deleted: deleted ?? this.deleted,
  );
  ThreadsLocalData copyWithCompanion(ThreadsLocalCompanion data) {
    return ThreadsLocalData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      rootMessageId: data.rootMessageId.present
          ? data.rootMessageId.value
          : this.rootMessageId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      title: data.title.present ? data.title.value : this.title,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThreadsLocalData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('rootMessageId: $rootMessageId, ')
          ..write('sectionId: $sectionId, ')
          ..write('title: $title, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    rootMessageId,
    sectionId,
    title,
    updatedAt,
    dirty,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThreadsLocalData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.rootMessageId == this.rootMessageId &&
          other.sectionId == this.sectionId &&
          other.title == this.title &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deleted == this.deleted);
}

class ThreadsLocalCompanion extends UpdateCompanion<ThreadsLocalData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> rootMessageId;
  final Value<String> sectionId;
  final Value<String> title;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ThreadsLocalCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.rootMessageId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.title = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThreadsLocalCompanion.insert({
    required String id,
    required String conversationId,
    required String rootMessageId,
    required String sectionId,
    this.title = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       rootMessageId = Value(rootMessageId),
       sectionId = Value(sectionId);
  static Insertable<ThreadsLocalData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? rootMessageId,
    Expression<String>? sectionId,
    Expression<String>? title,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (rootMessageId != null) 'root_message_id': rootMessageId,
      if (sectionId != null) 'section_id': sectionId,
      if (title != null) 'title': title,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThreadsLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? rootMessageId,
    Value<String>? sectionId,
    Value<String>? title,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return ThreadsLocalCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      rootMessageId: rootMessageId ?? this.rootMessageId,
      sectionId: sectionId ?? this.sectionId,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (rootMessageId.present) {
      map['root_message_id'] = Variable<String>(rootMessageId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThreadsLocalCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('rootMessageId: $rootMessageId, ')
          ..write('sectionId: $sectionId, ')
          ..write('title: $title, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThreadMessagesLocalTable extends ThreadMessagesLocal
    with TableInfo<$ThreadMessagesLocalTable, ThreadMessagesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThreadMessagesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    threadId,
    role,
    content,
    updatedAt,
    dirty,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thread_messages_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThreadMessagesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThreadMessagesLocalData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThreadMessagesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $ThreadMessagesLocalTable createAlias(String alias) {
    return $ThreadMessagesLocalTable(attachedDatabase, alias);
  }
}

class ThreadMessagesLocalData extends DataClass
    implements Insertable<ThreadMessagesLocalData> {
  final String id;
  final String threadId;
  final String role;
  final String content;
  final DateTime updatedAt;
  final bool dirty;
  final bool deleted;
  const ThreadMessagesLocalData({
    required this.id,
    required this.threadId,
    required this.role,
    required this.content,
    required this.updatedAt,
    required this.dirty,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ThreadMessagesLocalCompanion toCompanion(bool nullToAbsent) {
    return ThreadMessagesLocalCompanion(
      id: Value(id),
      threadId: Value(threadId),
      role: Value(role),
      content: Value(content),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      deleted: Value(deleted),
    );
  }

  factory ThreadMessagesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThreadMessagesLocalData(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  ThreadMessagesLocalData copyWith({
    String? id,
    String? threadId,
    String? role,
    String? content,
    DateTime? updatedAt,
    bool? dirty,
    bool? deleted,
  }) => ThreadMessagesLocalData(
    id: id ?? this.id,
    threadId: threadId ?? this.threadId,
    role: role ?? this.role,
    content: content ?? this.content,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    deleted: deleted ?? this.deleted,
  );
  ThreadMessagesLocalData copyWithCompanion(ThreadMessagesLocalCompanion data) {
    return ThreadMessagesLocalData(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThreadMessagesLocalData(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, threadId, role, content, updatedAt, dirty, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThreadMessagesLocalData &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.role == this.role &&
          other.content == this.content &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.deleted == this.deleted);
}

class ThreadMessagesLocalCompanion
    extends UpdateCompanion<ThreadMessagesLocalData> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ThreadMessagesLocalCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThreadMessagesLocalCompanion.insert({
    required String id,
    required String threadId,
    required String role,
    required String content,
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       threadId = Value(threadId),
       role = Value(role),
       content = Value(content);
  static Insertable<ThreadMessagesLocalData> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThreadMessagesLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? threadId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return ThreadMessagesLocalCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      role: role ?? this.role,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThreadMessagesLocalCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableKeyMeta = const VerificationMeta(
    'tableKey',
  );
  @override
  late final GeneratedColumn<String> tableKey = GeneratedColumn<String>(
    'table_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPulledAtMeta = const VerificationMeta(
    'lastPulledAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPulledAt = GeneratedColumn<DateTime>(
    'last_pulled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [tableKey, lastPulledAt, cursor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_key')) {
      context.handle(
        _tableKeyMeta,
        tableKey.isAcceptableOrUnknown(data['table_key']!, _tableKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_tableKeyMeta);
    }
    if (data.containsKey('last_pulled_at')) {
      context.handle(
        _lastPulledAtMeta,
        lastPulledAt.isAcceptableOrUnknown(
          data['last_pulled_at']!,
          _lastPulledAtMeta,
        ),
      );
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableKey};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      tableKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_key'],
      )!,
      lastPulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_pulled_at'],
      ),
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      ),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String tableKey;
  final DateTime? lastPulledAt;
  final String? cursor;
  const SyncStateData({required this.tableKey, this.lastPulledAt, this.cursor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_key'] = Variable<String>(tableKey);
    if (!nullToAbsent || lastPulledAt != null) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt);
    }
    if (!nullToAbsent || cursor != null) {
      map['cursor'] = Variable<String>(cursor);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      tableKey: Value(tableKey),
      lastPulledAt: lastPulledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPulledAt),
      cursor: cursor == null && nullToAbsent
          ? const Value.absent()
          : Value(cursor),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      tableKey: serializer.fromJson<String>(json['tableKey']),
      lastPulledAt: serializer.fromJson<DateTime?>(json['lastPulledAt']),
      cursor: serializer.fromJson<String?>(json['cursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableKey': serializer.toJson<String>(tableKey),
      'lastPulledAt': serializer.toJson<DateTime?>(lastPulledAt),
      'cursor': serializer.toJson<String?>(cursor),
    };
  }

  SyncStateData copyWith({
    String? tableKey,
    Value<DateTime?> lastPulledAt = const Value.absent(),
    Value<String?> cursor = const Value.absent(),
  }) => SyncStateData(
    tableKey: tableKey ?? this.tableKey,
    lastPulledAt: lastPulledAt.present ? lastPulledAt.value : this.lastPulledAt,
    cursor: cursor.present ? cursor.value : this.cursor,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      tableKey: data.tableKey.present ? data.tableKey.value : this.tableKey,
      lastPulledAt: data.lastPulledAt.present
          ? data.lastPulledAt.value
          : this.lastPulledAt,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('tableKey: $tableKey, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('cursor: $cursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tableKey, lastPulledAt, cursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.tableKey == this.tableKey &&
          other.lastPulledAt == this.lastPulledAt &&
          other.cursor == this.cursor);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> tableKey;
  final Value<DateTime?> lastPulledAt;
  final Value<String?> cursor;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.tableKey = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.cursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String tableKey,
    this.lastPulledAt = const Value.absent(),
    this.cursor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tableKey = Value(tableKey);
  static Insertable<SyncStateData> custom({
    Expression<String>? tableKey,
    Expression<DateTime>? lastPulledAt,
    Expression<String>? cursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tableKey != null) 'table_key': tableKey,
      if (lastPulledAt != null) 'last_pulled_at': lastPulledAt,
      if (cursor != null) 'cursor': cursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? tableKey,
    Value<DateTime?>? lastPulledAt,
    Value<String?>? cursor,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      tableKey: tableKey ?? this.tableKey,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      cursor: cursor ?? this.cursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableKey.present) {
      map['table_key'] = Variable<String>(tableKey.value);
    }
    if (lastPulledAt.present) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('tableKey: $tableKey, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('cursor: $cursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConversationsLocalTable conversationsLocal =
      $ConversationsLocalTable(this);
  late final $MessagesLocalTable messagesLocal = $MessagesLocalTable(this);
  late final $MessageSectionsLocalTable messageSectionsLocal =
      $MessageSectionsLocalTable(this);
  late final $ThreadsLocalTable threadsLocal = $ThreadsLocalTable(this);
  late final $ThreadMessagesLocalTable threadMessagesLocal =
      $ThreadMessagesLocalTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    conversationsLocal,
    messagesLocal,
    messageSectionsLocal,
    threadsLocal,
    threadMessagesLocal,
    syncState,
  ];
}

typedef $$ConversationsLocalTableCreateCompanionBuilder =
    ConversationsLocalCompanion Function({
      required String id,
      Value<String> title,
      required String userId,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$ConversationsLocalTableUpdateCompanionBuilder =
    ConversationsLocalCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> userId,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$ConversationsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsLocalTable> {
  $$ConversationsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsLocalTable> {
  $$ConversationsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsLocalTable> {
  $$ConversationsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$ConversationsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsLocalTable,
          ConversationsLocalData,
          $$ConversationsLocalTableFilterComposer,
          $$ConversationsLocalTableOrderingComposer,
          $$ConversationsLocalTableAnnotationComposer,
          $$ConversationsLocalTableCreateCompanionBuilder,
          $$ConversationsLocalTableUpdateCompanionBuilder,
          (
            ConversationsLocalData,
            BaseReferences<
              _$AppDatabase,
              $ConversationsLocalTable,
              ConversationsLocalData
            >,
          ),
          ConversationsLocalData,
          PrefetchHooks Function()
        > {
  $$ConversationsLocalTableTableManager(
    _$AppDatabase db,
    $ConversationsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsLocalCompanion(
                id: id,
                title: title,
                userId: userId,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> title = const Value.absent(),
                required String userId,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsLocalCompanion.insert(
                id: id,
                title: title,
                userId: userId,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsLocalTable,
      ConversationsLocalData,
      $$ConversationsLocalTableFilterComposer,
      $$ConversationsLocalTableOrderingComposer,
      $$ConversationsLocalTableAnnotationComposer,
      $$ConversationsLocalTableCreateCompanionBuilder,
      $$ConversationsLocalTableUpdateCompanionBuilder,
      (
        ConversationsLocalData,
        BaseReferences<
          _$AppDatabase,
          $ConversationsLocalTable,
          ConversationsLocalData
        >,
      ),
      ConversationsLocalData,
      PrefetchHooks Function()
    >;
typedef $$MessagesLocalTableCreateCompanionBuilder =
    MessagesLocalCompanion Function({
      required String id,
      required String conversationId,
      required String role,
      required String content,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$MessagesLocalTableUpdateCompanionBuilder =
    MessagesLocalCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$MessagesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesLocalTable> {
  $$MessagesLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesLocalTable> {
  $$MessagesLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesLocalTable> {
  $$MessagesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$MessagesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesLocalTable,
          MessagesLocalData,
          $$MessagesLocalTableFilterComposer,
          $$MessagesLocalTableOrderingComposer,
          $$MessagesLocalTableAnnotationComposer,
          $$MessagesLocalTableCreateCompanionBuilder,
          $$MessagesLocalTableUpdateCompanionBuilder,
          (
            MessagesLocalData,
            BaseReferences<
              _$AppDatabase,
              $MessagesLocalTable,
              MessagesLocalData
            >,
          ),
          MessagesLocalData,
          PrefetchHooks Function()
        > {
  $$MessagesLocalTableTableManager(_$AppDatabase db, $MessagesLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesLocalCompanion(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String role,
                required String content,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesLocalCompanion.insert(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesLocalTable,
      MessagesLocalData,
      $$MessagesLocalTableFilterComposer,
      $$MessagesLocalTableOrderingComposer,
      $$MessagesLocalTableAnnotationComposer,
      $$MessagesLocalTableCreateCompanionBuilder,
      $$MessagesLocalTableUpdateCompanionBuilder,
      (
        MessagesLocalData,
        BaseReferences<_$AppDatabase, $MessagesLocalTable, MessagesLocalData>,
      ),
      MessagesLocalData,
      PrefetchHooks Function()
    >;
typedef $$MessageSectionsLocalTableCreateCompanionBuilder =
    MessageSectionsLocalCompanion Function({
      required String id,
      required String messageId,
      required int idx,
      Value<String> title,
      required String body,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$MessageSectionsLocalTableUpdateCompanionBuilder =
    MessageSectionsLocalCompanion Function({
      Value<String> id,
      Value<String> messageId,
      Value<int> idx,
      Value<String> title,
      Value<String> body,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$MessageSectionsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $MessageSectionsLocalTable> {
  $$MessageSectionsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessageSectionsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageSectionsLocalTable> {
  $$MessageSectionsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessageSectionsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageSectionsLocalTable> {
  $$MessageSectionsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$MessageSectionsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageSectionsLocalTable,
          MessageSectionsLocalData,
          $$MessageSectionsLocalTableFilterComposer,
          $$MessageSectionsLocalTableOrderingComposer,
          $$MessageSectionsLocalTableAnnotationComposer,
          $$MessageSectionsLocalTableCreateCompanionBuilder,
          $$MessageSectionsLocalTableUpdateCompanionBuilder,
          (
            MessageSectionsLocalData,
            BaseReferences<
              _$AppDatabase,
              $MessageSectionsLocalTable,
              MessageSectionsLocalData
            >,
          ),
          MessageSectionsLocalData,
          PrefetchHooks Function()
        > {
  $$MessageSectionsLocalTableTableManager(
    _$AppDatabase db,
    $MessageSectionsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageSectionsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageSectionsLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MessageSectionsLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<int> idx = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageSectionsLocalCompanion(
                id: id,
                messageId: messageId,
                idx: idx,
                title: title,
                body: body,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String messageId,
                required int idx,
                Value<String> title = const Value.absent(),
                required String body,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageSectionsLocalCompanion.insert(
                id: id,
                messageId: messageId,
                idx: idx,
                title: title,
                body: body,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessageSectionsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageSectionsLocalTable,
      MessageSectionsLocalData,
      $$MessageSectionsLocalTableFilterComposer,
      $$MessageSectionsLocalTableOrderingComposer,
      $$MessageSectionsLocalTableAnnotationComposer,
      $$MessageSectionsLocalTableCreateCompanionBuilder,
      $$MessageSectionsLocalTableUpdateCompanionBuilder,
      (
        MessageSectionsLocalData,
        BaseReferences<
          _$AppDatabase,
          $MessageSectionsLocalTable,
          MessageSectionsLocalData
        >,
      ),
      MessageSectionsLocalData,
      PrefetchHooks Function()
    >;
typedef $$ThreadsLocalTableCreateCompanionBuilder =
    ThreadsLocalCompanion Function({
      required String id,
      required String conversationId,
      required String rootMessageId,
      required String sectionId,
      Value<String> title,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$ThreadsLocalTableUpdateCompanionBuilder =
    ThreadsLocalCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> rootMessageId,
      Value<String> sectionId,
      Value<String> title,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$ThreadsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ThreadsLocalTable> {
  $$ThreadsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootMessageId => $composableBuilder(
    column: $table.rootMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThreadsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ThreadsLocalTable> {
  $$ThreadsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootMessageId => $composableBuilder(
    column: $table.rootMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThreadsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThreadsLocalTable> {
  $$ThreadsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rootMessageId => $composableBuilder(
    column: $table.rootMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$ThreadsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThreadsLocalTable,
          ThreadsLocalData,
          $$ThreadsLocalTableFilterComposer,
          $$ThreadsLocalTableOrderingComposer,
          $$ThreadsLocalTableAnnotationComposer,
          $$ThreadsLocalTableCreateCompanionBuilder,
          $$ThreadsLocalTableUpdateCompanionBuilder,
          (
            ThreadsLocalData,
            BaseReferences<_$AppDatabase, $ThreadsLocalTable, ThreadsLocalData>,
          ),
          ThreadsLocalData,
          PrefetchHooks Function()
        > {
  $$ThreadsLocalTableTableManager(_$AppDatabase db, $ThreadsLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThreadsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThreadsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThreadsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> rootMessageId = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThreadsLocalCompanion(
                id: id,
                conversationId: conversationId,
                rootMessageId: rootMessageId,
                sectionId: sectionId,
                title: title,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String rootMessageId,
                required String sectionId,
                Value<String> title = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThreadsLocalCompanion.insert(
                id: id,
                conversationId: conversationId,
                rootMessageId: rootMessageId,
                sectionId: sectionId,
                title: title,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThreadsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThreadsLocalTable,
      ThreadsLocalData,
      $$ThreadsLocalTableFilterComposer,
      $$ThreadsLocalTableOrderingComposer,
      $$ThreadsLocalTableAnnotationComposer,
      $$ThreadsLocalTableCreateCompanionBuilder,
      $$ThreadsLocalTableUpdateCompanionBuilder,
      (
        ThreadsLocalData,
        BaseReferences<_$AppDatabase, $ThreadsLocalTable, ThreadsLocalData>,
      ),
      ThreadsLocalData,
      PrefetchHooks Function()
    >;
typedef $$ThreadMessagesLocalTableCreateCompanionBuilder =
    ThreadMessagesLocalCompanion Function({
      required String id,
      required String threadId,
      required String role,
      required String content,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$ThreadMessagesLocalTableUpdateCompanionBuilder =
    ThreadMessagesLocalCompanion Function({
      Value<String> id,
      Value<String> threadId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$ThreadMessagesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ThreadMessagesLocalTable> {
  $$ThreadMessagesLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThreadMessagesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ThreadMessagesLocalTable> {
  $$ThreadMessagesLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThreadMessagesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThreadMessagesLocalTable> {
  $$ThreadMessagesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$ThreadMessagesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThreadMessagesLocalTable,
          ThreadMessagesLocalData,
          $$ThreadMessagesLocalTableFilterComposer,
          $$ThreadMessagesLocalTableOrderingComposer,
          $$ThreadMessagesLocalTableAnnotationComposer,
          $$ThreadMessagesLocalTableCreateCompanionBuilder,
          $$ThreadMessagesLocalTableUpdateCompanionBuilder,
          (
            ThreadMessagesLocalData,
            BaseReferences<
              _$AppDatabase,
              $ThreadMessagesLocalTable,
              ThreadMessagesLocalData
            >,
          ),
          ThreadMessagesLocalData,
          PrefetchHooks Function()
        > {
  $$ThreadMessagesLocalTableTableManager(
    _$AppDatabase db,
    $ThreadMessagesLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThreadMessagesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThreadMessagesLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ThreadMessagesLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThreadMessagesLocalCompanion(
                id: id,
                threadId: threadId,
                role: role,
                content: content,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String threadId,
                required String role,
                required String content,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThreadMessagesLocalCompanion.insert(
                id: id,
                threadId: threadId,
                role: role,
                content: content,
                updatedAt: updatedAt,
                dirty: dirty,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThreadMessagesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThreadMessagesLocalTable,
      ThreadMessagesLocalData,
      $$ThreadMessagesLocalTableFilterComposer,
      $$ThreadMessagesLocalTableOrderingComposer,
      $$ThreadMessagesLocalTableAnnotationComposer,
      $$ThreadMessagesLocalTableCreateCompanionBuilder,
      $$ThreadMessagesLocalTableUpdateCompanionBuilder,
      (
        ThreadMessagesLocalData,
        BaseReferences<
          _$AppDatabase,
          $ThreadMessagesLocalTable,
          ThreadMessagesLocalData
        >,
      ),
      ThreadMessagesLocalData,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String tableKey,
      Value<DateTime?> lastPulledAt,
      Value<String?> cursor,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> tableKey,
      Value<DateTime?> lastPulledAt,
      Value<String?> cursor,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tableKey => $composableBuilder(
    column: $table.tableKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tableKey => $composableBuilder(
    column: $table.tableKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tableKey =>
      $composableBuilder(column: $table.tableKey, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tableKey = const Value.absent(),
                Value<DateTime?> lastPulledAt = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                tableKey: tableKey,
                lastPulledAt: lastPulledAt,
                cursor: cursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tableKey,
                Value<DateTime?> lastPulledAt = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                tableKey: tableKey,
                lastPulledAt: lastPulledAt,
                cursor: cursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConversationsLocalTableTableManager get conversationsLocal =>
      $$ConversationsLocalTableTableManager(_db, _db.conversationsLocal);
  $$MessagesLocalTableTableManager get messagesLocal =>
      $$MessagesLocalTableTableManager(_db, _db.messagesLocal);
  $$MessageSectionsLocalTableTableManager get messageSectionsLocal =>
      $$MessageSectionsLocalTableTableManager(_db, _db.messageSectionsLocal);
  $$ThreadsLocalTableTableManager get threadsLocal =>
      $$ThreadsLocalTableTableManager(_db, _db.threadsLocal);
  $$ThreadMessagesLocalTableTableManager get threadMessagesLocal =>
      $$ThreadMessagesLocalTableTableManager(_db, _db.threadMessagesLocal);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}
