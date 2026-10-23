import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'fire_loop.dart';

/// Six recorded, independently framed ground fires shared by Chapter 1 screens.
class ForestFireSimulation extends StatefulWidget {
  const ForestFireSimulation({super.key, this.reducedElement});
  final int? reducedElement;
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
    duration: const Duration(milliseconds: 1800),
  );
  bool _replay = false;
  List<double> _starts = List.filled(6, 1);

  @override
  void initState() {
    super.initState();
    if (widget.reducedElement != null) _quench.forward();
  }

  @override
  void didUpdateWidget(ForestFireSimulation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedElement == widget.reducedElement) return;
    if (widget.reducedElement == null) {
      _quench.reset();
      _replay = false;
    } else {
      final current = List.generate(
        6,
        (i) => _strength(i, oldWidget.reducedElement),
      );
      // Preserve the current strength on rapid changes; only relight once out.
      _replay = current.every((value) => value < .01);
      _starts = _replay ? List.filled(6, 1) : current;
      _quench.duration = Duration(milliseconds: _replay ? 2200 : 1800);
      _quench.forward(from: 0);
    }
  }

  double _strength(int i, int? element) {
    if (element == null) return 1;
    var t = _quench.value;
    if (_replay && t < .18) return Curves.easeOut.transform(t / .18);
    if (_replay) t = ((t - .18) / .82).clamp(0, 1);
    final order = (i + element * 2) % 6;
    final local = ((t - order * .035) / .80).clamp(0.0, 1.0);
    return _starts[i] * (1 - Curves.easeInOut.transform(local));
  }

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
                          final strength =
                              reducedMotion && widget.reducedElement != null
                              ? 0.0
                              : _strength(i, widget.reducedElement);
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
                                      child: FireLoop(
                                        asset:
                                            ForestFireSimulation.assets[i % 3],
                                        poster: ForestFireSimulation.poster,
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
