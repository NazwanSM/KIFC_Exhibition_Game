import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

// One subscription for the app lifetime, shared by all mascot instances.
final ValueListenable<bool> mascotReducedMotion = _listen();

ValueNotifier<bool> _listen() {
  final query = web.window.matchMedia('(prefers-reduced-motion: reduce)');
  final value = ValueNotifier(query.matches);
  query.addEventListener(
    'change',
    ((web.Event _) {
      value.value = query.matches;
    }).toJS,
  );
  return value;
}
