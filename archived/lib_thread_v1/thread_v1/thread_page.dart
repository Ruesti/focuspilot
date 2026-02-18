import 'package:flutter/material.dart';
import '../state/thread_state.dart';
import '../state/journal_state.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final _controller = TextEditingController();

  void _addMessage() {
    final t = _controller.text.trim();
    if (t.isEmpty) return;
    threadController.add(t);
    _controller.clear();
  }

  void _togglePin(String id, bool value) {
    threadController.togglePin(id, value);
    // Journal aus allen aktuell gepinnten Einträgen neu erzeugen (MVP)
    journalController.rebuildFromThread(threadController.messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thread')),
      body: AnimatedBuilder(
        animation: threadController,
        builder: (context, _) {
          final items = threadController.messages;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Notiz / Idee / Entscheidung…',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: _addMessage, child: const Text('Add')),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemBuilder: (context, i) {
                    final m = items[i];
                    return Card(
                      child: ListTile(
                        title: Text(m.text),
                        subtitle: Text(m.createdAt.toIso8601String()),
                        trailing: IconButton(
                          tooltip: m.pinnedToJournal
                              ? 'Aus Journal entfernen'
                              : 'Zum Journal hinzufügen',
                          icon: Icon(
                            m.pinnedToJournal ? Icons.push_pin : Icons.push_pin_outlined,
                          ),
                          onPressed: () => _togglePin(m.id, !m.pinnedToJournal),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: items.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
