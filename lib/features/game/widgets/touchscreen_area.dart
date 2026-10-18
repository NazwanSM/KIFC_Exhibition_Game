import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Provisional reach layout for large portrait exhibition displays.
/// Physical reach still depends on panel size and mounting height.
class TouchscreenArea extends StatelessWidget {
  const TouchscreenArea({super.key, required this.child, this.bottom = true});

  final Widget child;
  final bool bottom;

  static bool isCenteredOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CenteredTouchscreen>() != null;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: bottom,
    child: LayoutBuilder(
      builder: (context, bounds) {
        if (bounds.maxHeight < 900 || bounds.maxWidth < 600) return child;

        // Scale the proven portrait layout uniformly, keeping touch controls
        // away from the physical edges instead of stretching their spacing.
        const design = Size(411, 731);
        final scale = math.min(
          bounds.maxWidth * .9 / design.width,
          bounds.maxHeight * .7 / design.height,
        );
        final top = (bounds.maxHeight - design.height * scale) / 2;
        // Feedback artwork may reach the panel bottom, so its waist crop never
        // ends visibly in the middle of an otherwise empty background.
        final height = bottom
            ? design.height
            : (bounds.maxHeight - top) / scale;
        return Padding(
          padding: EdgeInsets.only(top: top),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: design.width * scale,
              height: height * scale,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: design.width,
                  height: height,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(design.width, height),
                      padding: EdgeInsets.zero,
                      viewPadding: EdgeInsets.zero,
                    ),
                    child: _CenteredTouchscreen(child: child),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _CenteredTouchscreen extends InheritedWidget {
  const _CenteredTouchscreen({required super.child});

  @override
  bool updateShouldNotify(_CenteredTouchscreen oldWidget) => false;
}
