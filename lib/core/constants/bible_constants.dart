class BibleConstants {
  BibleConstants._();

  static const String appName = 'Bíblia Sagrada Evangélica';
  static const String dbName = 'biblia_sagrada.db';
  static const int dbVersion = 1;

  static const List<String> translations = [
    'ARC',
    'ARA',
    'NVI',
    'NTLH',
  ];

  static const Map<String, String> translationNames = {
    'ARC': 'Almeida Revista e Corrigida',
    'ARA': 'Almeida Revista e Atualizada',
    'NVI': 'Nova Versão Internacional',
    'NTLH': 'Nova Tradução na Linguagem de Hoje',
  };

  static const List<String> biblicalLanguages = [
    'HEBRAICO',
    'ARAMAICO',
    'GREGO_KOINE',
  ];

  static const Map<String, String> biblicalLanguageNames = {
    'HEBRAICO': 'Hebraico (AT)',
    'ARAMAICO': 'Aramaico (AT)',
    'GREGO_KOINE': 'Grego Koiné (NT)',
  };
}
