import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'game_flow_test.dart' show loadGameFonts;
import 'reading_integration_test.dart' show ReadingPlayer, waitForReading;
import 'chapter2_review_test.dart' show captureScreen;

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await rootBundle.loadString('assets/audio/narration/reading_timing.json');
  });
  Future<ReadingPlayer> launch(WidgetTester t) async {
    t.view.physicalSize = const Size(411, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final p = ReadingPlayer();
    await t.pumpWidget(
      MaterialApp(
        theme: KifcTheme.light(),
        home: RepaintBoundary(
          key: const ValueKey('review-target'),
          child: ExhibitionGame(
            initialPage: 'triangleExplanation',
            audioBackend: const SilentGameAudioBackend(),
            narrationPlayer: p,
          ),
        ),
      ),
    );
    await t.tap(find.text('Lanjut'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
    await waitForReading(t);
    await t.pump(const Duration(seconds: 4));
    await t.pump();
    return p;
  }

  testWidgets(
    'each reading holds for one second after speech including before quiz',
    (t) async {
      final p = await launch(t);
      for (final key in ['definition', 'cause', 'prevention']) {
        p.sessions.last.complete();
        await t.pump();
        await t.pump(const Duration(milliseconds: 999));
        expect(find.byKey(ValueKey('karhutla-$key')), findsOneWidget);
        await captureScreen(t, 'reading-$key-hold-999ms', {
          'source': 'Flutter widget render, controlled narration completion',
          'width': 411,
          'height': 900,
          'afterSpeechMilliseconds': 999,
        });
        await t.pump(const Duration(milliseconds: 1));
        await t.pump(const Duration(milliseconds: 400));
        if (key != 'prevention') {
          await waitForReading(t);
          await t.pump(const Duration(seconds: 4));
          await t.pump();
        }
      }
      expect(
        find.text('Pilih jenis hutan yang memiliki lapisan gambut.'),
        findsOneWidget,
      );
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'manual next cancels speech completion delay and cannot skip another page',
    (t) async {
      final p = await launch(t);
      p.sessions.last.complete();
      await t.pump();
      await t.tap(find.text('Lanjut'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
      await t.pump(const Duration(seconds: 2));
      expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
      await t.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('background pauses the post-speech allowance', (t) async {
    final p = await launch(t);
    p.sessions.last.complete();
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await t.pump();
    await t.pump(const Duration(seconds: 3));
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await t.pump();
    await t.pump(const Duration(milliseconds: 599));
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await t.pump(const Duration(milliseconds: 1));
    await t.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
    await t.pumpWidget(const SizedBox.shrink());
  });
}
