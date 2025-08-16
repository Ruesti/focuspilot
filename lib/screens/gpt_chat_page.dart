import 'package:flutter/material.dart';

/// GPTChatPage
/// - Hauptchat (linear)
/// - Assistant-Antworten in Abschnitte
/// - "Hinterfragen" → Thread-Chat (BottomSheet mobil, Sidepanel breit)
/// - Feedback-Chips (Super, Kürzer, Ausführlicher, Technischer, Einsteiger, Weniger Blabla, Beispiele)
///
/// Keine Backend/DB-Abhängigkeit – kann sofort laufen.
/// TODO: Später Drift/Supabase andocken.

class GPTChatPage extends StatefulWidget {
  const GPTChatPage({super.key});

  @override
  State<GPTChatPage> createState() => _GPTChatPageState();
}

// ------------------------------ Models & State ------------------------------

enum Author { user, assistant }
enum FeedbackTag { superGood, shorter, longer, moreTech, moreBegin, lessFluff, examples }

class StyleConfig {
  int verbosity;      // -2..+2
  int technicality;   // -2..+2
  bool examples;      // add examples
  int fluff;          // -2..+2 (negativ = weniger Blabla)

  StyleConfig({this.verbosity = 0, this.technicality = 0, this.examples = false, this.fluff = 0});

  StyleConfig copyWith({int? verbosity, int? technicality, bool? examples, int? fluff}) =>
      StyleConfig(
        verbosity: verbosity ?? this.verbosity,
        technicality: technicality ?? this.technicality,
        examples: examples ?? this.examples,
        fluff: fluff ?? this.fluff,
      );

  @override
  String toString() => 'Style(verb=$verbosity, tech=$technicality, ex=$examples, fluff=$fluff)';
}

class Section { final String id; final String title; final String body;
  const Section({required this.id, required this.title, required this.body}); }

class Message { final String id; final Author author; final List<Section> sections;
  const Message({required this.id, required this.author, required this.sections}); }

class ThreadMsg { final Author author; final String text; final DateTime ts;
  ThreadMsg({required this.author, required this.text}) : ts = DateTime.now(); }

class ThreadData {
  final String id; final String messageId; final String sectionId; final String title;
  final List<ThreadMsg> msgs;
  ThreadData({required this.id, required this.messageId, required this.sectionId, required this.title, List<ThreadMsg>? msgs})
      : msgs = msgs ?? [];
}

List<Message> _seedConversation() => const [
  Message(
    id: 'm1',
    author: Author.user,
    sections: [Section(id: 's1', title: 'Frage', body: 'Erkläre mir den FocusPilot-Thread-Ansatz in 3 Schritten.')],
  ),
  Message(
    id: 'm2',
    author: Author.assistant,
    sections: [
      Section(id: 's1', title: '1) Abschnitt erkennen', body: 'Antworten in Abschnitte splitten – jeder Abschnitt ist anklickbar.'),
      Section(id: 's2', title: '2) Thread starten', body: 'Bei Fragen zu einem Abschnitt öffnet sich ein Neben-Thread.'),
      Section(id: 's3', title: '3) Stil steuern', body: 'Feedback-Chips (kürzer, technischer, Beispiele) beeinflussen die nächste Antwort.'),
    ],
  ),
];

class _AppState extends ChangeNotifier {
  final List<Message> messages = _seedConversation();
  final Map<String, ThreadData> threads = {}; // key: messageId#sectionId
  StyleConfig style = StyleConfig(); // global (Demo)

  void addUserMessage(String text) {
    final id = 'm${messages.length + 1}';
    messages.add(Message(id: id, author: Author.user, sections: [Section(id: 's1', title: 'Frage', body: text)]));
    notifyListeners();
    // TODO: Backend call mit `style`, Antwort anhängen & Abschnitte parsen
  }

  ThreadData ensureThread(String messageId, Section section) {
    final key = '${messageId}#${section.id}';
    return threads.putIfAbsent(key, () {
      final t = ThreadData(
        id: key,
        messageId: messageId,
        sectionId: section.id,
        title: section.title,
        msgs: [
          ThreadMsg(author: Author.user, text: 'Fokus: ${section.title}'),
          ThreadMsg(author: Author.assistant, text: 'Alles klar – stell deine Frage genau zu diesem Abschnitt.'),
        ],
      );
      notifyListeners();
      return t;
    });
  }

  void addThreadUserMsg(ThreadData thread, String text) {
    thread.msgs.add(ThreadMsg(author: Author.user, text: text));
    notifyListeners();
    // TODO: Backend call (thread context + style)
  }

