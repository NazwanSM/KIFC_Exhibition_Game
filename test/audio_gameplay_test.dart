import 'package:fire_prevention_challenge/core/audio/audio_controls.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show SemanticsAction, SemanticsActionEvent;
import 'package:flutter_test/flutter_test.dart';
import 'game_audio_test.dart' show RecordingAudioBackend;
import 'game_flow_test.dart' show GameFlow, loadGameFonts;

void main() {
  setUpAll(loadGameFonts);
  testWidgets('semantic navigation starts audio without pointer events', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    final backend = RecordingAudioBackend();
    final flow = GameFlow(
      tester,
      english: false,
      size: const Size(411, 731),
      audioBackend: backend,
    );
    await flow.launch();
    final start = tester.getSemantics(find.text('Mulai Tantangan'));
    tester.binding.performSemanticsAction(
      SemanticsActionEvent(
        nodeId: start.id,
        type: SemanticsAction.tap,
        viewId: tester.view.viewId,
      ),
    );
    await flow.pump();
    expect(backend.preparations, 1);
    expect(backend.sounds, [GameSound.tap]);
    expect(flow.type('_TriangleBuild'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    semantics.dispose();
  });
  testWidgets('final deadline sounds once and navigation/dialog buttons sound', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final backend = RecordingAudioBackend();
    final flow = GameFlow(
      tester,
      english: false,
      size: const Size(411, 731),
      audioBackend: backend,
    );
    await flow.launch();
    await flow.toCharacteristics();
    await flow.readCharacteristics();
    await flow.finalChallenge();
    backend.sounds.clear();
    flow.clock.advance(const Duration(seconds: 30));
    await flow.pump(100);
    await flow.pump(500);
    expect(backend.sounds, [GameSound.finish]);
    await flow.pump(3000);
    expect(backend.sounds, [
      GameSound.finish,
    ], reason: 'Deadline cannot repeat cue');
    await tester.tap(find.byKey(const ValueKey('impact-photo-credits')));
    await flow.pump();
    expect(backend.sounds.last, GameSound.tap);
    // A distinct real user gesture, outside the double-tap suppression window.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 80)),
    );
    backend.sounds.clear();
    await flow.tap('Tutup');
    expect(backend.sounds, [GameSound.tap]);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 80)),
    );
    backend.sounds.clear();
    await tester.tap(find.byKey(const ValueKey('final-review-continue')));
    await flow.pump();
    expect(backend.sounds, [GameSound.tap]);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 80)),
    );
    await flow.tap('Selesai');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 80)),
    );
    backend.sounds.clear();
    await flow.tap('Main Lagi');
    expect(backend.sounds, [
      GameSound.tap,
    ], reason: 'Custom closing button must sound');
    expect(
      backend.preparations,
      1,
      reason: 'Replay reuses fixed audio resources',
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'final choices and information cards never reveal correctness through sound',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final backend = RecordingAudioBackend();
      final flow = GameFlow(
        tester,
        english: false,
        size: const Size(411, 731),
        audioBackend: backend,
      );
      await flow.launch();
      await flow.toCharacteristics();
      expect(backend.sounds, contains(GameSound.correct));
      backend.sounds.clear();
      await flow.readCharacteristics();
      expect(backend.sounds.every((s) => s == GameSound.flip), isTrue);
      await flow.finalChallenge();
      backend.sounds.clear();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 120)),
      );
      await flow.token('haze');
      await flow.pump(150);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 120)),
      );
      await flow.token('cleanAir');
      await flow.pump(150);
      expect(backend.sounds, [GameSound.select, GameSound.select]);
      final audio = GameAudioScope.of(
        tester.element(find.byKey(const ValueKey('audio-settings'))),
      );
      await audio.setMuted(true);
      await flow.finish(perfect: false);
      expect(backend.sounds, [GameSound.select, GameSound.select]);
      await flow.tap('Main Lagi');
      expect(
        audio.muted,
        isTrue,
        reason: 'Replay preserves visitor audio settings',
      );
      expect(
        backend.preparations,
        1,
        reason: 'Replay cannot duplicate loop players',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await audio.settled;
      expect(backend.disposals, 1);
    },
  );
}
