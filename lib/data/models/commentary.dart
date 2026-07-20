class Commentary {
  final int? id;
  final String author;
  final String bookReference;
  final int chapter;
  final int verseStart;
  final int? verseEnd;
  final String content;
  final String? source;

  const Commentary({
    this.id,
    required this.author,
    required this.bookReference,
    required this.chapter,
    required this.verseStart,
    this.verseEnd,
    required this.content,
    this.source,
  });

  factory Commentary.fromMap(Map<String, dynamic> map) {
    return Commentary(
      id: map['id'] as int?,
      author: map['author'] as String,
      bookReference: map['book_reference'] as String,
      chapter: map['chapter'] as int,
      verseStart: map['verse_start'] as int,
      verseEnd: map['verse_end'] as int?,
      content: map['content'] as String,
      source: map['source'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'book_reference': bookReference,
      'chapter': chapter,
      'verse_start': verseStart,
      'verse_end': verseEnd,
      'content': content,
      'source': source,
    };
  }

  String get reference => '$bookReference $chapter:$verseStart'
      '${verseEnd != null && verseEnd != verseStart ? '-$verseEnd' : ''}';
}
