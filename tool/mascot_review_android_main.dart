// Debug-only native inspection entry point; the normal release main does not
// enable WebView remote inspection.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:fire_prevention_challenge/main.dart' as app;
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    await AndroidWebViewController.enableDebugging(true);
    // Timed screens continuously emit accessibility changes, so Android's
    // `uiautomator dump` cannot become idle. Select real game fixtures via the
    // debug VM service instead. This entry point is never the release target.
    registerExtension('ext.kifc.reviewPage', (_, params) async {
      final page = params['page'] ?? 'welcome';
      final locale = switch (params['lang']) {
        'en' => AppLocale.english,
        'ko' => AppLocale.korean,
        _ => AppLocale.indonesian,
      };
      runApp(
        MaterialApp(
          key: UniqueKey(),
          debugShowCheckedModeBanner: false,
          theme: KifcTheme.light(),
          home: ExhibitionGame(initialPage: page, initialLocale: locale),
        ),
      );
      return ServiceExtensionResponse.result(
        jsonEncode({'page': page, 'language': locale.name}),
      );
    });
  }
  app.main();
}
