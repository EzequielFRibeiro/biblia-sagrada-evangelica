import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/bible_constants.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, BibleConstants.dbName);

    return await openDatabase(
      path,
      version: BibleConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createBibleTables(db);
    await _createUserTables(db);
    await _createStudyTables(db);
    await _createSermonTables(db);
    await _seedBooks(db);
    await _seedThemes(db);
  }

  Future<void> _createBibleTables(Database db) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        abbreviation TEXT NOT NULL,
        name TEXT NOT NULL,
        testament TEXT NOT NULL,
        chapters INTEGER NOT NULL,
        "order" INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE verses (
        id INTEGER PRIMARY KEY,
        book_id INTEGER NOT NULL,
        chapter INTEGER NOT NULL,
        verse_number INTEGER NOT NULL,
        text TEXT NOT NULL,
        translation TEXT NOT NULL,
        original_text TEXT,
        transliteration TEXT,
        language TEXT,
        FOREIGN KEY (book_id) REFERENCES books(id),
        UNIQUE(book_id, chapter, verse_number, translation)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_verses_reference
      ON verses(book_id, chapter, verse_number)
    ''');

    await db.execute('''
      CREATE INDEX idx_verses_translation
      ON verses(translation)
    ''');

    await db.execute('''
      CREATE INDEX idx_verses_text
      ON verses(text)
    ''');
  }

  Future<void> _createUserTables(Database db) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        verse_id INTEGER NOT NULL,
        book_id INTEGER NOT NULL,
        chapter INTEGER NOT NULL,
        verse_number INTEGER NOT NULL,
        note TEXT,
        color TEXT DEFAULT '#FFD700',
        "group" TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (verse_id) REFERENCES verses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE user_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        verse_id INTEGER NOT NULL,
        book_id INTEGER NOT NULL,
        chapter INTEGER NOT NULL,
        verse_number INTEGER NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (verse_id) REFERENCES verses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER NOT NULL,
        chapter INTEGER NOT NULL,
        verse INTEGER NOT NULL,
        translation TEXT NOT NULL,
        read_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_history_date
      ON reading_history(read_at DESC)
    ''');
  }

  Future<void> _createStudyTables(Database db) async {
    await db.execute('''
      CREATE TABLE strong_numbers (
        number TEXT PRIMARY KEY,
        word TEXT NOT NULL,
        transliteration TEXT NOT NULL,
        pronunciation TEXT,
        definition TEXT NOT NULL,
        language TEXT NOT NULL,
        related_number TEXT,
        occurrences INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_strong_word
      ON strong_numbers(word)
    ''');

    await db.execute('''
      CREATE TABLE commentaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        author TEXT NOT NULL,
        book_reference TEXT NOT NULL,
        chapter INTEGER NOT NULL,
        verse_start INTEGER NOT NULL,
        verse_end INTEGER,
        content TEXT NOT NULL,
        source TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bible_themes (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        verse_references TEXT
      )
    ''');
  }

  Future<void> _createSermonTables(Database db) async {
    await db.execute('''
      CREATE TABLE sermons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subtitle TEXT,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        content TEXT NOT NULL,
        verses TEXT,
        tags TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_sermons_category
      ON sermons(category)
    ''');
  }

  Future<void> _seedBooks(Database db) async {
    final books = [
      {'id': 1, 'abbreviation': 'Gn', 'name': 'Gênesis', 'testament': 'AT', 'chapters': 50, 'order': 1},
      {'id': 2, 'abbreviation': 'Êx', 'name': 'Êxodo', 'testament': 'AT', 'chapters': 40, 'order': 2},
      {'id': 3, 'abbreviation': 'Lv', 'name': 'Levítico', 'testament': 'AT', 'chapters': 27, 'order': 3},
      {'id': 4, 'abbreviation': 'Nm', 'name': 'Números', 'testament': 'AT', 'chapters': 36, 'order': 4},
      {'id': 5, 'abbreviation': 'Dt', 'name': 'Deuteronômio', 'testament': 'AT', 'chapters': 34, 'order': 5},
      {'id': 6, 'abbreviation': 'Js', 'name': 'Josué', 'testament': 'AT', 'chapters': 24, 'order': 6},
      {'id': 7, 'abbreviation': 'Jz', 'name': 'Juízes', 'testament': 'AT', 'chapters': 21, 'order': 7},
      {'id': 8, 'abbreviation': 'Rt', 'name': 'Rute', 'testament': 'AT', 'chapters': 4, 'order': 8},
      {'id': 9, 'abbreviation': '1Sm', 'name': '1 Samuel', 'testament': 'AT', 'chapters': 31, 'order': 9},
      {'id': 10, 'abbreviation': '2Sm', 'name': '2 Samuel', 'testament': 'AT', 'chapters': 24, 'order': 10},
      {'id': 11, 'abbreviation': '1Rs', 'name': '1 Reis', 'testament': 'AT', 'chapters': 22, 'order': 11},
      {'id': 12, 'abbreviation': '2Rs', 'name': '2 Reis', 'testament': 'AT', 'chapters': 25, 'order': 12},
      {'id': 13, 'abbreviation': '1Cr', 'name': '1 Crônicas', 'testament': 'AT', 'chapters': 29, 'order': 13},
      {'id': 14, 'abbreviation': '2Cr', 'name': '2 Crônicas', 'testament': 'AT', 'chapters': 36, 'order': 14},
      {'id': 15, 'abbreviation': 'Ed', 'name': 'Esdras', 'testament': 'AT', 'chapters': 10, 'order': 15},
      {'id': 16, 'abbreviation': 'Ne', 'name': 'Neemias', 'testament': 'AT', 'chapters': 13, 'order': 16},
      {'id': 17, 'abbreviation': 'Et', 'name': 'Ester', 'testament': 'AT', 'chapters': 10, 'order': 17},
      {'id': 18, 'abbreviation': 'Jó', 'name': 'Jó', 'testament': 'AT', 'chapters': 42, 'order': 18},
      {'id': 19, 'abbreviation': 'Sl', 'name': 'Salmos', 'testament': 'AT', 'chapters': 150, 'order': 19},
      {'id': 20, 'abbreviation': 'Pv', 'name': 'Provérbios', 'testament': 'AT', 'chapters': 31, 'order': 20},
      {'id': 21, 'abbreviation': 'Ec', 'name': 'Eclesiastes', 'testament': 'AT', 'chapters': 12, 'order': 21},
      {'id': 22, 'abbreviation': 'Ct', 'name': 'Cânticos', 'testament': 'AT', 'chapters': 8, 'order': 22},
      {'id': 23, 'abbreviation': 'Is', 'name': 'Isaías', 'testament': 'AT', 'chapters': 66, 'order': 23},
      {'id': 24, 'abbreviation': 'Jr', 'name': 'Jeremias', 'testament': 'AT', 'chapters': 52, 'order': 24},
      {'id': 25, 'abbreviation': 'Lm', 'name': 'Lamentações', 'testament': 'AT', 'chapters': 5, 'order': 25},
      {'id': 26, 'abbreviation': 'Ez', 'name': 'Ezequiel', 'testament': 'AT', 'chapters': 48, 'order': 26},
      {'id': 27, 'abbreviation': 'Dn', 'name': 'Daniel', 'testament': 'AT', 'chapters': 12, 'order': 27},
      {'id': 28, 'abbreviation': 'Os', 'name': 'Oséias', 'testament': 'AT', 'chapters': 14, 'order': 28},
      {'id': 29, 'abbreviation': 'Jl', 'name': 'Joel', 'testament': 'AT', 'chapters': 3, 'order': 29},
      {'id': 30, 'abbreviation': 'Am', 'name': 'Amós', 'testament': 'AT', 'chapters': 9, 'order': 30},
      {'id': 31, 'abbreviation': 'Ob', 'name': 'Obadias', 'testament': 'AT', 'chapters': 1, 'order': 31},
      {'id': 32, 'abbreviation': 'Jn', 'name': 'Jonas', 'testament': 'AT', 'chapters': 4, 'order': 32},
      {'id': 33, 'abbreviation': 'Mq', 'name': 'Miquéias', 'testament': 'AT', 'chapters': 7, 'order': 33},
      {'id': 34, 'abbreviation': 'Na', 'name': 'Naum', 'testament': 'AT', 'chapters': 3, 'order': 34},
      {'id': 35, 'abbreviation': 'Hc', 'name': 'Habacuque', 'testament': 'AT', 'chapters': 3, 'order': 35},
      {'id': 36, 'abbreviation': 'Sf', 'name': 'Sofonias', 'testament': 'AT', 'chapters': 3, 'order': 36},
      {'id': 37, 'abbreviation': 'Ag', 'name': 'Ageu', 'testament': 'AT', 'chapters': 2, 'order': 37},
      {'id': 38, 'abbreviation': 'Zc', 'name': 'Zacarias', 'testament': 'AT', 'chapters': 14, 'order': 38},
      {'id': 39, 'abbreviation': 'Ml', 'name': 'Malaquias', 'testament': 'AT', 'chapters': 4, 'order': 39},
      {'id': 40, 'abbreviation': 'Mt', 'name': 'Mateus', 'testament': 'NT', 'chapters': 28, 'order': 40},
      {'id': 41, 'abbreviation': 'Mc', 'name': 'Marcos', 'testament': 'NT', 'chapters': 16, 'order': 41},
      {'id': 42, 'abbreviation': 'Lc', 'name': 'Lucas', 'testament': 'NT', 'chapters': 24, 'order': 42},
      {'id': 43, 'abbreviation': 'Jo', 'name': 'João', 'testament': 'NT', 'chapters': 21, 'order': 43},
      {'id': 44, 'abbreviation': 'At', 'name': 'Atos', 'testament': 'NT', 'chapters': 28, 'order': 44},
      {'id': 45, 'abbreviation': 'Rm', 'name': 'Romanos', 'testament': 'NT', 'chapters': 16, 'order': 45},
      {'id': 46, 'abbreviation': '1Co', 'name': '1 Coríntios', 'testament': 'NT', 'chapters': 16, 'order': 46},
      {'id': 47, 'abbreviation': '2Co', 'name': '2 Coríntios', 'testament': 'NT', 'chapters': 13, 'order': 47},
      {'id': 48, 'abbreviation': 'Gl', 'name': 'Gálatas', 'testament': 'NT', 'chapters': 6, 'order': 48},
      {'id': 49, 'abbreviation': 'Ef', 'name': 'Efésios', 'testament': 'NT', 'chapters': 6, 'order': 49},
      {'id': 50, 'abbreviation': 'Fp', 'name': 'Filipenses', 'testament': 'NT', 'chapters': 4, 'order': 50},
      {'id': 51, 'abbreviation': 'Cl', 'name': 'Colossenses', 'testament': 'NT', 'chapters': 4, 'order': 51},
      {'id': 52, 'abbreviation': '1Ts', 'name': '1 Tessalonicenses', 'testament': 'NT', 'chapters': 5, 'order': 52},
      {'id': 53, 'abbreviation': '2Ts', 'name': '2 Tessalonicenses', 'testament': 'NT', 'chapters': 3, 'order': 53},
      {'id': 54, 'abbreviation': '1Tm', 'name': '1 Timóteo', 'testament': 'NT', 'chapters': 6, 'order': 54},
      {'id': 55, 'abbreviation': '2Tm', 'name': '2 Timóteo', 'testament': 'NT', 'chapters': 4, 'order': 55},
      {'id': 56, 'abbreviation': 'Tt', 'name': 'Tito', 'testament': 'NT', 'chapters': 3, 'order': 56},
      {'id': 57, 'abbreviation': 'Fm', 'name': 'Filêmon', 'testament': 'NT', 'chapters': 1, 'order': 57},
      {'id': 58, 'abbreviation': 'Hb', 'name': 'Hebreus', 'testament': 'NT', 'chapters': 13, 'order': 58},
      {'id': 59, 'abbreviation': 'Tg', 'name': 'Tiago', 'testament': 'NT', 'chapters': 5, 'order': 59},
      {'id': 60, 'abbreviation': '1Pe', 'name': '1 Pedro', 'testament': 'NT', 'chapters': 5, 'order': 60},
      {'id': 61, 'abbreviation': '2Pe', 'name': '2 Pedro', 'testament': 'NT', 'chapters': 3, 'order': 61},
      {'id': 62, 'abbreviation': '1Jo', 'name': '1 João', 'testament': 'NT', 'chapters': 5, 'order': 62},
      {'id': 63, 'abbreviation': '2Jo', 'name': '2 João', 'testament': 'NT', 'chapters': 1, 'order': 63},
      {'id': 64, 'abbreviation': '3Jo', 'name': '3 João', 'testament': 'NT', 'chapters': 1, 'order': 64},
      {'id': 65, 'abbreviation': 'Jd', 'name': 'Judas', 'testament': 'NT', 'chapters': 1, 'order': 65},
      {'id': 66, 'abbreviation': 'Ap', 'name': 'Apocalipse', 'testament': 'NT', 'chapters': 22, 'order': 66},
    ];

    for (final book in books) {
      await db.insert('books', book);
    }
  }

  Future<void> _seedThemes(Database db) async {
    final themes = [
      {'id': 1, 'name': 'Salvação', 'description': 'Versículos sobre a salvação em Cristo', 'icon': 'cross', 'verse_references': 'João 3:16, Efésios 2:8-9, Romanos 10:9, Atos 4:12, 2 Coríntios 5:17'},
      {'id': 2, 'name': 'Fé', 'description': 'Versículos sobre a fé cristã', 'icon': 'heart', 'verse_references': 'Hebreus 11:1, Romanos 10:17, Mateus 17:20, Marcos 11:22-24, Tiago 1:6'},
      {'id': 3, 'name': 'Casamento', 'description': 'Versículos sobre casamento e família', 'icon': 'family', 'verse_references': 'Gênesis 2:24, Efésios 5:25-33, Provérbios 18:22, Miquéias 6:8, 1 Coríntios 13:4-7'},
      {'id': 4, 'name': 'Prosperidade', 'description': 'Versículos sobre prosperidade e provisão', 'icon': 'star', 'verse_references': 'Filipenses 4:19, Malaquias 3:10, Provérbios 3:9-10, 3 João 1:2, Deuteronômio 28:1-14'},
      {'id': 5, 'name': 'Oração', 'description': 'Versículos sobre oração e comunhão com Deus', 'icon': 'pray', 'verse_references': '1 Tessalonicenses 5:17, Filipenses 4:6-7, Mateus 7:7-8, Jeremias 33:3, Tiago 5:16'},
      {'id': 6, 'name': 'Amor', 'description': 'Versículos sobre o amor de Deus e do próximo', 'icon': 'love', 'verse_references': '1 João 4:8, 1 Coríntios 13:4-8, João 15:12-13, Romanos 8:38-39, Gálatas 5:14'},
      {'id': 7, 'name': 'Liberdade', 'description': 'Versículos sobre liberdade em Cristo', 'icon': 'freedom', 'verse_references': 'Gálatas 5:1, João 8:36, 2 Coríntios 3:17, Romanos 8:2, Isaías 61:1'},
      {'id': 8, 'name': 'Poder', 'description': 'Versículos sobre poder e autoridade', 'icon': 'power', 'verse_references': 'Atos 1:8, Filipenses 4:13, 2 Timóteo 1:7, Isaías 40:31, Efésios 6:10'},
    ];

    for (final theme in themes) {
      await db.insert('bible_themes', theme);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
