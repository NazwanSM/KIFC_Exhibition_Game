import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Silent documentary footage, with a still fallback while loading or on error.
class ForestBurnVideo extends StatefulWidget {
  const ForestBurnVideo({super.key});
  @override
  State<ForestBurnVideo> createState() => _ForestBurnVideoState();
}

class _ForestBurnVideoState extends State<ForestBurnVideo>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _failed = false;
  bool _active = true;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!_reduceMotion && _controller == null && !_failed) _initialize();
    if (_reduceMotion) unawaited(_controller?.pause() ?? Future<void>.value());
    if (!_reduceMotion && _active && _ready) unawaited(_controller!.play());
  }

  Future<void> _initialize() async {
    final controller = VideoPlayerController.asset(
      'assets/animations/forest-burn-loop.mp4',
    );
    _controller = controller;
    try {
      await controller.initialize();
      await controller.setVolume(0);
      await controller.setLooping(true);
      if (!mounted || _controller != controller) return;
      controller.addListener(_observeError);
      setState(() => _ready = true);
      if (_active && !_reduceMotion) {
        await controller.play();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _failed = true;
          _ready = false;
        });
      }
    }
  }

  void _observeError() {
    if (mounted && _controller?.value.hasError == true && !_failed) {
      setState(() {
        _failed = true;
        _ready = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    final c = _controller;
    if (c != null && _ready) {
      if (_active && !_reduceMotion) {
        unawaited(c.play());
      } else {
        unawaited(c.pause());
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final controller = _controller;
    _controller = null;
    controller?.removeListener(_observeError);
    if (controller != null) unawaited(controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        'assets/animations/forest-burn-poster.jpg',
        fit: BoxFit.cover,
      ),
      if (_ready && !_failed && !_reduceMotion && _controller != null)
        ClipRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
    ],
  );
}
