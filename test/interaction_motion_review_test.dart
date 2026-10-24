import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/widgets/interaction_motion.dart';
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

  final cards = find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == '_RiskCard',
  );

  testWidgets('feedback poses are decoded before the first answer', (
    tester,
  ) async {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    await launchScreen(
      tester,
      size: const Size(411, 731),
      locale: AppLocale.indonesian,
      page: 'risk',
    );
    final context = tester.element(find.byType(MaterialApp));
    final keys = <Object>[];
    for (final name in ['welcome', 'presenting', 'hint_safety', 'success']) {
      keys.add(
        await ResizeImage(
          AssetImage('assets/images/mascot/manggala_agni_$name.png'),
          width: 320,
        ).obtainKey(createLocalImageConfiguration(context)),
      );
    }
    expect(keys, hasLength(4));
    bool ready() => keys.every((key) {
      final status = PaintingBinding.instance.imageCache.statusForKey(key);
      return status.keepAlive && !status.pending;
    });
    for (var attempt = 0; attempt < 40 && !ready(); attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(
      ready(),
      isTrue,
      reason: 'A cold pose must not pop in after its dialogue',
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final size in const [
    Size(360, 640),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final locale in AppLocale.values) {
      final lang = ['id', 'en', 'ko'][locale.index];
      final res = '${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('feedback motion preserves reading and targets $lang-$res', (
        tester,
      ) async {
        final metadata = <String, Object>{
          'ticket': 'KIFC-G01-motion',
          'source': 'Flutter widget render',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        };
        Future<void> capture(String state) =>
            captureScreen(tester, '$state-$lang-$res', metadata);
        Future<void> launch(String page) async {
          await tester.pumpWidget(const SizedBox.shrink());
          await launchScreen(tester, size: size, locale: locale, page: page);
          await tester.runAsync(() async {
            final context = tester.element(find.byType(MaterialApp));
            for (final pose in [
              'welcome',
              'presenting',
              'hint_safety',
              'success',
            ]) {
              await precacheImage(
                ResizeImage(
                  AssetImage('assets/images/mascot/manggala_agni_$pose.png'),
                  width: 320,
                ),
                context,
              );
            }
          });
          await tester.pump(const Duration(milliseconds: 600));
        }

        await launch('welcome');
        await capture('welcome');
        await launch('risk');
        final originalCards = [
          for (var i = 0; i < 3; i++) tester.getRect(cards.at(i)),
        ];
        await tester.tap(
          find.descendant(of: cards.first, matching: find.byType(InkWell)),
        );
        await tester.pump();
        for (final frame in [80, 180, 420]) {
          await tester.pump(
            Duration(
              milliseconds: frame == 80
                  ? 80
                  : frame == 180
                  ? 100
                  : 240,
            ),
          );
          for (var i = 0; i < 3; i++) {
            final rect = tester.getRect(cards.at(i));
            expect(rect.left, closeTo(originalCards[i].left, .05));
            expect(rect.top, closeTo(originalCards[i].top, .05));
            expect(rect.width, closeTo(originalCards[i].width, .05));
            expect(rect.height, closeTo(originalCards[i].height, .05));
          }
          final bubble = tester.getRect(
            find.byKey(const ValueKey('feedback-message')),
          );
          expect(bubble.top, greaterThan(originalCards.last.bottom));
          expect(bubble.right, lessThanOrEqualTo(size.width));
          expect(
            tester
                .getRect(find.byKey(const ValueKey('feedback-mascot-crop')))
                .bottom,
            closeTo(size.height, .5),
          );
          await capture('hint-${frame}ms');
        }
        // Correcting the answer must replace the old message, not stack it.
        await tester.tap(
          find.descendant(of: cards.at(1), matching: find.byType(InkWell)),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 180));
        expect(find.byKey(const ValueKey('feedback-message')), findsOneWidget);
        await capture('correct-180ms');
        await tester.pump(const Duration(milliseconds: 240));
        await capture('correct-settled');
        final reveal = find.byKey(const ValueKey('feedback-motion'));
        final fade = find.descendant(
          of: reveal,
          matching: find.byType(FadeTransition),
        );
        expect(tester.widget<FadeTransition>(fade).opacity.value, 1);
        // Tap-anywhere still advances once without waiting for the timeout.
        await tester.tapAt(const Offset(5, 5));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(cards, findsNothing);
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_CauseQuiz',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await launch('breakTriangle');
        await capture('demo');
        await launch('score');
        final total = find.byKey(const ValueKey('total-score'));
        expect(
          find.descendant(of: total, matching: find.text('0')),
          findsOneWidget,
        );
        await capture('score-preview-zero');
        await tester.pump(const Duration(seconds: 1));
        for (final entrance in find.byType(MotionReveal).evaluate()) {
          final childFade = find
              .descendant(
                of: find.byElementPredicate((e) => e == entrance),
                matching: find.byType(FadeTransition),
              )
              .first;
          expect(
            tester.widget<FadeTransition>(childFade).opacity.value,
            1,
            reason: 'Idle rebuild must not replay result details',
          );
        }
        await launch('closing');
        await capture('closing');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
