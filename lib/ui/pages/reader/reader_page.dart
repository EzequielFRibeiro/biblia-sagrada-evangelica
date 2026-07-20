import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/providers.dart';
import '../../../ui/widgets/widgets.dart';
import '../../../core/constants/bible_constants.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  int _currentIndex = 0;
  double _fontSize = 18.0;
  bool _isNightMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BibleProvider>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bíblia Sagrada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              setState(() {
                _isNightMode = !_isNightMode;
              });
            },
            tooltip: 'Modo Noturno',
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              setState(() {
                _fontSize = (_fontSize + 2).clamp(12.0, 32.0);
              });
            },
            tooltip: 'Aumentar Fonte',
          ),
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () {
              setState(() {
                _fontSize = (_fontSize - 2).clamp(12.0, 32.0);
              });
            },
            tooltip: 'Diminuir Fonte',
          ),
        ],
      ),
      body: Consumer<BibleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadBooks(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildReferenceBar(context, provider),
              Expanded(
                child: provider.selectedBook == null
                    ? _buildWelcomeView(context)
                    : _buildVersesList(context, provider),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Leitura',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Estudos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Esboços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Favoritos',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookSelector(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.menu_book, color: Colors.white),
      ),
    );
  }

  Widget _buildReferenceBar(BuildContext context, BibleProvider provider) {
    final bookName = provider.selectedBook?.name ?? 'Selecione um Livro';
    final chapter = provider.selectedChapter;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showBookSelector(context),
              child: Row(
                children: [
                  Icon(
                    Icons.book,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$bookName $chapter',
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () => _showTranslationSelector(context),
              child: Text(
                provider.currentTranslation,
                style: GoogleFonts.notoSerif(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Bem-vindo à Bíblia Sagrada',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Toque no botão abaixo para selecionar um livro e comece sua leitura.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showBookSelector(context),
              icon: const Icon(Icons.menu_book),
              label: const Text('Selecionar Livro'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersesList(BuildContext context, BibleProvider provider) {
    if (provider.currentVerses.isEmpty) {
      return const Center(
        child: Text('Nenhum versículo encontrado.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: provider.currentVerses.length,
      itemBuilder: (context, index) {
        final verse = provider.currentVerses[index];
        final isSelected = verse.verseNumber == provider.selectedVerse;

        return VerseCard(
          verseNumber: verse.verseNumber,
          text: verse.text,
          translation: verse.translation,
          isSelected: isSelected,
          onTap: () {
            provider.selectVerse(verse.verseNumber);
          },
          onLongPress: () {
            _showVerseOptions(context, verse);
          },
        );
      },
    );
  }

  void _showBookSelector(BuildContext context) {
    final provider = context.read<BibleProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BookSelector(
        oldTestament: provider.oldTestament,
        newTestament: provider.newTestament,
        selectedBook: provider.selectedBook,
        onBookSelected: (book) {
          provider.selectBook(book);
          Navigator.pop(context);
          _showChapterSelector(context);
        },
      ),
    );
  }

  void _showChapterSelector(BuildContext context) {
    final provider = context.read<BibleProvider>();
    if (provider.selectedBook == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChapterSelector(
        totalChapters: provider.selectedBook!.chapters,
        selectedChapter: provider.selectedChapter,
        onChapterSelected: (chapter) {
          provider.selectChapter(chapter);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showTranslationSelector(BuildContext context) {
    final provider = context.read<BibleProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TranslationSelector(
        selectedTranslation: provider.currentTranslation,
        onTranslationSelected: (translation) {
          provider.changeTranslation(translation);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showVerseOptions(BuildContext context, dynamic verse) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('Adicionar Favorito'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Adicionar Anotação'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copiar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/theology');
        break;
      case 3:
        Navigator.pushNamed(context, '/sermons');
        break;
      case 4:
        Navigator.pushNamed(context, '/bookmarks');
        break;
    }
  }
}
