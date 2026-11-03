// Review fixture: production screens, renderer and input, explicit entry page.
import 'package:flutter/material.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/widgets/web_portrait_shell.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';

void main() {
  final query = Uri.base.queryParameters;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: KifcTheme.light(),
      home: ExhibitionGame(
        initialPage: query['page'] == 'finalReview' ? 'finalReview' : 'risk',
        initialLocale: switch (query['lang']) {
          'en' => AppLocale.english,
          'ko' => AppLocale.korean,
          _ => AppLocale.indonesian,
        },
      ),
      builder: (context, child) => WebPortraitShell(child: child!),
    ),
  );
}
