import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'narration_position_updater.dart'
    if (dart.library.js_interop) 'narration_position_updater_web.dart';

abstract interface class NarrationPlayer {
  Future<void> play(String asset, double volume);
  Future<void> setVolume(double volume);
  Future<void> stop();
  Future<void> dispose();
}

/// Optional capabilities used by synchronized readings.
abstract interface class PositionedNarrationPlayer {
  Stream<Duration> get positions;
  Future<void> pause();
  Future<void> resume();
}

/// Owns a single voice session. Epochs prevent stale completions from changing
/// the current mascot or mixer after navigation or language changes.
class NarrationCoordinator {
  NarrationCoordinator({required this.player, required this.onSpeaking});
  final NarrationPlayer player;
  final void Function(bool) onSpeaking;
  int _epoch = 0;
  Future<void> _commands = Future.value();
  bool _disposed = false;
  void speak(
    String asset,
    double volume, {
    void Function()? onStart,
    void Function()? onFinished,
    void Function()? onError,
  }) {
    final epoch = ++_epoch;
    _commands = _commands
        .catchError((Object _) {})
        .then((_) async {
          await player.stop();
          if (_disposed || epoch != _epoch) return;
          onSpeaking(true);
          onStart?.call();
          unawaited(
            player
                .play(asset, volume)
                .then((_) {
                  if (!_disposed && epoch == _epoch) {
                    onSpeaking(false);
                    onFinished?.call();
                  }
                })
                .catchError((Object _) {
                  if (!_disposed && epoch == _epoch) {
                    onSpeaking(false);
                    onError?.call();
                  }
                }),
          );
        })
        .catchError((Object _) {
          if (!_disposed && epoch == _epoch) {
            onSpeaking(false);
            onError?.call();
          }
        });
  }

  void stop() {
    ++_epoch;
    onSpeaking(false);
    _commands = _commands.catchError((Object _) {}).then((_) => player.stop());
  }

  void setVolume(double volume) {
    if (!_disposed) {
      _commands = _commands
          .catchError((Object _) {})
          .then((_) => player.setVolume(volume));
    }
  }

  void pause() {
    final p = player;
    if (p is PositionedNarrationPlayer) {
      final positioned = p as PositionedNarrationPlayer;
      _commands = _commands
          .catchError((Object _) {})
          .then((_) => positioned.pause());
    }
  }

  void resume() {
    final p = player;
    if (p is PositionedNarrationPlayer) {
      final positioned = p as PositionedNarrationPlayer;
      _commands = _commands
          .catchError((Object _) {})
          .then((_) => positioned.resume());
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    ++_epoch;
    await _commands.catchError((Object _) {});
    await player.dispose();
  }
}

class AssetNarrationPlayer
    implements NarrationPlayer, PositionedNarrationPlayer {
  AssetNarrationPlayer({AudioPlayer Function()? createPlayer})
    : _playerFactory = createPlayer;

  final AudioPlayer Function()? _playerFactory;
  AudioPlayer? _player;
  final _positions = StreamController<Duration>.broadcast();
  StreamSubscription<Duration>? _positionSubscription;
  @override
  Stream<Duration> get positions => _positions.stream;
  Future<void> _operations = Future.value();
  Completer<void>? _completion;
  StreamSubscription<void>? _subscription;

  Future<void> _enqueue(Future<void> Function() action) {
    final next = _operations.catchError((Object _) {}).then((_) => action());
    _operations = next.catchError((Object _) {});
    return next;
  }

  @override
  Future<void> play(String asset, double volume) async {
    final done = Completer<void>();
    await _enqueue(() async {
      await _stopCurrent();
      // Platform completion and asynchronous position queries carry no source
      // identity. Give each clip its own player so late events from the previous
      // recording cannot finish or reveal the next reading.
      final player = _player = _playerFactory?.call() ?? _createPlayer();
      _positionSubscription = player.onPositionChanged.listen(_positions.add);
      _completion = done;
      await player.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await player.setReleaseMode(ReleaseMode.stop);
      _subscription = player.onPlayerComplete.listen((_) {
        if (!done.isCompleted) done.complete();
      });
      await player.play(
        AssetSource('audio/narration/prepared/$asset'),
        volume: volume,
      );
    });
    await done.future;
  }

  AudioPlayer _createPlayer() {
    final player = AudioPlayer();
    player.positionUpdater = createNarrationPositionUpdater(
      getPosition: player.getCurrentPosition,
    );
    return player;
  }

  @override
  Future<void> pause() => _enqueue(() async {
    await _player?.pause();
  });
  @override
  Future<void> resume() => _enqueue(() async {
    await _player?.resume();
  });

  @override
  Future<void> setVolume(double volume) => _enqueue(() async {
    await _player?.setVolume(volume);
  });

  @override
  Future<void> stop() => _enqueue(_stopCurrent);

  Future<void> _stopCurrent() async {
    // Detach before stop: stop itself can emit a final position/completion.
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await _subscription?.cancel();
    _subscription = null;
    final player = _player;
    _player = null;
    final done = _completion;
    _completion = null;
    if (done != null && !done.isCompleted) done.complete();
    try {
      await player?.stop();
    } finally {
      await player?.dispose();
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _positions.close();
  }
}
