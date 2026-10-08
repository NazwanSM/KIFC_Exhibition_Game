import 'package:flutter/material.dart';

/// Shared starter tokens. The approved Figma system will replace these values
/// before the game UI is implemented.
abstract final class KifcTheme {
  static const forest950 = Color(0xFF10251D);
  static const forest800 = Color(0xFF234536);
  static const mossGreen = Color(0xFF607A3C);
  static const amber = Color(0xFFD99C31);
  static const paper = Color(0xFFF4F1E8);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: forest950,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mossGreen,
        brightness: Brightness.dark,
        surface: forest800,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: paper,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        bodyLarge: TextStyle(color: paper, height: 1.4),
      ),
    );
  }
}
