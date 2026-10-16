import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A low, irregular fire front. Place over a landscape in a bounded Stack.
class FireSpreadVisual extends StatefulWidget {
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
  State<FireSpreadVisual> createState() => _FireSpreadVisualState();
}

class _FireSpreadVisualState extends State<FireSpreadVisual> {
  double _time = 0;
  double _stopTime = 0;
  double _previousFront = 0;

  @override
  void didUpdateWidget(covariant FireSpreadVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stopped && !oldWidget.stopped) {
      _stopTime = _time;
      _previousFront = oldWidget.progress.clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) => _FireTexture(
    builder: (image, shader) => _EnvironmentMotion(
      builder: (context, seconds, reduced) {
        _time = seconds;
        final quench = reduced
            ? 1.0
            : ((seconds - _stopTime + 120) % 120 / 1.3).clamp(0.0, 1.0);
        return CustomPaint(
          painter: _FireFrontPainter(
            image: image,
            shader: shader,
            time: seconds,
            progress: widget.progress.clamp(0.0, 1.0),
            stopped: widget.stopped,
            boosted: widget.boosted,
            previousFront: _previousFront,
            quench: quench,
          ),
          child: const SizedBox.expand(),
        );
      },
    ),
  );
}

/// Photographic fire with an anchored base and independently moving upper body.
class PhotographicFlame extends StatelessWidget {
  const PhotographicFlame({super.key, required this.size, this.small = false});

