import 'package:flutter/material.dart';

/// Fill the frame by uniformly zooming/cropping, never stretching either axis.
class GamePhoto extends StatelessWidget {
  const GamePhoto(this.asset, {super.key, this.alignment});

  final String asset;
  final Alignment? alignment;

  static const _focalPoints = <String, Alignment>{
    'assets/images/field/oxygen-air.jpg': Alignment(0, -.35),
    'assets/images/field/small-campfire.jpg': Alignment(0, .65),
  };

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    fit: BoxFit.cover,
    alignment: alignment ?? _focalPoints[asset] ?? Alignment.center,
    filterQuality: FilterQuality.medium,
  );
}
