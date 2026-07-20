class Verse {
  final int id;
  final int bookId;
  final int chapter;
  final int verseNumber;
  final String text;
  final String translation;
  final String? originalText;
  final String? transliteration;
  final String? language;

  const Verse({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verseNumber,
    required this.text,
    required this.translation,
    this.originalText,
    this.transliteration,
    this.language,
  });

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      id: map['id'] as int,
      bookId: map['book_id'] as int,
      chapter: map['chapter'] as int,
      verseNumber: map['verse_number'] as int,
      text: map['text'] as String,
      translation: map['translation'] as String,
      originalText: map['original_text'] as String?,
      transliteration: map['transliteration'] as String?,
      language: map['language'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter': chapter,
      'verse_number': verseNumber,
      'text': text,
      'translation': translation,
      'original_text': originalText,
      'transliteration': transliteration,
      'language': language,
    };
  }

  Verse copyWith({
    int? id,
    int? bookId,
    int? chapter,
    int? verseNumber,
    String? text,
    String? translation,
    String? originalText,
    String? transliteration,
    String? language,
  }) {
    return Verse(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseNumber: verseNumber ?? this.verseNumber,
      text: text ?? this.text,
      translation: translation ?? this.translation,
      originalText: originalText ?? this.originalText,
      transliteration: transliteration ?? this.transliteration,
      language: language ?? this.language,
    );
  }

  String get reference {
    return '$bookId $chapter:$verseNumber';
  }
}
