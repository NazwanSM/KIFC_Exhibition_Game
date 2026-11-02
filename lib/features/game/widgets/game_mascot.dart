import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'animated_mascot.dart';
import 'interaction_motion.dart';
import 'mascot_state.dart';
import 'mascot_motion_preferences_stub.dart'
    if (dart.library.js_interop) 'mascot_motion_preferences_web.dart';

export 'mascot_state.dart';

enum MascotPose { welcome, presenting, hintSafety, success }

/// Decorative companion; the adjacent text carries its message accessibly.
class GameMascot extends StatelessWidget {
  const GameMascot({
    super.key,
    required this.pose,
    this.height = 100,
    this.motionTrigger,
    this.state,
    this.narrating = false,
  });
  final MascotPose pose;
  final double height;
  final Object? motionTrigger;
  final MascotState? state;
  final bool narrating;

  /// The same decoded key is used for warmup and display on web and Android.
  static ImageProvider<Object> imageFor(MascotPose pose) {
    final state = switch (pose) {
      MascotPose.welcome => MascotState.welcome,
      MascotPose.presenting => MascotState.presenting,
      MascotPose.hintSafety => MascotState.hintSafety,
      MascotPose.success => MascotState.success,
    };
    return imageForState(state);
  }

  static ImageProvider<Object> imageForState(MascotState state) {
    return ResizeImage(
      AssetImage('assets/images/mascot3d/${state.name}.png'),
      width: 768,
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: mascotReducedMotion,
    builder: (context, reduced, _) => _buildMascot(context, reduced),
  );

  Widget _buildMascot(BuildContext context, bool reduced) {
    final animation =
        state ??
        switch (pose) {
          MascotPose.welcome => MascotState.welcome,
          MascotPose.presenting => MascotState.presenting,
          MascotPose.hintSafety => MascotState.hintSafety,
          MascotPose.success => MascotState.success,
        };
    final fallback = Image(
      image: imageForState(animation),
      height: height,
      gaplessPlayback: true,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
    final enabled =
        const bool.fromEnvironment('MASCOT_3D', defaultValue: true) &&
        (kIsWeb || WebViewPlatform.instance != null) &&
        !MediaQuery.disableAnimationsOf(context) &&
        !reduced;
    final mascot = ExcludeSemantics(
      child: MotionReveal(
        key: const ValueKey('mascot-motion'),
        trigger: (pose, motionTrigger),
        duration: const Duration(milliseconds: 380),
        offset: const Offset(0, 16),
        beginScale: .98,
        alignment: Alignment.bottomCenter,
        child: enabled
            ? AnimatedMascot(
                state: animation,
                height: height,
                fallback: fallback,
                narrating: narrating,
                trigger: motionTrigger,
              )
            : fallback,
      ),
    );
    return reduced
        ? MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: mascot,
          )
        : mascot;
  }
}
