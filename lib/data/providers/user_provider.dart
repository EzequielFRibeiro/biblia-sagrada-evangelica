import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<Bookmark> _bookmarks = [];
  List<UserNote> _notes = [];
  List<ReadingHistory> _history = [];
  bool _isLoading = false;
  String? _error;

  List<Bookmark> get bookmarks => _bookmarks;
  List<UserNote> get notes => _notes;
  List<ReadingHistory> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ==================== BOOKMARKS ====================

  Future<void> loadBookmarks({String? group}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookmarks = await _repository.getBookmarks(group: group);
    } catch (e) {
      _error = 'Erro ao carregar favoritos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    try {
      await _repository.insertBookmark(bookmark);
      await loadBookmarks();
    } catch (e) {
      _error = 'Erro ao adicionar favorito: $e';
      notifyListeners();
    }
  }

  Future<void> removeBookmark(int id) async {
    try {
      await _repository.deleteBookmark(id);
      await loadBookmarks();
    } catch (e) {
      _error = 'Erro ao remover favorito: $e';
      notifyListeners();
    }
  }

  Future<void> updateBookmark(Bookmark bookmark) async {
    try {
      await _repository.updateBookmark(bookmark);
      await loadBookmarks();
    } catch (e) {
      _error = 'Erro ao atualizar favorito: $e';
      notifyListeners();
    }
  }

  // ==================== NOTES ====================

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await _repository.getAllNotes();
    } catch (e) {
      _error = 'Erro ao carregar anotações: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(UserNote note) async {
    try {
      await _repository.insertNote(note);
      await loadNotes();
    } catch (e) {
      _error = 'Erro ao adicionar anotação: $e';
      notifyListeners();
    }
  }

  Future<void> updateNote(UserNote note) async {
    try {
      await _repository.updateNote(note);
      await loadNotes();
    } catch (e) {
      _error = 'Erro ao atualizar anotação: $e';
      notifyListeners();
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
      await loadNotes();
    } catch (e) {
      _error = 'Erro ao deletar anotação: $e';
      notifyListeners();
    }
  }

  // ==================== HISTORY ====================

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _history = await _repository.getHistory();
    } catch (e) {
      _error = 'Erro ao carregar histórico: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToHistory(ReadingHistory history) async {
    try {
      await _repository.addToHistory(history);
    } catch (e) {
      _error = 'Erro ao adicionar ao histórico: $e';
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repository.clearHistory();
      _history = [];
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao limpar histórico: $e';
      notifyListeners();
    }
  }
}