  void applyFeedback({required FeedbackTag tag, required String messageId, String? sectionId}) {
    switch (tag) {
      case FeedbackTag.superGood: break;
      case FeedbackTag.shorter:    style = style.copyWith(verbosity: (style.verbosity - 1).clamp(-2, 2)); break;
      case FeedbackTag.longer:     style = style.copyWith(verbosity: (style.verbosity + 1).clamp(-2, 2)); break;
      case FeedbackTag.moreTech:   style = style.copyWith(technicality: (style.technicality + 1).clamp(-2, 2)); break;
      case FeedbackTag.moreBegin:  style = style.copyWith(technicality: (style.technicality - 1).clamp(-2, 2)); break;
      case FeedbackTag.lessFluff:  style = style.copyWith(fluff: (style.fluff - 1).clamp(-2, 2)); break;
      case FeedbackTag.examples:   style = style.copyWith(examples: true); break;
    }
    notifyListeners();
  }
}

// ------------------------------ Page State ------------------------------

class _GPTChatPageState extends State<GPTChatPage> {
  final _AppState state = _AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusPilot – Threaded Insight'),
        actions: [
          IconButton(
            tooltip: 'Aktiver Stil',
            onPressed: () => _showStyle(context),
            icon: const Icon(Icons.tune),
          )
        ],
      ),
      endDrawer: _ThreadDrawer(state: state),
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 980;
          return Row(children: [
            Expanded(child: Column(children: [
              Expanded(child: _ChatList(state: state)),
              _Composer(onSubmit: (t) => setState(() => state.addUserMessage(t))),
            ])),
            if (wide) SizedBox(width: 360, child: _ThreadPanel(state: state)),
          ]);
        },
      ),
    );
  }

  void _showStyle(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Stilpräferenzen'),
        content: Text(state.style.toString()),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}

// ------------------------------ Widgets ------------------------------

class _ChatList extends StatelessWidget {
  const _ChatList({required this.state});
  final _AppState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.messages.length,
      itemBuilder: (context, i) {
        final msg = state.messages[i];
        final isAssistant = msg.author == Author.assistant;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isAssistant ? Theme.of(context).colorScheme.surfaceContainerHighest
                               : Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(isAssistant ? Icons.smart_toy : Icons.person, size: 18),
                const SizedBox(width: 6),
                Text(isAssistant ? 'Assistant' : 'Du', style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                if (isAssistant)
                  Tooltip(
                    message: 'Stilpräferenzen wirken auf nächste Antworten',
                    child: Row(children: [
                      const Icon(Icons.tune, size: 16),
                      const SizedBox(width: 4),
                      Text('Stil aktiv', style: Theme.of(context).textTheme.labelSmall),
                    ]),
                  ),
              ]),
              const SizedBox(height: 8),
              ...msg.sections.map((s) => _SectionCard(state: state, messageId: msg.id, section: s, isAssistant: isAssistant)).toList(),
            ]),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.state, required this.messageId, required this.section, required this.isAssistant});
  final _AppState state; final String messageId; final Section section; final bool isAssistant;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (section.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(section.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
        Text(section.body),
        const SizedBox(height: 8),
        if (isAssistant) _FeedbackChips(state: state, messageId: messageId, sectionId: section.id),
        if (isAssistant)
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(spacing: 8, children: [
              TextButton.icon(onPressed: () => _openThread(context), icon: const Icon(Icons.search), label: const Text('Hinterfragen')),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gepinnt (Demo).'))),
                icon: const Icon(Icons.push_pin_outlined),
                label: const Text('Pin'),
              ),
            ]),
          ),
      ]),
    );
  }

  void _openThread(BuildContext context) {
    final thread = state.ensureThread(messageId, section);
    final wide = MediaQuery.of(context).size.width >= 980;
    if (wide) {
      Scaffold.of(context).openEndDrawer();
    } else {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => ThreadSheet(state: state, thread: thread),
      );
    }
  }
}

class _FeedbackChips extends StatelessWidget {
  const _FeedbackChips({required this.state, required this.messageId, required this.sectionId});
  final _AppState state; final String messageId; final String sectionId;

  @override
  Widget build(BuildContext context) {
    final items = [
      (FeedbackTag.superGood, 'Super', Icons.thumb_up_alt_outlined),
      (FeedbackTag.shorter, 'Kürzer', Icons.content_cut),
      (FeedbackTag.longer, 'Ausführlicher', Icons.add),
      (FeedbackTag.moreTech, 'Technischer', Icons.science_outlined),
      (FeedbackTag.moreBegin, 'Einsteiger', Icons.school_outlined),
      (FeedbackTag.lessFluff, 'Weniger Blabla', Icons.cleaning_services_outlined),
      (FeedbackTag.examples, 'Beispiele', Icons.lightbulb_outline),
    ];
    return Wrap(
      spacing: 6,
      runSpacing: -6,
      children: [
        for (final it in items)
          ChoiceChip(
            label: Row(mainAxisSize: MainAxisSize.min, children: [Icon(it.$3, size: 16), const SizedBox(width: 4), Text(it.$2)]),
            selected: false,
            onSelected: (_) {
              state.applyFeedback(tag: it.$1, messageId: messageId, sectionId: sectionId);
              final msg = switch (it.$1) {
                FeedbackTag.superGood => 'Danke! Ich halte mich an den Stil.',
                FeedbackTag.shorter => 'Okay, ich fasse mich kürzer.',
                FeedbackTag.longer => 'Alles klar, ich werde ausführlicher.',
                FeedbackTag.moreTech => 'Verstanden. Ich werde technischer.',
                FeedbackTag.moreBegin => 'Ich erkläre es einsteigerfreundlicher.',
                FeedbackTag.lessFluff => 'Weniger Füllsätze, direkt zur Sache.',
                FeedbackTag.examples => 'Ich füge Beispiele hinzu.',
              };
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
            },
          ),
      ],
    );
  }
}

