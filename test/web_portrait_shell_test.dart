import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/services.dart';
import 'chapter2_review_test.dart' show captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'package:fire_prevention_challenge/core/widgets/web_portrait_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  for (final size in const [
    Size(1440, 900),
    Size(800, 600),
    Size(390, 844),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final locale in AppLocale.values) {
      final lang = ['id', 'en', 'ko'][locale.index];
      final res = '${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('fixed web preview renders $lang-$res', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: KifcTheme.light(),
            debugShowCheckedModeBanner: false,
            home: RepaintBoundary(
              key: const ValueKey('review-target'),
              child: WebPortraitShell(
                child: ExhibitionGame(
                  audioBackend: const SilentGameAudioBackend(),
                  initialLocale: locale,
                ),
              ),
            ),
          ),
        );
        await tester.runAsync(() async {
          for (final element in find.byType(Image).evaluate()) {
            await precacheImage((element.widget as Image).image, element);
          }
        });
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.takeException(), isNull);
        await captureScreen(tester, 'welcome-$lang-$res', <String, Object>{
          'source': 'Flutter widget render',
          'language': lang,
          'viewportWidth': size.width,
          'viewportHeight': size.height,
          'canvasWidth': 411,
          'canvasHeight': 411 * 16 / 9,
          'physicalTVReachValidated': false,
        });
      });
    }
  }

  testWidgets('browser resize keeps canvas, layout and interaction stable', (
    tester,
  ) async {
    const canvasSize = Size(411, 411 * 16 / 9);
    const canvasKey = ValueKey('canvas');
    var taps = 0;
    late Size mediaSize;
    final preview = MaterialApp(
      home: WebPortraitShell(
        child: Builder(
          builder: (context) {
            mediaSize = MediaQuery.sizeOf(context);
            return SizedBox.expand(
              key: canvasKey,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => taps++,
                  child: const Text('Start'),
                ),
              ),
            );
          },
        ),
      ),
    );
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final viewport in const [
      Size(1440, 900),
      Size(800, 600),
      Size(390, 844),
      Size(1080, 1920),
      Size(2160, 3840),
    ]) {
      tester.view.physicalSize = viewport;
      await tester.pumpWidget(preview);
      await tester.pump();
      expect(
        mediaSize,
        canvasSize,
        reason: 'MediaQuery must stay fixed at $viewport',
      );
      expect(tester.getSize(find.byKey(canvasKey)), canvasSize);
      final box = tester.renderObject<RenderBox>(find.byKey(canvasKey));
      final topLeft = box.localToGlobal(Offset.zero);
      final bottomRight = box.localToGlobal(
        Offset(canvasSize.width, canvasSize.height),
      );
      final width = bottomRight.dx - topLeft.dx;
      final height = bottomRight.dy - topLeft.dy;
      expect(width / height, closeTo(9 / 16, .000001));
      expect(topLeft.dx, greaterThanOrEqualTo(0));
      expect(topLeft.dy, greaterThanOrEqualTo(0));
      expect(bottomRight.dx, lessThanOrEqualTo(viewport.width + .1));
      expect(bottomRight.dy, lessThanOrEqualTo(viewport.height + .1));
      await tester.tap(find.text('Start'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
    expect(
      taps,
      5,
      reason: 'Scaled controls must remain clickable after every resize',
    );
  });
}
