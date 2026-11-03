import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/widgets/game_mascot.dart';
import 'chapter2_review_test.dart' show launchScreen;
import 'game_flow_test.dart' show loadGameFonts;

void main() {
  setUpAll(loadGameFonts);
  for (final size in [
    const Size(360, 640),
    const Size(411, 731),
    const Size(1080, 1920),
    const Size(2160, 3840),
  ]) {
    testWidgets('welcome mascot is at least as tall as Chapter 2 at $size', (
      t,
    ) async {
      await launchScreen(
        t,
        size: size,
        locale: AppLocale.indonesian,
        page: 'welcome',
      );
      await t.pump(const Duration(seconds: 1));
      final welcome = t.getRect(find.byType(GameMascot)).height;
      await t.pumpWidget(const SizedBox.shrink());
      await launchScreen(
        t,
        size: size,
        locale: AppLocale.indonesian,
        page: 'karhutlaCards',
      );
      await t.pump(const Duration(seconds: 1));
      expect(
        welcome,
        greaterThanOrEqualTo(t.getRect(find.byType(GameMascot)).height),
      );
      await t.pumpWidget(const SizedBox.shrink());
    });
  }
}
