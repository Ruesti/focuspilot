import 'package:flutter/material.dart';
import '../widgets/side_thread_overlay.dart';
import '../state/side_thread_state.dart';
import '../state/journal_state.dart';

class ChatMessage {
  final String id;
  final String role; // 'user' | 'assistant'
  final String text;
  final DateTime createdAt;
  const ChatMessage({required this.id, required this.role, required this.text, required this.createdAt});
}

class GPTChatPage extends StatefulWidget {
  const GPTChatPage({super.key});

  @override
  State<GPTChatPage> createState() => _GPTChatPageState();
}

class _GPTChatPageState extends State<GPTChatPage> {
  final List<ChatMessage> _msgs = [];
  final _input = TextEditingController();
  final String _chatId = UniqueKey().toString();
  String? _focusedRootMessageId; // für Nebenchat-Fokus auf eine Nachricht
  int _openSignal = 0;           // um Overlay gezielt zu öffnen

  Future<String> _sendToAssistant(String prompt) async {
    // TODO: hier echte GPT-Integration aufrufen.
    await Future.delayed(const Duration(milliseconds: 350));
    return "Echo: $prompt"; // Platzhalter
  }

  void _send() async {
    final t = _input.text.trim();
    if (t.isEmpty) return;

    setState(() {
      _msgs.add(ChatMessage(id: UniqueKey().toString(), role: 'user', text: t, createdAt: DateTime.now()));
    });
    _input.clear();

    // Assistant-Antwort simulieren / integrieren
    final reply = await _sendToAssistant(t);

    setState(() {
      _msgs.add(ChatMessage(id: UniqueKey().toString(), role: 'assistant', text: reply, createdAt: DateTime.now()));
    });

    // Journal-Hook (optional, wenn Auto-Journal an)
    journalController.onAssistantReply(reply);
  }

  Widget _bubble(ChatMessage m) {
    final isUser = m.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Card(
          color: isUser ? Theme.of(context).colorScheme.primaryContainer : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Text(m.text)),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'nj') {
                      // Nebenchat zu dieser Nachricht fokussieren & Overlay öffnen
                      setState(() {
                        _focusedRootMessageId = m.id;
                        _openSignal++; // Signal steigern → Overlay öffnet
                      });
                    } else if (v == 'to_journal') {
                      journalController.addPlanFromText(m.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Zum Journal übernommen')),
                      );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'nj', child: Text('Nebenchat öffnen')),
                    PopupMenuItem(value: 'to_journal', child: Text('Ins Journal übernehmen')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPT Chat'),
        actions: [
          IconButton(
            tooltip: journalController.autoCapture ? 'Auto‑Journal: AN' : 'Auto‑Journal: AUS',
            icon: Icon(journalController.autoCapture ? Icons.auto_mode : Icons.auto_awesome_motion),
            onPressed: () {
              setState(() => journalController.autoCapture = !journalController.autoCapture);
              final on = journalController.autoCapture ? 'an' : 'aus';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auto‑Journal $on')));
            },
          ),
          IconButton(
            tooltip: 'Speicherziel Nebenchat',
            icon: const Icon(Icons.save),
            onPressed: () => sideThreadController.pickStorage(context, _chatId),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _msgs.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _bubble(_msgs[i]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        decoration: const InputDecoration(
                          hintText: 'Nachricht an GPT…',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: _send, child: const Text('Senden')),
                  ],
                ),
              ),
            ],
          ),

          // Nebenchat-Overlay (läuft mit, kommt per Bubble/Signal nach vorne)
          SideThreadOverlay(
            chatId: _chatId,
            rootMessageId: _focusedRootMessageId,
            openSignal: _openSignal,
          ),
        ],
      ),
    );
  }
}