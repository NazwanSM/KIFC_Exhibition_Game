import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'approved_mascot_camera.dart';
import 'mascot_state.dart';
import 'native_mascot_viewer_stub.dart';
import 'mascot_viewer_lifecycle_stub.dart'
    if (dart.library.js_interop) 'mascot_viewer_lifecycle_web.dart';

/// An outgoing page must pause before its AnimatedSwitcher fade completes.
class MascotPlaybackScope extends InheritedWidget {
  const MascotPlaybackScope({
    super.key,
    required this.page,
    required super.child,
  });
  final Object page;
  static Object? pageOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MascotPlaybackScope>()?.page;
  @override
  bool updateShouldNotify(MascotPlaybackScope oldWidget) =>
      page != oldWidget.page;
}

class AnimatedMascot extends StatefulWidget {
  const AnimatedMascot({
    super.key,
    required this.state,
    required this.height,
    required this.fallback,
    this.narrating = false,
    this.trigger,
  });
  final MascotState state;
  final double height;
  final Widget fallback;
  final bool narrating;
  final Object? trigger;
  @override
  State<AnimatedMascot> createState() => _AnimatedMascotState();
}

class _AnimatedMascotState extends State<AnimatedMascot>
    with WidgetsBindingObserver {
  static int _nextId = 0;
  late String _id;
  late MascotViewerLifecycle _lifecycle;
  Timer? _loadTimeout;
  bool _ready = false,
      _failed = false,
      _appActive = true,
      _allowed = true,
      _pageCaptured = false;
  Object? _originPage;
  void Function(String code)? _nativeSend;
  String get _clip => mascotClip(widget.state, narrating: widget.narrating);

  void _open() {
    _id = 'game-mascot-${++_nextId}';
    final session = _id;
    _ready = false;
    _failed = false;
    _nativeSend = null;
    _lifecycle = MascotViewerLifecycle(
      _id,
      onLoad: () {
        if (mounted && session == _id) _loaded();
      },
      onError: () {
        if (mounted && session == _id) _error();
      },
    );
    _loadTimeout = Timer(const Duration(seconds: 30), () {
      if (mounted && session == _id && !_ready) _error();
    });
  }

  void _loaded() {
    if (_failed) return;
    _loadTimeout?.cancel();
    if (!_ready) setState(() => _ready = true);
    _playback();
  }

  void _error() {
    if (_failed) return;
    _loadTimeout?.cancel();
    _lifecycle.release();
    setState(() {
      _failed = true;
      _ready = false;
    });
  }

  void _playback() {
    final play = _allowed && _appActive && !_failed;
    _lifecycle.setPlayback(play: play);
    _nativeSend?.call(
      "document.querySelector('model-viewer')?.${play ? 'play()' : 'pause()'};",
    );
  }

  void _close() {
    _loadTimeout?.cancel();
    _nativeSend?.call("document.querySelector('model-viewer')?.pause();");
    _lifecycle.release();
    _nativeSend = null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final page = MascotPlaybackScope.pageOf(context);
    if (!_pageCaptured) {
      _originPage = page;
      _pageCaptured = true;
    }
    _allowed =
        page == _originPage &&
        !MediaQuery.disableAnimationsOf(context) &&
        (ModalRoute.of(context)?.isCurrent ?? true);
    _playback();
  }

  @override
  void didUpdateWidget(AnimatedMascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mascotClip(oldWidget.state, narrating: oldWidget.narrating) != _clip) {
      _close();
      _open();
    } else if (oldWidget.trigger != widget.trigger && _ready) {
      _lifecycle.restart();
      _nativeSend?.call(
        "document.querySelector('model-viewer').currentTime=0;",
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appActive = state == AppLifecycleState.resumed;
    _playback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.height,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (!_failed)
          ClipRect(
            child: OverflowBox(
              minWidth: widget.height * ApprovedMascotCamera.aspect,
              maxWidth: widget.height * ApprovedMascotCamera.aspect,
              minHeight: widget.height,
              maxHeight: widget.height,
              child: IgnorePointer(
                child: !kIsWeb
                    ? NativeMascotViewer(
                        key: ValueKey(_id),
                        id: _id,
                        clip: _clip,
                        autoplay: _allowed && _appActive,
                        onLoaded: _loaded,
                        onError: _error,
                        onController: (send) => _nativeSend = send,
                      )
                    : ModelViewer(
                        key: ValueKey(_id),
                        id: _id,
                        src: 'assets/assets/models/manggala_game_states.glb',
                        cameraControls: false,
                        autoRotate: false,
                        ar: false,
                        interactionPrompt: InteractionPrompt.none,
                        // The Flutter poster owns loading/failure presentation.
                        innerModelViewerHtml:
                            '<span slot="progress-bar"></span>',
                        cameraOrbit: ApprovedMascotCamera.orbit,
                        minCameraOrbit: ApprovedMascotCamera.orbit,
                        maxCameraOrbit: ApprovedMascotCamera.orbit,
                        cameraTarget: ApprovedMascotCamera.target,
                        fieldOfView: ApprovedMascotCamera.fieldOfView,
                        minFieldOfView: ApprovedMascotCamera.fieldOfView,
                        maxFieldOfView: ApprovedMascotCamera.fieldOfView,
                        animationName: _clip,
                        autoPlay: _allowed && _appActive,
                        debugLogging: false,
                      ),
              ),
            ),
          ),
        if (!_ready || _failed) widget.fallback,
      ],
    ),
  );
}
