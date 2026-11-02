import 'package:flutter/widgets.dart';

// The web path uses ModelViewer directly; no dart:io is compiled into that build.
class NativeMascotViewer extends StatelessWidget {
  const NativeMascotViewer({
    super.key,
    required this.id,
    required this.clip,
    required this.autoplay,
    required this.onLoaded,
    required this.onError,
    required this.onController,
  });
  final String id, clip;
  final bool autoplay;
  final VoidCallback onLoaded, onError;
  final void Function(void Function(String)) onController;
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
