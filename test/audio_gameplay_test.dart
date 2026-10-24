import 'package:fire_prevention_challenge/core/audio/audio_controls.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'game_audio_test.dart' show RecordingAudioBackend;
import 'game_flow_test.dart' show GameFlow, loadGameFonts;

void main() {
  setUpAll(loadGameFonts);
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
