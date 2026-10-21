import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/kifc_theme.dart';

/// Static contour lines sit behind the content and never intercept touches.
class TerrainBackdrop extends StatelessWidget {
  const TerrainBackdrop({super.key, required this.child, this.dark = false});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Positioned.fill(
        child: IgnorePointer(
          child: ExcludeSemantics(
            child: RepaintBoundary(
              child: CustomPaint(painter: _ContourPainter(dark: dark)),
            ),
          ),
        ),
      ),
      child,
    ],
  );
}

class _ContourPainter extends CustomPainter {
  const _ContourPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final scale = size.width / 411;
    final color = (dark ? const Color(0xFFB9CBB8) : KifcTheme.forest800)
        .withValues(alpha: dark ? .24 : .20);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 1.1
      ..shader = LinearGradient(
        colors: [
          color,
          color.withValues(alpha: dark ? .065 : .05),
          color.withValues(alpha: dark ? .065 : .05),
          color,
        ],
        stops: const [0, .38, .62, 1],
      ).createShader(Offset.zero & size);

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final centers = [
      Offset(size.width * 1.07, size.height * .19),
      Offset(size.width * -.20, size.height * .81),
    ];
    // The contour's maximum radial variation is 1 + .09 + .045.
    // Bound both groups to leave a gap even when viewport proportions change.
    final maxRadius = math.min(
      283 * scale,
      (centers.first - centers.last).distance * .44 / 1.135,
    );
    for (final center in centers) {
      for (var ring = 0; ring < 12; ring++) {
        final radius = maxRadius * (ring + 1) / 12;
        final path = Path();
        for (var step = 0; step <= 96; step++) {
          final angle = step * math.pi * 2 / 96;
          final contour =
              1 + .09 * math.sin(angle * 3 + .6) + .045 * math.cos(angle * 5);
          final x = center.dx + math.cos(angle) * radius * contour;
          final y = center.dy + math.sin(angle) * radius * .87 * contour;
          if (step == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        canvas.drawPath(path..close(), paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ContourPainter oldDelegate) =>
      oldDelegate.dark != dark;
}
