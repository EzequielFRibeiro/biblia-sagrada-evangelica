import '../database/database_service.dart';
import '../models/models.dart';

class SermonRepository {
  final DatabaseService _db = DatabaseService();

  Future<int> insertSermon(Sermon sermon) async {
    final db = await _db.database;
    return await db.insert('sermons', sermon.toMap());
  }

  Future<List<Sermon>> getAllSermons() async {
    final db = await _db.database;
    final maps = await db.query('sermons', orderBy: 'created_at DESC');
    return maps.map((map) => Sermon.fromMap(map)).toList();
  }

  Future<List<Sermon>> getSermonsByCategory(String category) async {
    final db = await _db.database;
    final maps = await db.query(
      'sermons',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Sermon.fromMap(map)).toList();
  }

  Future<List<Sermon>> getSermonsByType(String type) async {
    final db = await _db.database;
    final maps = await db.query(
      'sermons',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Sermon.fromMap(map)).toList();
  }

  Future<Sermon?> getSermon(int id) async {
    final db = await _db.database;
    final maps = await db.query('sermons', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Sermon.fromMap(maps.first);
  }

  Future<int> updateSermon(Sermon sermon) async {
    final db = await _db.database;
    return await db.update(
      'sermons',
      sermon.toMap(),
      where: 'id = ?',
      whereArgs: [sermon.id],
    );
  }

  Future<int> deleteSermon(int id) async {
    final db = await _db.database;
    return await db.delete('sermons', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Sermon>> searchSermons(String query) async {
    final db = await _db.database;
    final maps = await db.query(
      'sermons',
      where: 'title LIKE ? OR content LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Sermon.fromMap(map)).toList();
  }
}
