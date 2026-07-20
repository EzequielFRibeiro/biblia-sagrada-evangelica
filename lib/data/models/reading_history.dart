class ReadingHistory {
  final int? id;
  final int bookId;
  final int chapter;
  final int verse;
  final String translation;
  final DateTime readAt;

  const ReadingHistory({
    this.id,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.translation,
    required this.readAt,
  });

  factory ReadingHistory.fromMap(Map<String, dynamic> map) {
    return ReadingHistory(
      id: map['id'] as int?,
      bookId: map['book_id'] as int,
      chapter: map['chapter'] as int,
      verse: map['verse'] as int,
      translation: map['translation'] as String,
      readAt: DateTime.parse(map['read_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter': chapter,
      'verse': verse,
      'translation': translation,
      'read_at': readAt.toIso8601String(),
    };
  }
}
