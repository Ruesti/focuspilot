import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'project_chat_page.dart';
import 'general_chat_page.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  late final SupabaseClient _client;
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _projects = [];

  @override
  void initState() {
    super.initState();
    _client = Supabase.instance.client;
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('Nicht eingeloggt.');
      }

      final res = await _client
          .from('projects')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      setState(() {
        _projects = List<Map<String, dynamic>>.from(res as List);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showCreateProjectDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Neuen Arbeitsraum anlegen'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ein Arbeitsraum kann ein Projekt, ein Themengebiet oder einfach ein eigener GPT-Bereich sein.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'z. B. FocusPilot, RideOS, LinguAI …',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Kurzbeschreibung (optional)',
                    hintText: 'Worum geht es in diesem Raum?',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bitte einen Namen eingeben.'),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Anlegen'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final name = nameController.text.trim();
    final description = descriptionController.text.trim().isEmpty
        ? null
        : descriptionController.text.trim();

    await _createProject(name: name, description: description);
  }

  Future<void> _createProject({
    required String name,
    String? description,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('Nicht eingeloggt.');
      }

      final inserted = await _client
          .from('projects')
          .insert({
            'user_id': user.id,
            'name': name,
            'description': description,
          })
          .select()
          .single();

      setState(() {
        _projects.insert(0, Map<String, dynamic>.from(inserted));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Anlegen: $e')),
      );
    }
  }

  void _openProjectChat(String projectId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectChatPage(projectId: projectId),
      ),
    );
  }

  void _openGeneralChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GeneralChatPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Arbeitsräume'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fehler beim Laden der Arbeitsräume:',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loadProjects,
                  child: const Text('Erneut versuchen'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbeitsräume'),
        actions: [
          IconButton(
            onPressed: _showCreateProjectDialog,
            icon: const Icon(Icons.add),
            tooltip: 'Neuen Arbeitsraum anlegen',
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Allgemeiner Chat-Block oben
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Allgemeiner Chat',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Freier Ideen- und Notiz-Chat. Kann später in ein Projekt überführt oder einem Projekt zugeordnet werden.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: _openGeneralChat,
                      child: const Text('Öffnen'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // 🔹 Liste der Projekte darunter
          Expanded(
            child: _projects.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 64,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Noch keine Arbeitsräume',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lege deinen ersten Raum an – für ein Projekt, ein Themengebiet oder einen dedizierten GPT-Bereich.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _showCreateProjectDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Arbeitsraum anlegen'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _projects.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final project = _projects[index];
                      final String id = project['id'] as String;
                      final String name =
                          (project['name'] ?? 'Unbenannter Raum') as String;
                      final String? description =
                          project['description'] as String?;

                      return ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(name),
                        subtitle: description != null
                            ? Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.forum_outlined),
                          tooltip: 'Projekt-Chat öffnen',
                          onPressed: () => _openProjectChat(id),
                        ),
                        onTap: () => _openProjectChat(id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
