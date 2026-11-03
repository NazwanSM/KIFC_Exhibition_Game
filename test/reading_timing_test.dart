import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/features/game/reading_timing.dart';

void main() {
  test(
    'word reveal follows timestamps and preserves the complete paragraph',
    () {
      final timing = ReadingTiming.fromJson({
        'key': 'karhutla-definition',
        'locale': 'id',
        'text': 'Api di hutan.',
        'duration': 2.0,
        'cues': [
          {'end': 3, 'time': 0.1},
          {'end': 6, 'time': 0.7},
          {'end': 13, 'time': 1.4},
        ],
      });
      expect(timing.visibleText(Duration.zero), '');
      expect(timing.visibleText(const Duration(milliseconds: 100)), 'Api');
      expect(timing.visibleText(const Duration(milliseconds: 900)), 'Api di');
      expect(timing.visibleText(const Duration(seconds: 3)), 'Api di hutan.');
    },
  );
}
