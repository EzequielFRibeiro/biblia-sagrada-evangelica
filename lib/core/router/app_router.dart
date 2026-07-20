import 'package:flutter/material.dart';
import '../../ui/pages/reader/reader_page.dart';
import '../../ui/pages/search/search_page.dart';
import '../../ui/pages/theology/theology_page.dart';
import '../../ui/pages/sermons/sermons_page.dart';
import '../../ui/pages/settings/settings_page.dart';
import '../../ui/pages/bookmarks/bookmarks_page.dart';
import '../../ui/pages/history/history_page.dart';
import '../../ui/pages/notes/notes_page.dart';

class AppRouter {
  AppRouter._();

  static const String reader = '/';
  static const String search = '/search';
  static const String theology = '/theology';
  static const String sermons = '/sermons';
  static const String settings = '/settings';
  static const String bookmarks = '/bookmarks';
  static const String history = '/history';
  static const String notes = '/notes';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case reader:
        return MaterialPageRoute(builder: (_) => const ReaderPage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case theology:
        return MaterialPageRoute(builder: (_) => const TheologyPage());
      case sermons:
        return MaterialPageRoute(builder: (_) => const SermonsPage());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case bookmarks:
        return MaterialPageRoute(builder: (_) => const BookmarksPage());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      case notes:
        return MaterialPageRoute(builder: (_) => const NotesPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
