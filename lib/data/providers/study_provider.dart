import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/study_repository.dart';

class StudyProvider extends ChangeNotifier {
  final StudyRepository _repository = StudyRepository();

  List<BibleTheme> _themes = [];
  List<StrongNumber> _searchResults = [];
  List<Commentary> _commentaries = [];
  StrongNumber? _selectedStrong;
  bool _isLoading = false;
  String? _error;

  List<BibleTheme> get themes => _themes;
  List<StrongNumber> get searchResults => _searchResults;
  List<Commentary> get commentaries => _commentaries;
  StrongNumber? get selectedStrong => _selectedStrong;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadThemes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _themes = await _repository.getAllThemes();
    } catch (e) {
      _error = 'Erro ao carregar temas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchStrongNumbers(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _repository.searchStrongNumbers(query);
    } catch (e) {
      _error = 'Erro na busca: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectStrongNumber(String number) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedStrong = await _repository.getStrongNumber(number);
    } catch (e) {
      _error = 'Erro ao carregar número Strong: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCommentaries({
    required String bookReference,
    required int chapter,
    int? verseStart,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _commentaries = await _repository.getCommentaries(
        bookReference: bookReference,
        chapter: chapter,
        verseStart: verseStart,
      );
    } catch (e) {
      _error = 'Erro ao carregar comentários: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStrongSelection() {
    _selectedStrong = null;
    notifyListeners();
  }
}
