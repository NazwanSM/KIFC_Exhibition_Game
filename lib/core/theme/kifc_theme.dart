import 'package:flutter/material.dart';

/// Tokens translated from the approved exhibition-screen direction in Figma.
abstract final class KifcTheme {
  /// Shared radius for tappable controls across the exhibition interface.
  static const double controlRadius = 16;

  static const forest950 = Color(0xFF0C2B1F);
  static const forest800 = Color(0xFF1F4A39);
  static const mossGreen = Color(0xFF537C5B);
  static const amber = Color(0xFFE9A814);
  static const paper = Color(0xFFF7F5EE);
  static const ink = Color(0xFF132B20);
  static const mutedInk = Color(0xFF66726B);
  static const line = Color(0xFFDDD8C9);
  static const warmPanel = Color(0xFFE1D8C2);
  static const success = Color(0xFFE4EFD9);
  static const warning = Color(0xFFFFEDC9);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mossGreen,
        brightness: Brightness.light,
        surface: paper,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        bodyLarge: TextStyle(color: ink, height: 1.4),
      ),
    );
  }
}
