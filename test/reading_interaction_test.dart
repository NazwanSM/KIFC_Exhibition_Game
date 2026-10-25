import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

Future<void> pump(WidgetTester tester, [int ms = 500]) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: ms));
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> launch(WidgetTester tester, String page) => launchScreen(
  tester,
  size: const Size(411, 731),
  locale: AppLocale.indonesian,
  page: page,
);

void main() {
  setUpAll(loadGameFonts);

  for (final correct in [true, false]) {
    testWidgets(
      'cause feedback offers reading time and an early tap advances ($correct)',
      (tester) async {
        await launch(tester, 'causeQuiz');
        await tester.tap(kind('_ChoiceButton').at(correct ? 0 : 1));
        await pump(tester, 100);
        // The answer gesture must reveal feedback, not also dismiss it.
        expect(kind('_Feedback'), findsOneWidget);
        await pump(tester, 5000);
        expect(find.text('BABAK 3 / SITUASI 1 DARI 4'), findsOneWidget);
        expect(kind('_Feedback'), findsOneWidget);
        await tester.tap(kind('_ScenarioCard'));
        await pump(tester);
        expect(find.text('BABAK 3 / SITUASI 2 DARI 4'), findsOneWidget);
        expect(kind('_Feedback'), findsNothing);
        await tester.tapAt(const Offset(4, 4));
        await pump(tester);
        expect(find.text('BABAK 3 / SITUASI 2 DARI 4'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  for (final reveal in [false, true]) {
    testWidgets('peat feedback waits and accepts a full-screen tap ($reveal)', (
      tester,
    ) async {
      await launch(tester, 'risk');
      if (reveal) {
        await tester.tap(
          find.descendant(
            of: kind('_RiskCard').at(0),
            matching: find.byType(InkWell),
          ),
        );
        await pump(tester);
        await tester.tapAt(const Offset(4, 4));
        await pump(tester);
        expect(
          kind('_RiskPage'),
          findsOneWidget,
          reason: 'A first hint must preserve the extra attempt',
        );
        await tester.tap(
          find.descendant(
            of: kind('_RiskCard').at(2),
            matching: find.byType(InkWell),
          ),
        );
      } else {
        await tester.tap(
          find.descendant(
            of: kind('_RiskCard').at(1),
            matching: find.byType(InkWell),
          ),
        );
      }
      await pump(tester, 5000);
      expect(kind('_RiskPage'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('feedback-message')));
      await pump(tester);
      expect(kind('_CauseQuiz'), findsOneWidget);
      expect(kind('_Feedback'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets(
    'assembly completion waits; its final drop does not skip feedback',
    (tester) async {
      await launch(tester, 'triangleBuild');
      for (final pair in [(0, 0), (2, 1), (4, 2)]) {
        final card = kind('_DraggablePiece').at(pair.$1);
        final slot = kind('_DropSlot').at(pair.$2);
        await tester.drag(
          card,
          tester.getCenter(slot) - tester.getCenter(card),
        );
        await pump(tester);
      }
      expect(kind('_TriangleBuild'), findsOneWidget);
      await pump(tester, 5000);
      expect(kind('_TriangleBuild'), findsOneWidget);
      await tester.tapAt(const Offset(4, 4));
      await pump(tester);
      expect(kind('_TriangleExplanation'), findsOneWidget);
      // Explanation cards remain manual rather than timed feedback.
      await pump(tester, 60000);
      expect(kind('_TriangleExplanation'), findsOneWidget);
      await tester.tapAt(const Offset(4, 4));
      await pump(tester);
      expect(kind('_BreakTriangle'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('reduction waits at 3/3; untried elements cannot be skipped', (
    tester,
  ) async {
    await launch(tester, 'breakTriangle');
    for (var i = 0; i < 3; i++) {
      await tester.tap(kind('_ChoiceButton').at(i));
      await pump(tester);
      expect(kind('_BreakTriangle'), findsOneWidget);
      if (i < 2) {
        await tester.tapAt(const Offset(4, 4));
        await pump(tester);
        expect(kind('_BreakTriangle'), findsOneWidget);
      }
    }
    await pump(tester, 5000);
    expect(kind('_BreakTriangle'), findsOneWidget);
    await tester.tapAt(const Offset(4, 4));
    await pump(tester);
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'review, score and closing accept separate taps before their deadlines',
    (tester) async {
      await launch(tester, 'finalReview');
      await pump(tester, 5000);
      expect(
        find.byKey(const ValueKey('final-review-continue')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('impact-haze')));
      await pump(tester);
      expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
      await pump(tester, 5000);
      expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('total-score')));
      await pump(tester);
      expect(kind('_ClosingPage'), findsOneWidget);
      await pump(tester, 5000);
      expect(kind('_ClosingPage'), findsOneWidget);
      await tester.tapAt(const Offset(4, 4));
      await pump(tester);
      expect(kind('_WelcomePage'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'audio, home and replay keep their own actions on readable pages',
    (tester) async {
      await launch(tester, 'risk');
      await tester.tap(
        find.descendant(
          of: kind('_RiskCard').at(1),
          matching: find.byType(InkWell),
        ),
      );
      await pump(tester);
      await tester.tap(find.byKey(const ValueKey('audio-settings')));
      await pump(tester);
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('audio-close')));
      await pump(tester);
      expect(kind('_RiskPage'), findsOneWidget);
      await tester.tap(find.text('Kembali'));
      await pump(tester);
      expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await launch(tester, 'score');
      await tester.tap(find.text('Main Lagi'));
      await pump(tester);
      expect(kind('_TriangleBuild'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('reading cards advance once and the last flip stays visible', (
    tester,
  ) async {
    await launch(tester, 'karhutlaCards');
    for (final key in [
      'karhutla-definition',
      'karhutla-cause',
      'karhutla-prevention',
    ]) {
      await pump(tester, 60000);
      expect(find.byKey(ValueKey(key)), findsOneWidget);
      await tester.tapAt(const Offset(4, 4));
      await pump(tester);
    }
    expect(kind('_RiskPage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await launch(tester, 'peatCharacteristics');
    await tester.tapAt(const Offset(4, 4));
    await pump(tester);
    expect(kind('_PeatCharacteristics'), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(ValueKey('peat-card-$i')));
      await pump(tester);
      expect(kind('_PeatCharacteristics'), findsOneWidget);
    }
    await pump(tester, 5000);
    expect(kind('_PeatCharacteristics'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('peat-card-0')));
    await pump(tester);
    expect(kind('_PeatCharacteristics'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('photo credits do not advance the review behind the dialog', (
    tester,
  ) async {
    await launch(tester, 'finalReview');
    await tester.tap(find.byKey(const ValueKey('impact-photo-credits')));
    await pump(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await pump(tester);
    expect(find.byKey(const ValueKey('final-review-continue')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('tap continuation preserves separately readable web semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await launch(tester, 'causeQuiz');
      await tester.tap(kind('_ChoiceButton').first);
      await pump(tester);
      expect(
        tester.getSemantics(find.text('BABAK 3 / SITUASI 1 DARI 4')).label,
        'BABAK 3 / SITUASI 1 DARI 4',
        reason:
            'A page-level tap must not merge all reading content into one node',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    } finally {
      semantics.dispose();
    }
  });
}
