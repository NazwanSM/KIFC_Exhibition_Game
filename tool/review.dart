// Development-only entry point for reproducible browser evidence.
// flutter run -d web-server -t tool/review.dart --web-port 8081
// Then open /?page=peatCharacteristics&lang=ko; normal builds use lib/main.dart.
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/core/widgets/web_portrait_shell.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';

void main() {
  final query = Uri.base.queryParameters;
  final locale = switch (query['lang']) {
    'en' => AppLocale.english,
    'ko' => AppLocale.korean,
    _ => AppLocale.indonesian,
  };
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: KifcTheme.light(),
      home: ExhibitionGame(initialLocale: locale, initialPage: query['page']),
      builder: (context, child) => WebPortraitShell(child: child!),
    ),
  );
}
