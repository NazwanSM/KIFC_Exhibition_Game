import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fire_prevention_challenge/core/audio/narration_coordinator.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'game_flow_test.dart' show loadGameFonts;

class FakeNarration implements NarrationPlayer {
  final played = <String>[];
  bool fail = false;
  int stops = 0;
  Completer<void>? current;
  @override
  Future<void> play(String asset, double volume) {
    played.add(asset);
    if (fail) return Future.error(StateError('output unavailable'));
    return (current = Completer<void>()).future;
  }

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  setUpAll(loadGameFonts);
  testWidgets('playing again stops the closing voice', (tester) async {
    tester.view.physicalSize = const Size(411, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          initialPage: 'score',
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
        ),
      ),
    );
    await tester.tap(find.text('Selesai'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    expect(player.played, ['id/closing.mp3']);
    final before = player.stops;
    await tester.tap(find.text('Main Lagi'));
    await tester.pump();
    await tester.pump();
    expect(player.stops, greaterThan(before));
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('changing language replaces the active greeting', (tester) async {
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
          greetingInterval: const Duration(seconds: 1),
        ),
      ),
    );
    await tester.tap(find.text('English').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    final old = player.current!;
    await tester.tap(find.text('한국어').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(player.played, ['en/welcome.mp3', 'ko/welcome.mp3']);
    old.complete();
    await tester.pump();
    expect(player.current!.isCompleted, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  test('failed voice restores silent mascot state', () async {
    final player = FakeNarration()..fail = true;
    final states = <bool>[];
    final voice = NarrationCoordinator(player: player, onSpeaking: states.add);
    voice.speak('id/closing.mp3', .5);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(states, [true, false]);
    await voice.dispose();
  });
  testWidgets('leaving before the mascot loads cancels closing speech', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(411, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          initialPage: 'score',
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
        ),
      ),
    );
    await tester.tap(find.text('Selesai'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Beranda'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    expect(player.played.where((x) => x.endsWith('closing.mp3')), isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('backgrounding stops a greeting', (tester) async {
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
          greetingInterval: const Duration(seconds: 1),
        ),
      ),
    );
    await tester.tap(find.text('English').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(player.played.length, 1);
    final before = player.stops;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    await tester.pump();
    expect(player.stops, greaterThan(before));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('muting cancels speech and does not queue greetings', (
    tester,
  ) async {
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
          greetingInterval: const Duration(seconds: 1),
        ),
      ),
    );
    await tester.tap(find.text('English').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(player.played.length, 1);
    await tester.tap(find.byKey(const ValueKey('audio-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('audio-mute')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('audio-close')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    expect(player.played.length, 1);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('closing speech ends without advancing the page', (tester) async {
    tester.view.physicalSize = const Size(411, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          initialPage: 'score',
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
        ),
      ),
    );
    await tester.tap(find.text('Selesai'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(player.played, isEmpty);
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    expect(player.played, ['id/closing.mp3']);
    player.current!.complete();
    await tester.pump();
    expect(find.text('Jaga Hutan,\nJaga Kehidupan.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('welcome greeting stops when the player starts', (tester) async {
    final player = FakeNarration();
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitionGame(
          audioBackend: const SilentGameAudioBackend(),
          narrationPlayer: player,
          greetingInterval: const Duration(seconds: 1),
        ),
      ),
    );
    await tester.tap(find.text('English').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(player.played, ['en/welcome.mp3']);
    player.current!.complete();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(player.played, ['en/welcome.mp3', 'en/welcome.mp3']);
    final count = player.stops;
    await tester.tap(find.text('Start Challenge'));
    await tester.pump();
    await tester.pump();
    expect(player.stops, greaterThan(count));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test(
    'replacing speech cancels old completion and ends current speech',
    () async {
      final player = FakeNarration();
      final states = <bool>[];
      final coordinator = NarrationCoordinator(
        player: player,
        onSpeaking: states.add,
      );
      coordinator.speak('id/welcome.mp3', 0.5);
      await Future<void>.delayed(Duration.zero);
      final old = player.current!;
      coordinator.speak('en/closing.mp3', 0.5);
      await Future<void>.delayed(Duration.zero);
      old.complete();
      await Future<void>.delayed(Duration.zero);
      expect(states.last, isTrue);
      player.current!.complete();
      await Future<void>.delayed(Duration.zero);
      expect(states.last, isFalse);
      expect(player.played, ['id/welcome.mp3', 'en/closing.mp3']);
      await coordinator.dispose();
    },
  );
}
