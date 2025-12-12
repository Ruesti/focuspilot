import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/project_chat_providers.dart';
import '../models/chat_models.dart';

class ProjectChatPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectChatPage({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<ProjectChatPage> createState() => _ProjectChatPageState();
}

class _ProjectChatPageState extends ConsumerState<ProjectChatPage> {
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

    final notifier =
        ref.read(projectChatProvider(widget.projectId).notifier);

    _controller.clear();
    await notifier.sendProjectMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(projectChatProvider(widget.projectId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final currentCount = chatState.messages.length;
    if (currentCount != _lastMessageCount) {
      _lastMessageCount = currentCount;
      _scrollToBottom();
    }

    final hasMessages = chatState.messages.isNotEmpty;
    final title = chatState.thread?.title ?? 'Projekt-Chat';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
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
                  if (chatState.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: colorScheme.errorContainer,
                      child: Text(
                        chatState.error!,
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
                          if (chatState.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!hasMessages && !chatState.isSending) {
                            return _ProjectChatEmptyState(
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
                            itemCount: chatState.messages.length +
                                (chatState.isSending ? 1 : 0),
                            itemBuilder: (context, index) {
                              final messages = chatState.messages;

                              if (chatState.isSending &&
                                  index == messages.length) {
                                return const _TypingIndicator();
                              }

                              final ChatMessage m = messages[index];
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
                                    if (!chatState.isSending) {
                                      _send();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'Schreib hier alles zum Projekt: nächste Schritte, Probleme, Ideen …',
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
                            onPressed: chatState.isSending ? null : _send,
                            icon: chatState.isSending
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

class _ProjectChatEmptyState extends StatelessWidget {
  final VoidCallback onStartNewChat;

  const _ProjectChatEmptyState({required this.onStartNewChat});

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
              Icons.developer_board,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Projekt-Chat',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nutze diesen Bereich, um speziell zu diesem Projekt Fragen zu stellen, Entscheidungen festzuhalten und nächste Schritte zu klären.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onStartNewChat,
              icon: const Icon(Icons.edit),
              label: const Text('Projekt-Chat starten'),
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
          children: [
            _Dot(color: colorScheme.primary),
            const SizedBox(width: 4),
            _Dot(color: colorScheme.primary),
            const SizedBox(width: 4),
            _Dot(color: colorScheme.primary),
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
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
