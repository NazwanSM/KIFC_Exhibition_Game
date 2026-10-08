import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/theme/kifc_theme.dart';
import 'features/game/exhibition_game.dart';

class KifcApp extends StatelessWidget {
  const KifcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Prevention Challenge',
      theme: KifcTheme.light(),
      themeAnimationDuration: Duration.zero,
      home: const ExhibitionGame(),
      builder: (context, child) {
        if (!kIsWeb || child == null) return child ?? const SizedBox.shrink();
        return _WebPortraitShell(child: child);
      },
    );
  }
}

class _WebPortraitShell extends StatelessWidget {
  const _WebPortraitShell({required this.child});

  static const _portraitAspectRatio = 9 / 16;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final viewport = constraints.biggest;
      final compact = viewport.width < 720;
      final horizontalMargin = compact ? 0.0 : 56.0;
      final verticalMargin = compact ? 0.0 : 32.0;
      final availableWidth = math.max(0.0, viewport.width - horizontalMargin);
      final availableHeight = math.max(0.0, viewport.height - verticalMargin);
      final frameWidth = math.min(
        availableWidth,
        availableHeight * _portraitAspectRatio,
      );
      final frameHeight = frameWidth / _portraitAspectRatio;
      final frameRadius = compact ? 0.0 : 28.0;
      final mediaQuery = MediaQuery.of(context);

      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[KifcTheme.forest950, KifcTheme.forest800],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: frameWidth,
            height: frameHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(frameRadius),
                border: compact
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: .25)),
                boxShadow: compact
                    ? null
                    : <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .42),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(frameRadius),
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    size: Size(frameWidth, frameHeight),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
