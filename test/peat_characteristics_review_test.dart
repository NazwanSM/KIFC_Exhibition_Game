import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

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
      testWidgets('KIFC-09 flip information cards $lang-$res', (tester) async {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'peatCharacteristics',
        );
        final next = find.byKey(const ValueKey('peat-cards-continue'));
        bool enabled() =>
            tester
                .widget<ElevatedButton>(
                  find.descendant(
                    of: next,
                    matching: find.byWidgetPredicate(
                      (w) => w is ElevatedButton,
                    ),
                  ),
                )
                .onPressed !=
            null;
        expect(next, findsOneWidget);
        expect(enabled(), isFalse);
        final metrics = <String, Object>{
          'ticket': 'KIFC-09',
          'source': 'Flutter widget render',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'scored': false,
        };
        await captureScreen(tester, 'peat-cards-front-$lang-$res', metrics);
        final rect = tester.getRect(find.byKey(const ValueKey('peat-card-0')));
        for (final index in [0, 0, 0, 1, 2]) {
          await tester.tap(find.byKey(ValueKey('peat-card-$index')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          if (index == 0) {
            await captureScreen(tester, 'peat-cards-flip-$lang-$res', metrics);
          }
          await tester.pump(const Duration(milliseconds: 400));
          expect(tester.takeException(), isNull);
          if (index == 0) expect(enabled(), isFalse);
          if (index == 1) {
            await captureScreen(
              tester,
              'peat-cards-partial-$lang-$res',
              metrics,
            );
          }
        }
        expect(enabled(), isTrue);
        expect(tester.getRect(find.byKey(const ValueKey('peat-card-0'))), rect);
        final facts = locale == AppLocale.english
            ? [
                'Fire can smolder beneath the ground surface.',
                'These fires are difficult to extinguish.',
                'Fire can reignite.',
              ]
            : [
                'Api dapat membara di bawah permukaan tanah.',
                'Kebakaran sulit dipadamkan.',
                'Api dapat menyala kembali.',
              ];
        for (final source in facts) {
          expect(find.text(AppCopy.translate(source)), findsOneWidget);
        }
        await captureScreen(tester, 'peat-cards-read-$lang-$res', metrics);
        await tester.pump(const Duration(seconds: 40));
        expect(
          next,
          findsOneWidget,
          reason: 'Information has no reading deadline',
        );
        await tester.tap(find.byKey(const ValueKey('peat-card-1')));
        await tester.pump(const Duration(milliseconds: 500));
        expect(
          enabled(),
          isTrue,
          reason: 'Rereading never erases read progress',
        );
        expect(
          find.byIcon(Icons.check_rounded),
          findsNothing,
          reason: 'This is not a question',
        );
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
  for (final reduced in [false, true]) {
    testWidgets(
      'flip handles rapid taps and hides unread semantics reduced=$reduced',
      (tester) async {
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(disableAnimations: reduced);
        addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );
        final handle = tester.ensureSemantics();
        await launchScreen(
          tester,
          size: const Size(411, 731),
          locale: AppLocale.indonesian,
          page: 'peatCharacteristics',
        );
        final card = find.byKey(const ValueKey('peat-card-0'));
        String label() => tester.getSemantics(card).getSemanticsData().label;
        expect(label(), 'Kartu 1. Sentuh untuk membuka');
        expect(
          find.text('Api dapat membara di bawah permukaan tanah.'),
          findsNothing,
        );
        await tester.tap(card);
        await tester.pump();
        if (reduced) {
          expect(
            find.text('Api dapat membara di bawah permukaan tanah.'),
            findsOneWidget,
          );
        }
        await tester.pump(const Duration(milliseconds: 30));
        if (!reduced) {
          expect(
            find.text('Api dapat membara di bawah permukaan tanah.'),
            findsNothing,
            reason: 'Normal motion flips before revealing the back',
          );
        }
        await tester.tap(card);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(
          find.text('Api dapat membara di bawah permukaan tanah.'),
          findsNothing,
        );
        expect(label(), 'Kartu 1. Sentuh untuk membuka');
        expect(find.text('1/3 kartu sudah dibuka'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        handle.dispose();
      },
    );
  }
}
