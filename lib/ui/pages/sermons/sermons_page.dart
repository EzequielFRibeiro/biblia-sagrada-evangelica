import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/models.dart';

class SermonsPage extends StatefulWidget {
  const SermonsPage({super.key});

  @override
  State<SermonsPage> createState() => _SermonsPageState();
}

class _SermonsPageState extends State<SermonsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SermonProvider>().loadSermons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Esboços'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: Consumer<SermonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.filteredSermons.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildSermonsList(context, provider);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewSermon(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Esboço'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Esboços de Pregação',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Crie novos esboços ou explore o banco de\nesboços prontos categorizados por temas.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _createNewSermon(context),
              icon: const Icon(Icons.add),
              label: const Text('Criar Esboço'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSermonsList(BuildContext context, SermonProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: provider.filteredSermons.length,
      itemBuilder: (context, index) {
        final sermon = provider.filteredSermons[index];
        return _buildSermonCard(context, sermon);
      },
    );
  }

  Widget _buildSermonCard(BuildContext context, Sermon sermon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _viewSermon(context, sermon),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(sermon.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      sermon.typeLabel,
                      style: GoogleFonts.notoSerif(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(sermon.type),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      sermon.category,
                      style: GoogleFonts.notoSerif(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                sermon.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (sermon.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  sermon.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                sermon.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(sermon.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (sermon.verses.isNotEmpty) ...[
                    Icon(
                      Icons.book,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${sermon.verses.length} versículos',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'expository':
        return Colors.blue;
      case 'thematic':
        return Colors.green;
      case 'textual':
        return Colors.orange;
      case 'topical':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showFilters(BuildContext context) {
    final provider = context.read<SermonProvider>();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por Tipo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: provider.selectedType == null,
                  onSelected: (selected) {
                    provider.filterByType(null);
                    Navigator.pop(context);
                  },
                ),
                ...SermonProvider.sermonTypes.map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: provider.selectedType == type,
                    onSelected: (selected) {
                      provider.filterByType(selected ? type : null);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createNewSermon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SermonEditorPage(),
      ),
    );
  }

  void _viewSermon(BuildContext context, Sermon sermon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SermonEditorPage(sermon: sermon),
      ),
    );
  }
}

class SermonEditorPage extends StatefulWidget {
  final Sermon? sermon;

  const SermonEditorPage({super.key, this.sermon});

  @override
  State<SermonEditorPage> createState() => _SermonEditorPageState();
}

class _SermonEditorPageState extends State<SermonEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _contentController;
  late TextEditingController _versesController;
  late TextEditingController _tagsController;
  String _selectedType = 'expository';
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.sermon?.title ?? '');
    _subtitleController =
        TextEditingController(text: widget.sermon?.subtitle ?? '');
    _contentController =
        TextEditingController(text: widget.sermon?.content ?? '');
    _versesController = TextEditingController(
        text: widget.sermon?.verses.join(', ') ?? '');
    _tagsController = TextEditingController(
        text: widget.sermon?.tags.join(', ') ?? '');
    _selectedType = widget.sermon?.type ?? 'expository';
    _selectedCategory = widget.sermon?.category ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _versesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sermon == null ? 'Novo Esboço' : 'Editar Esboço'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSermon,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Título do Esboço',
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                hintText: 'Subtítulo (opcional)',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Tipo de Esboço',
              ),
              items: const [
                DropdownMenuItem(
                    value: 'expository', child: Text('Expositório')),
                DropdownMenuItem(value: 'thematic', child: Text('Temático')),
                DropdownMenuItem(value: 'textual', child: Text('Textual')),
                DropdownMenuItem(value: 'topical', child: Text('Topical')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: _selectedCategory),
              decoration: const InputDecoration(
                hintText: 'Categoria',
              ),
              onChanged: (value) {
                _selectedCategory = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _versesController,
              decoration: const InputDecoration(
                hintText: 'Versículos (separados por vírgula)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                hintText: 'Tags (separadas por vírgula)',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Conteúdo do Esboço',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: null,
              minLines: 15,
              decoration: const InputDecoration(
                hintText: 'Escreva seu esboço aqui...',
                alignLabelWithHint: true,
              ),
              style: GoogleFonts.notoSerif(
                fontSize: 16,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSermon() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o título e o conteúdo.')),
      );
      return;
    }

    final now = DateTime.now();
    final sermon = Sermon(
      id: widget.sermon?.id,
      title: title,
      subtitle: _subtitleController.text.trim().isEmpty
          ? null
          : _subtitleController.text.trim(),
      category: _selectedCategory.isEmpty ? 'Geral' : _selectedCategory,
      type: _selectedType,
      content: content,
      verses: _versesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      tags: _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      createdAt: widget.sermon?.createdAt ?? now,
      updatedAt: now,
    );

    final provider = context.read<SermonProvider>();
    if (widget.sermon == null) {
      await provider.addSermon(sermon);
    } else {
      await provider.updateSermon(sermon);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esboço salvo com sucesso!')),
      );
    }
  }
}
