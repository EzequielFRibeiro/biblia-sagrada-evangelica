import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/sermon_repository.dart';

class SermonProvider extends ChangeNotifier {
  final SermonRepository _repository = SermonRepository();

  List<Sermon> _sermons = [];
  List<Sermon> _filteredSermons = [];
  String? _selectedCategory;
  String? _selectedType;
  bool _isLoading = false;
  String? _error;

  List<Sermon> get sermons => _sermons;
  List<Sermon> get filteredSermons => _filteredSermons;
  String? get selectedCategory => _selectedCategory;
  String? get selectedType => _selectedType;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get categories {
    return _sermons.map((s) => s.category).toSet().toList();
  }

  static const List<String> sermonTypes = [
    'Expositório',
    'Temático',
    'Textual',
    'Topical',
  ];

  Future<void> loadSermons() async {
    _isLoading = true;
    notifyListeners();

    try {
      _sermons = await _repository.getAllSermons();
      _filteredSermons = List.from(_sermons);
    } catch (e) {
      _error = 'Erro ao carregar esboços: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSermon(Sermon sermon) async {
    try {
      await _repository.insertSermon(sermon);
      await loadSermons();
    } catch (e) {
      _error = 'Erro ao criar esboço: $e';
      notifyListeners();
    }
  }

  Future<void> updateSermon(Sermon sermon) async {
    try {
      await _repository.updateSermon(sermon);
      await loadSermons();
    } catch (e) {
      _error = 'Erro ao atualizar esboço: $e';
      notifyListeners();
    }
  }

  Future<void> deleteSermon(int id) async {
    try {
      await _repository.deleteSermon(id);
      await loadSermons();
    } catch (e) {
      _error = 'Erro ao deletar esboço: $e';
      notifyListeners();
    }
  }

  Future<void> searchSermons(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _filteredSermons = await _repository.searchSermons(query);
    } catch (e) {
      _error = 'Erro na busca: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    if (category == null) {
      _filteredSermons = List.from(_sermons);
    } else {
      _filteredSermons = _sermons.where((s) => s.category == category).toList();
    }
    notifyListeners();
  }

  void filterByType(String? type) {
    _selectedType = type;
    if (type == null) {
      _filteredSermons = List.from(_sermons);
    } else {
      _filteredSermons = _sermons.where((s) => s.typeLabel == type).toList();
    }
    notifyListeners();
  }
}
