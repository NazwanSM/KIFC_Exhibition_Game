import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts, ControlledStopwatch;

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  for (final size in const [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final locale in AppLocale.values) {
      final lang = ['id', 'en', 'ko'][locale.index];
      final res = '${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('KIFC-10 impacts and review $lang-$res', (tester) async {
        final clock = ControlledStopwatch();
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'peatCharacteristics',
          stopwatchFactory: () => clock,
        );
        await tester.runAsync(() async {
          final context = tester.element(find.byType(ExhibitionGame));
          for (final path in const [
            'assets/images/field/haze-sumatra-nasa.jpg',
            'assets/images/field/peat-fire-selangor.jpg',
            'assets/images/field/fire-klaten.jpg',
            'assets/images/field/peat-subsidence-nara.jpg',
            'assets/images/field/oxygen-canopy.jpg',
            'assets/images/forest/kereng-bangkirai.jpg',
          ]) {
            await precacheImage(AssetImage(path), context);
          }
        });
        for (var index = 0; index < 3; index++) {
          await tester.tap(find.byKey(ValueKey('peat-card-$index')));
          await tester.pump(const Duration(milliseconds: 500));
        }
        await tester.tap(find.byKey(const ValueKey('peat-cards-continue')));
        await tester.pump();
        await tester.pump(const Duration(seconds: 5));
        for (var attempt = 0; attempt < 50; attempt++) {
          if (find
              .byKey(const ValueKey('final-selection-grid'))
              .evaluate()
              .isNotEmpty) {
            break;
          }
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
          await tester.pump(const Duration(milliseconds: 20));
        }
        await tester.pump(const Duration(milliseconds: 800));
        expect(clock.isRunning, isTrue);
        final grid = find.byKey(const ValueKey('final-selection-grid'));
        final before = tester.getRect(grid);
        final metrics = <String, Object>{
          'ticket': 'KIFC-10',
          'source': 'Flutter widget render',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'durationSeconds': finalChallengeSeconds,
          'physicalTVReachValidated': false,
        };
        void check() {
          expect(tester.takeException(), isNull);
          for (final e
              in find
                  .descendant(of: grid, matching: find.byType(RichText))
                  .evaluate()) {
            final paragraph = e.renderObject! as RenderParagraph;
            expect(
              paragraph.didExceedMaxLines,
              isFalse,
              reason: paragraph.text.toPlainText(),
            );
            if (locale == AppLocale.korean) {
              expect(
                paragraph.text.toPlainText(),
                isNot(matches(RegExp('[A-Za-z]'))),
              );
            }
          }
        }

        check();
        await captureScreen(tester, 'impact-play-$lang-$res', metrics);
        // Alternate perfect and mixed outcomes to exercise both review poses.
        final perfect = size.width >= 720;
        for (final name
            in perfect
                ? ['haze', 'ecosystemDamage', 'carbonEmissions', 'subsidence']
                : ['haze', 'carbonStorage']) {
          await tester.tap(find.byKey(ValueKey('impact-$name')));
          await tester.pump(const Duration(milliseconds: 200));
        }
        expect(
          find.descendant(of: grid, matching: find.byIcon(Icons.check_rounded)),
          findsNothing,
        );
        await captureScreen(tester, 'impact-selected-$lang-$res', metrics);
        clock.advance(const Duration(seconds: finalChallengeSeconds));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 450));
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.getRect(grid), before);
        check();
        await tester.runAsync(() async {
          for (final e in find.byType(Image).evaluate()) {
            await precacheImage((e.widget as Image).image, e);
          }
        });
        await tester.pump();
        await captureScreen(tester, 'impact-review-$lang-$res', metrics);
        await tester.tap(find.byKey(const ValueKey('impact-photo-credits')));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.textContaining('CC BY-SA 3.0'), findsOneWidget);
        expect(find.textContaining('Safari — syncopika'), findsOneWidget);
        Navigator.of(tester.element(find.byType(AlertDialog))).pop();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.byKey(const ValueKey('final-review-continue')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.takeException(), isNull);
        await captureScreen(tester, 'impact-score-$lang-$res', metrics);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
