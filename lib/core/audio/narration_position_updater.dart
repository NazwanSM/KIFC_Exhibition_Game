import 'package:audioplayers/audioplayers.dart';

PositionUpdater createNarrationPositionUpdater({
  required Future<Duration?> Function() getPosition,
}) => FramePositionUpdater(getPosition: getPosition);
