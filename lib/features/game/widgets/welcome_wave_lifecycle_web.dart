import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS()
extension type _ModelViewer(JSObject _) implements JSObject {
  external void play();
  external void pause();
}

/// Retain the actual element: Flutter may detach its platform view before
/// State.dispose, so a document lookup during disposal is too late.
class WelcomeWaveLifecycle {
  WelcomeWaveLifecycle(this.id) {
    _observer = web.MutationObserver(
      ((JSArray<web.MutationRecord> records, web.MutationObserver observer) {
        _capture();
      }).toJS,
    );
    _observer.observe(
      web.document.documentElement!,
      web.MutationObserverInit(childList: true, subtree: true),
    );
    _capture();
  }

  final String id;
  late final web.MutationObserver _observer;
  web.Element? _element;

  void _capture() {
    _element ??= web.document.getElementById(id);
    if (_element != null) _observer.disconnect();
  }

  void setPlayback({required bool play}) {
    _capture();
    final element = _element;
    if (element == null) return;
    final viewer = _ModelViewer(element);
    if (play) {
      viewer.play();
    } else {
      viewer.pause();
    }
  }

  void release() {
    _capture();
    _observer.disconnect();
    final element = _element;
    if (element == null) return;
    _ModelViewer(element).pause();
    element.removeAttribute('autoplay');
    element.removeAttribute('src');
    _element = null;
  }
}
