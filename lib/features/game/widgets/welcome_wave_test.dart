import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'approved_mascot_camera.dart';
import 'welcome_wave_lifecycle_stub.dart'
    if (dart.library.js_interop) 'welcome_wave_lifecycle_web.dart';

/// Notifies an outgoing welcome while AnimatedSwitcher is still fading it out.
class WelcomeWaveActivity extends InheritedWidget {
  const WelcomeWaveActivity({
    super.key,
    required this.active,
    required super.child,
  });
  final bool active;
  static bool isActiveOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<WelcomeWaveActivity>()
          ?.active ??
      true;

  @override
  bool updateShouldNotify(WelcomeWaveActivity oldWidget) =>
      active != oldWidget.active;
}

/// Welcome renderer. The landscape camera viewport keeps its original
/// projection; only transparent side margins are clipped by the portrait UI.
class WelcomeWaveTest extends StatefulWidget {
  const WelcomeWaveTest({super.key, required this.height});
  final double height;

  @override
  State<WelcomeWaveTest> createState() => _WelcomeWaveTestState();
}

class _WelcomeWaveTestState extends State<WelcomeWaveTest>
    with WidgetsBindingObserver {
  static const _viewerId = 'welcome-approved-mascot';
  late final WelcomeWaveLifecycle _webPlayback;
  bool _animationsAllowed = true;
  void Function(bool play)? _nativePlayback;

  @override
  void initState() {
    super.initState();
    _webPlayback = WelcomeWaveLifecycle(_viewerId);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final allowed =
        !MediaQuery.disableAnimationsOf(context) &&
        WelcomeWaveActivity.isActiveOf(context);
    if (_animationsAllowed != allowed) {
      _animationsAllowed = allowed;
      _setPlayback(allowed);
    }
  }

  void _setPlayback(bool play) {
    _webPlayback.setPlayback(play: play);
    _nativePlayback?.call(play);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _setPlayback(state == AppLifecycleState.resumed && _animationsAllowed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setPlayback(false);
    _webPlayback.release();
    _nativePlayback = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.height,
    child: ClipRect(
      child: OverflowBox(
        minWidth: widget.height * ApprovedMascotCamera.aspect,
        maxWidth: widget.height * ApprovedMascotCamera.aspect,
        minHeight: widget.height,
        maxHeight: widget.height,
        child: IgnorePointer(
          child: ModelViewer(
            id: _viewerId,
            src: kIsWeb
                ? 'assets/assets/models/manggala_welcome_wave_30s.glb'
                : 'assets/models/manggala_welcome_wave_30s.glb',
            cameraControls: false,
            autoRotate: false,
            ar: false,
            interactionPrompt: InteractionPrompt.none,
            cameraOrbit: ApprovedMascotCamera.orbit,
            minCameraOrbit: ApprovedMascotCamera.orbit,
            maxCameraOrbit: ApprovedMascotCamera.orbit,
            cameraTarget: ApprovedMascotCamera.target,
            fieldOfView: ApprovedMascotCamera.fieldOfView,
            minFieldOfView: ApprovedMascotCamera.fieldOfView,
            maxFieldOfView: ApprovedMascotCamera.fieldOfView,
            animationName: 'Wave',
            // model-viewer's autoplay repeats the embedded 30-second clip.
            autoPlay: _animationsAllowed,
            onWebViewCreated: (controller) {
              _nativePlayback = (play) {
                unawaited(
                  controller
                      .runJavaScript(
                        "document.querySelector('model-viewer')?."
                        "${play ? 'play()' : 'pause()'};",
                      )
                      .catchError((Object error) {
                        debugPrint('Welcome Wave lifecycle: $error');
                      }),
                );
              };
            },
            debugLogging: false,
          ),
        ),
      ),
    ),
  );
}
