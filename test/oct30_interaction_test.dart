import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen;
import 'game_flow_test.dart'
    show loadGameFonts, ControlledStopwatch, renderedTextByKey;
import 'game_audio_test.dart' show RecordingAudioBackend;

Future<ControlledStopwatch> openChallenge(
  WidgetTester tester, {
  RecordingAudioBackend? backend,
}) async {
  final clock = ControlledStopwatch();
  await launchScreen(
    tester,
    size: const Size(411, 731),
    locale: AppLocale.indonesian,
    page: 'peatCharacteristics',
    stopwatchFactory: () => clock,
    audioBackend: backend,
  );
  await tester.runAsync(() async {
    final context = tester.element(find.byType(ExhibitionGame));
    for (final path in [
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
  for (var i = 0; i < 3; i++) {
    await tester.tap(find.byKey(ValueKey('peat-card-$i')));
    await tester.pump(const Duration(milliseconds: 500));
  }
  await tester.tap(find.byKey(const ValueKey('peat-cards-continue')));
  for (var i = 0; i < 100 && kind('_FinalChallenge').evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
  await tester.pump(const Duration(milliseconds: 800));
  expect(clock.isRunning, isTrue);
  return clock;
}

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
  for (final (selected, correct, wrong, missed, bonus) in [
    (<String>[], 0, 0, 4, 0.0),
    (['haze'], 1, 0, 3, .25),
    (['haze', 'carbonStorage'], 1, 1, 3, 0.0),
    (
      ['haze', 'ecosystemDamage', 'carbonEmissions', 'subsidence'],
      4,
      0,
      0,
      1.0,
    ),
    (
      [
        'haze',
        'ecosystemDamage',
        'carbonEmissions',
        'subsidence',
        'cleanAir',
        'carbonStorage',
      ],
      4,
      2,
      0,
      .5,
    ),
  ]) {
    testWidgets(
      'R30-06 early finish grades current selection $correct-$wrong',
      (tester) async {
        final backend = RecordingAudioBackend();
        final clock = await openChallenge(tester, backend: backend);
        for (final token in selected) {
          await tester.tap(find.byKey(ValueKey('impact-$token')));
          await tester.pump(const Duration(milliseconds: 100));
        }
        final grid = find.byKey(const ValueKey('final-selection-grid'));
        expect(
          find.descendant(of: grid, matching: find.byIcon(Icons.check_rounded)),
          findsNothing,
        );
        await tester.tap(find.byKey(const ValueKey('final-finish-early')));
        await tester.pump(const Duration(milliseconds: 700));
        expect(clock.isRunning, isFalse);
        expect(find.byKey(const ValueKey('final-finish-early')), findsNothing);
        expect(
          renderedTextByKey(tester, 'final-review-summary'),
          '$correct benar · $wrong salah · $missed terlewat',
        );
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 80)),
        );
        expect(backend.sounds.where((s) => s == GameSound.finish).length, 1);
        clock.advance(const Duration(seconds: 40));
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.byKey(const ValueKey('final-review-continue')),
          findsOneWidget,
        );
        await tester.tap(find.byKey(const ValueKey('final-review-continue')));
        await tester.pump(const Duration(milliseconds: 500));
        expect((tester.widget(kind('_ScorePage')) as dynamic).bonus, bonus);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
  testWidgets(
    'R30-06 canceled choice stays canceled and repeated finish is harmless',
    (tester) async {
      final backend = RecordingAudioBackend();
      await openChallenge(tester, backend: backend);
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('impact-haze')));
        await tester.pump(const Duration(milliseconds: 100));
      }
      final action = tester
          .widget<ElevatedButton>(
            find.descendant(
              of: find.byKey(const ValueKey('final-finish-early')),
              matching: find.byWidgetPredicate((w) => w is ElevatedButton),
            ),
          )
          .onPressed!;
      action();
      action();
      await tester.pump(const Duration(milliseconds: 700));
      expect(
        renderedTextByKey(tester, 'final-review-summary'),
        '0 benar · 0 salah · 4 terlewat',
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 80)),
      );
      expect(backend.sounds.where((s) => s == GameSound.finish).length, 1);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  for (final deadlineFirst in [false, true]) {
    testWidgets('R30-06 finish at deadline happens once ($deadlineFirst)', (
      tester,
    ) async {
      final backend = RecordingAudioBackend();
      final clock = await openChallenge(tester, backend: backend);
      final action = tester
          .widget<ElevatedButton>(
            find.descendant(
              of: find.byKey(const ValueKey('final-finish-early')),
              matching: find.byWidgetPredicate((w) => w is ElevatedButton),
            ),
          )
          .onPressed!;
      clock.advance(const Duration(seconds: 30));
      if (deadlineFirst) await tester.pump(const Duration(milliseconds: 100));
      action();
      action();
      await tester.pump(const Duration(milliseconds: 900));
      expect(
        find.byKey(const ValueKey('final-review-continue')),
        findsOneWidget,
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 80)),
      );
      expect(backend.sounds.where((s) => s == GameSound.finish).length, 1);
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.byKey(const ValueKey('final-review-continue')),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('R30-04 closing keeps 30 seconds; other feedback keeps 15', (
    tester,
  ) async {
    await launch(tester, 'closing');
    expect((tester.widget(kind('_ClosingPage')) as dynamic).readingSeconds, 30);
    await tester.pump(const Duration(seconds: 15));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 14));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('R30-04 early tap cancels closing deadline', (tester) async {
    await launch(tester, 'closing');
    await tester.pump(const Duration(seconds: 16));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.tapAt(const Offset(4, 4));
    await tester.pump(const Duration(milliseconds: 400));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 40));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('R30-04 dialog and inactive app pause closing allowance', (
    tester,
  ) async {
    await launch(tester, 'closing');
    await tester.pump(const Duration(seconds: 5));
    await tester.tap(find.byKey(const ValueKey('audio-settings')));
    await tester.pump(const Duration(milliseconds: 300));
    int remaining() =>
        (tester.widget(kind('_ClosingPage')) as dynamic).readingSeconds as int;
    final beforeDialog = remaining();
    await tester.pump(const Duration(seconds: 40));
    expect(remaining(), beforeDialog);
    await tester.tap(find.byKey(const ValueKey('audio-close')));
    await tester.pump(const Duration(milliseconds: 300));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    final beforePause = remaining();
    await tester.pump(const Duration(seconds: 40));
    expect(remaining(), beforePause);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(Duration(seconds: beforePause - 1));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
