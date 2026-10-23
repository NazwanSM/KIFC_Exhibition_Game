import 'dart:ui' as ui;

import 'package:fire_prevention_challenge/features/game/widgets/fire_loop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show captureScreen;

void main() {
  testWidgets('unavailable recording falls back to its offline still', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RepaintBoundary(
          key: ValueKey('review-target'),
          child: SizedBox(
            width: 160,
            height: 240,
            child: FireLoop(
              asset: 'assets/animations/missing-test.webp',
              poster: 'assets/animations/forest-fire-poster.png',
            ),
          ),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
    final fallback = find.byWidgetPredicate(
      (w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName ==
              'assets/animations/forest-fire-poster.png',
    );
    expect(fallback, findsOneWidget);
    final raw = tester.renderObject<RenderImage>(
      find.descendant(of: fallback, matching: find.byType(RawImage)),
    );
    expect(raw.image, isNotNull);
    await captureScreen(tester, 'offline-fire-fallback', {
      'ticket': 'KIFC-G02',
      'source': 'Flutter component render',
      'width': 800,
      'height': 600,
      'recordingIntentionallyUnavailable': true,
    });
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  test(
    'recording is a transparent animated loop with changing decoded frames',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final data = await rootBundle.load(FireLoop.animationAsset);
      expect(data.lengthInBytes, lessThan(10 * 1024 * 1024));
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      expect(codec.frameCount, greaterThan(250));
      expect(codec.repetitionCount, -1);
      final first = await codec.getNextFrame();
      expect(
        first.image.width / first.image.height,
        closeTo(FireLoop.aspectRatio, .001),
      );
      final firstBytes = (await first.image.toByteData())!.buffer.asUint8List();
      final second = await codec.getNextFrame();
      final secondBytes = (await second.image.toByteData())!.buffer
          .asUint8List();
      var transparent = 0;
      var opaque = 0;
      var changed = 0;
      for (var i = 0; i < firstBytes.length; i += 4) {
        if (firstBytes[i + 3] == 0) transparent++;
        if (firstBytes[i + 3] > 240) opaque++;
        if (firstBytes[i] != secondBytes[i]) changed++;
      }
      expect(transparent, greaterThan(1000));
      expect(opaque, greaterThan(1000));
      expect(changed, greaterThan(1000));
      expect(first.duration.inMilliseconds, inInclusiveRange(60, 70));
      first.image.dispose();
      second.image.dispose();
      codec.dispose();
    },
  );

  testWidgets(
    'recording pauses when hidden/inactive; reduced motion uses its poster',
    (tester) async {
      Widget surface({bool reduced = false, bool visible = true}) =>
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(disableAnimations: reduced),
              child: TickerMode(
                enabled: visible,
                child: const SizedBox(
                  width: 300,
                  height: 120,
                  child: FireLoop(),
                ),
              ),
            ),
          );
      bool enabled() => tester
          .widget<TickerMode>(
            find.descendant(
              of: find.byType(FireLoop),
              matching: find.byType(TickerMode),
            ),
          )
          .enabled;
      await tester.pumpWidget(surface());
      expect(enabled(), isTrue);
      await tester.pumpWidget(surface(visible: false));
      expect(enabled(), isFalse);
      await tester.pumpWidget(surface());
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(enabled(), isFalse);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(enabled(), isTrue);
      await tester.pumpWidget(surface(reduced: true));
      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        FireLoop.posterAsset,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );
}
