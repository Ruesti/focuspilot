import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../state/journal_state.dart';
import '../state/thread_state.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal (Markdown)')),
      body: AnimatedBuilder(
        animation: journalController,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: Markdown(
                  data: journalController.markdown,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.sync),
                      label: const Text('Aus Thread neu aufbauen'),
                      onPressed: () => journalController
                          .rebuildFromThread(threadController.messages),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Manuell hinzufügen'),
                      onPressed: () {
                        // Mini-Dialog: Text → als Planzeile ins Journal
                        showDialog<void>(
                          context: context,
                          builder: (ctx) {
                            final c = TextEditingController();
                            return AlertDialog(
                              title: const Text('Text ins Journal'),
                              content: TextField(
                                controller: c,
                                decoration: const InputDecoration(
                                  hintText: 'Kurze Notiz / Planzeile…',
                                ),
                                autofocus: true,
                                onSubmitted: (_) {
                                  journalController.addPlanFromText(c.text);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Abbrechen'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    journalController.addPlanFromText(c.text);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Hinzufügen'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
