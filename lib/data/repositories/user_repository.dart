import '../database/database_service.dart';
import '../models/models.dart';

class UserRepository {
  final DatabaseService _db = DatabaseService();

  // ==================== BOOKMARKS ====================

  Future<int> insertBookmark(Bookmark bookmark) async {
    final db = await _db.database;
    return await db.insert('bookmarks', bookmark.toMap());
  }

  Future<List<Bookmark>> getBookmarks({String? group}) async {
    final db = await _db.database;
    String? whereClause;
    List<dynamic>? whereArgs;

    if (group != null) {
      whereClause = '"group" = ?';
      whereArgs = [group];
    }

    final maps = await db.query(
      'bookmarks',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Bookmark.fromMap(map)).toList();
  }

  Future<List<Bookmark>> getBookmarksForVerse(int verseId) async {
    final db = await _db.database;
    final maps = await db.query(
      'bookmarks',
      where: 'verse_id = ?',
      whereArgs: [verseId],
    );
    return maps.map((map) => Bookmark.fromMap(map)).toList();
  }

  Future<int> deleteBookmark(int id) async {
    final db = await _db.database;
    return await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateBookmark(Bookmark bookmark) async {
    final db = await _db.database;
    return await db.update(
      'bookmarks',
      bookmark.toMap(),
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }

  // ==================== USER NOTES ====================

  Future<int> insertNote(UserNote note) async {
    final db = await _db.database;
    return await db.insert('user_notes', note.toMap());
  }

  Future<List<UserNote>> getAllNotes() async {
    final db = await _db.database;
    final maps = await db.query('user_notes', orderBy: 'updated_at DESC');
    return maps.map((map) => UserNote.fromMap(map)).toList();
  }

  Future<List<UserNote>> getNotesForVerse(int verseId) async {
    final db = await _db.database;
    final maps = await db.query(
      'user_notes',
      where: 'verse_id = ?',
      whereArgs: [verseId],
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => UserNote.fromMap(map)).toList();
  }

  Future<int> updateNote(UserNote note) async {
    final db = await _db.database;
    return await db.update(
      'user_notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await _db.database;
    return await db.delete('user_notes', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== READING HISTORY ====================

  Future<void> addToHistory(ReadingHistory history) async {
    final db = await _db.database;
    await db.insert('reading_history', history.toMap());
  }

  Future<List<ReadingHistory>> getHistory({int limit = 50}) async {
    final db = await _db.database;
    final maps = await db.query(
      'reading_history',
      orderBy: 'read_at DESC',
      limit: limit,
    );
    return maps.map((map) => ReadingHistory.fromMap(map)).toList();
  }

  Future<void> clearHistory() async {
    final db = await _db.database;
    await db.delete('reading_history');
  }
}
