import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/models.dart';
import '../../../ui/widgets/verse_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'keyword';
  bool _isSearching = false;
  List<Verse> _results = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca Avançada'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _searchType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'keyword',
                child: Text('Palavra-chave'),
              ),
              const PopupMenuItem(
                value: 'exact',
                child: Text('Frase Exata'),
              ),
              const PopupMenuItem(
                value: 'theme',
                child: Text('Por Tema'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildSearchTypeChip(),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? _buildEmptyState(context)
                    : _buildResultsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _getHintText(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _results = [];
                    });
                  },
                )
              : null,
        ),
        onSubmitted: (_) => _performSearch(),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSearchTypeChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildChip('Palavra-chave', 'keyword'),
          const SizedBox(width: 8),
          _buildChip('Frase Exata', 'exact'),
          const SizedBox(width: 8),
          _buildChip('Por Tema', 'theme'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _searchType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _searchType = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
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
              Icons.search,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Busca Bíblica',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Digite uma palavra, frase ou selecione um tema para buscar versículos.',
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

  Widget _buildResultsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final verse = _results[index];
        return VerseCard(
          verseNumber: verse.verseNumber,
          text: verse.text,
          translation: verse.translation,
          onTap: () {
            // Navigate to verse
          },
        );
      },
    );
  }

  String _getHintText() {
    switch (_searchType) {
      case 'keyword':
        return 'Buscar por palavra-chave...';
      case 'exact':
        return 'Buscar frase exata...';
      case 'theme':
        return 'Buscar por tema...';
      default:
        return 'Buscar...';
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final provider = context.read<BibleProvider>();
      List<Verse> results;

      if (_searchType == 'exact') {
        results = await provider.searchExactPhrase(query);
      } else {
        results = await provider.searchVerses(query);
      }

      setState(() {
        _results = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na busca: $e')),
        );
      }
    }
  }
}
