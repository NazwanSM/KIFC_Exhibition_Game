import 'package:flutter/material.dart';

/// Fit approved PDF lines as a block, preserving every intentional line break.
/// Used for Korean PDF blocks and text with explicit display line breaks.
class KoreanPdfLayout extends StatelessWidget {
  const KoreanPdfLayout({
    super.key,
    required this.text,
    required this.style,
    required this.builder,
    this.textScaler,
  });
  final String text;
  final TextStyle? style;
  final TextScaler? textScaler;
  final Widget Function(TextStyle) builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final effective = DefaultTextStyle.of(context).style.merge(style);
      final painter = TextPainter(
        textDirection: Directionality.of(context),
        textScaler: textScaler ?? MediaQuery.textScalerOf(context),
        locale: Localizations.maybeLocaleOf(context),
      );
      TextStyle scaled(double scale) => effective.copyWith(
        fontSize: (effective.fontSize ?? 14) * scale,
        letterSpacing: (effective.letterSpacing ?? 0) * scale,
        wordSpacing: (effective.wordSpacing ?? 0) * scale,
      );
      bool fits(double scale) {
        painter.text = TextSpan(text: text, style: scaled(scale));
        painter.layout();
        return (!bounds.hasBoundedWidth ||
                painter.width <= bounds.maxWidth - .5) &&
            (!bounds.hasBoundedHeight || painter.height <= bounds.maxHeight);
      }

      var scale = 1.0;
      if (!fits(scale)) {
        var low = 0.0;
        var high = 1.0;
        // Measure the actual displayed glyphs, including word joiners and
        // inherited spacing. Font-size ratios alone overflow spaced text.
        for (var i = 0; i < 14; i++) {
          final middle = (low + high) / 2;
          if (fits(middle)) {
            low = middle;
          } else {
            high = middle;
          }
        }
        scale = low;
      }
      painter.dispose();
      return builder(scaled(scale));
    },
  );
}
