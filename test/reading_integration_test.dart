import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/audio/narration_coordinator.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:fire_prevention_challenge/features/game/widgets/progressive_reading_text.dart';
import 'game_flow_test.dart' show loadGameFonts, ControlledStopwatch;

class ReadingPlayer implements NarrationPlayer, PositionedNarrationPlayer {
  final events = StreamController<Duration>.broadcast();
  final played = <String>[];
  final sessions = <Completer<void>>[];
  bool fail = false;
  int pauses = 0, resumes = 0;
  @override
  Stream<Duration> get positions => events.stream;
  @override
  Future<void> play(String asset, double volume) {
    played.add(asset);
    if (fail) return Future.error(StateError('decode failed'));
    final session = Completer<void>();
    sessions.add(session);
    return session.future;
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> pause() async {
    pauses++;
  }

  @override
  Future<void> resume() async {
    resumes++;
  }

  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> dispose() => events.close();
}

Future<void> waitForReading(WidgetTester tester, {String? card}) async {
  for (var i = 0; i < 50; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
    final finder = card == null
        ? find.byWidgetPredicate((w) => w is ProgressiveReadingText && w.key != const ValueKey('reading-paragraph-loading'))
        : find.byKey(ValueKey('reading-paragraph-$card'));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Reading timing asset did not load');
}

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await rootBundle.loadString('assets/audio/narration/reading_timing.json');
  });
  testWidgets('reduced motion exposes the complete paragraph immediately', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(411, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = ReadingPlayer();
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: ExhibitionGame(
          initialPage: 'karhutlaCards',
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
        ),
      ),
    );
    await tester.pump();
    await waitForReading(tester);
    final text = tester.widget<ProgressiveReadingText>(
      find.byType(ProgressiveReadingText),
    );
    expect(text.visibleCharacters, text.text.length);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('failed narration exposes the whole text and stays manual', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(411, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = ReadingPlayer()..fail = true;
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          initialPage: 'triangleExplanation',
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
        ),
      ),
    );
    await tester.tap(find.text('Lanjut'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await waitForReading(tester);
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    await tester.pump();
    expect(
      find.text('Audio belum tersedia. Silakan baca, lalu lanjutkan.'),
      findsOneWidget,
    );
    final text = tester.widget<ProgressiveReadingText>(
      find.byType(ProgressiveReadingText),
    );
    expect(text.visibleCharacters, text.text.length);
    await tester.pump(const Duration(seconds: 20));
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'silent reading uses recording duration and pauses in background',
    (tester) async {
      tester.view.physicalSize = const Size(411, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final clock = ControlledStopwatch();
      final player = ReadingPlayer();
      await tester.pumpWidget(
        MaterialApp(
          home: ExhibitionGame(
            initialPage: 'karhutlaCards',
            audioBackend: const SilentGameAudioBackend(),
            narrationPlayer: player,
            readingStopwatchFactory: () => clock,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await waitForReading(tester);
      expect(find.byType(ProgressiveReadingText), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      clock.advance(const Duration(seconds: 60));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      clock.advance(const Duration(seconds: 60));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
      expect(player.played, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'reading follows audio position and ignores old completion after skip',
    (tester) async {
      tester.view.physicalSize = const Size(411, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final player = ReadingPlayer();
      await tester.pumpWidget(
        MaterialApp(
          home: ExhibitionGame(
            initialPage: 'triangleExplanation',
            audioBackend: const SilentGameAudioBackend(),
            narrationPlayer: player,
          ),
        ),
      );
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await waitForReading(tester);
      await tester.pump(const Duration(seconds: 4)); // static renderer fallback
      await tester.pump();
      expect(player.played, ['id/karhutla-definition.mp3']);
      player.events.add(const Duration(seconds: 2));
      await tester.pump();
      await tester.pump();
      final text = tester.widget<ProgressiveReadingText>(
        find.byType(ProgressiveReadingText),
      );
      expect(text.visibleCharacters, greaterThan(0));
      expect(text.visibleCharacters, lessThan(text.text.length));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(player.pauses, greaterThan(0));
      player.events.add(const Duration(seconds: 4));
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<ProgressiveReadingText>(find.byType(ProgressiveReadingText))
            .visibleCharacters,
        text.visibleCharacters,
      );
      expect(player.pauses, greaterThan(0));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump();
      expect(player.resumes, greaterThan(0));
      player.events.add(const Duration(seconds: 4));
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<ProgressiveReadingText>(find.byType(ProgressiveReadingText))
            .visibleCharacters,
        greaterThan(text.visibleCharacters),
      );
      final previous = player.sessions.first;
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tester.tapAt(const Offset(5, 300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await waitForReading(tester, card: 'karhutla-cause');
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
      expect(player.played.last, 'id/karhutla-cause.mp3');
      previous.complete();
      await tester.pump();
      expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
      await tester.tap(find.text('Kembali'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await waitForReading(tester, card: 'karhutla-definition');
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
      expect(player.played.last, 'id/karhutla-definition.mp3');
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await waitForReading(tester, card: 'karhutla-cause');
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
      expect(player.played.last, 'id/karhutla-cause.mp3');
      player.sessions.last.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 400));
      await waitForReading(tester, card: 'karhutla-prevention');
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
      expect(player.played.last, 'id/karhutla-prevention.mp3');
      player.sessions.last.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 400));
      expect(
        find.text('Pilih jenis hutan yang memiliki lapisan gambut.'),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
