import 'dart:async';
import 'package:flutter/foundation.dart';

enum GameSound { tap, select, flip, correct, retry, complete }

enum AudioLayer { master, music, nature, effects }

abstract interface class GameAudioBackend {
  Future<void> prepare();
  Future<void> setMix({
    required bool playing,
    required double music,
    required double nature,
    required double effects,
  });
  Future<void> play(GameSound sound);
  Future<void> dispose();
}

/// Session settings deliberately outlive page changes and Replay, not app exit.
class GameAudioController extends ChangeNotifier {
  GameAudioController({required GameAudioBackend backend}) : _backend = backend;
  final GameAudioBackend _backend;
  final _levels = <AudioLayer, double>{
    AudioLayer.master: .45,
    AudioLayer.music: .35,
    AudioLayer.nature: .45,
    AudioLayer.effects: .7,
  };
  bool muted = false, unavailable = false;
  bool _activated = false, _active = true, _disposed = false, _prepared = false;
  bool _dirty = false, _updating = false;
  int _effectEpoch = 0;
  final Stopwatch _clock = Stopwatch()..start();
  int _lastEffect = -1000;
  Future<void> _pending = Future.value();
  Future<void> get settled => _pending;
  double level(AudioLayer layer) => _levels[layer]!;
  bool get audible =>
      _activated &&
      _active &&
      !muted &&
      level(AudioLayer.master) > 0 &&
      !_disposed &&
      !unavailable;

  Future<void> activate() {
    if (_disposed) return Future.value();
    if (_activated) return _pending;
    _activated = true;
    notifyListeners();
    return _sync();
  }

  Future<void> setLevel(AudioLayer layer, double value) {
    if (_disposed) return Future.value();
    _levels[layer] = value.isFinite ? value.clamp(0, 1) : 0;
    _effectEpoch++;
    notifyListeners();
    return _sync();
  }

  Future<void> setMuted(bool value) {
    if (_disposed) return Future.value();
    muted = value;
    _effectEpoch++;
    notifyListeners();
    return _sync();
  }

  Future<void> setActive(bool value) {
    if (_disposed) return Future.value();
    _active = value;
    _effectEpoch++;
    return _sync();
  }

  Future<void> retry() {
    if (_disposed) return Future.value();
    unavailable = false;
    notifyListeners();
    _activated = true;
    return _sync();
  }

  Future<void> _sync() {
    _dirty = true;
    if (_updating) return _pending;
    _updating = true;
    return _pending = _drain();
  }

  Future<void> _drain() async {
    try {
      while (_dirty && !_disposed) {
        _dirty = false;
        if (!_activated || unavailable) continue;
        if (!_prepared) {
          await _backend.prepare();
          _prepared = true;
        }
        if (_disposed) break;
        // Re-read state after preparation: an intervening mute/background wins.
        final gain = audible ? level(AudioLayer.master) : 0.0;
        await _backend.setMix(
          playing: audible,
          music: gain * level(AudioLayer.music),
          nature: gain * level(AudioLayer.nature),
          effects: gain * level(AudioLayer.effects),
        );
      }
    } catch (_) {
      await _fail();
    } finally {
      _updating = false;
    }
  }

  Future<void> play(GameSound sound) async {
    if (!audible || level(AudioLayer.effects) == 0) return;
    final feedback =
        sound == GameSound.correct ||
        sound == GameSound.retry ||
        sound == GameSound.complete;
    if (!feedback && _clock.elapsedMilliseconds - _lastEffect < 100) return;
    _lastEffect = _clock.elapsedMilliseconds;
    final epoch = _effectEpoch;
    await _pending;
    if (!audible || epoch != _effectEpoch) return;
    try {
      await _backend.play(sound);
    } catch (_) {
      await _fail();
    }
  }

  Future<void> _fail() async {
    if (_disposed) return;
    unavailable = true;
    _effectEpoch++;
    notifyListeners();
    try {
      await _backend.setMix(playing: false, music: 0, nature: 0, effects: 0);
    } catch (_) {
      /* Failed output must not affect the game. */
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _effectEpoch++;
    _pending = _pending
        .then((_) => _backend.dispose())
        .catchError((Object _) {});
    _clock.stop();
    super.dispose();
  }
}

/// Injectable no-output backend for UI rendering tests; production uses players.
class SilentGameAudioBackend implements GameAudioBackend {
  const SilentGameAudioBackend();
  @override
  Future<void> prepare() async {}
  @override
  Future<void> setMix({
    required bool playing,
    required double music,
    required double nature,
    required double effects,
  }) async {}
  @override
  Future<void> play(GameSound sound) async {}
  @override
  Future<void> dispose() async {}
}
