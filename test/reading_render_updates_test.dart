import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:fire_prevention_challenge/features/game/widgets/progressive_reading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'game_flow_test.dart' show loadGameFonts;
import 'reading_integration_test.dart' show ReadingPlayer, waitForReading;

void main() {
  setUpAll(loadGameFonts);

  testWidgets(
    'audio positions between words do not schedule identical UI frames',
    (tester) async {
      tester.view.physicalSize = const Size(411, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final player = ReadingPlayer();
      await tester.pumpWidget(
        MaterialApp(
          home: ExhibitionGame(
            initialPage: 'triangleExplanation',
            audioBackend: const SilentGameAudioBackend(),
            narrationPlayer: player,
          ),
        ),
      );
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await waitForReading(tester);
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(player.played, ['id/karhutla-definition.mp3']);

      player.events.add(const Duration(milliseconds: 100));
      await tester.pump();
      await tester.pump();
      final text = find.byType(ProgressiveReadingText);
      expect(tester.widget<ProgressiveReadingText>(text).visibleCharacters, 9);
      final size = tester.getSize(text);
      expect(tester.binding.hasScheduledFrame, isFalse);
      for (final ms in [200, 300, 500]) {
        player.events.add(Duration(milliseconds: ms));
        await tester.idle();
        expect(
          tester.binding.hasScheduledFrame,
          isFalse,
          reason: 'The first word remains unchanged until 540 ms.',
        );
      }
      player.events.add(const Duration(milliseconds: 540));
      await tester.idle();
      expect(tester.binding.hasScheduledFrame, isTrue);
      await tester.pump();
      expect(tester.widget<ProgressiveReadingText>(text).visibleCharacters, 15);
      expect(tester.getSize(text), size);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
