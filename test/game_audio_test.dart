import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';

class RecordingAudioBackend implements GameAudioBackend {
  final mixes =
      <({bool playing, double music, double nature, double effects})>[];
  final sounds = <GameSound>[];
  int preparations = 0, disposals = 0;
  Completer<void>? gate;
  bool fail = false;
  @override
  Future<void> prepare() async {
    preparations++;
    await gate?.future;
    if (fail) throw StateError('unavailable');
  }

  @override
  Future<void> setMix({
    required bool playing,
    required double music,
    required double nature,
    required double effects,
  }) async {
    mixes.add((
      playing: playing,
      music: music,
      nature: nature,
      effects: effects,
    ));
  }

  @override
  Future<void> play(GameSound sound) async => sounds.add(sound);
  @override
  Future<void> dispose() async => disposals++;
}

void main() {
  test(
    'silent before a gesture, loops start once and keep mixer levels',
    () async {
      final backend = RecordingAudioBackend();
      final audio = GameAudioController(backend: backend);
      expect(backend.preparations, 0);
      await audio.activate();
      await audio.activate();
      expect(backend.preparations, 1);
      expect(backend.mixes.last.playing, isTrue);
      expect(backend.mixes.last.music, closeTo(.45 * .35, .0001));
      await audio.setLevel(AudioLayer.music, .2);
      expect(backend.mixes.last.music, closeTo(.45 * .2, .0001));
      audio.dispose();
      await audio.settled;
      expect(backend.disposals, 1);
    },
  );
  test(
    'mute, zero and background silence output; resume never replays effects',
    () async {
      final backend = RecordingAudioBackend();
      final audio = GameAudioController(backend: backend);
      await audio.activate();
      await audio.play(GameSound.correct);
      await audio.setMuted(true);
      expect(backend.mixes.last.playing, isFalse);
      expect(backend.mixes.last.effects, 0);
      await audio.play(GameSound.retry);
      expect(backend.sounds, [GameSound.correct]);
      await audio.setMuted(false);
      await audio.setActive(false);
      expect(backend.mixes.last.playing, isFalse);
      await audio.play(GameSound.complete);
      await audio.setActive(true);
      expect(backend.sounds, [GameSound.correct]);
      await audio.setLevel(AudioLayer.master, 0);
      expect(backend.mixes.last.playing, isFalse);
      audio.dispose();
      await audio.settled;
    },
  );
  test(
    'mute during loading wins and dispose cannot leave a late loop playing',
    () async {
      final backend = RecordingAudioBackend()..gate = Completer<void>();
      final audio = GameAudioController(backend: backend);
      final activating = audio.activate();
      final muting = audio.setMuted(true);
      backend.gate!.complete();
      await Future.wait([activating, muting]);
      expect(backend.mixes.every((m) => !m.playing), isTrue);
      audio.dispose();
      await audio.settled;
      expect(backend.disposals, 1);
      expect(backend.mixes.last.playing, isFalse);
    },
  );
  test(
    'rapid neutral taps are bounded while feedback can replace a tap',
    () async {
      final backend = RecordingAudioBackend();
      final audio = GameAudioController(backend: backend);
      await audio.activate();
      await Future.wait(List.generate(20, (_) => audio.play(GameSound.select)));
      expect(backend.sounds, [GameSound.select]);
      await audio.play(GameSound.correct);
      expect(backend.sounds.last, GameSound.correct);
      audio.dispose();
      await audio.settled;
    },
  );
  test('failures are recoverable and do not throw through gameplay', () async {
    final backend = RecordingAudioBackend()..fail = true;
    final audio = GameAudioController(backend: backend);
    await audio.activate();
    expect(audio.unavailable, isTrue);
    backend.fail = false;
    await audio.retry();
    expect(audio.unavailable, isFalse);
    expect(backend.mixes.last.playing, isTrue);
    audio.dispose();
    await audio.settled;
  });
}
