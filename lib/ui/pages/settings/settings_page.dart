import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/providers.dart';
import '../../../core/constants/bible_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _fontSize = 18.0;
  bool _isNightMode = false;
  String _defaultTranslation = 'ARA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Aparência'),
          _buildNightModeTile(context),
          _buildFontSizeTile(context),
          const Divider(),
          _buildSectionHeader(context, 'Bíblia'),
          _buildDefaultTranslationTile(context),
          const Divider(),
          _buildSectionHeader(context, 'Conta'),
          _buildBackupTile(context),
          _buildRestoreTile(context),
          const Divider(),
          _buildSectionHeader(context, 'Sobre'),
          _buildAboutTile(context),
          _buildVersionTile(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildNightModeTile(BuildContext context) {
    return SwitchListTile(
      title: const Text('Modo Noturno'),
      subtitle: const Text('Ativar tema escuro'),
      value: _isNightMode,
      onChanged: (value) {
        setState(() {
          _isNightMode = value;
        });
      },
      secondary: Icon(
        _isNightMode ? Icons.dark_mode : Icons.light_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildFontSizeTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.text_fields,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Tamanho da Fonte'),
      subtitle: Text('${_fontSize.round()}px'),
      trailing: SizedBox(
        width: 200,
        child: Slider(
          value: _fontSize,
          min: 12,
          max: 32,
          divisions: 10,
          label: '${_fontSize.round()}px',
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDefaultTranslationTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.book,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Versão Padrão'),
      subtitle: Text(
        BibleConstants.translationNames[_defaultTranslation] ??
            _defaultTranslation,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showTranslationPicker(context);
      },
    );
  }

  Widget _buildBackupTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.cloud_upload,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Backup na Nuvem'),
      subtitle: const Text('Sincronizar anotações e esboços'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement Firebase backup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup na nuvem será implementado em breve.'),
          ),
        );
      },
    );
  }

  Widget _buildRestoreTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.cloud_download,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Restaurar Backup'),
      subtitle: const Text('Restaurar dados da nuvem'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement Firebase restore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restauração será implementada em breve.'),
          ),
        );
      },
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.info,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Sobre o App'),
      subtitle: const Text('Bíblia Sagrada Evangélica Completa'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: 'Bíblia Sagrada',
          applicationVersion: '1.0.0',
          applicationIcon: Icon(
            Icons.menu_book,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          children: const [
            Text(
              'Aplicativo completo para estudo bíblico, '
              'desenvolvido para pastores, líderes e estudantes da Bíblia.',
            ),
          ],
        );
      },
    );
  }

  Widget _buildVersionTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.code,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Versão'),
      subtitle: const Text('1.0.0+1'),
    );
  }

  void _showTranslationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selecionar Versão Padrão',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...BibleConstants.translations.map((translation) {
              final fullName =
                  BibleConstants.translationNames[translation] ?? translation;
              return RadioListTile<String>(
                title: Text(fullName),
                subtitle: Text(translation),
                value: translation,
                groupValue: _defaultTranslation,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _defaultTranslation = value;
                    });
                    Navigator.pop(context);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
