class StrongNumber {
  final String number;
  final String word;
  final String transliteration;
  final String pronunciation;
  final String definition;
  final String language;
  final String? relatedNumber;
  final int occurrences;

  const StrongNumber({
    required this.number,
    required this.word,
    required this.transliteration,
    required this.pronunciation,
    required this.definition,
    required this.language,
    this.relatedNumber,
    this.occurrences = 0,
  });

  factory StrongNumber.fromMap(Map<String, dynamic> map) {
    return StrongNumber(
      number: map['number'] as String,
      word: map['word'] as String,
      transliteration: map['transliteration'] as String,
      pronunciation: map['pronunciation'] as String,
      definition: map['definition'] as String,
      language: map['language'] as String,
      relatedNumber: map['related_number'] as String?,
      occurrences: map['occurrences'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'word': word,
      'transliteration': transliteration,
      'pronunciation': pronunciation,
      'definition': definition,
      'language': language,
      'related_number': relatedNumber,
      'occurrences': occurrences,
    };
  }

  bool get isHebrew => number.startsWith('H');
  bool get isGreek => number.startsWith('G');
}
