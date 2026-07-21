# Bíblia Sagrada Evangélica Completa

Aplicativo mobile Flutter para estudo bíblico, desenvolvido para pastores, líderes e estudantes da Bíblia.

## Funcionalidades

### 📖 Leitor Bíblico Principal
- 66 livros (Antigo e Novo Testamento)
- 4 versões: ARC, ARA, NVI, NTLH
- Seleção rápida de Livro, Capítulo e Versículo
- Modo Noturno e ajuste de tamanho de fonte
- Marcadores de versículos

### 🔍 Busca Avançada
- Busca por palavra-chave
- Busca por frase exata
- 8 temas teológicos predefinidos (Salvação, Fé, Casamento, etc.)

### 📚 Espaço de Estudos Teológicos
- Dicionário Bíblico integrado (Dicionário Strong)
- Texto original em Hebraico/Grego Koiné
- Comentários bíblicos (Matthew Henry, Comentário Moody)

### ✍️ Central de Esboços de Pregação
- Banco de esboços categorizados (Exponenciais, Temáticos, Textuais)
- Editor integrado para criar e salvar esboços
- Exportação em PDF

### 📌 Extras
- Favoritos e marcadores
- Anotações pessoais atreladas a versículos
- Histórico de leitura
- Backup em nuvem (Firebase)

## Tecnologias

- **Flutter** 3.29+
- **Dart** 
- **SQLite** (sqflite) — funcionamento 100% offline
- **Provider** — state management
- **Material Design 3** — design system
- **Firebase** — backup na nuvem

## Como Compilar

```bash
# Clonar o repositório
git clone https://github.com/EzequielFRibeiro/biblia-sagrada-evangelica.git
cd biblia-sagrada-evangelica

# Gerar scaffolding do projeto
flutter create . --org com.biblia.sagrada --project-name biblia_sagrada

# Instalar dependências
flutter pub get

# Compilar APK (release)
flutter build apk --release
```

O APK estará em: `build/app/outputs/flutter-apk/app-release.apk`

## Estrutura do Projeto

```
lib/
├── main.dart
├── core/
│   ├── constants/    # Constantes do app
│   ├── router/       # Rotas
│   └── theme/        # Tema claro/escuro
├── data/
│   ├── database/     # SQLite service
│   ├── models/       # Models (9 arquivos)
│   ├── providers/    # State management
│   └── repositories/ # Repositories de dados
└── ui/
    ├── pages/        # 8 telas
    └── widgets/      # Widgets compartilhados
```

## Licença

Projeto open-source para estudo e uso cristão.
