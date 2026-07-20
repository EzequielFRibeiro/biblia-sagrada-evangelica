class BibleBook {
  final int id;
  final String abbreviation;
  final String name;
  final String testament;
  final int chapters;
  final int order;

  const BibleBook({
    required this.id,
    required this.abbreviation,
    required this.name,
    required this.testament,
    required this.chapters,
    required this.order,
  });

  factory BibleBook.fromMap(Map<String, dynamic> map) {
    return BibleBook(
      id: map['id'] as int,
      abbreviation: map['abbreviation'] as String,
      name: map['name'] as String,
      testament: map['testament'] as String,
      chapters: map['chapters'] as int,
      order: map['order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'abbreviation': abbreviation,
      'name': name,
      'testament': testament,
      'chapters': chapters,
      'order': order,
    };
  }

  String get fullName => '$name ($abbreviation)';
  bool get isOldTestament => testament == 'AT';
  bool get isNewTestament => testament == 'NT';
}
