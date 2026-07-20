import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/bible_repository.dart';

class BibleProvider extends ChangeNotifier {
  final BibleRepository _repository = BibleRepository();

  List<BibleBook> _books = [];
  List<BibleBook> _oldTestament = [];
  List<BibleBook> _newTestament = [];
  List<Verse> _currentVerses = [];
  BibleBook? _selectedBook;
  int _selectedChapter = 1;
  int _selectedVerse = 1;
  String _currentTranslation = 'ARA';
  bool _isLoading = false;
  String? _error;

  List<BibleBook> get books => _books;
  List<BibleBook> get oldTestament => _oldTestament;
  List<BibleBook> get newTestament => _newTestament;
  List<Verse> get currentVerses => _currentVerses;
  BibleBook? get selectedBook => _selectedBook;
  int get selectedChapter => _selectedChapter;
  int get selectedVerse => _selectedVerse;
  String get currentTranslation => _currentTranslation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _books = await _repository.getAllBooks();
      _oldTestament = _books.where((b) => b.isOldTestament).toList();
      _newTestament = _books.where((b) => b.isNewTestament).toList();
    } catch (e) {
      _error = 'Erro ao carregar livros: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectBook(BibleBook book) async {
    _selectedBook = book;
    _selectedChapter = 1;
    _selectedVerse = 1;
    notifyListeners();
    await loadChapter();
  }

  Future<void> selectChapter(int chapter) async {
    _selectedChapter = chapter;
    _selectedVerse = 1;
    notifyListeners();
    await loadChapter();
  }

  void selectVerse(int verse) {
    _selectedVerse = verse;
    notifyListeners();
  }

  void changeTranslation(String translation) {
    _currentTranslation = translation;
    notifyListeners();
    if (_selectedBook != null) {
      loadChapter();
    }
  }

  Future<void> loadChapter() async {
    if (_selectedBook == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentVerses = await _repository.getVerses(
        bookId: _selectedBook!.id,
        chapter: _selectedChapter,
        translation: _currentTranslation,
      );
    } catch (e) {
      _error = 'Erro ao carregar versículos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Verse>> searchVerses(String query, {int? bookId}) async {
    return await _repository.searchVerses(
      query: query,
      translation: _currentTranslation,
      bookId: bookId,
    );
  }

  Future<List<Verse>> searchExactPhrase(String phrase) async {
    return await _repository.searchExactPhrase(
      phrase: phrase,
      translation: _currentTranslation,
    );
  }

  Future<void> goToReference(String bookName, int chapter, int verse) async {
    final book = _books.firstWhere(
      (b) => b.name.toLowerCase().contains(bookName.toLowerCase()),
      orElse: () => _books.first,
    );
    await selectBook(book);
    await selectChapter(chapter);
    selectVerse(verse);
  }
}