// ---- Composer, Thread Drawer & Views ----

class _Composer extends StatefulWidget { const _Composer({required this.onSubmit}); final void Function(String) onSubmit; @override State<_Composer> createState() => _ComposerState(); }
class _ComposerState extends State<_Composer> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withOpacity(.2)))),
        child: Row(children: [
          Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Frage eingeben…', border: OutlineInputBorder(), isDense: true), minLines: 1, maxLines: 5)),
          const SizedBox(width: 8),
          FilledButton.icon(onPressed: () { final t = controller.text.trim(); if (t.isEmpty) return; controller.clear(); widget.onSubmit(t); }, icon: const Icon(Icons.send), label: const Text('Senden')),
        ]),
      ),
    );
  }
}

class _ThreadDrawer extends StatelessWidget { const _ThreadDrawer({required this.state}); final _AppState state;
  @override Widget build(BuildContext context) => Drawer(child: SafeArea(child: _ThreadPanel(state: state))); }

class _ThreadPanel extends StatefulWidget { const _ThreadPanel({required this.state}); final _AppState state; @override State<_ThreadPanel> createState() => _ThreadPanelState(); }
class _ThreadPanelState extends State<_ThreadPanel> {
  ThreadData? selected;
  @override
  Widget build(BuildContext context) {
    final entries = widget.state.threads.values.toList();
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withOpacity(.2)))),
        child: Row(children: [
          const Icon(Icons.forum_outlined, size: 20),
          const SizedBox(width: 8),
          Text('Threads', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const Spacer(),
          const Icon(Icons.tune, size: 16),
        ]),
      ),
      Expanded(
        child: entries.isEmpty
            ? const Center(child: Text('Noch keine Threads.'))
            : Row(children: [
                SizedBox(
                  width: 160,
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final t = entries[i];
                      final isSel = selected?.id == t.id;
                      return ListTile(
                        dense: true,
                        title: Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(t.id, maxLines: 1, overflow: TextOverflow.ellipsis),
                        leading: const Icon(Icons.chat_bubble_outline),
                        selected: isSel,
                        onTap: () => setState(() => selected = t),
                      );
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: selected == null ? const Center(child: Text('Thread wählen')) : ThreadView(state: widget.state, thread: selected!)),
              ]),
      ),
    ]);
  }
}

class ThreadSheet extends StatelessWidget {
  const ThreadSheet({super.key, required this.state, required this.thread});
  final _AppState state; final ThreadData thread;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withOpacity(.2)))),
            child: Row(children: [
              const Icon(Icons.chat_outlined),
              const SizedBox(width: 8),
              Expanded(child: Text('Thread: ${thread.title}', style: Theme.of(context).textTheme.titleMedium)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
            ]),
          ),
          Expanded(child: ThreadView(state: state, thread: thread)),
          ThreadComposer(onSubmit: (t) => state.addThreadUserMsg(thread, t)),
        ]),
      ),
    );
  }
}

class ThreadView extends StatelessWidget {
  const ThreadView({super.key, required this.state, required this.thread});
  final _AppState state; final ThreadData thread;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: thread.msgs.length,
      itemBuilder: (context, i) {
        final m = thread.msgs[i];
        final isAssistant = m.author == Author.assistant;
        return Align(
          alignment: isAssistant ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAssistant
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(m.text),
          ),
        );
      },
    );
  }
}

class ThreadComposer extends StatefulWidget { const ThreadComposer({super.key, required this.onSubmit}); final void Function(String) onSubmit; @override State<ThreadComposer> createState() => _ThreadComposerState(); }
class _ThreadComposerState extends State<ThreadComposer> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withOpacity(.2)))),
        child: Row(children: [
          Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Nachfrage zum Abschnitt …', border: OutlineInputBorder(), isDense: true), minLines: 1, maxLines: 4)),
          const SizedBox(width: 8),
          FilledButton.icon(onPressed: () { final t = controller.text.trim(); if (t.isEmpty) return; controller.clear(); widget.onSubmit(t); }, icon: const Icon(Icons.send), label: const Text('Senden')),
        ]),
      ),
    );
  }
}
