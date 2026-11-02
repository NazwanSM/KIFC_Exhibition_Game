// Review-only entry point: actual game pages, no debug controls in the product.
import 'package:flutter/material.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/core/widgets/web_portrait_shell.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';

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
      home: ExhibitionGame(
        initialPage: query['page'],
        initialLocale: locale,
        initialCardIndex: int.tryParse(query['card'] ?? ''),
        audioBackend: SilentGameAudioBackend(),
      ),
      builder: (context, child) => WebPortraitShell(child: child!),
    ),
  );
}
