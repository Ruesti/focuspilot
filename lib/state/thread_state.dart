import 'package:flutter/material.dart';
import 'side_thread_state.dart';

/// UI-Model für ThreadPage/JournalPage (inkl. Pin-Status)
class ThreadMessage {
  final String id;
  final String text;
  final DateTime createdAt;
  final bool pinnedToJournal;

  const ThreadMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.pinnedToJournal,
  });
}

/// Wrapper-Controller, der intern die Side-Threads nutzt,
/// aber einen separaten Pin-Status verwaltet (nur lokal/MVP).
class ThreadController extends ChangeNotifier {
  // Wir nehmen für den Thread-Screen einen Default-Chat-Kontext.
  static const String _defaultChatId = 'default';

  // Lokaler Pin-Status (MVP). Später in SideThreadEntry persistieren.
  final Set<String> _pinnedIds = <String>{};

  /// Liefert die SideThread-Einträge als ThreadMessages inkl. Pin-Flag.
  List<ThreadMessage> get messages {
    final entries = sideThreadController.entriesFor(chatId: _defaultChatId);
    return entries
        .map((e) => ThreadMessage(
              id: e.id,
              text: e.text,
              createdAt: e.createdAt,
              pinnedToJournal: _pinnedIds.contains(e.id),
            ))
        .toList();
  }

  /// Fügt einen neuen Eintrag in den Default-SideThread ein.
  void add(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    sideThreadController.add(chatId: _defaultChatId, text: t);
    notifyListeners();
  }

  /// Pin/Unpin (nur lokaler Status im MVP)
  void togglePin(String id, bool value) {
    if (value) {
      _pinnedIds.add(id);
    } else {
      _pinnedIds.remove(id);
    }
    notifyListeners();
  }
}

// Singleton wie gehabt
final threadController = ThreadController();
