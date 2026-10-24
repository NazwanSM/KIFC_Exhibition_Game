import 'dart:ui' as ui;
import 'package:fire_prevention_challenge/features/game/widgets/forest_fire_simulation.dart';
import 'package:fire_prevention_challenge/features/game/widgets/fire_loop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'extinguished fires pause their recordings and reset resumes them',
    (tester) async {
      var regions = <int>{0};
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return SizedBox(
                width: 360,
                height: 150,
                child: ForestFireSimulation(reducedRegions: regions),
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      final loops = find.byType(FireLoop).evaluate().toList();
      for (var i = 0; i < 6; i++) {
        expect(
          TickerMode.of(loops[i]),
          i >= 2,
          reason: 'Only the extinguished left pair pauses its recordings',
        );
      }
      update(() => regions = <int>{});
      await tester.pump();
      for (final element in find.byType(FireLoop).evaluate()) {
        expect(TickerMode.of(element), isTrue);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  test(
    'three offset recordings contain moving transparent frames under 2 MB total',
    () async {
      var total = 0;
      final signatures = <int>{};
      for (final asset in ForestFireSimulation.assets) {
        final data = await rootBundle.load(asset);
        total += data.lengthInBytes;
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        expect(codec.frameCount, 90);
        final frame = await codec.getNextFrame();
        final pixels = (await frame.image.toByteData())!.buffer.asUint8List();
        expect(frame.image.width, 160);
        expect(frame.image.height, 240);
        expect([
          for (var i = 3; i < pixels.length; i += 4) pixels[i],
        ], contains(0));
        signatures.add(Object.hashAll(pixels));
        frame.image.dispose();
        codec.dispose();
      }
      expect(total, lessThan(2 * 1024 * 1024));
      expect(signatures.length, 3);
    },
  );

  testWidgets(
    'pairs accumulate and rapid additions preserve already extinguished regions',
    (tester) async {
      final regions = <int>{};
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Center(
                child: SizedBox(
                  width: 360,
                  height: 150,
                  child: ForestFireSimulation(reducedRegions: regions),
                ),
              );
            },
          ),
        ),
      );
      List<double> strengths() => [
        for (var i = 0; i < 6; i++)
          tester
              .widget<Opacity>(find.byKey(ValueKey('forest-fire-opacity-$i')))
              .opacity,
      ];
      expect(strengths(), everyElement(1.0));
      for (var i = 0; i < 6; i++) {
        expect(find.byKey(ValueKey('forest-fire-point-$i')), findsOneWidget);
      }
      update(() => regions.add(0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      final before = strengths();
      expect(before.any((value) => value < .9), isTrue);
      update(() => regions.add(1));
      await tester.pump();
      final after = strengths();
      for (var i = 0; i < 6; i++) {
        expect(after[i], closeTo(before[i], .001));
      }
      await tester.pump(const Duration(milliseconds: 1900));
      expect(strengths(), [0.0, 0.0, 0.0, 0.0, 1.0, 1.0]);
      update(() => regions.add(2));
      await tester.pump();
      expect(strengths(), [0.0, 0.0, 0.0, 0.0, 1.0, 1.0]);
      await tester.pump(const Duration(milliseconds: 300));
      expect(strengths().any((value) => value > .1), isTrue);
      await tester.pump(const Duration(milliseconds: 2000));
      expect(strengths(), everyElement(0.0));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'reduced motion finishes quenching without a hidden animation ticker',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const SizedBox(
              width: 360,
              height: 150,
              child: ForestFireSimulation(reducedRegions: {0}),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        [
          for (var i = 0; i < 6; i++)
            tester
                .widget<Opacity>(find.byKey(ValueKey('forest-fire-opacity-$i')))
                .opacity,
        ],
        [0.0, 0.0, 1.0, 1.0, 1.0, 1.0],
      );
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
