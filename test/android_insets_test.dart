import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'assembly_review_test.dart' show paintAssembly, dropAssembly;
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  for (final locale in AppLocale.values) {
    final lang = ['id', 'en', 'ko'][locale.index];
    testWidgets('Android cutout preserves assembly and other screens $lang', (
      tester,
    ) async {
      const size = Size(411, 731);
      final metrics = <String, Object>{
        'ticket': 'KIFC-G03',
        'source': 'Flutter widget render with Android safe inset',
        'width': 411,
        'height': 731,
        'topInset': 52,
        'language': lang,
      };
      await launchScreen(
        tester,
        size: size,
        locale: locale,
        page: 'triangleBuild',
        topInset: 52,
      );
      await paintAssembly(tester);
      expect(tester.takeException(), isNull);
      await captureScreen(tester, 'android-inset-assembly-$lang', metrics);
      await dropAssembly(tester, 0, 0);
      await dropAssembly(tester, 2, 1);
      await dropAssembly(tester, 4, 2);
      expect(tester.takeException(), isNull);
      await captureScreen(tester, 'android-inset-complete-$lang', metrics);
      await tester.pumpWidget(const SizedBox.shrink());
      for (final page in [
        'triangleExplanation',
        'karhutlaCards',
        'risk',
        'causeQuiz',
        'peatCharacteristics',
        'finalChallenge',
        'score',
        'closing',
      ]) {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: page,
          topInset: 52,
        );
        await paintAssembly(tester);
        expect(tester.takeException(), isNull, reason: '$page ($lang)');
        await captureScreen(tester, 'android-inset-$page-$lang', metrics);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });
  }
}
