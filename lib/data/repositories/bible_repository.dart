import '../database/database_service.dart';
import '../models/models.dart';

class BibleRepository {
  final DatabaseService _db = DatabaseService();

  Future<List<BibleBook>> getAllBooks() async {
    final db = await _db.database;
    final maps = await db.query('books', orderBy: '"order" ASC');
    return maps.map((map) => BibleBook.fromMap(map)).toList();
  }

  Future<BibleBook?> getBook(int id) async {
    final db = await _db.database;
    final maps = await db.query('books', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return BibleBook.fromMap(maps.first);
  }

  Future<List<BibleBook>> getBooksByTestament(String testament) async {
    final db = await _db.database;
    final maps = await db.query(
      'books',
      where: 'testament = ?',
      whereArgs: [testament],
      orderBy: '"order" ASC',
    );
    return maps.map((map) => BibleBook.fromMap(map)).toList();
  }

  Future<List<Verse>> getVerses({
    required int bookId,
    required int chapter,
    required String translation,
  }) async {
    final db = await _db.database;
    final maps = await db.query(
      'verses',
      where: 'book_id = ? AND chapter = ? AND translation = ?',
      whereArgs: [bookId, chapter, translation],
      orderBy: 'verse_number ASC',
    );
    return maps.map((map) => Verse.fromMap(map)).toList();
  }

  Future<Verse?> getVerse({
    required int bookId,
    required int chapter,
    required int verseNumber,
    required String translation,
  }) async {
    final db = await _db.database;
    final maps = await db.query(
      'verses',
      where: 'book_id = ? AND chapter = ? AND verse_number = ? AND translation = ?',
      whereArgs: [bookId, chapter, verseNumber, translation],
    );
    if (maps.isEmpty) return null;
    return Verse.fromMap(maps.first);
  }

  Future<List<Verse>> searchVerses({
    required String query,
    required String translation,
    int? bookId,
  }) async {
    final db = await _db.database;
    String whereClause = 'text LIKE ? AND translation = ?';
    List<dynamic> whereArgs = ['%$query%', translation];

    if (bookId != null) {
      whereClause += ' AND book_id = ?';
      whereArgs.add(bookId);
    }

    final maps = await db.query(
      'verses',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'book_id ASC, chapter ASC, verse_number ASC',
    );
    return maps.map((map) => Verse.fromMap(map)).toList();
  }

  Future<List<Verse>> searchExactPhrase({
    required String phrase,
    required String translation,
  }) async {
    final db = await _db.database;
    final maps = await db.query(
      'verses',
      where: 'text LIKE ? AND translation = ?',
      whereArgs: ['%$phrase%', translation],
      orderBy: 'book_id ASC, chapter ASC, verse_number ASC',
    );
    return maps.map((map) => Verse.fromMap(map)).toList();
  }

  Future<List<Verse>> getVersesByTheme({
    required String themeReferences,
    required String translation,
  }) async {
    final db = await _db.database;
    final references = themeReferences.split(', ').toList();
    List<Verse> results = [];

    for (final ref in references) {
      final parts = ref.split(' ');
      if (parts.length < 2) continue;

      final bookName = parts[0];
      final chapterVerse = parts[1].split(':');
      if (chapterVerse.length < 2) continue;

      final chapter = int.tryParse(chapterVerse[0]);
      final verse = int.tryParse(chapterVerse[1]);
      if (chapter == null || verse == null) continue;

      final bookMaps = await db.query(
        'books',
        where: 'name LIKE ?',
        whereArgs: ['%$bookName%'],
      );
      if (bookMaps.isEmpty) continue;

      final bookId = bookMaps.first['id'] as int;
      final verseObj = await getVerse(
        bookId: bookId,
        chapter: chapter,
        verseNumber: verse,
        translation: translation,
      );
      if (verseObj != null) {
        results.add(verseObj);
      }
    }

    return results;
  }

  Future<int> getChapterCount(int bookId) async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT MAX(chapter) as max_chapter FROM verses WHERE book_id = ?',
      [bookId],
    );
    return result.first['max_chapter'] as int? ?? 0;
  }

  Future<void> insertVersesBatch(List<Verse> verses) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final verse in verses) {
      batch.insert('verses', verse.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
