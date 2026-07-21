import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';
import '../models/models.dart';

class StudyRepository {
  final DatabaseService _db = DatabaseService();

  // ==================== STRONG NUMBERS ====================

  Future<StrongNumber?> getStrongNumber(String number) async {
    final db = await _db.database;
    final maps = await db.query(
      'strong_numbers',
      where: 'number = ?',
      whereArgs: [number],
    );
    if (maps.isEmpty) return null;
    return StrongNumber.fromMap(maps.first);
  }

  Future<List<StrongNumber>> searchStrongNumbers(String query) async {
    final db = await _db.database;
    final maps = await db.query(
      'strong_numbers',
      where: 'word LIKE ? OR definition LIKE ? OR number = ?',
      whereArgs: ['%$query%', '%$query%', query],
      orderBy: 'word ASC',
      limit: 50,
    );
    return maps.map((map) => StrongNumber.fromMap(map)).toList();
  }

  Future<List<StrongNumber>> getStrongByLanguage(String language) async {
    final db = await _db.database;
    final maps = await db.query(
      'strong_numbers',
      where: 'language = ?',
      whereArgs: [language],
      orderBy: 'number ASC',
    );
    return maps.map((map) => StrongNumber.fromMap(map)).toList();
  }

  Future<void> insertStrongNumbersBatch(List<StrongNumber> numbers) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final number in numbers) {
      batch.insert('strong_numbers', number.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ==================== COMMENTARIES ====================

  Future<List<Commentary>> getCommentaries({
    required String bookReference,
    required int chapter,
    int? verseStart,
  }) async {
    final db = await _db.database;
    String whereClause = 'book_reference = ? AND chapter = ?';
    List<dynamic> whereArgs = [bookReference, chapter];

    if (verseStart != null) {
      whereClause += ' AND (verse_start <= ? AND (verse_end >= ? OR verse_end IS NULL))';
      whereArgs.addAll([verseStart, verseStart]);
    }

    final maps = await db.query(
      'commentaries',
      where: whereClause,
      whereArgs: whereArgs,
    );
    return maps.map((map) => Commentary.fromMap(map)).toList();
  }

  Future<void> insertCommentariesBatch(List<Commentary> commentaries) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final commentary in commentaries) {
      batch.insert('commentaries', commentary.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ==================== BIBLE THEMES ====================

  Future<List<BibleTheme>> getAllThemes() async {
    final db = await _db.database;
    final maps = await db.query('bible_themes');
    return maps.map((map) => BibleTheme.fromMap(map)).toList();
  }

  Future<BibleTheme?> getTheme(int id) async {
    final db = await _db.database;
    final maps = await db.query('bible_themes', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return BibleTheme.fromMap(maps.first);
  }
}
