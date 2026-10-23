import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'fire_loop.dart';

/// The recorded fire front advances only through connected fuel.
class FireSpreadVisual extends StatelessWidget {
  const FireSpreadVisual({
    super.key,
    required this.progress,
    this.stopped = false,
    this.boosted = false,
  });
  final double progress;
  final bool stopped;
  final bool boosted;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, bounds) {
          final live = stopped ? math.min(progress, .43) : progress;
          final front = .085 + live.clamp(0.0, 1.0) * .8;
          final width = bounds.maxWidth * (boosted ? .96 : .9);
          final height = math.min(
            width / FireLoop.aspectRatio,
            bounds.maxHeight * .68,
          );
          return ClipRect(
            clipper: _FireFrontClipper(front),
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => LinearGradient(
                colors: const [
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: [0, math.max(0, front - .035), front, 1],
              ).createShader(rect),
              child: Stack(
                children: [
                  Positioned(
                    left: bounds.maxWidth * .02,
                    bottom: bounds.maxHeight * .1,
                    width: width,
                    height: height,
                    child: const FireLoop(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _FireFrontClipper extends CustomClipper<Rect> {
  const _FireFrontClipper(this.front);
  final double front;
  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * front, size.height);
  @override
  bool shouldReclip(_FireFrontClipper oldClipper) => front != oldClipper.front;
}

/// The same recording shrinks toward its anchored base when an element is reduced.
class PhotographicFlame extends StatelessWidget {
  const PhotographicFlame({super.key, required this.size, this.small = false});
  final double size;
  final bool small;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size / FireLoop.aspectRatio,
    child: AnimatedScale(
      scale: small ? .35 : 1,
      alignment: Alignment.bottomCenter,
      duration: MediaQuery.maybeOf(context)?.disableAnimations == true
          ? Duration.zero
          : const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      child: const FireLoop(),
    ),
  );
}

/// Slow atmospheric drift. It never captures touch or adds accessibility nodes.
class AmbientFog extends StatelessWidget {
  const AmbientFog({super.key, this.dark = false, this.strength = 1});

  final bool dark;
  final double strength;

  @override
  Widget build(BuildContext context) => _EnvironmentMotion(
    builder: (context, seconds, reduced) => CustomPaint(
      painter: _FogPainter(
        time: seconds,
        dark: dark,
        strength: strength.clamp(0.0, 2.0),
      ),
      child: const SizedBox.expand(),
    ),
  );
}

/// One clock per visual surface, paused for reduced motion, hidden routes, and
/// application lifecycle transitions. A shared 120s loop keeps time bounded.
class _EnvironmentMotion extends StatefulWidget {
  const _EnvironmentMotion({required this.builder});

  final Widget Function(BuildContext context, double seconds, bool reduced)
  builder;

  @override
  State<_EnvironmentMotion> createState() => _EnvironmentMotionState();
}

class _EnvironmentMotionState extends State<_EnvironmentMotion>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 120),
  );
  bool _reduced = false;
  bool _visible = true;
  bool _resumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    _resumed = state == null || state == AppLifecycleState.resumed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _visible = TickerMode.of(context);
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resumed = state == AppLifecycleState.resumed;
    _sync();
  }

  void _sync() {
    if (!_reduced && _visible && _resumed) {
      if (!_clock.isAnimating) _clock.repeat();
    } else {
      _clock.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _clock,
          builder: (context, _) => widget.builder(
            context,
            _reduced ? 7.0 : _clock.value * 120,
            _reduced,
          ),
        ),
      ),
    ),
  );
}

class _FogPainter extends CustomPainter {
  const _FogPainter({
    required this.time,
    required this.dark,
    required this.strength,
  });
  final double time;
  final bool dark;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || strength <= 0) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (var i = 0; i < 5; i++) {
      // Both axes make whole cycles over the shared 120s clock.
      final phase =
          time * math.pi * 2 / const [24, 30, 40, 60, 120][i] + i * 1.9;
      final side = i.isEven ? -.08 : 1.08;
      final center = Offset(
        size.width * (side + math.sin(phase) * .15),
        size.height * (.12 + i * .205 + math.cos(phase) * .055),
      );
      _softEllipse(
        canvas,
        center,
        size.width * (.6 + math.sin(phase) * .08),
        size.height * .19,
        (dark ? const Color(0xFFDDE6DC) : const Color(0xFFA3B5A4)).withValues(
          alpha: (dark ? .085 : .045) * strength,
        ),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FogPainter old) =>
      old.time != time || old.dark != dark || old.strength != strength;
}

void _softEllipse(
  Canvas canvas,
  Offset center,
  double radiusX,
  double radiusY,
  Color color,
) {
  if (radiusX <= 0 || radiusY <= 0) return;
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.scale(radiusX, radiusY);
  canvas.drawCircle(
    Offset.zero,
    1,
    Paint()
      ..shader = ui.Gradient.radial(
        Offset.zero,
        1,
        <Color>[
          color,
          color.withValues(alpha: color.a * .42),
          color.withValues(alpha: 0),
        ],
        <double>[0, .45, 1],
      ),
  );
  canvas.restore();
}
