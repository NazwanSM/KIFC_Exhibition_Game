import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/widgets/game_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder assemblyType(String name) =>
    find.byWidgetPredicate((widget) => widget.runtimeType.toString() == name);
Future<void> paintAssembly(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final provider = (element.widget as Image).image;
      if (provider is AssetImage && provider.assetName.endsWith('.webp')) {
        continue;
      }
      await precacheImage((element.widget as Image).image, element);
    }
  });
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 20));
    if (tester
        .widgetList<RawImage>(find.byType(RawImage))
        .every((w) => w.image != null)) {
      break;
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
  }
}

Future<void> dropAssembly(WidgetTester tester, int piece, int slot) async {
  final source = assemblyType('_DraggablePiece').at(piece);
  final target = assemblyType('_DropSlot').at(slot);
  await tester.drag(
    source,
    tester.getCenter(target) - tester.getCenter(source),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
  await paintAssembly(tester);
}

int filledAssembly(WidgetTester tester) => tester
    .widgetList(assemblyType('_DropSlot'))
    .where((w) => (w as dynamic).filled)
    .length;

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  for (final size in const [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final locale in AppLocale.values) {
      final lang = ['id', 'en', 'ko'][locale.index];
      final res = '${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('assembly interaction and layout $lang-$res', (tester) async {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'triangleBuild',
        );
        await paintAssembly(tester);
        String text(String id, String en) =>
            AppCopy.translate(locale == AppLocale.english ? en : id);
        final metrics = <String, Object>{
          'ticket': 'KIFC-02',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
          'source': 'Flutter widget render',
        };
        void checkLayout() {
          expect(tester.takeException(), isNull);
          final crop = tester.getRect(
            find.byKey(const ValueKey('feedback-mascot-crop')),
          );
          expect(
            crop.bottom,
            closeTo(size.height, .5),
            reason: 'Half-body mascot meets the physical bottom',
          );
          expect(
            crop.width,
            greaterThanOrEqualTo(size.width * .25),
            reason: 'Mascot must stay visibly large',
          );
          final slots = assemblyType('_DropSlot');
          expect(slots, findsNWidgets(3));
          final first = tester.getRect(slots.first);
          for (final slot in slots.evaluate()) {
            final rect = tester.getRect(
              find.byElementPredicate((e) => e == slot),
            );
            expect(rect.top, closeTo(first.top, .5));
            expect(rect.width / rect.height, closeTo(1.8, .01));
          }
          for (final state in tester.stateList<ScrollableState>(
            find.byType(Scrollable),
          )) {
            expect(state.position.maxScrollExtent, lessThanOrEqualTo(.5));
          }
        }

        checkLayout();
        expect(assemblyType('_DraggablePiece'), findsNWidgets(6));
        expect(find.byWidgetPredicate((w) => w is Draggable), findsNWidgets(6));
        expect(
          find.text(text('Pilih tiga unsur api.', 'Choose three elements.')),
          findsOneWidget,
        );
        expect(
          find.text(
            text(
              'Seret tiga foto yang tepat ke tempat kosong.',
              'Drag the right photos into the empty spaces.',
            ),
          ),
          findsOneWidget,
        );
        for (final slot in assemblyType('_DropSlot').evaluate()) {
          final labels = find.descendant(
            of: find.byElementPredicate((e) => e == slot),
            matching: find.byType(Text),
          );
          expect(
            tester
                .widgetList<Text>(labels)
                .any(
                  (w) => [
                    text('Panas', 'Heat'),
                    text('Bahan bakar', 'Fuel'),
                    text('Oksigen', 'Oxygen'),
                  ].contains(w.data),
                ),
            isFalse,
          );
        }
        await captureScreen(tester, 'initial-$lang-$res', metrics);
        final source = assemblyType('_DraggablePiece').first;
        final originalRect = tester.getRect(source);
        final gesture = await tester.startGesture(originalRect.center);
        await gesture.moveBy(const Offset(0, -30));
        await tester.pump(const Duration(milliseconds: 100));
        final previewRect = tester.getRect(assemblyType('_PieceCard').last);
        expect(
          previewRect.width,
          closeTo(originalRect.width, .5),
          reason:
              'Dragged photo must retain its visible size in scaled TV/web layouts',
        );
        await gesture.cancel();
        await tester.pump();

        // Every decoy can be dragged, but none may fill any element.
        for (final decoy in [1, 3, 5]) {
          await dropAssembly(tester, decoy, 0);
          final expected = switch (decoy) {
            1 => text(
              'Air bukan salah satu unsur dalam Segitiga Api.',
              'Water is not one of the elements of the fire triangle.',
            ),
            3 => text(
              'Hujan bukan salah satu unsur dalam Segitiga Api.',
              'Rain is not one of the elements of the fire triangle.',
            ),
            _ => text(
              'Batu bukan unsur yang dicari dalam Segitiga Api.',
              'Stone is not an element of the fire triangle.',
            ),
          };
          expect(find.text(expected), findsOneWidget);
          expect(filledAssembly(tester), 0);
          expect(find.byKey(const ValueKey('fire')), findsNothing);
          checkLayout();
        }
        await captureScreen(tester, 'incorrect-$lang-$res', metrics);
        // Empty slots have no hidden categories: heat may fill the middle.
        await dropAssembly(tester, 0, 1);
        expect(filledAssembly(tester), 1);
        expect(
          (tester.widget(assemblyType('_DropSlot').at(1)) as dynamic).filled,
          isTrue,
        );
        await dropAssembly(tester, 2, 0);
        expect(filledAssembly(tester), 2);
        expect(find.byKey(const ValueKey('fire')), findsNothing);
        checkLayout();
        await captureScreen(tester, 'partial-$lang-$res', metrics);
        await dropAssembly(tester, 4, 2);
        expect(filledAssembly(tester), 3);
        expect(find.byKey(const ValueKey('fire')), findsOneWidget);
        expect(
          find.text(
            text(
              'Tepat! Api dapat menyala ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Ketiga unsur ini disebut Segitiga Api. Mengurangi salah satu unsur dapat membantu mengendalikan api.',
              'Correct! Fire can start when sufficient heat, fuel, and oxygen meet. These three elements form the fire triangle. Reducing any one of them can help control fire.',
            ),
          ),
          findsOneWidget,
        );
        for (final photo in tester.widgetList<GamePhoto>(
          find.byType(GamePhoto),
        )) {
          expect(
            (photo as dynamic).forestTone,
            isTrue,
            reason: 'Chapter 1 photos share a subtle color treatment',
          );
        }
        checkLayout();
        final scene = tester.getRect(assemblyType('_FireScene'));
        final feedback = tester.getRect(
          find.byKey(const ValueKey('feedback-message')),
        );
        final mascot = tester.getRect(
          find.byKey(const ValueKey('feedback-mascot-crop')),
        );
        expect(
          feedback.top - scene.bottom,
          inInclusiveRange(0, size.height * .025),
        );
        expect(mascot.top, greaterThanOrEqualTo(feedback.bottom));
        expect(mascot.width, greaterThanOrEqualTo(size.width * .28));
        await captureScreen(tester, 'complete-$lang-$res', metrics);
        await tester.pump(const Duration(seconds: 5));
        expect(assemblyType('_TriangleBuild'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
        expect(assemblyType('_TriangleBuild'), findsOneWidget);
        await tester.tapAt(Offset(size.width * .28, 8));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));
        expect(assemblyType('_TriangleExplanation'), findsOneWidget);
        await paintAssembly(tester);
        final explanationScene = tester.getRect(assemblyType('_FireScene'));
        expect(explanationScene.height, closeTo(scene.height, .5));
        final explanationBubble = tester.getRect(
          find.byKey(const ValueKey('feedback-message')),
        );
        expect(
          explanationBubble.top - explanationScene.bottom,
          inInclusiveRange(0, size.height * .025),
        );
        final explanationMascot = tester.getRect(
          find.byKey(const ValueKey('feedback-mascot-crop')),
        );
        expect(explanationMascot.bottom, closeTo(size.height, .5));
        expect(
          explanationMascot.top,
          greaterThanOrEqualTo(explanationBubble.bottom),
        );
        expect(
          find.text(
            text(
              'Api Dapat Muncul Saat Tiga Unsur Bertemu',
              'Fire Can Start When Three Elements Meet',
            ),
          ),
          findsOneWidget,
        );
        final placed = tester.widgetList(assemblyType('_DropSlot')).toList();
        expect((placed[0] as dynamic).placedPiece.toString(), contains('fuel'));
        expect((placed[1] as dynamic).placedPiece.toString(), contains('heat'));
        await captureScreen(tester, 'explanation-$lang-$res', metrics);
        // Reading waits indefinitely; a separate background tap continues.
        await tester.pump(const Duration(seconds: 60));
        expect(assemblyType('_TriangleExplanation'), findsOneWidget);
        await tester.tap(assemblyType('_Primary'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 800));
        expect(assemblyType('_BreakTriangle'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
