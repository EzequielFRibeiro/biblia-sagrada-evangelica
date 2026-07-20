class Sermon {
  final int? id;
  final String title;
  final String? subtitle;
  final String category;
  final String type;
  final String content;
  final List<String> verses;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Sermon({
    this.id,
    required this.title,
    this.subtitle,
    required this.category,
    required this.type,
    required this.content,
    this.verses = const [],
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sermon.fromMap(Map<String, dynamic> map) {
    return Sermon(
      id: map['id'] as int?,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      category: map['category'] as String,
      type: map['type'] as String,
      content: map['content'] as String,
      verses: (map['verses'] as String?)?.split(', ') ?? [],
      tags: (map['tags'] as String?)?.split(', ') ?? [],
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'type': type,
      'content': content,
      'verses': verses.join(', '),
      'tags': tags.join(', '),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Sermon copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? category,
    String? type,
    String? content,
    List<String>? verses,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sermon(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      type: type ?? this.type,
      content: content ?? this.content,
      verses: verses ?? this.verses,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get typeLabel {
    switch (type) {
      case 'expository':
        return 'Expositório';
      case 'thematic':
        return 'Temático';
      case 'textual':
        return 'Textual';
      case 'topical':
        return 'Topical';
      default:
        return type;
    }
  }
}
