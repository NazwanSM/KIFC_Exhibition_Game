import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'assembly_review_test.dart' show paintAssembly, filledAssembly;
import 'chapter2_review_test.dart' show captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'oct30_visual_review_test.dart' show kind;

void main() {
  setUpAll(loadGameFonts);
  testWidgets(
    'R30-08 full application gesture frames include the drag overlay',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(411, 731);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('review-target'),
          child: MaterialApp(
            theme: KifcTheme.light(),
            debugShowCheckedModeBanner: false,
            home: const ExhibitionGame(
              initialPage: 'triangleBuild',
              initialLocale: AppLocale.indonesian,
              audioBackend: SilentGameAudioBackend(),
            ),
          ),
        ),
      );
      await paintAssembly(tester);
      await tester.pump(const Duration(milliseconds: 600));
      var frame = 0;
      Future<void> capture({int duration = 80}) => captureScreen(
        tester,
        'frame-${(frame++).toString().padLeft(2, '0')}',
        {
          'ticket': 'KIFC-R30-08',
          'source':
              'Flutter widget gesture frames, including application overlay',
          'width': 411,
          'height': 731,
          'language': 'indonesian',
          'durationMs': duration,
          'physicalTVReachValidated': false,
        },
      );
      await capture(duration: 800);
      final panel = tester.getRect(kind('_FireScene'));
      final positions = [
        panel.topCenter + const Offset(0, 16),
        panel.center,
        tester.getCenter(kind('_DropSlot').first),
      ];
      for (final (index, piece) in [0, 2, 4].indexed) {
        final source = tester.getCenter(kind('_DraggablePiece').at(piece));
        final gesture = await tester.startGesture(source);
        for (var step = 1; step <= 6; step++) {
          await gesture.moveTo(
            Offset.lerp(source, positions[index], step / 6)!,
          );
          await tester.pump(const Duration(milliseconds: 80));
          await capture();
        }
        expect(
          find.byKey(const ValueKey('forest-drop-highlight')),
          findsOneWidget,
        );
        await gesture.up();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await paintAssembly(tester);
        await tester.pump(const Duration(milliseconds: 500));
        expect(filledAssembly(tester), index + 1);
        await capture(duration: 1100);
      }
      expect(kind('_TriangleBuild'), findsOneWidget);
      await tester.tapAt(const Offset(4, 4));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await paintAssembly(tester);
      await tester.pump(const Duration(milliseconds: 500));
      expect(kind('_TriangleExplanation'), findsOneWidget);
      await capture(duration: 1300);
      await tester.tap(find.byKey(const ValueKey('triangle-reading-continue')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await paintAssembly(tester);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
      await capture(duration: 1500);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