  final double size;
  final bool small;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: _FireTexture(
      builder: (image, shader) => _EnvironmentMotion(
        builder: (context, seconds, reduced) => AnimatedScale(
          scale: small ? .42 : 1,
          alignment: Alignment.bottomCenter,
          duration: reduced ? Duration.zero : const Duration(milliseconds: 550),
          curve: Curves.easeOutCubic,
          child: CustomPaint(
            painter: _SingleFlamePainter(
              image: image,
              shader: shader,
              time: seconds,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
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

class _FireTexture extends StatefulWidget {
  const _FireTexture({required this.builder});
  final Widget Function(ui.Image? image, ui.ImageShader? shader) builder;

  @override
  State<_FireTexture> createState() => _FireTextureState();
}

class _FireTextureState extends State<_FireTexture> {
  ImageStream? _stream;
  late final ImageStreamListener _listener = ImageStreamListener(_loaded);
  ImageInfo? _info;
  ui.ImageShader? _shader;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stream != null) return;
    _stream = const AssetImage(
      'assets/images/field/fire-cutout.png',
    ).resolve(createLocalImageConfiguration(context));
    _stream!.addListener(_listener);
  }

  void _loaded(ImageInfo info, bool synchronousCall) {
    if (!mounted) {
      info.dispose();
      return;
    }
    final previousInfo = _info;
    final previousShader = _shader;
    setState(() {
      _info = info;
      _shader = ui.ImageShader(
        info.image,
        ui.TileMode.clamp,
        ui.TileMode.clamp,
        Float64List.fromList(<double>[
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
        ]),
      );
    });
    previousShader?.dispose();
    previousInfo?.dispose();
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    _shader?.dispose();
    _info?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_info?.image, _shader);
}

class _FireFrontPainter extends CustomPainter {
  const _FireFrontPainter({
    required this.image,
    required this.shader,
    required this.time,
    required this.progress,
    required this.stopped,
    required this.boosted,
    required this.previousFront,
    required this.quench,
  });

  final ui.Image? image;
  final ui.ImageShader? shader;
  final double time;
  final double progress;
  final bool stopped;
  final bool boosted;
  final double previousFront;
  final double quench;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final liveProgress = stopped ? math.min(progress, .43) : progress;
    final front = .085 + liveProgress * .8;
    final oldFront = .085 + previousFront * .8;
    double groundAt(double x) =>
        size.height * (.887 + math.sin(x * 5.8 - 1.1) * .027);

    // Low contrast scorched ground connects the front to the photograph.
    final trail = Path()..moveTo(size.width * .025, groundAt(.025));
    for (var i = 0; i <= 30; i++) {
      final x = .025 + (front - .025) * i / 30;
      trail.lineTo(
        size.width * x,
        groundAt(x) - size.height * (.006 + _noise(i + 8) * .011),
      );
    }
    for (var i = 30; i >= 0; i--) {
      final x = .025 + (front - .025) * i / 30;
      trail.lineTo(size.width * x, groundAt(x) + size.height * .014);
    }
    trail.close();
    canvas.drawPath(trail, Paint()..color = const Color(0x32231D16));

    // Individual wisps overlap softly; there is no full-screen blur layer.
    for (var i = 0; i < 14; i++) {
      final seed = _noise(i + 3);
      final origin = .045 + i * .062;
      if (origin > math.max(front, stopped ? oldFront : 0)) continue;
      final beyondBreak = origin > front;
      final visibility = beyondBreak ? (1 - quench) * .8 : 1.0;
      final life = (time * (.105 + seed * .065) + seed) % 1;
      final x = size.width * (origin + life * .09);
      final y = groundAt(origin) - life * size.height * .48;
      _softEllipse(
        canvas,
        Offset(x, y),
        size.width * (.035 + life * .09),
        size.height * (.04 + life * .1),
        const Color(
          0xFFB4B7AD,
        ).withValues(alpha: .15 * math.sin(life * math.pi) * visibility),
      );
    }

    if (image != null && shader != null) {
      for (var i = 0; i < 31; i++) {
        final seed = _noise(i + 11);
        // Uneven clusters, with small gaps between groups of nearby tongues.
        final x =
            .04 + i * .0275 + math.sin(i * 1.13) * .014 + (seed - .5) * .012;
        final oldVisible = stopped && x <= oldFront;
        if (x > front && !oldVisible) continue;
        final entry = ((front - x) / .045 + .35).clamp(0.0, 1.0);
        final alpha = x > front ? 1 - quench : entry;
        if (alpha <= .01) continue;
        final flicker = .91 + math.sin(time * 11 + i * 1.7) * .09;
        final cluster = .72 + .28 * (math.sin(i * .89 + .6) * .5 + .5);
        final height = math.min(
          82.0,
          size.height *
              (.085 + seed * .09) *
              (boosted ? 1.22 : 1) *
              flicker *
              cluster,
        );
        final width = size.width * (.085 + _noise(i + 47) * .075);
        final base = groundAt(x) + size.height * (seed - .5) * .012;
        _softEllipse(
          canvas,
          Offset(size.width * x, base),
          width * .85,
          height * .2,
          const Color(0xFFFFAB37).withValues(alpha: .17 * alpha),
        );
        _drawFlame(
          canvas,
          image!,
          shader!,
          Rect.fromLTWH(
            size.width * x - width / 2,
            base - height,
            width,
            height,
          ),
          time: time,
          phase: i * 1.91,
          opacity: alpha * (.79 + seed * .2),
          cropBase: true,
          mirror: i.isOdd,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FireFrontPainter old) =>
      old.time != time ||
      old.progress != progress ||
      old.stopped != stopped ||
      old.boosted != boosted ||
      old.quench != quench ||
      old.image != image;
}

class _SingleFlamePainter extends CustomPainter {
  const _SingleFlamePainter({
    required this.image,
    required this.shader,
    required this.time,
  });
  final ui.Image? image;
  final ui.ImageShader? shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null || shader == null || size.isEmpty) return;
    _softEllipse(
      canvas,
      Offset(size.width * .5, size.height * .88),
      size.width * .43,
      size.height * .11,
      const Color(0x44FF9F31),
    );
    _drawFlame(
      canvas,
      image!,
      shader!,
      Rect.fromLTWH(size.width * .08, 0, size.width * .84, size.height),
      time: time,
      phase: 0,
      opacity: 1,
      cropBase: false,
      mirror: false,
    );
  }

  @override
  bool shouldRepaint(covariant _SingleFlamePainter old) =>
      old.time != time || old.image != image;
}

/// A small photographic mesh: the bottom stays anchored while the upper rows
/// bend at different frequencies. Cropping removes repeated grass piles from
/// the landscape version; the triangle keeps the complete original photograph.
void _drawFlame(
  Canvas canvas,
  ui.Image image,
  ui.ImageShader shader,
  Rect rect, {
  required double time,
  required double phase,
  required double opacity,
  required bool cropBase,
  required bool mirror,
}) {
  final sourceHeight = image.height * (cropBase ? .72 : 1.0);
  final scale = math.min(rect.width / image.width, rect.height / sourceHeight);
  final fittedWidth = image.width * scale;
  final fittedHeight = sourceHeight * scale;
  rect = Rect.fromLTWH(
    rect.center.dx - fittedWidth / 2,
    rect.bottom - fittedHeight,
    fittedWidth,
    fittedHeight,
  );
  const columns = 3;
  const rows = 9;
  final positions = <Offset>[];
  final coordinates = <Offset>[];
  final colors = <Color>[];
  final indices = <int>[];
  for (var row = 0; row <= rows; row++) {
    final v = row / rows;
    final upper = math.pow(1 - v, 1.7).toDouble();
    final sway =
        (math.sin(time * 8.2 + phase + v * 5) * .065 +
            math.sin(time * 13.4 + phase * .7 + v * 8) * .025) *
        rect.width *
        upper;
    final lift =
        math.sin(time * 10.1 + phase + v * 4) * rect.height * .035 * upper;
    for (var column = 0; column <= columns; column++) {
      final u = column / columns;
      positions.add(
        Offset(
          rect.left + u * rect.width + sway,
          rect.top + v * rect.height + lift,
        ),
      );
      coordinates.add(
        Offset(
          (mirror ? 1 - u : u) * image.width,
          (cropBase ? .035 + v * .72 : v) * image.height,
        ),
      );
      final baseFade = cropBase ? ((1 - v) / .2).clamp(0.0, 1.0) : 1.0;
      colors.add(Colors.white.withValues(alpha: opacity * baseFade));
      if (row < rows && column < columns) {
        final a = row * (columns + 1) + column;
        final b = a + columns + 1;
        indices.addAll(<int>[a, b, a + 1, a + 1, b, b + 1]);
      }
    }
  }
  final vertices = ui.Vertices(
    ui.VertexMode.triangles,
    positions,
    textureCoordinates: coordinates,
    colors: colors,
    indices: indices,
  );
  canvas.drawVertices(
    vertices,
    BlendMode.modulate,
    Paint()
      ..shader = shader
      ..filterQuality = FilterQuality.low,
  );
  vertices.dispose();
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

double _noise(int seed) {
  final value = math.sin(seed * 127.1 + 311.7) * 43758.5453;
  return value - value.floorToDouble();
}
