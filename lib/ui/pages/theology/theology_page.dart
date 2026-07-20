import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/models.dart';

class TheologyPage extends StatefulWidget {
  const TheologyPage({super.key});

  @override
  State<TheologyPage> createState() => _TheologyPageState();
}

class _TheologyPageState extends State<TheologyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyProvider>().loadThemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estudos Teológicos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Temas'),
              Tab(text: 'Dicionário'),
              Tab(text: 'Comentários'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ThemesTab(),
            _DictionaryTab(),
            _CommentariesTab(),
          ],
        ),
      ),
    );
  }
}

class _ThemesTab extends StatelessWidget {
  const _ThemesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final themes = provider.themes.isEmpty
            ? BibleTheme.defaultThemes
            : provider.themes;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: themes.length,
          itemBuilder: (context, index) {
            final theme = themes[index];
            return _buildThemeCard(context, theme);
          },
        );
      },
    );
  }

  Widget _buildThemeCard(BuildContext context, BibleTheme theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showThemeVerses(context, theme);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getThemeIcon(theme.icon),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeVerses(BuildContext context, BibleTheme theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  theme.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  theme.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: theme.verseReferences.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.book,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          theme.verseReferences[index],
                          style: GoogleFonts.notoSerif(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to verse
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getThemeIcon(String icon) {
    switch (icon) {
      case 'cross':
        return Icons.add;
      case 'heart':
        return Icons.favorite;
      case 'family':
        return Icons.family_restroom;
      case 'star':
        return Icons.star;
      case 'pray':
        return Icons.back_hand;
      case 'love':
        return Icons.favorite;
      case 'freedom':
        return Icons.lock_open;
      case 'power':
        return Icons.bolt;
      default:
        return Icons.book;
    }
  }
}

class _DictionaryTab extends StatefulWidget {
  const _DictionaryTab();

  @override
  State<_DictionaryTab> createState() => _DictionaryTabState();
}

class _DictionaryTabState extends State<_DictionaryTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar palavra Strong ou definição...',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<StudyProvider>().searchStrongNumbers(value);
              }
            },
          ),
        ),
        Expanded(
          child: Consumer<StudyProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book,
                        size: 80,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Dicionário Bíblico',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Busque por palavras no idioma original\n(Hebraico ou Grego) usando o dicionário Strong.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.searchResults.length,
                itemBuilder: (context, index) {
                  final strong = provider.searchResults[index];
                  return _buildStrongCard(context, strong);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStrongCard(BuildContext context, StrongNumber strong) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    color: strong.isHebrew
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    strong.number,
                    style: GoogleFonts.notoSerif(
                      fontWeight: FontWeight.bold,
                      color: strong.isHebrew ? Colors.blue : Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    strong.word,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            if (strong.transliteration.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                strong.transliteration,
                style: GoogleFonts.notoSerif(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              strong.definition,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ocorrências: ${strong.occurrences}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentariesTab extends StatelessWidget {
  const _CommentariesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyProvider>(
      builder: (context, provider, child) {
        if (provider.commentaries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment,
                    size: 80,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Comentários Bíblicos',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selecione um versículo na tela de leitura para ver\ncomentários de estudiosos como Matthew Henry\ne Comentário Moody.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.commentaries.length,
          itemBuilder: (context, index) {
            final commentary = provider.commentaries[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentary.author,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      commentary.reference,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      commentary.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
