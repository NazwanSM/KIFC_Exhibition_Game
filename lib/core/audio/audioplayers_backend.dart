import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'game_audio.dart';

/// Two persistent loops and exactly one transient channel. Never creates a
/// player per tap. No position polling or network URLs are needed at runtime.
class AudioplayersGameBackend implements GameAudioBackend {
  AudioPlayer? _music, _nature, _effect;
  bool _ready = false, _disposed = false, _playing = false;
  double _musicGain = 0, _natureGain = 0, _effectGain = 0;
  int _effectEpoch = 0;
  Future<void> _commands = Future.value();
  Future<void> _enqueue(Future<void> Function() action) {
    final next = _commands.then((_) => action());
    _commands = next.catchError((Object _) {});
    return next;
  }

  @override
  Future<void> prepare() => _enqueue(() async {
    if (_ready || _disposed) return;
    await _release();
    try {
      for (var index = 0; index < 3; index++) {
        final player = AudioPlayer()..positionUpdater = null;
        if (index == 0) _music = player;
        if (index == 1) _nature = player;
        if (index == 2) _effect = player;
        await player.setAudioContext(
          AudioContextConfig(
            focus: AudioContextConfigFocus.mixWithOthers,
          ).build(),
        );
        await player.setVolume(0);
        await player.setReleaseMode(
          index < 2 ? ReleaseMode.loop : ReleaseMode.stop,
        );
        if (_disposed) return;
      }
      await _music!.setSource(AssetSource('audio/forest-music.mp3'));
      await _nature!.setSource(AssetSource('audio/forest-birds.mp3'));
      _ready = true;
      if (kDebugMode) {
        debugPrint('[KIFC audio] Offline sources ready; 3 players');
      }
    } catch (_) {
      await _release();
      rethrow;
    }
  });

  @override
  Future<void> setMix({
    required bool playing,
    required double music,
    required double nature,
    required double effects,
  }) {
    _playing = playing;
    _musicGain = music;
    _natureGain = nature;
    _effectGain = effects;
    if (!playing || effects == 0) _effectEpoch++;
    return _enqueue(() async {
      if (!_ready || _disposed) return;
      for (final pair in [(_music!, _musicGain), (_nature!, _natureGain)]) {
        await pair.$1.setVolume(_playing ? pair.$2 : 0);
        if (_disposed) return;
        if (_playing && pair.$2 > 0) {
          if (pair.$1.state != PlayerState.playing) await pair.$1.resume();
        } else if (pair.$1.state == PlayerState.playing) {
          await pair.$1.pause();
        }
      }
      await _effect!.setVolume(_playing ? _effectGain : 0);
      if (!_playing || _effectGain == 0) await _effect!.stop();
      if (kDebugMode) {
        debugPrint(
          '[KIFC audio] music=${_music!.state.name}:${_music!.volume} nature=${_nature!.state.name}:${_nature!.volume} effects=${_effect!.volume}',
        );
      }
    });
  }

  @override
  Future<void> play(GameSound sound) {
    final epoch = _effectEpoch;
    return _enqueue(() async {
      bool allowed() =>
          _ready &&
          !_disposed &&
          _playing &&
          _effectGain > 0 &&
          epoch == _effectEpoch;
      if (!allowed()) return;
      await _effect!.stop();
      await _effect!.setSource(AssetSource('audio/${sound.name}.wav'));
      if (!allowed()) return;
      await _effect!.setVolume(_effectGain);
      if (allowed()) {
        await _effect!.resume();
        if (kDebugMode) {
          debugPrint(
            '[KIFC audio] effect=${sound.name} state=${_effect!.state.name} gain=${_effect!.volume}',
          );
        }
      }
    });
  }

  Future<void> _release() async {
    for (final player in [_music, _nature, _effect]) {
      try {
        await player?.dispose();
      } catch (_) {
        /* A partial load must be recoverable. */
      }
    }
    _music = null;
    _nature = null;
    _effect = null;
    _ready = false;
  }

  @override
  Future<void> dispose() {
    _disposed = true;
    _playing = false;
    _effectEpoch++;
    return _enqueue(_release);
  }
}
