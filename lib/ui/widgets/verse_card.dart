import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerseCard extends StatelessWidget {
  final int verseNumber;
  final String text;
  final String? translation;
  final bool isSelected;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const VerseCard({
    super.key,
    required this.verseNumber,
    required this.text,
    this.translation,
    this.isSelected = false,
    this.isBookmarked = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          border: Border(
            left: BorderSide(
              width: 3,
              color: isBookmarked
                  ? const Color(0xFFD4AF37)
                  : isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isBookmarked
                    ? const Color(0xFFD4AF37).withOpacity(0.2)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '$verseNumber',
                  style: GoogleFonts.notoSerif(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isBookmarked
                        ? const Color(0xFFD4AF37)
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
