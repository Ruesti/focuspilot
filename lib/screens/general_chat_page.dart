import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/chat_repository.dart';
import '../models/chat_models.dart';
import '../services/gpt_service.dart';

class GeneralChatPage extends StatefulWidget {
  const GeneralChatPage({super.key});

  @override
  State<GeneralChatPage> createState() => _GeneralChatPageState();
}

class _GeneralChatPageState extends State<GeneralChatPage> {
  late final ChatRepository _repo;

  ChatThread? _thread;
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _error;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _repo = ChatRepository(Supabase.instance.client);
    _initChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final thread = await _repo.getOrCreateGeneralInboxThread();
      final msgs = await _repo.loadMessages(thread.id);
      setState(() {
        _thread = thread;
        _messages = msgs;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _thread == null || _isSending) return;

    final thread = _thread!;
    setState(() {
      _isSending = true;
      _error = null;
    });

    _controller.clear();

    // User-Message speichern
    final userMsg = await _repo.addMessage(
      threadId: thread.id,
      role: 'user',
      content: text,
    );

    setState(() {
      _messages = [..._messages, userMsg];
    });
    _scrollToBottom();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      final userName = user?.userMetadata?['display_name'] ??
          user?.userMetadata?['name'] ??
          'Du';

      final fullPrompt =
          '$userName schreibt im allgemeinen Ideen-Chat:\n$text\n\n'
          'Die Antwort soll in Du-Form, ruhig, freundlich und konkret sein. '
          'Hilf, Gedanken zu sortieren und mögliche nächste Schritte zu sehen, '
          'ohne Druck aufzubauen.';

      final replyText = await GPTService.sendPrompt(fullPrompt);

      final assistantMsg = await _repo.addMessage(
        threadId: thread.id,
        role: 'assistant',
        content: replyText,
      );

      setState(() {
        _messages = [..._messages, assistantMsg];
        _isSending = false;
      });
      _scrollToBottom();
    } catch (e) {
      final errorMsg = await _repo.addMessage(
        threadId: thread.id,
        role: 'assistant',
        content: 'Fehler: ${e.toString()}',
        isError: true,
      );

      setState(() {
        _messages = [..._messages, errorMsg];
        _isSending = false;
        _error = e.toString();
      });
      _scrollToBottom();
    }
  }

  void _onConvertToProject() {
    // Hier später: aus diesem Chat ein Projekt anlegen oder zuweisen.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '„In Projekt umwandeln“ ist noch nicht implementiert – Hook ist vorbereitet.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasMessages = _messages.isNotEmpty;
    final title = _thread?.title ?? 'Allgemeiner Chat';

    final currentCount = _messages.length;
    if (currentCount != _lastMessageCount) {
      _lastMessageCount = currentCount;
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Später: In Projekt umwandeln / zu Projekt hinzufügen',
            icon: const Icon(Icons.redo),
            onPressed: _onConvertToProject,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 800;
          final double maxWidth = isWide ? 900 : constraints.maxWidth;

          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              decoration: isWide
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.5),
                      ),
                    )
                  : null,
              child: Column(
                children: [
                  if (_error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: colorScheme.errorContainer,
                      child: Text(
                        _error!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),

                  Expanded(
                    child: Container(
                      color: isDark
                          ? colorScheme.surface
                          : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      child: Builder(
                        builder: (context) {
                          if (_isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!hasMessages && !_isSending) {
                            return _GeneralChatEmptyState(
                              onStartNewChat: () {
                                FocusScope.of(context)
                                    .requestFocus(_inputFocusNode);
                              },
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            itemCount:
                                _messages.length + (_isSending ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (_isSending && index == _messages.length) {
                                return const _TypingIndicator();
                              }

                              final ChatMessage m = _messages[index];
                              final bool isUser = m.role == 'user';
                              final bool isError = m.isError;

                              return _ChatBubble(
                                text: m.content,
                                isUser: isUser,
                                isError: isError,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                            color: colorScheme.outlineVariant.withOpacity(0.7),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 140,
                              ),
                              child: Scrollbar(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _inputFocusNode,
                                  maxLines: null,
                                  minLines: 1,
                                  textInputAction: TextInputAction.newline,
                                  onSubmitted: (_) {
                                    if (!_isSending) {
                                      _send();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'Schreib hier alles, was gerade anliegt – Ideen, Fragen, ToDos …',
                                    filled: true,
                                    fillColor: isDark
                                        ? colorScheme.surfaceContainerHighest
                                        : colorScheme.surfaceContainerHighest
                                            .withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: _isSending ? null : _send,
                            icon: _isSending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GeneralChatEmptyState extends StatelessWidget {
  final VoidCallback onStartNewChat;

  const _GeneralChatEmptyState({required this.onStartNewChat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Allgemeiner Chat',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nutze diesen Raum, um erstmal alles rauszulassen – bevor daraus vielleicht ein echtes Projekt wird.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onStartNewChat,
              icon: const Icon(Icons.edit),
              label: const Text('Loslegen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;

  const _ChatBubble({
    required this.text,
    required this.isUser,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Alignment alignment =
        isUser ? Alignment.centerRight : Alignment.centerLeft;

    final Color bubbleColor;
    final Color textColor;

    if (isError) {
      bubbleColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
    } else if (isUser) {
      bubbleColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
    } else {
      bubbleColor = isDark
          ? colorScheme.surfaceContainerHighest.withOpacity(0.8)
          : colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface;
    }

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: SelectableText(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _Dot(),
            SizedBox(width: 4),
            _Dot(),
            SizedBox(width: 4),
            _Dot(),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot();

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
