import 'package:flutter/material.dart';


class JournalController extends ChangeNotifier {
  String _markdown = _baseTemplate;
  String get markdown => _markdown;

  bool autoCapture = false; // Schalter: Journal läuft „mit“

  void rebuildFromThread(List<dynamic> messages) {
    // optional – nur falls du das Thread-Feature nutzt.
  }

  // Manuell: Text ins Journal
  void addPlanFromText(String text) {
    final cleaned = text.trim().isEmpty ? '(leer)' : text.trim();
    final injected = '- $cleaned';
    _markdown = _markdown.replaceFirst('{PLANS}', '$injected\n{PLANS}');
    notifyListeners();
  }

  // Hook: nach jeder GPT-Antwort optional auto-capturen (MVP simpel)
  void onAssistantReply(String replyText) {
    if (!autoCapture) return;
    // naive Heuristik: erste Zeile als Plan-Notiz
    final firstLine = replyText.split('\n').first.trim();
    addPlanFromText(firstLine.isEmpty ? replyText : firstLine);
  }
}

final journalController = JournalController();

const String _baseTemplate = '''
# Projekt-Script (MVP)

## 1. Plan / Notizen
{PLANS}

## 2. Snippets (später automatisch)
- 

## 3. Teileliste (später automatisch)
- 
''';
