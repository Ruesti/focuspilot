import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/chat_providers.dart';
import '../models/chat_models.dart';

class GPTChatPage extends ConsumerStatefulWidget {
  const GPTChatPage({super.key});

  @override
  ConsumerState<GPTChatPage> createState() => _GPTChatPageState();
}

class _GPTChatPageState extends ConsumerState<GPTChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  int _lastMessageCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
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
    if (text.isEmpty) return;

    final notifier = ref.read(chatProvider.notifier);

    _controller.clear();
    await notifier.sendUserMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final currentCount = chatState.messages.length;
    if (currentCount != _lastMessageCount) {
      _lastMessageCount = currentCount;
      _scrollToBottom();
    }

    final hasMessages = chatState.messages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(chatState.thread?.title ?? 'GPT-Chat'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          if (chatState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: cs.errorContainer,
              child: Text(
                chatState.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onErrorContainer,
                ),
              ),
            ),

          Expanded(
            child: Container(
              color: isDark
                  ? cs.surface
                  : cs.surfaceContainerHighest.withOpacity(0.25),
              child: Builder(
                builder: (context) {
                  if (chatState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!hasMessages && !chatState.isSending) {
                    return _ChatEmptyState(
                      onStartNewChat: () {
                        FocusScope.of(context).requestFocus(_inputFocusNode);
                      },
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    itemCount:
                        chatState.messages.length + (chatState.isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      final messages = chatState.messages;

                      if (chatState.isSending && index == messages.length) {
                        return const _ChatGPTStyleRowTyping();
                      }

                      final ChatMessage m = messages[index];
                      final bool isUser = m.role == 'user';
                      final bool isError = m.isError;

                      return _ChatGPTStyleRow(
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
                color: cs.surface,
                border: Border(
                  top: BorderSide(color: cs.outlineVariant.withOpacity(0.7)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 160),
                      child: TextField(
                        controller: _controller,
                        focusNode: _inputFocusNode,
                        maxLines: null,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                        onSubmitted: (_) {
                          if (!chatState.isSending) _send();
                        },
                        decoration: InputDecoration(
                          hintText:
                              'Frag deinen GPT-Coach oder erzähl, woran du arbeitest …',
                          filled: true,
                          fillColor: isDark
                              ? cs.surfaceContainerHighest
                              : cs.surfaceContainerHighest.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: chatState.isSending ? null : _send,
                    icon: chatState.isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ChatGPT-style full-width message row
class _ChatGPTStyleRow extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;

  const _ChatGPTStyleRow({
    required this.text,
    required this.isUser,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color bg;
    final Color fg;
    final IconData icon;

    if (isError) {
      bg = cs.errorContainer;
      fg = cs.onErrorContainer;
      icon = Icons.error_outline_rounded;
    } else if (isUser) {
      // user rows: slightly tinted
      bg = cs.primaryContainer.withOpacity(isDark ? 0.55 : 0.40);
      fg = cs.onPrimaryContainer;
      icon = Icons.person_rounded;
    } else {
      // assistant rows: subtle neutral
      bg = isDark
          ? cs.surfaceContainerHighest.withOpacity(0.45)
          : cs.surfaceContainerHighest.withOpacity(0.55);
      fg = cs.onSurface;
      icon = Icons.auto_awesome_rounded;
    }

    return Container(
      width: double.infinity, // ✅ full width
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        // keep text readable on ultra-wide screens
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outlineVariant.withOpacity(0.55),
                    ),
                  ),
                  child: Icon(icon, size: 18, color: fg.withOpacity(0.9)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectableText(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: fg,
                      height: 1.45,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatGPTStyleRowTyping extends StatelessWidget {
  const _ChatGPTStyleRowTyping();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.45),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
            ),
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outlineVariant.withOpacity(0.55),
                    ),
                  ),
                  child: Icon(Icons.auto_awesome_rounded,
                      size: 18, color: cs.primary.withOpacity(0.95)),
                ),
                const SizedBox(width: 10),
                _Dot(color: cs.primary),
                const SizedBox(width: 4),
                _Dot(color: cs.primary),
                const SizedBox(width: 4),
                _Dot(color: cs.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatEmptyState extends StatelessWidget {
  final VoidCallback onStartNewChat;

  const _ChatEmptyState({required this.onStartNewChat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'Willkommen beim GPT-Chat',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Schreib einfach los. FocusPilot hilft dir beim Sortieren, Planen und Dranbleiben.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
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

class _Dot extends StatefulWidget {
  final Color color;
  const _Dot({required this.color});

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
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
