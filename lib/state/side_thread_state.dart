import 'package:flutter/material.dart';

class SideThreadEntry {
  final String id;
  final String chatId;
  final String? rootMessageId;
  final String text;
  final DateTime createdAt;

  const SideThreadEntry({
    required this.id,
    required this.chatId,
    required this.text,
    required this.createdAt,
    this.rootMessageId,
  });
}

enum StorageTarget { local, userCloud, supabase }

class SideThreadController extends ChangeNotifier {
  final List<SideThreadEntry> _entries = [];
  final Map<String, StorageTarget> _storageByChat = {}; // chatId -> target

  List<SideThreadEntry> entriesFor({required String chatId, String? rootMessageId}) {
    final list = _entries.where((e) =>
      e.chatId == chatId && e.rootMessageId == rootMessageId
    ).toList();
    list.sort((a,b)=>b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int countForChat(String chatId) => _entries.where((e) => e.chatId == chatId).length;

  void add({required String chatId, String? rootMessageId, required String text}) {
    final t = text.trim();
    if (t.isEmpty) return;
    _entries.add(SideThreadEntry(
      id: UniqueKey().toString(),
      chatId: chatId,
      rootMessageId: rootMessageId,
      text: t,
      createdAt: DateTime.now(),
    ));
    // TODO: je nach _storageByChat[chatId] -> persistieren
    notifyListeners();
  }

  StorageTarget storageForChat(String chatId) =>
      _storageByChat[chatId] ?? StorageTarget.local;

  String _labelForStorageTarget(StorageTarget t) {
    if (t == StorageTarget.local) return 'Nur lokal';
    if (t == StorageTarget.userCloud) return 'Eigene Cloud';
    return 'Supabase (Team/Sync)';
  }

  Future<void> pickStorage(BuildContext context, String chatId) async {
    final current = storageForChat(chatId);
    final choice = await showModalBottomSheet<StorageTarget>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(title: Text('Speicherziel für Nebenchat')),
          for (final t in StorageTarget.values)
            RadioListTile<StorageTarget>(
              value: t,
              groupValue: current,
              title: Text(_labelForStorageTarget(t)),
              onChanged: (v) => Navigator.of(context).pop(v),
            ),
        ]),
      ),
    );
    if (choice != null) {
      _storageByChat[chatId] = choice;
      notifyListeners();
    }
  }
}

// globaler, einfacher Controller (MVP)
final sideThreadController = SideThreadController();
