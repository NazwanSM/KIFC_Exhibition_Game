import 'package:flutter/material.dart';
import 'interaction_motion.dart';

enum MascotPose { welcome, presenting, hintSafety, success }

/// Decorative companion; the adjacent text carries its message accessibly.
class GameMascot extends StatelessWidget {
  const GameMascot({
    super.key,
    required this.pose,
    this.height = 100,
    this.motionTrigger,
  });
  final MascotPose pose;
  final double height;
  final Object? motionTrigger;

  /// The same decoded key is used for warmup and display on web and Android.
  static ImageProvider<Object> imageFor(MascotPose pose) {
    final name = switch (pose) {
      MascotPose.hintSafety => 'hint_safety',
      _ => pose.name,
    };
    return ResizeImage(
      AssetImage('assets/images/mascot/manggala_agni_$name.png'),
      width: 320,
    );
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: MotionReveal(
      key: const ValueKey('mascot-motion'),
      trigger: (pose, motionTrigger),
      duration: const Duration(milliseconds: 380),
      offset: const Offset(0, 16),
      beginScale: .98,
      alignment: Alignment.bottomCenter,
      child: Image(
        image: imageFor(pose),
        height: height,
        gaplessPlayback: true,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    ),
  );
}
