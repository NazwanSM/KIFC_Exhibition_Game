import 'package:flutter/material.dart';

/// A short, finite entrance that leaves layout, input and child state intact.
/// Only a meaningful trigger change replays it; ordinary rebuilds do not.
class MotionReveal extends StatefulWidget {
  const MotionReveal({
    super.key,
    required this.child,
    this.trigger,
    this.duration = const Duration(milliseconds: 320),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 8),
    this.beginScale = 1,
    this.alignment = Alignment.center,
    this.animateOnMount = true,
  });

  final Widget child;
  final Object? trigger;
  final Duration duration, delay;
  final Offset offset;
  final double beginScale;
  final Alignment alignment;
  final bool animateOnMount;

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  late Animation<double> _progress;
  bool _initialized = false;

  void _configure() {
    final total = widget.duration + widget.delay;
    _controller.duration = total;
    _progress = _controller.drive(
      CurveTween(
        curve: Interval(
          total.inMicroseconds == 0
              ? 0
              : widget.delay.inMicroseconds / total.inMicroseconds,
          1,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  void _replay() {
    if (MediaQuery.disableAnimationsOf(context) ||
        _controller.duration == Duration.zero) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _configure();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.animateOnMount) {
        _replay();
      } else {
        _controller.value = 1;
      }
    } else if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(MotionReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.delay != widget.delay) {
      _configure();
    }
    if (oldWidget.trigger != widget.trigger) _replay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _progress,
    alwaysIncludeSemantics: true,
    child: AnimatedBuilder(
      animation: _progress,
      child: widget.child,
      builder: (context, child) {
        final remaining = 1 - _progress.value;
        return Transform.translate(
          offset: widget.offset * remaining,
          child: Transform.scale(
            scale: 1 - (1 - widget.beginScale) * remaining,
            alignment: widget.alignment,
            child: child,
          ),
        );
      },
    ),
  );
}

/// Visual pressure only. The existing button keeps ownership of activation,
/// cancellation, keyboard, semantics and audio; no second gesture is added.
class PressFeedback extends StatefulWidget {
  const PressFeedback({super.key, required this.child, this.enabled = true});
  final Widget child;
  final bool enabled;

  @override
  State<PressFeedback> createState() => _PressFeedbackState();
}

class _PressFeedbackState extends State<PressFeedback> {
  final _pointers = <int>{};

  void _release(int pointer) {
    if (_pointers.remove(pointer)) setState(() {});
  }

  @override
  void didUpdateWidget(PressFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) _pointers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Listener(
      onPointerDown: widget.enabled
          ? (event) => setState(() => _pointers.add(event.pointer))
          : null,
      onPointerUp: (event) => _release(event.pointer),
      onPointerCancel: (event) => _release(event.pointer),
      child: AnimatedScale(
        scale: !reduced && widget.enabled && _pointers.isNotEmpty ? .98 : 1,
        duration: reduced
            ? Duration.zero
            : Duration(milliseconds: _pointers.isEmpty ? 150 : 80),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
