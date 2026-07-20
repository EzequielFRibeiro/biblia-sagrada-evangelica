class UserNote {
  final int? id;
  final int verseId;
  final int bookId;
  final int chapter;
  final int verseNumber;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserNote({
    this.id,
    required this.verseId,
    required this.bookId,
    required this.chapter,
    required this.verseNumber,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserNote.fromMap(Map<String, dynamic> map) {
    return UserNote(
      id: map['id'] as int?,
      verseId: map['verse_id'] as int,
      bookId: map['book_id'] as int,
      chapter: map['chapter'] as int,
      verseNumber: map['verse_number'] as int,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'verse_id': verseId,
      'book_id': bookId,
      'chapter': chapter,
      'verse_number': verseNumber,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserNote copyWith({
    int? id,
    int? verseId,
    int? bookId,
    int? chapter,
    int? verseNumber,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserNote(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseNumber: verseNumber ?? this.verseNumber,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
