import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// One offline read per session, shared by successive native WebViews.
abstract final class MascotAssetCache {
  static final Map<String, Future<ByteData>> _loads = {};
  static Future<ByteData> load(String key) =>
      _loads.putIfAbsent(key, () => rootBundle.load(key));
  static void warmup() {
    // Web's model-viewer owns the fetch and decoded-model cache. rootBundle
    // bytes are consumed only by native WebViews' local asset server.
    if (kIsWeb) return;
    for (final key in [
      'assets/models/manggala_game_states.glb',
      'packages/model_viewer_plus/assets/model-viewer.min.js',
    ]) {
      unawaited(
        load(key).then<void>(
          (_) {},
          onError: (Object _) {
            _loads.remove(key);
          },
        ),
      );
    }
  }
}
