import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';

/// Lay out the complete paragraph while revealing only its current prefix.
class ProgressiveReadingText extends StatelessWidget {
  const ProgressiveReadingText({
    super.key,
    required this.text,
    required this.visibleCharacters,
    this.style,
  });
  final String text;
  final int visibleCharacters;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final end = visibleCharacters.clamp(0, text.length);
    final visible = text.substring(0, end);
    final korean = AppCopy.locale == AppLocale.korean;
    final display = korean ? AppCopy.keepKoreanWordBreaks(text) : text;
    // Find the visible prefix in the joined string while retaining joins across
    // the boundary between the visible and transparent spans.
    var displayEnd = 0;
    var sourceEnd = 0;
    while (displayEnd < display.length && sourceEnd < end) {
      if (display.codeUnitAt(displayEnd) != 0x2060) sourceEnd++;
      displayEnd++;
    }
    if (displayEnd < display.length &&
        display.codeUnitAt(displayEnd) == 0x2060) {
      displayEnd++;
    }
    return Semantics(
      label: visible,
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            style: korean ? AppCopy.koreanStyle(style) : style,
            children: [
              TextSpan(text: display.substring(0, displayEnd)),
              TextSpan(
                text: display.substring(displayEnd),
                style: const TextStyle(color: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
