class BibleTheme {
  final int id;
  final String name;
  final String description;
  final String icon;
  final List<String> verseReferences;

  const BibleTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.verseReferences = const [],
  });

  factory BibleTheme.fromMap(Map<String, dynamic> map) {
    return BibleTheme(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      icon: map['icon'] as String,
      verseReferences: (map['verse_references'] as String?)
              ?.split(', ') ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'verse_references': verseReferences.join(', '),
    };
  }

  static List<BibleTheme> defaultThemes = const [
    BibleTheme(
      id: 1,
      name: 'Salvação',
      description: 'Versículos sobre a salvação em Cristo',
      icon: 'cross',
      verseReferences: [
        'João 3:16',
        'Efésios 2:8-9',
        'Romanos 10:9',
        'Atos 4:12',
        '2 Coríntios 5:17',
      ],
    ),
    BibleTheme(
      id: 2,
      name: 'Fé',
      description: 'Versículos sobre a fé cristã',
      icon: 'heart',
      verseReferences: [
        'Hebreus 11:1',
        'Romanos 10:17',
        'Mateus 17:20',
        'Marcos 11:22-24',
        'Tiago 1:6',
      ],
    ),
    BibleTheme(
      id: 3,
      name: 'Casamento',
      description: 'Versículos sobre casamento e família',
      icon: 'family',
      verseReferences: [
        'Gênesis 2:24',
        'Efésios 5:25-33',
        'Provérbios 18:22',
        'Miquéias 6:8',
        '1 Coríntios 13:4-7',
      ],
    ),
    BibleTheme(
      id: 4,
      name: 'Prosperidade',
      description: 'Versículos sobre prosperidade e provisão',
      icon: 'star',
      verseReferences: [
        'Filipenses 4:19',
        'Malaquias 3:10',
        'Provérbios 3:9-10',
        '3 João 1:2',
        'Deuteronômio 28:1-14',
      ],
    ),
    BibleTheme(
      id: 5,
      name: 'Oração',
      description: 'Versículos sobre oração e comunhão com Deus',
      icon: 'pray',
      verseReferences: [
        '1 Tessalonicenses 5:17',
        'Filipenses 4:6-7',
        'Mateus 7:7-8',
        'Jeremias 33:3',
        'Tiago 5:16',
      ],
    ),
    BibleTheme(
      id: 6,
      name: 'Amor',
      description: 'Versículos sobre o amor de Deus e do próximo',
      icon: 'love',
      verseReferences: [
        '1 João 4:8',
        '1 Coríntios 13:4-8',
        'João 15:12-13',
        'Romanos 8:38-39',
        'Gálatas 5:14',
      ],
    ),
    BibleTheme(
      id: 7,
      name: 'Liberdade',
      description: 'Versículos sobre liberdade em Cristo',
      icon: 'freedom',
      verseReferences: [
        'Gálatas 5:1',
        'João 8:36',
        '2 Coríntios 3:17',
        'Romanos 8:2',
        'Isaías 61:1',
      ],
    ),
    BibleTheme(
      id: 8,
      name: 'Poder',
      description: 'Versículos sobre poder e autoridade',
      icon: 'power',
      verseReferences: [
        'Atos 1:8',
        'Filipenses 4:13',
        '2 Timóteo 1:7',
        'Isaías 40:31',
        'Efésios 6:10',
      ],
    ),
  ];
}
