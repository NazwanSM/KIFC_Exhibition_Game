import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS()
extension type _Viewer(JSObject _) implements JSObject {
  external bool get loaded;
  external set currentTime(double value);
  external set animationName(String value);
  external void play();
  external void pause();
}

/// Own the actual DOM node, including after Flutter detaches a platform view.
class MascotViewerLifecycle {
  MascotViewerLifecycle(
    this.id, {
    required this.onLoad,
    required this.onError,
  }) {
    _loaded = ((web.Event event) {
      _resize();
      onLoad();
    }).toJS;
    _error = ((web.Event event) {
      onError();
    }).toJS;
    _windowResize = ((web.Event event) {
      // Flutter updates FittedBox transforms after the browser resize event.
      web.window.requestAnimationFrame(
        ((double _) {
          web.window.requestAnimationFrame(
            ((double _) {
              _resize();
            }).toJS,
          );
        }).toJS,
      );
    }).toJS;
    _observer = web.MutationObserver(
      ((JSArray<web.MutationRecord> records, web.MutationObserver observer) {
        _capture();
      }).toJS,
    );
    _sizeObserver = web.ResizeObserver(
      ((JSArray<web.ResizeObserverEntry> entries, web.ResizeObserver observer) {
        _resize();
      }).toJS,
    );
    _observer.observe(
      web.document.documentElement!,
      web.MutationObserverInit(childList: true, subtree: true),
    );
    web.window.addEventListener('resize', _windowResize);
    _capture();
  }
  final String id;
  final void Function() onLoad, onError;
  late final web.MutationObserver _observer;
  late final web.ResizeObserver _sizeObserver;
  late final JSFunction _loaded, _error, _windowResize;
  web.Element? _element;
  bool _released = false;

  void _capture() {
    if (_released || _element != null) return;
    final element = web.document.getElementById(id);
    if (element == null) return;
    _element = element;
    final parent = element.parentElement;
    if (parent != null) _sizeObserver.observe(parent);
    _observer.disconnect();
    element.addEventListener('load', _loaded);
    element.addEventListener('error', _error);
    // FittedBox scales the Flutter canvas. Render at the displayed CSS pixel
    // size, then counter-scale inside the logical slot to avoid blurry models.
    web.window.requestAnimationFrame(
      ((double time) {
        if (_released) return;
        _resize();
        if (_Viewer(element).loaded) onLoad();
      }).toJS,
    );
  }

  void _resize() {
    if (_released) return;
    final element = _element;
    final parent = element?.parentElement;
    if (element == null || parent == null) return;
    final rect = parent.getBoundingClientRect();
    final logicalHeight = parent.clientHeight;
    final logicalWidth = parent.clientWidth;
    if (logicalHeight <= 0 || logicalWidth <= 0) return;
    final scale = (rect.height / logicalHeight).clamp(1.0, 6.0);
    final style = (element as web.HTMLElement).style;
    style.width = '${logicalWidth * scale}px';
    style.height = '${logicalHeight * scale}px';
    style.transformOrigin = 'top left';
    style.transform = 'scale(${1 / scale})';
    style.pointerEvents = 'none';
  }

  void setPlayback({required bool play}) {
    final element = _element;
    if (_released || element == null || !_Viewer(element).loaded) return;
    if (play) {
      _Viewer(element).play();
    } else {
      _Viewer(element).pause();
    }
  }

  void restart() {
    final element = _element;
    if (!_released && element != null && _Viewer(element).loaded) {
      _Viewer(element).currentTime = 0;
    }
  }

  void setClip(String clip) {
    final element = _element;
    if (_released || element == null) return;
    _Viewer(element).animationName = clip;
    _Viewer(element).currentTime = 0;
  }

  void release() {
    if (_released) return;
    _released = true;
    _observer.disconnect();
    web.window.removeEventListener('resize', _windowResize);
    _sizeObserver.disconnect();
    final element = _element;
    if (element == null) return;
    element.removeEventListener('load', _loaded);
    element.removeEventListener('error', _error);
    // A failed/new source may have loaded=false while the old clip still exists.
    _Viewer(element).pause();
    element.removeAttribute('autoplay');
    element.removeAttribute('src');
    _element = null;
  }
}
