import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:fire_prevention_challenge/features/game/widgets/game_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'assembly_review_test.dart'
    show paintAssembly, dropAssembly, filledAssembly;
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'oct30_visual_review_test.dart' show sizes, kind;

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await paintAssembly(tester);
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> dropAt(WidgetTester tester, int piece, Offset position) async {
  final source = kind('_DraggablePiece').at(piece);
  await tester.drag(source, position - tester.getCenter(source));
  await settle(tester);
}

void main() {
  setUpAll(() async {
    await loadGameFonts();
    for (final (family, asset) in [
      ('NotoSansKR', 'assets/fonts/NotoSansKR-Variable.ttf'),
      ('MaterialIcons', 'fonts/MaterialIcons-Regular.otf'),
    ]) {
      await (FontLoader(family)..addFont(rootBundle.load(asset))).load();
    }
  });
  for (final size in sizes) {
    for (final locale in AppLocale.values) {
      final suffix =
          '${locale.name}-${size.width.toInt()}x${size.height.toInt()}';
      testWidgets(
        'R30-08 whole forest accepts and auto-places elements $suffix',
        (tester) async {
          await launchScreen(
            tester,
            size: size,
            locale: locale,
            page: 'triangleBuild',
          );
          await settle(tester);
          final panel = tester.getRect(kind('_FireScene'));
          void checkForestSurface() {
            final forest = find.descendant(
              of: kind('_FireScene'),
              matching: find.byWidgetPredicate(
                (w) =>
                    w is GamePhoto &&
                    w.asset == 'assets/images/field/rainforest-kalimantan.jpg',
              ),
            );
            expect(
              tester.getRect(forest),
              panel,
              reason: 'The forest photo must reach every panel edge',
            );
            for (final element in kind('_DropSlot').evaluate()) {
              if (!(element.widget as dynamic).filled) {
                final empty = find.byElementPredicate((e) => e == element);
                expect(
                  find.descendant(
                    of: empty,
                    matching: find.byWidgetPredicate(
                      (w) =>
                          w is Text ||
                          w is Icon ||
                          w is Image ||
                          w is DecoratedBox,
                    ),
                  ),
                  findsNothing,
                  reason:
                      'An unfilled position must leave the forest visible without a placeholder',
                );
              }
            }
          }

          checkForestSurface();
          final slots = [
            for (final slot in kind('_DropSlot').evaluate())
              tester.getRect(find.byElementPredicate((e) => e == slot)),
          ];
          final reset = AppCopy.translate(
            locale == AppLocale.english ? 'Restart' : 'Ulangi',
          );
          final metrics = <String, Object>{
            'ticket': 'KIFC-R30-08',
            'source': 'Flutter widget render',
            'language': locale.name,
            'width': size.width,
            'height': size.height,
            'physicalTVReachValidated': false,
          };
          await captureScreen(tester, 'empty-$suffix', metrics);
          await dropAt(tester, 1, panel.topCenter + const Offset(0, 6));
          expect(
            filledAssembly(tester),
            0,
            reason: 'Water is a decoy throughout the forest',
          );
          await dropAt(tester, 0, panel.topCenter + const Offset(0, 6));
          expect(filledAssembly(tester), 1);
          checkForestSurface();
          expect(
            (tester.widget(kind('_DropSlot').first) as dynamic).placedPiece
                .toString(),
            contains('heat'),
          );
          expect(find.byKey(const ValueKey('fire')), findsNothing);
          await captureScreen(tester, 'partial-$suffix', metrics);
          await dropAt(tester, 0, panel.center);
          expect(
            filledAssembly(tester),
            1,
            reason: 'An already placed card cannot count twice',
          );
          final fuel = tester.getCenter(kind('_DraggablePiece').at(2));
          final gesture = await tester.startGesture(fuel);
          await gesture.moveTo(panel.center);
          await tester.pump(const Duration(milliseconds: 120));
          expect(
            find.byKey(const ValueKey('forest-drop-highlight')),
            findsOneWidget,
          );
          await captureScreen(tester, 'dragging-$suffix', metrics);
          await gesture.moveTo(slots.first.center);
          await gesture.up();
          await settle(tester);
          expect(
            filledAssembly(tester),
            2,
            reason: 'Dropping over an occupied slot fills the next one',
          );
          checkForestSurface();
          expect(
            (tester.widget(kind('_DropSlot').at(1)) as dynamic).placedPiece
                .toString(),
            contains('fuel'),
          );
          await dropAt(tester, 4, panel.topRight + const Offset(-12, 20));
          expect(filledAssembly(tester), 3);
          checkForestSurface();
          expect(find.byKey(const ValueKey('fire')), findsOneWidget);
          expect(
            kind('_TriangleBuild'),
            findsOneWidget,
            reason: 'The last drop must not dismiss feedback',
          );
          expect(tester.getRect(kind('_FireScene')), panel);
          for (var i = 0; i < 3; i++) {
            expect(tester.getRect(kind('_DropSlot').at(i)), slots[i]);
          }
          await captureScreen(tester, 'complete-$suffix', metrics);
          await tester.tap(find.text(reset));
          await settle(tester);
          checkForestSurface();
          final inside = [
            panel.topCenter + const Offset(0, 1),
            panel.centerLeft + const Offset(1, 0),
            panel.centerRight - const Offset(1, 0),
            panel.bottomCenter - const Offset(0, 1),
            panel.topLeft + Offset(panel.width * .15, panel.height * .2),
            panel.center,
            panel.topLeft + Offset(panel.width * .85, panel.height * .6),
            slots.first.center,
            slots.last.center,
          ];
          for (final point in inside) {
            await dropAt(tester, 0, point);
            expect(
              filledAssembly(tester),
              1,
              reason: 'Visible panel point $point accepts an element',
            );
            expect(
              (tester.widget(kind('_DropSlot').first) as dynamic).filled,
              isTrue,
            );
            await tester.tap(find.text(reset));
            await settle(tester);
          }
          for (final point in [
            panel.topCenter - const Offset(0, 1),
            panel.centerLeft - const Offset(1, 0),
            panel.centerRight + const Offset(1, 0),
            panel.bottomCenter + const Offset(0, 1),
          ]) {
            await dropAt(tester, 0, point);
            expect(
              filledAssembly(tester),
              0,
              reason: 'Outside point $point must not count',
            );
          }
          expect(find.byKey(const ValueKey('fire')), findsNothing);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          AppCopy.locale = AppLocale.indonesian;
        },
      );
      testWidgets('R30-07 explanation goes directly to reading $suffix', (
        tester,
      ) async {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'triangleExplanation',
        );
        await settle(tester);
        final action = find.byKey(const ValueKey('triangle-reading-continue'));
        expect(action, findsOneWidget);
        expect(
          find.byKey(const ValueKey('triangle-reduction-continue')),
          findsNothing,
        );
        expect(
          find.descendant(
            of: action,
            matching: find.text(switch (locale) {
              AppLocale.indonesian => 'Lanjut',
              AppLocale.english => 'Continue',
              AppLocale.korean => '계속',
            }),
          ),
          findsOneWidget,
        );
        final metrics = <String, Object>{
          'ticket': 'KIFC-R30-07',
          'source': 'Flutter widget render',
          'language': locale.name,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        };
        await captureScreen(tester, 'explanation-$suffix', metrics);
        await tester.tap(action);
        await settle(tester);
        expect(
          find.byKey(const ValueKey('karhutla-definition')),
          findsOneWidget,
        );
        await captureScreen(tester, 'reading-$suffix', metrics);
        await tester.pump(const Duration(seconds: 35));
        expect(
          find.byKey(const ValueKey('karhutla-definition')),
          findsOneWidget,
        );
        final back = AppCopy.translate(
          locale == AppLocale.english ? 'Back' : 'Kembali',
        );
        await tester.tap(find.text(back));
        await settle(tester);
        expect(kind('_TriangleExplanation'), findsOneWidget);
        await tester.tapAt(Offset(size.width * .01, size.height * .01));
        await settle(tester);
        expect(
          find.byKey(const ValueKey('karhutla-definition')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        expect(maxGamePoints, 8);
        await tester.pumpWidget(const SizedBox.shrink());
        AppCopy.locale = AppLocale.indonesian;
      });
    }
  }
  for (final locale in AppLocale.values) {
    testWidgets(
      'R30-08 forest has an accessible target without placeholders ${locale.name}',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          await launchScreen(
            tester,
            size: const Size(411, 731),
            locale: locale,
            page: 'triangleBuild',
          );
          await settle(tester);
          final label = AppCopy.translate(
            locale == AppLocale.english
                ? 'Forest area for dropping fire elements'
                : 'Area hutan untuk meletakkan unsur api',
          );
          final target = find.bySemanticsLabel(label);
          expect(target, findsOneWidget);
          expect(tester.getRect(target), tester.getRect(kind('_FireScene')));
          expect(find.byIcon(Icons.add_circle_outline), findsNothing);
          await tester.pumpWidget(const SizedBox.shrink());
          AppCopy.locale = AppLocale.indonesian;
        } finally {
          semantics.dispose();
        }
      },
    );
  }
  testWidgets(
    'R30-08 concurrent duplicate gestures and stale callbacks cannot add points',
    (tester) async {
      await launchScreen(
        tester,
        size: const Size(411, 731),
        locale: AppLocale.indonesian,
        page: 'triangleBuild',
      );
      await settle(tester);
      final dynamic callback =
          (tester.widget(kind('_TriangleBuild')) as dynamic).onDrop;
      final draggable = find.byWidgetPredicate((w) => w is Draggable).first;
      final dynamic heat = (tester.widget(draggable) as dynamic).data;
      final start = tester.getCenter(kind('_DraggablePiece').first);
      final panel = tester.getRect(kind('_FireScene'));
      final first = await tester.startGesture(start, pointer: 1);
      final second = await tester.startGesture(start, pointer: 2);
      await first.moveTo(panel.topCenter + const Offset(0, 10));
      await second.moveTo(panel.center);
      await tester.pump();
      await first.up();
      await second.up();
      await settle(tester);
      expect(filledAssembly(tester), 1);
      await dropAt(tester, 2, panel.center);
      await dropAt(tester, 4, panel.center);
      expect(filledAssembly(tester), 3);
      callback(heat);
      await settle(tester);
      expect(
        (tester.widget(kind('_TriangleBuild')) as dynamic).lastDropCorrect,
        isTrue,
      );
      await tester.tapAt(const Offset(4, 4));
      await settle(tester);
      expect(kind('_TriangleExplanation'), findsOneWidget);
      callback(heat);
      await settle(tester);
      expect(kind('_TriangleExplanation'), findsOneWidget);
      final placed =
          (tester.widget(kind('_TriangleExplanation')) as dynamic).pieces
              as Map;
      expect(placed.length, 3);
      await tester.pumpWidget(const SizedBox.shrink());
      callback(heat);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'R30-07 completion timer cannot skip reading; back and replay reset assembly',
    (tester) async {
      await launchScreen(
        tester,
        size: const Size(411, 731),
        locale: AppLocale.indonesian,
        page: 'triangleBuild',
      );
      for (final (piece, slot) in [(0, 0), (2, 1), (4, 2)]) {
        await dropAssembly(tester, piece, slot);
      }
      expect(filledAssembly(tester), 3);
      await tester.tapAt(const Offset(4, 4));
      await settle(tester);
      expect(kind('_TriangleExplanation'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('triangle-reading-continue')));
      await settle(tester);
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
      await tester.tap(find.text('Kembali'));
      await settle(tester);
      await tester.tap(find.text('Kembali'));
      await settle(tester);
      expect(kind('_TriangleBuild'), findsOneWidget);
      expect(filledAssembly(tester), 0);
      await dropAssembly(tester, 0, 0);
      await tester.tap(find.text('Ulangi'));
      await settle(tester);
      expect(filledAssembly(tester), 0);
      await tester.tap(find.text('Kembali'));
      await settle(tester);
      expect(kind('_WelcomePage'), findsOneWidget);
      await tester.tap(kind('_WelcomeStartButton'));
      await settle(tester);
      expect(kind('_TriangleBuild'), findsOneWidget);
      expect(filledAssembly(tester), 0);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
