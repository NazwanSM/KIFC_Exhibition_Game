import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'game_audio_test.dart' show RecordingAudioBackend;

void main() {
  test(
    'R30-09 soundtrack defaults keep music present and effects separate',
    () async {
      final backend = RecordingAudioBackend();
      final audio = GameAudioController(backend: backend);
      await audio.activate();
      expect(backend.mixes.last.music, closeTo(.65 * .50, .0001));
      expect(backend.mixes.last.nature, closeTo(.65 * .22, .0001));
      expect(backend.mixes.last.effects, .65);
      audio.dispose();
      await audio.settled;
    },
  );

  test(
    'R30-09 narration ducking restores current user levels without new players',
    () async {
      final backend = RecordingAudioBackend();
      final audio = GameAudioController(backend: backend);
      await audio.setLevel(AudioLayer.music, .8);
      await audio.setLevel(AudioLayer.nature, .4);
      await audio.activate();
      await audio.setNarrationActive(true);
      expect(audio.level(AudioLayer.music), .8);
      expect(audio.level(AudioLayer.nature), .4);
      expect(backend.mixes.last.music, closeTo(.65 * .8 * .28, .0001));
      expect(backend.mixes.last.nature, closeTo(.65 * .4 * .5, .0001));
      expect(backend.mixes.last.effects, .65);
      await audio.play(GameSound.correct);
      expect(backend.sounds, [GameSound.correct]);
      await audio.setLevel(AudioLayer.music, .6);
      await audio.setNarrationActive(false);
      expect(backend.mixes.last.music, closeTo(.65 * .6, .0001));
      expect(backend.mixes.last.nature, closeTo(.65 * .4, .0001));
      expect(backend.preparations, 1);
      audio.dispose();
      await audio.settled;
    },
  );

  test(
    'R30-09 ducking never unlocks autoplay or overrides mute and lifecycle',
    () async {
      final backend = RecordingAudioBackend();
      final audio = GameAudioController(backend: backend);
      await audio.setNarrationActive(true);
      expect(backend.preparations, 0);
      await audio.activate();
      await audio.setMuted(true);
      await audio.setNarrationActive(false);
      expect(backend.mixes.last.playing, isFalse);
      expect(backend.mixes.last.music, 0);
      await audio.setMuted(false);
      await audio.setActive(false);
      await audio.setNarrationActive(true);
      expect(backend.mixes.last.music, 0);
      await audio.setActive(true);
      expect(backend.mixes.last.music, closeTo(.65 * .5 * .28, .0001));
      expect(audio.level(AudioLayer.music), .5);
      expect(backend.preparations, 1);
      audio.dispose();
      await audio.settled;
      await audio.setNarrationActive(false);
      expect(backend.disposals, 1);
    },
  );
}
