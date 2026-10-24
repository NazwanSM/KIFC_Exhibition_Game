import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);
List<double> strengths(WidgetTester tester) => [
  for (var i = 0; i < 6; i++)
    tester
        .widget<Opacity>(find.byKey(ValueKey('forest-fire-opacity-$i')))
        .opacity,
];

void main() {
  setUpAll(loadGameFonts);

  testWidgets('a right-first choice leaves the left four flames burning', (
    tester,
  ) async {
    await launchScreen(
      tester,
      size: const Size(411, 731),
      locale: AppLocale.indonesian,
      page: 'breakTriangle',
    );
    await tester.tap(kind('_ChoiceButton').at(2));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(strengths(tester), [1.0, 1.0, 1.0, 1.0, 0.0, 0.0]);
    await tester.tap(kind('_ChoiceButton').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(strengths(tester), [0.0, 0.0, 1.0, 1.0, 0.0, 0.0]);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'repeating an element leaves its two fires out without adding progress',
    (tester) async {
      await launchScreen(
        tester,
        size: const Size(411, 731),
        locale: AppLocale.indonesian,
        page: 'breakTriangle',
      );
      await tester.tap(kind('_ChoiceButton').first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(strengths(tester), [0.0, 0.0, 1.0, 1.0, 1.0, 1.0]);
      await tester.tap(kind('_ChoiceButton').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(
        strengths(tester),
        [0.0, 0.0, 1.0, 1.0, 1.0, 1.0],
        reason: 'Previously extinguished flames must not relight',
      );
      expect(find.text('1/3 unsur sudah dicoba'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'last explanation remains readable and continue cancels its fallback',
    (tester) async {
      await launchScreen(
        tester,
        size: const Size(411, 731),
        locale: AppLocale.indonesian,
        page: 'breakTriangle',
      );
      for (var i = 0; i < 3; i++) {
        await tester.tap(kind('_ChoiceButton').at(i));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        kind('_BreakTriangle'),
        findsOneWidget,
        reason: '2.6 seconds is too short to read the final explanation',
      );
      expect(find.textContaining('Tanpa angin pun'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('reduction-continue')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
      expect(
        find.byKey(const ValueKey('karhutla-definition')),
        findsOneWidget,
        reason:
            'A stale demo callback must not interrupt the next reading card',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'automatic continuation waits for reading and restart cancels it',
    (tester) async {
      await launchScreen(
        tester,
        size: const Size(411, 731),
        locale: AppLocale.indonesian,
        page: 'breakTriangle',
      );
      for (var i = 0; i < 3; i++) {
        await tester.tap(kind('_ChoiceButton').at(i));
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 10));
      await tester.tap(kind('_ChoiceButton').first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      expect(
        kind('_BreakTriangle'),
        findsOneWidget,
        reason: 'Exploring again restarts the reading allowance',
      );
      await tester.tap(find.text('Ulangi'));
      await tester.pump();
      expect(find.text('0/3 unsur sudah dicoba'), findsOneWidget);
      expect(find.byKey(const ValueKey('reduction-continue')), findsNothing);
      expect(strengths(tester), everyElement(1));
      await tester.pump(const Duration(seconds: 20));
      expect(kind('_BreakTriangle'), findsOneWidget);
      for (var i = 0; i < 3; i++) {
        await tester.tap(kind('_ChoiceButton').at(i));
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 13));
      expect(kind('_BreakTriangle'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'left, centre and right choices cumulatively extinguish their own pair',
    (tester) async {
      await launchScreen(
        tester,
        size: const Size(411, 731),
        locale: AppLocale.indonesian,
        page: 'breakTriangle',
      );
      const expected = [
        [0.0, 0.0, 1.0, 1.0, 1.0, 1.0],
        [0.0, 0.0, 0.0, 0.0, 1.0, 1.0],
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
      ];
      for (var region = 0; region < 3; region++) {
        await tester.tap(kind('_ChoiceButton').at(region));
        await tester.pump();
        await tester.pump(const Duration(seconds: 2));
        expect(
          strengths(tester),
          expected[region],
          reason: 'Only the newly selected pair may disappear',
        );
      }
      await tester.tap(find.text('Ulangi'));
      await tester.pump();
      expect(strengths(tester), everyElement(1.0));
      expect(find.text('0/3 unsur sudah dicoba'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
