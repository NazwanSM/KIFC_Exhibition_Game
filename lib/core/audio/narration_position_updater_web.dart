import 'dart:async';
import 'dart:js_interop';
import 'package:audioplayers/audioplayers.dart';
import 'package:web/web.dart' as web;

PositionUpdater createNarrationPositionUpdater({
  required Future<Duration?> Function() getPosition,
}) => _BrowserFramePositionUpdater(getPosition: getPosition);

/// Audio is sampled at display cadence without asking Flutter to paint an
/// otherwise unchanged CanvasKit scene. The GLB has its own browser renderer.
class _BrowserFramePositionUpdater extends PositionUpdater {
  _BrowserFramePositionUpdater({required super.getPosition});

  int? _frame;
  bool _running = false;
  late final JSFunction _callback = ((double _) {
    _frame = null;
    if (_running) _tick();
  }).toJS;

  void _tick() {
    unawaited(update());
    _frame = web.window.requestAnimationFrame(_callback);
  }

  @override
  void start() {
    if (_running) return;
    _running = true;
    _tick();
  }

  @override
  void stop() {
    _running = false;
    final frame = _frame;
    if (frame != null) web.window.cancelAnimationFrame(frame);
    _frame = null;
  }
}
