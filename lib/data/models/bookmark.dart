class Bookmark {
  final int? id;
  final int verseId;
  final int bookId;
  final int chapter;
  final int verseNumber;
  final String? note;
  final String? color;
  final String? group;
  final DateTime createdAt;

  const Bookmark({
    this.id,
    required this.verseId,
    required this.bookId,
    required this.chapter,
    required this.verseNumber,
    this.note,
    this.color,
    this.group,
    required this.createdAt,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as int?,
      verseId: map['verse_id'] as int,
      bookId: map['book_id'] as int,
      chapter: map['chapter'] as int,
      verseNumber: map['verse_number'] as int,
      note: map['note'] as String?,
      color: map['color'] as String?,
      group: map['group'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'verse_id': verseId,
      'book_id': bookId,
      'chapter': chapter,
      'verse_number': verseNumber,
      'note': note,
      'color': color,
      'group': group,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Bookmark copyWith({
    int? id,
    int? verseId,
    int? bookId,
    int? chapter,
    int? verseNumber,
    String? note,
    String? color,
    String? group,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseNumber: verseNumber ?? this.verseNumber,
      note: note ?? this.note,
      color: color ?? this.color,
      group: group ?? this.group,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
