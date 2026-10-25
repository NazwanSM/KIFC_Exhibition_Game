import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

Future<void> launch(WidgetTester tester, String page) => launchScreen(
  tester,
  size: const Size(411, 731),
  locale: AppLocale.indonesian,
  page: page,
);

void main() {
  setUpAll(loadGameFonts);

  for (final correct in [true, false]) {
    testWidgets('cause feedback advances at 15 seconds ($correct)', (
      tester,
    ) async {
      await launch(tester, 'causeQuiz');
      await tester.tap(kind('_ChoiceButton').at(correct ? 0 : 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 14999));
      expect(find.text('BABAK 3 / SITUASI 1 DARI 4'), findsOneWidget);
      expect(kind('_Feedback'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      expect(find.text('BABAK 3 / SITUASI 2 DARI 4'), findsOneWidget);
      expect(kind('_Feedback'), findsNothing);
      await tester.pump(const Duration(seconds: 20));
      expect(
        find.text('BABAK 3 / SITUASI 2 DARI 4'),
        findsOneWidget,
        reason: 'The next unanswered question must not inherit a timer',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final (page, next) in const [
    ('finalReview', '_ScorePage'),
    ('score', '_ClosingPage'),
    ('closing', '_WelcomePage'),
  ]) {
    testWidgets('$page waits 15 seconds then advances once', (tester) async {
      await launch(tester, page);
      await tester.pump(const Duration(seconds: 14));
      expect(kind(next), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 500));
      expect(kind(next), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('early continuation cancels the previous timer', (tester) async {
    await launch(tester, 'finalReview');
    await tester.pump(const Duration(seconds: 5));
    await tester.tapAt(const Offset(4, 4));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(kind('_ScorePage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      kind('_ScorePage'),
      findsOneWidget,
      reason: 'The review deadline must not also close the score page',
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('an open audio dialog pauses the remaining reading allowance', (
    tester,
  ) async {
    await launch(tester, 'score');
    await tester.pump(const Duration(seconds: 10));
    await tester.tap(find.byKey(const ValueKey('audio-settings')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 20));
    expect(find.byType(Dialog), findsOneWidget);
    expect(kind('_ScorePage'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('audio-close')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(kind('_ScorePage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(milliseconds: 500));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a wrong first answer still waits for the remaining attempt', (
    tester,
  ) async {
    await launch(tester, 'risk');
    await tester.tap(
      find.descendant(
        of: kind('_RiskCard').first,
        matching: find.byType(InkWell),
      ),
    );
    await tester.pump(const Duration(seconds: 20));
    expect(kind('_RiskPage'), findsOneWidget);
    expect(
      (tester.widget(kind('_RiskCard').at(1)) as dynamic).onTap,
      isNotNull,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final reveal in [false, true]) {
    testWidgets('finished peat feedback has a 15-second fallback ($reveal)', (
      tester,
    ) async {
      await launch(tester, 'risk');
      Future<void> choose(int i) => tester.tap(
        find.descendant(
          of: kind('_RiskCard').at(i),
          matching: find.byType(InkWell),
        ),
      );
      if (reveal) {
        await choose(0);
        await tester.pump();
        await choose(2);
      } else {
        await choose(1);
      }
      await tester.pump(const Duration(seconds: 14));
      expect(kind('_RiskPage'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 500));
      expect(kind('_CauseQuiz'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets(
    'assembly completion automatically opens its explanation at 15s',
    (tester) async {
      await launch(tester, 'triangleBuild');
      for (final (piece, slot) in [(0, 0), (2, 1), (4, 2)]) {
        final card = kind('_DraggablePiece').at(piece);
        await tester.drag(
          card,
          tester.getCenter(kind('_DropSlot').at(slot)) - tester.getCenter(card),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
      }
      await tester.pump(const Duration(seconds: 14));
      expect(kind('_TriangleBuild'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 500));
      expect(kind('_TriangleExplanation'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
