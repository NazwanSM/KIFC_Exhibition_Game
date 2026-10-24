import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'game_audio.dart';

/// Fixed sources: two loops plus one reusable player for each short cue.
/// Keeping each source avoids per-tap loading and source/end-event interleaving.
/// Independent command lanes keep an effect failure from blocking the mixer.
class AudioplayersGameBackend implements GameAudioBackend {
  AudioPlayer? _music, _nature;
  final _effects = <GameSound, AudioPlayer>{};
  bool _ready = false, _disposed = false, _playing = false;
  double _musicGain = 0, _natureGain = 0, _effectGain = 0;
  int _effectEpoch = 0;
  Future<void> _mixCommands = Future.value(), _effectCommands = Future.value();

  Future<void> _mix(Future<void> Function() action) {
    final next = _mixCommands.then((_) => action());
    _mixCommands = next.catchError((Object _) {});
    return next;
  }

  Future<void> _cue(Future<void> Function() action) {
    final next = _effectCommands.then((_) => action());
    _effectCommands = next.catchError((Object _) {});
    return next;
  }

  Future<AudioPlayer> _load(String file, {bool loop = false}) async {
    final player = AudioPlayer()..positionUpdater = null;
    try {
      await player.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await player.setVolume(0);
      await player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
      await player.setSource(AssetSource('audio/$file'));
      return player;
    } catch (_) {
      await player.dispose();
      rethrow;
    }
  }

  @override
  Future<void> prepare() => _mix(() async {
    if (_ready || _disposed) return;
    await _release();
    try {
      _music = await _load('forest-music.mp3', loop: true);
      _nature = await _load('forest-birds.mp3', loop: true);
      for (final sound in GameSound.values) {
        if (_disposed) break;
        try {
          _effects[sound] = await _load('${sound.name}.wav');
        } catch (error) {
          debugPrint('[KIFC audio] preload ${sound.name} failed: $error');
          // Keep loops and other cues available; recreate this cue on demand.
        }
      }
      _ready = !_disposed;
      if (kDebugMode) {
        debugPrint(
          '[KIFC audio] Offline sources ready; ${2 + _effects.length} fixed players',
        );
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
    // Do not wait behind a one-shot's load/resume to silence background output.
    return _mix(() async {
      if (!_ready || _disposed) return;
      try {
        for (final pair in [(_music!, _musicGain), (_nature!, _natureGain)]) {
          await pair.$1.setVolume(_playing ? pair.$2 : 0);
          if (_disposed) return;
          if (_playing && pair.$2 > 0) {
            if (pair.$1.state != PlayerState.playing) await pair.$1.resume();
          } else if (pair.$1.state == PlayerState.playing) {
            await pair.$1.pause();
          }
        }
        for (final entry in _effects.entries.toList()) {
          try {
            await entry.value.setVolume(_playing ? _effectGain : 0);
            if (!_playing || _effectGain == 0) await entry.value.stop();
          } catch (error) {
            await _discard(entry.key, entry.value);
            debugPrint(
              '[KIFC audio] mix effect ${entry.key.name} failed: $error',
            );
          }
        }
        if (kDebugMode) {
          debugPrint(
            '[KIFC audio] music=${_music!.state.name}:${_music!.volume} nature=${_nature!.state.name}:${_nature!.volume} effects=$_effectGain',
          );
        }
      } catch (_) {
        await _release();
        rethrow;
      }
    });
  }

  @override
  Future<void> play(GameSound sound) {
    final epoch = _effectEpoch;
    return _cue(() async {
      bool allowed() =>
          _ready &&
          !_disposed &&
          _playing &&
          _effectGain > 0 &&
          epoch == _effectEpoch;
      if (!allowed()) return;
      AudioPlayer? player;
      try {
        player = _effects[sound] ??= await _load('${sound.name}.wav');
        if (!allowed()) {
          await player.setVolume(0);
          return;
        }
        // Stop and rewind only this cue; navigation cannot cut off feedback.
        await player.stop();
        if (!allowed()) return;
        await player.setVolume(_effectGain);
        if (!allowed()) {
          await player.setVolume(0);
          return;
        }
        await player.resume();
        if (!allowed()) await player.stop();
        if (kDebugMode) {
          debugPrint(
            '[KIFC audio] effect=${sound.name} state=${player.state.name} gain=${player.volume}',
          );
        }
      } catch (_) {
        if (player != null) await _discard(sound, player);
        rethrow;
      }
    });
  }

  Future<void> _discard(GameSound sound, AudioPlayer player) async {
    if (identical(_effects[sound], player)) _effects.remove(sound);
    try {
      await player.dispose();
    } catch (_) {
      /* Already failed. */
    }
  }

  Future<void> _release() async {
    _ready = false;
    final players = [_music, _nature, ..._effects.values];
    _music = null;
    _nature = null;
    _effects.clear();
    for (final player in players) {
      try {
        await player?.dispose();
      } catch (_) {
        /* Partial load cleanup. */
      }
    }
  }

  @override
  Future<void> dispose() {
    _disposed = true;
    _playing = false;
    _effectEpoch++;
    return Future.wait([_mixCommands, _effectCommands]).then((_) => _release());
  }
}
