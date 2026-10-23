import 'package:flutter/material.dart';

/// Fill the frame by uniformly zooming/cropping, never stretching either axis.
class GamePhoto extends StatelessWidget {
  const GamePhoto(
    this.asset, {
    super.key,
    this.alignment,
    this.forestTone = false,
  });

  final String asset;
  final Alignment? alignment;
  final bool forestTone;

  // Mild desaturation and neutral-warm shadows; preserve subject color cues.
  static const _forestGrade = ColorFilter.matrix([
    .853,
    .096,
    .010,
    0,
    3,
    .029,
    .921,
    .010,
    0,
    4,
    .029,
    .096,
    .835,
    0,
    2,
    0,
    0,
    0,
    1,
    0,
  ]);

  static const _focalPoints = <String, Alignment>{
    'assets/images/field/oxygen-air.jpg': Alignment(0, -.35),
    'assets/images/field/small-campfire.jpg': Alignment(0, .65),
  };

  @override
  Widget build(BuildContext context) {
    final photo = Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: alignment ?? _focalPoints[asset] ?? Alignment.center,
      filterQuality: FilterQuality.medium,
    );
    return forestTone
        ? ColorFiltered(colorFilter: _forestGrade, child: photo)
        : photo;
  }
}
