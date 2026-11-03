// Review-only entry point using the production audio backend and real page.
import 'package:flutter/material.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/core/widgets/web_portrait_shell.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';

void main() {
  final locale = switch (Uri.base.queryParameters['lang']) {
    'en' => AppLocale.english,
    'ko' => AppLocale.korean,
    _ => AppLocale.indonesian,
  };
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: KifcTheme.light(),
      home: ExhibitionGame(
        initialPage: 'triangleExplanation',
        initialLocale: locale,
      ),
      builder: (context, child) => WebPortraitShell(child: child!),
    ),
  );
}
