import 'dart:math' as math;
import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import 'fire_loop.dart';

/// Six recorded, independently framed ground fires shared by Chapter 1 screens.
class ForestFireSimulation extends StatefulWidget {
  const ForestFireSimulation({super.key, this.reducedRegions = const {}});

  /// Left, centre and right demonstration areas, each containing two fires.
  final Set<int> reducedRegions;
  static const assets = [
    'assets/animations/forest-fire-0.webp',
    'assets/animations/forest-fire-1.webp',
    'assets/animations/forest-fire-2.webp',
  ];
  static const poster = 'assets/animations/forest-fire-poster.png';

  @override
  State<ForestFireSimulation> createState() => _ForestFireSimulationState();
}

class _ForestFireSimulationState extends State<ForestFireSimulation>
    with SingleTickerProviderStateMixin {
  late final _quench = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late Set<int> _regions;
  List<double> _starts = List.filled(6, 1);
  late List<double> _targets;

  List<double> _targetStrengths() => [
    for (var i = 0; i < 6; i++) _regions.contains(i ~/ 2) ? 0.0 : 1.0,
  ];

  @override
  void initState() {
    super.initState();
    _regions = Set.of(widget.reducedRegions);
    _targets = _targetStrengths();
    if (_regions.isEmpty) {
      _quench.value = 1;
    } else {
      _quench.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _quench.value = 1;
    }
  }

  @override
  void didUpdateWidget(ForestFireSimulation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (setEquals(_regions, widget.reducedRegions)) return;
    // Snapshot strengths before changing targets. A fast second choice must
    // not flash a previous region back on or disturb the unselected flames.
    _starts = List.generate(6, _strength);
    _regions = Set.of(widget.reducedRegions);
    _targets = _targetStrengths();
    if (_regions.isEmpty) {
      _starts = List.filled(6, 1);
      _quench.value = 1;
    } else {
      if (MediaQuery.disableAnimationsOf(context)) {
        _quench.value = 1;
      } else {
        _quench.forward(from: 0);
      }
    }
  }

  double _strength(int i) =>
      _starts[i] +
      (_targets[i] - _starts[i]) *
          Curves.easeInOutCubic.transform(_quench.value);

  @override
  void dispose() {
    _quench.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _quench,
            builder: (context, _) => LayoutBuilder(
              builder: (context, bounds) {
                const points = [
                  (.09, .98, .78),
                  (.27, .89, .56),
                  (.43, .99, 1.0),
                  (.60, .90, .65),
                  (.76, .97, .86),
                  (.92, .90, .59),
                ];
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    for (var i = 0; i < points.length; i++)
                      Builder(
                        builder: (context) {
                          final strength = reducedMotion
                              ? _targets[i]
                              : _strength(i);
                          final point = points[i];
                          final height =
                              math.min(
                                bounds.maxHeight * .8,
                                bounds.maxWidth * .32,
                              ) *
                              point.$3;
                          final width = height * 2 / 3;
                          return Positioned(
                            key: ValueKey('forest-fire-point-$i'),
                            left: bounds.maxWidth * point.$1 - width / 2,
                            bottom: bounds.maxHeight * (1 - point.$2),
                            width: width,
                            height: height,
                            child: Opacity(
                              key: ValueKey('forest-fire-opacity-$i'),
                              opacity: strength.clamp(0, 1),
                              child: Transform.scale(
                                scale: .12 + .88 * strength,
                                alignment: Alignment.bottomCenter,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: const Alignment(0, .75),
                                          colors: [
                                            const Color(
                                              0x55FF9638,
                                            ).withValues(alpha: .25 * strength),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Transform.flip(
                                      flipX: i.isOdd,
                                      child: TickerMode(
                                        enabled: strength > 0,
                                        child: FireLoop(
                                          asset: ForestFireSimulation
                                              .assets[i % 3],
                                          poster: ForestFireSimulation.poster,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
