import 'package:flutter/material.dart';

class AnswerBubbleSelectable extends StatefulWidget {
  final String messageId;
  final String text;
  final void Function({
    required String excerpt,
    required String parentMessageId,
  }) onAskAboutSelection;

  const AnswerBubbleSelectable({
    super.key,
    required this.messageId,
    required this.text,
    required this.onAskAboutSelection,
  });

  @override
  State<AnswerBubbleSelectable> createState() => _AnswerBubbleSelectableState();
}

class _AnswerBubbleSelectableState extends State<AnswerBubbleSelectable> {
  TextSelection? _selection;

  String? get _selectedText {
    final sel = _selection;
    if (sel == null) return null;
    final start = sel.start.clamp(0, widget.text.length);
    final end = sel.end.clamp(0, widget.text.length);
    if (end <= start) return null;
    return widget.text.substring(start, end).trim();
  }

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SelectableText(
        widget.text,
        onSelectionChanged: (selection, cause) {
          setState(() => _selection = selection);
        },
        style: const TextStyle(fontSize: 15, height: 1.35),
      ),
    );

    final hasSelection = (_selectedText != null && _selectedText!.isNotEmpty);

    return Stack(
      children: [
        bubble,
        if (hasSelection)
          Positioned(
            right: 8,
            bottom: 8,
            child: FilledButton.tonal(
              onPressed: () {
                final excerpt = _selectedText!;
                setState(() => _selection = const TextSelection(baseOffset: 0, extentOffset: 0));
                widget.onAskAboutSelection(
                  excerpt: excerpt,
                  parentMessageId: widget.messageId,
                );
              },
              child: const Text('Frage zur Auswahl'),
            ),
          ),
      ],
    );
  }
}
