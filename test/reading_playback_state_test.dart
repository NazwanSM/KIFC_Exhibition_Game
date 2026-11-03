import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/features/game/reading_playback_state.dart';

void main() {
  test('an old completion cannot skip a newly opened reading', () {
    final state = ReadingPlaybackState();
    final first = state.open(const Duration(seconds: 5));
    expect(state.advanceOnce(first), isTrue);
    final second = state.open(const Duration(seconds: 8));
    expect(state.advanceOnce(first), isFalse);
    expect(state.advanceOnce(second), isTrue);
    expect(state.advanceOnce(second), isFalse);
  });
  test('paused and failed readings never auto-advance', () {
    final state = ReadingPlaybackState();
    final epoch = state.open(const Duration(seconds: 2));
    state.pause();
    expect(state.update(epoch, const Duration(seconds: 3)), isFalse);
    state.resume();
    state.fail();
    expect(state.update(epoch, const Duration(seconds: 3)), isFalse);
    expect(state.advanceOnce(epoch), isTrue); // manual continuation
  });
  test('muted timeline reaches the recording duration once', () {
    final state = ReadingPlaybackState();
    final epoch = state.open(const Duration(seconds: 2));
    expect(state.update(epoch, const Duration(milliseconds: 1900)), isFalse);
    expect(state.update(epoch, const Duration(milliseconds: 500)), isFalse);
    expect(state.position, const Duration(milliseconds: 1900));
    expect(state.update(epoch, const Duration(seconds: 2)), isTrue);
    expect(state.update(epoch, const Duration(seconds: 3)), isFalse);
  });
}
