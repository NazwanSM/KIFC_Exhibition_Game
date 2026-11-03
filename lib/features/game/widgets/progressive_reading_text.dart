import 'package:flutter/material.dart';

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
    return Semantics(
      label: visible,
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            style: style,
            children: [
              TextSpan(text: visible),
              TextSpan(
                text: text.substring(end),
                style: const TextStyle(color: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
