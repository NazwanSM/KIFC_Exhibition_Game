import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/audio/narration_coordinator.dart';

class ClipPlayer extends Fake implements AudioPlayer {
  final positions = StreamController<Duration>.broadcast();
  final completions = StreamController<void>.broadcast();
  final started = Completer<void>();
  bool disposed = false;
  @override
  Stream<Duration> get onPositionChanged => positions.stream;
  @override
  Stream<void> get onPlayerComplete => completions.stream;
  @override
  Future<void> setAudioContext(AudioContext context) async {}
  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {}
  @override
  Future<void> play(
    Source source, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {
    if (!started.isCompleted) started.complete();
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

Future<void> flush() async {
  for (var i = 0; i < 12; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  test(
    'late old-clip position and completion cannot finish the next narration',
    () async {
      final clips = <ClipPlayer>[];
      final player = AssetNarrationPlayer(
        createPlayer: () {
          final clip = ClipPlayer();
          clips.add(clip);
          return clip;
        },
      );
      final positions = <Duration>[];
      final subscription = player.positions.listen(positions.add);
      final firstDone = player.play('id/karhutla-definition.mp3', .5);
      await flush();
      final first = clips.single;
      first.completions.add(null);
      await firstDone;
      // The one-second reading allowance elapses without touching the player.
      await player.stop();
      var nextFinished = false;
      final nextDone = player
          .play('id/karhutla-cause.mp3', .5)
          .then((_) => nextFinished = true);
      await flush();
      positions.clear();
      // A queued platform event or asynchronous position query from the old
      // source resolves after the second source has started.
      first.positions.add(const Duration(seconds: 60));
      first.completions.add(null);
      await flush();
      expect(
        positions,
        isEmpty,
        reason: 'Never reveal the new paragraph from old audio.',
      );
      expect(
        nextFinished,
        isFalse,
        reason: 'Old completion must not silence the new mascot.',
      );
      expect(clips, hasLength(2));
      expect(first.disposed, isTrue);
      final second = clips.last;
      second.positions.add(const Duration(milliseconds: 200));
      await flush();
      expect(positions, [const Duration(milliseconds: 200)]);
      second.completions.add(null);
      await nextDone;
      await subscription.cancel();
      await player.dispose();
      expect(second.disposed, isTrue);
      for (final clip in clips) {
        await clip.positions.close();
        await clip.completions.close();
      }
    },
  );
}
