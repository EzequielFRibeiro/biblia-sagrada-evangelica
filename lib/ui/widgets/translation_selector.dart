import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/bible_constants.dart';

class TranslationSelector extends StatelessWidget {
  final String selectedTranslation;
  final Function(String) onTranslationSelected;

  const TranslationSelector({
    super.key,
    required this.selectedTranslation,
    required this.onTranslationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selecione a Versão',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...BibleConstants.translations.map((translation) {
            final isSelected = translation == selectedTranslation;
            final fullName = BibleConstants.translationNames[translation] ?? translation;

            return ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    translation,
                    style: GoogleFonts.notoSerif(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              title: Text(
                fullName,
                style: GoogleFonts.notoSerif(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(translation),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => onTranslationSelected(translation),
            );
          }),
        ],
      ),
    );
  }
}
