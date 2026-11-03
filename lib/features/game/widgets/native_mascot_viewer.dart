import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'approved_mascot_camera.dart';
import 'mascot_asset_cache.dart';

/// Decorative native WebView. Hybrid composition avoids the texture WebView
/// swallowing Flutter touches on the tested Android 12 device.
class NativeMascotViewer extends StatefulWidget {
  const NativeMascotViewer({
    super.key,
    required this.id,
    required this.clip,
    required this.autoplay,
    required this.onLoaded,
    required this.onError,
    required this.onController,
  });
  final String id, clip;
  final bool autoplay;
  final VoidCallback onLoaded, onError;
  final void Function(void Function(String)) onController;
  @override
  State<NativeMascotViewer> createState() => _NativeMascotViewerState();
}

class _NativeMascotViewerState extends State<NativeMascotViewer> {
  HttpServer? _server;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      if (!mounted) {
        await server.close(force: true);
        return;
      }
      _server = server;
      server.listen((request) async {
        try {
          switch (request.uri.path) {
            case '/':
              request.response.headers.contentType = ContentType.html;
              request.response.write(_html);
            case '/model-viewer.min.js':
              request.response.headers.contentType = ContentType(
                'application',
                'javascript',
              );
              final data = await MascotAssetCache.load(
                'packages/model_viewer_plus/assets/model-viewer.min.js',
              );
              request.response.add(
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
              );
            case '/model':
              request.response.headers.contentType = ContentType.binary;
              final data = await MascotAssetCache.load(
                'assets/models/manggala_game_states.glb',
              );
              request.response.add(
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
              );
            default:
              request.response.statusCode = HttpStatus.notFound;
          }
          await request.response.close();
        } on Object {
          /* A disposed WebView may cancel a pending local request. */
        }
      });
      final controller = WebViewController();
      await controller.setBackgroundColor(Colors.transparent);
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.addJavaScriptChannel(
        'MascotLoaded',
        onMessageReceived: (_) {
          if (mounted) widget.onLoaded();
        },
      );
      await controller.addJavaScriptChannel(
        'MascotFailed',
        onMessageReceived: (_) {
          if (mounted) widget.onError();
        },
      );
      if (!mounted) return;
      widget.onController((code) {
        unawaited(
          controller.runJavaScript(code).catchError((Object e) {
            debugPrint('Mascot WebView: $e');
          }),
        );
      });
      await controller.loadRequest(
        Uri.parse('http://127.0.0.1:${server.port}/'),
      );
      if (mounted) setState(() => _controller = controller);
    } on Object catch (error) {
      debugPrint('Mascot initialization: $error');
      if (mounted) widget.onError();
    }
  }

  String get _html =>
      '''<!doctype html><meta name="viewport" content="width=device-width,initial-scale=1">
<style>html,body,model-viewer{width:100%;height:100%;margin:0;padding:0;background:transparent;pointer-events:none}</style>
<script type="module" src="/model-viewer.min.js"></script>
<model-viewer id="${widget.id}" src="/model" animation-name="${widget.clip}" ${widget.autoplay ? 'autoplay' : ''}
camera-orbit="${ApprovedMascotCamera.orbit}" min-camera-orbit="${ApprovedMascotCamera.orbit}" max-camera-orbit="${ApprovedMascotCamera.orbit}"
camera-target="${ApprovedMascotCamera.target}" field-of-view="${ApprovedMascotCamera.fieldOfView}" min-field-of-view="${ApprovedMascotCamera.fieldOfView}" max-field-of-view="${ApprovedMascotCamera.fieldOfView}" interaction-prompt="none">
<span slot="progress-bar"></span></model-viewer>
<script>const m=document.querySelector('model-viewer');m.addEventListener('load',()=>MascotLoaded.postMessage('${widget.id}'));m.addEventListener('error',()=>MascotFailed.postMessage('${widget.id}'));</script>''';

  @override
  void dispose() {
    unawaited(_server?.close(force: true));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();
    final params = PlatformWebViewWidgetCreationParams(
      controller: controller.platform,
    );
    return WebViewWidget.fromPlatformCreationParams(
      params: controller.platform is AndroidWebViewController
          ? AndroidWebViewWidgetCreationParams.fromPlatformWebViewWidgetCreationParams(
              params,
              displayWithHybridComposition: true,
            )
          : params,
    );
  }
}
