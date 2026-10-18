import 'package:flutter/material.dart';

enum MascotPose { welcome, presenting, hintSafety, success }

/// Decorative companion; the adjacent text carries its message accessibly.
class GameMascot extends StatelessWidget {
  const GameMascot({super.key, required this.pose, this.height = 100});
  final MascotPose pose;
  final double height;

  @override
  Widget build(BuildContext context) {
    final name = switch (pose) {
      MascotPose.hintSafety => 'hint_safety',
      _ => pose.name,
    };
    return ExcludeSemantics(
      child: Image.asset(
        'assets/images/mascot/manggala_agni_$name.png',
        height: height,
        cacheWidth: 320,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
