import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/models.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bookmarks.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildBookmarksList(context, provider);
        },
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
              Icons.bookmark_border,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum Favorito',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Pressione e segure em um versículo para\nadicionar aos seus favoritos.',
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

  Widget _buildBookmarksList(BuildContext context, UserProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = provider.bookmarks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: Color(
                    int.parse(bookmark.color?.replaceFirst('#', '0xFF') ??
                        '0xFFFFD700')),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            title: Text(
              'Livro ${bookmark.bookId} ${bookmark.chapter}:${bookmark.verseNumber}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: bookmark.note != null
                ? Text(
                    bookmark.note!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                provider.removeBookmark(bookmark.id!);
              },
            ),
          ),
        );
      },
    );
  }
}
