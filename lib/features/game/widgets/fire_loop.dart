import 'package:flutter/material.dart';

/// The owner's recording, keyed to alpha and encoded for offline Flutter use.
/// Both assets have the same 8:3 crop; no synthetic flame motion is added.
class FireLoop extends StatefulWidget {
  const FireLoop({
    super.key,
    this.asset = animationAsset,
    this.poster = posterAsset,
  });

  final String asset;
  final String poster;

  static const animationAsset = 'assets/animations/fire-loop.webp';
  static const posterAsset = 'assets/animations/fire-poster.png';
  static const aspectRatio = 8 / 3;

  @override
  State<FireLoop> createState() => _FireLoopState();
}

class _FireLoopState extends State<FireLoop> with WidgetsBindingObserver {
  bool _resumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    _resumed = state == null || state == AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() => _resumed = state == AppLifecycleState.resumed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: TickerMode(
            enabled: _resumed && TickerMode.of(context),
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0, .05, .84, 1],
              ).createShader(bounds),
              child: Image.asset(
                reduced ? widget.poster : widget.asset,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
                excludeFromSemantics: true,
                // A missing/unsupported recording must not replace the lesson
                // with a red error tile. Its keyed still uses the same framing.
                errorBuilder: reduced
                    ? null
                    : (context, error, stackTrace) => Image.asset(
                        widget.poster,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        filterQuality: FilterQuality.medium,
                        excludeFromSemantics: true,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
