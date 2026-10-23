import 'dart:ui' as ui;

import 'package:fire_prevention_challenge/features/game/widgets/environment_motion.dart';
import 'package:fire_prevention_challenge/features/game/widgets/fire_loop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _surface({
  bool reduced = false,
  bool visible = true,
  required Widget child,
}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: TickerMode(enabled: visible, child: child),
  ),
);

void main() {
  testWidgets('fog preserves touch and semantics of the controls below it', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _surface(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: TextButton(
                onPressed: () => taps++,
                child: const Text('Lanjut'),
              ),
            ),
            const AmbientFog(dark: true),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Lanjut'));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('fog pauses for hidden, reduced motion, and inactive surfaces', (
    tester,
  ) async {
    const fog = AmbientFog();
    await tester.pumpWidget(_surface(child: fog));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.binding.transientCallbackCount, greaterThan(0));

    await tester.pumpWidget(_surface(visible: false, child: fog));
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(_surface(reduced: true, child: fog));
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(_surface(child: fog));
    await tester.pump();
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'recorded fire loads and renders bounded spread and stopped states',
    (tester) async {
      var stopped = false;
      late StateSetter update;
      await tester.pumpWidget(
        _surface(
          reduced: true,
          child: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Center(
                child: RepaintBoundary(
                  key: const ValueKey('fire-surface'),
                  child: SizedBox(
                    width: 360,
                    height: 460,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FireSpreadVisual(progress: 1.2, stopped: stopped),
                        const Align(
                          alignment: Alignment.topCenter,
                          child: PhotographicFlame(size: 100),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.runAsync(() async {
        await precacheImage(
          const AssetImage(FireLoop.posterAsset),
          tester.element(find.byType(FireSpreadVisual)),
        );
      });
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(tester.binding.transientCallbackCount, 0);
      Future<int> warmPixelsBeyondBreak() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('fire-surface')),
        );
        var warm = 0;
        await tester.runAsync(() async {
          final image = await boundary.toImage();
          final data = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          for (var y = image.height ~/ 2; y < image.height; y++) {
            for (var x = (image.width * .55).floor(); x < image.width; x++) {
              final offset = (y * image.width + x) * 4;
              final r = data!.getUint8(offset);
              final g = data.getUint8(offset + 1);
              if (r > 20 && r > g * 1.15) warm++;
            }
          }
          image.dispose();
        });
        return warm;
      }

      final beforeStop = await warmPixelsBeyondBreak();
      expect(beforeStop, greaterThan(100));
      update(() => stopped = true);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(tester.binding.transientCallbackCount, 0);
      expect(await warmPixelsBeyondBreak(), lessThan(beforeStop * .1));
      await tester.pumpWidget(const SizedBox());
    },
  );
}
