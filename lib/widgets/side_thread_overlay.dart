import 'package:flutter/material.dart';
import '../state/side_thread_state.dart';
import '../state/journal_state.dart';

class SideThreadOverlay extends StatefulWidget {
  final String chatId;
  final String? rootMessageId;
  final int openSignal;

  const SideThreadOverlay({
    super.key,
    required this.chatId,
    this.rootMessageId,
    this.openSignal = 0,
  });

  @override
  State<SideThreadOverlay> createState() => _SideThreadOverlayState();
}

class _SideThreadOverlayState extends State<SideThreadOverlay> {
  bool _open = false;
  int _lastOpenSignal = 0;
  final _input = TextEditingController();

  void _toggle() => setState(() => _open = !_open);

  void _add() {
    sideThreadController.add(
      chatId: widget.chatId,
      rootMessageId: widget.rootMessageId,
      text: _input.text,
    );
    _input.clear();
  }

  @override
  void didUpdateWidget(covariant SideThreadOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openSignal != _lastOpenSignal) {
      _lastOpenSignal = widget.openSignal;
      setState(() => _open = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sideThreadController,
      builder: (context, _) {
        final count = sideThreadController.countForChat(widget.chatId);
        final list = sideThreadController.entriesFor(
          chatId: widget.chatId,
          rootMessageId: widget.rootMessageId,
        );
        return Stack(children: [
          if (_open)
            Positioned(
              right: 16,
              bottom: 90,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: const BoxConstraints(maxHeight: 420),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Nebenchat', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Speicherziel',
                            icon: const Icon(Icons.save),
                            onPressed: () => sideThreadController.pickStorage(context, widget.chatId),
                          ),
                          IconButton(
                            tooltip: 'Schließen',
                            icon: const Icon(Icons.close),
                            onPressed: _toggle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: list.isEmpty
                            ? const Center(child: Text('Noch keine Nebenchat-Einträge.'))
                            : ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                itemBuilder: (_, i) {
                                  final e = list[i];
                                  return Card(
                                    child: ListTile(
                                      title: Text(e.text),
                                      subtitle: Text(e.createdAt.toIso8601String()),
                                      trailing: IconButton(
                                        tooltip: 'Ins Journal übernehmen',
                                        icon: const Icon(Icons.push_pin_outlined),
                                        onPressed: () => journalController.addPlanFromText(e.text),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _input,
                              decoration: const InputDecoration(
                                hintText: 'Nachfrage/Notiz…',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _add(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(onPressed: _add, child: const Text('Add')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: _toggle,
              label: Row(children: [
                const Icon(Icons.forum),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('$count', style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ]),
            ),
          ),
        ]);
      },
    );
  }
}
