import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder get cards => find.byWidgetPredicate(
  (widget) => widget.runtimeType.toString() == '_RiskCard',
);

Future<void> choose(WidgetTester tester, int index) async {
  await tester.tap(
    find.descendant(of: cards.at(index), matching: find.byType(InkWell)),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pump();
}

Future<void> captureRisk(
  WidgetTester tester,
  String name,
  Map<String, Object> metrics,
) async {
  // Asset decoding can finish between frames; record only a fully painted UI.
  for (var attempt = 0; attempt < 20; attempt++) {
    final pending = tester
        .widgetList<RawImage>(find.byType(RawImage))
        .any((image) => image.image == null);
    if (!pending) break;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
  expect(
    tester
        .widgetList<RawImage>(find.byType(RawImage))
        .every((image) => image.image != null),
    isTrue,
    reason: 'Photographs and mascot must be decoded before capture: $name',
  );
  await captureScreen(tester, name, metrics);
}

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });

  testWidgets(
    'finished feedback enables background taps and preserves its controls',
    (tester) async {
      const size = Size(411, 731);
      // Cover empty space, heading, disabled answer and mascot area.
      for (final point in const [
        Offset(10, 10),
        Offset(200, 210),
        Offset(200, 300),
        Offset(390, 710),
      ]) {
        await launchScreen(
          tester,
          size: size,
          locale: AppLocale.indonesian,
          page: 'risk',
        );
        await tester.tapAt(const Offset(5, 500));
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNWidgets(3));
        await choose(tester, 0);
        await tester.tapAt(const Offset(5, 500));
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNWidgets(3));
        await choose(tester, 1);
        // The answer tap itself must leave the feedback visible.
        expect(cards, findsNWidgets(3));
        await tester.tapAt(point);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNothing);
        final causeQuiz = find.byWidgetPredicate(
          (w) => w.runtimeType.toString() == '_CauseQuiz',
        );
        expect(causeQuiz, findsOneWidget);
        // Reading time does not advance the next unanswered question.
        final quizBefore = tester.widget(causeQuiz);
        await tester.pump(const Duration(seconds: 20));
        expect(tester.widget(causeQuiz), same(quizBefore));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    },
  );

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
      testWidgets('peat quiz and feedback fit $lang-$res', (tester) async {
        await launchScreen(tester, size: size, locale: locale, page: 'risk');
        expect(tester.takeException(), isNull);
        expect(cards, findsNWidgets(3));
        final stageFinder = find.byWidgetPredicate(
          (w) => w.runtimeType.toString() == '_LightStage',
        );
        final originalStage = tester.widget(stageFinder) as dynamic;
        final originalTitle = originalStage.title as String;
        final originalSubtitle = originalStage.subtitle as String;
        void expectUnchangedHeading() {
          final stage = tester.widget(stageFinder) as dynamic;
          expect(stage.title, originalTitle);
          expect(stage.subtitle, originalSubtitle);
          for (final card in tester.widgetList(cards)) {
            expect(
              (card as dynamic).height,
              72.0,
              reason: 'Feedback must not shrink answer cards',
            );
          }
        }

        void expectFeedbackReach() {
          final bubble = tester.getRect(
            find.byKey(const ValueKey('feedback-message')),
          );
          final minimumBottom = size.height >= 900
              ? size.height * .075
              : size.height < 680
              ? 20.0
              : 48.0;
          expect(
            size.height - bubble.bottom,
            greaterThanOrEqualTo(minimumBottom - .5),
            reason: 'Reading feedback must stay away from the bottom edge',
          );
          expect(
            bubble.top,
            greaterThanOrEqualTo(tester.getRect(cards.last).bottom + 2),
            reason: 'Raised feedback must not overlap answer choices',
          );
        }

        expect(
          tester.widgetList(cards).where((w) => (w as dynamic).selected),
          isEmpty,
        );
        for (var i = 0; i < 3; i++) {
          expect(
            find
                .descendant(of: cards.at(i), matching: find.byType(InkWell))
                .hitTestable(),
            findsOneWidget,
          );
          expect(tester.getRect(cards.at(i)).height, greaterThanOrEqualTo(48));
        }
        final metrics = <String, Object>{
          'ticket': 'KIFC-08',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        };
        await captureRisk(tester, 'question-$lang-$res', metrics);
        await choose(tester, 0);
        expectUnchangedHeading();
        expect(tester.takeException(), isNull);
        expect((tester.widget(cards.at(1)) as dynamic).selected, isFalse);
        expect((tester.widget(cards.at(1)) as dynamic).onTap, isNotNull);
        expectFeedbackReach();
        await captureRisk(tester, 'hint-$lang-$res', metrics);
        // A hint waits for the retry; repeating the same wrong choice does not
        // consume the remaining attempt or reveal B.
        await tester.pump(const Duration(seconds: 20));
        await choose(tester, 0);
        expect((tester.widget(cards.at(1)) as dynamic).selected, isFalse);
        expect((tester.widget(cards.at(1)) as dynamic).onTap, isNotNull);
        await choose(tester, 2);
        expectUnchangedHeading();
        expect(tester.takeException(), isNull);
        expect((tester.widget(cards.at(1)) as dynamic).selected, isTrue);
        expect(
          tester.widgetList(cards).every((w) => (w as dynamic).onTap == null),
          isTrue,
        );
        expectFeedbackReach();
        await captureRisk(tester, 'reveal-$lang-$res', metrics);
        await tester.pump(const Duration(seconds: 5));
        expect(cards, findsNWidgets(3));
        await tester.pump(const Duration(seconds: 8));
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNWidgets(3));
        await tester.tapAt(const Offset(4, 4));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await launchScreen(tester, size: size, locale: locale, page: 'risk');
        await choose(tester, 1);
        expectUnchangedHeading();
        expect(tester.takeException(), isNull);
        expect(
          tester.widgetList(cards).every((w) => (w as dynamic).onTap == null),
          isTrue,
        );
        final bubble = tester.getRect(
          find.byKey(const ValueKey('feedback-message')),
        );
        final mascot = tester.getRect(
          find.byKey(const ValueKey('feedback-mascot-crop')),
        );
        expect(bubble.right, lessThanOrEqualTo(mascot.left + 1));
        expect(bubble.bottom, greaterThan(mascot.top));
        expectFeedbackReach();
        await captureRisk(tester, 'correct-$lang-$res', metrics);
        // Long feedback must remain readable beyond the former 4.5 seconds.
        await tester.pump(const Duration(seconds: 5));
        expect(cards, findsNWidgets(3));
        await tester.pump(const Duration(seconds: 3));
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNWidgets(3));
        await tester.tapAt(const Offset(4, 4));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(cards, findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
