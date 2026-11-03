/// Tracks one reading and rejects late completion events from older readings.
/// UI and audio drivers supply playback position; this class owns no timer.
class ReadingPlaybackState {
  int _epoch = 0;
  Duration _duration = Duration.zero;
  Duration position = Duration.zero;
  bool _advanced = false, _paused = false, _failed = false;

  int open(Duration duration) {
    _epoch++;
    _duration = duration;
    position = Duration.zero;
    _advanced = false;
    _paused = false;
    _failed = false;
    return _epoch;
  }

  void pause() => _paused = true;
  void resume() => _paused = false;
  void fail() => _failed = true;

  bool update(int epoch, Duration value) {
    if (epoch != _epoch || _advanced || _paused || _failed) return false;
    // Player position streams can briefly report an older timestamp.
    // Revealed words must never disappear within the same reading.
    if (value > position) position = value;
    if (position >= _duration) return advanceOnce(epoch);
    return false;
  }

  bool advanceOnce(int epoch) {
    if (epoch != _epoch || _advanced) return false;
    _advanced = true;
    return true;
  }
}
