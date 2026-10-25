import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/widgets/fire_loop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fire_prevention_challenge/features/game/widgets/forest_fire_simulation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'assembly_review_test.dart' show paintAssembly;
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'package:flutter/services.dart';

Finder type(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

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
      testWidgets('recorded fire layout and interaction $lang-$res', (
        tester,
      ) async {
        final metrics = <String, Object>{
          'revision': 'recorded-fire',
          'source': 'Flutter widget render',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        };
        void checkPanel() {
          expect(tester.takeException(), isNull);
          final fire = tester.getRect(find.byType(ForestFireSimulation));
          final cards = tester.getRect(type('_DropSlot').first);
          expect(fire.bottom, lessThan(cards.top));
          expect(find.byType(FireLoop), findsNWidgets(6));
        }

        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'triangleExplanation',
        );
        await paintAssembly(tester);
        checkPanel();
        await tester.pump(const Duration(milliseconds: 500));
        final action = find.byKey(
          const ValueKey('triangle-reduction-continue'),
        );
        final actionRect = tester.getRect(action);
        final mascotRect = tester.getRect(
          find.byKey(const ValueKey('feedback-mascot-crop')),
        );
        expect(mascotRect.right, lessThanOrEqualTo(actionRect.left + 1));
        final label = find.descendant(of: action, matching: find.byType(Text));
        final paragraph = tester.renderObject<RenderParagraph>(label);
        expect(
          paragraph.getBoxesForSelection(
            TextSelection(
              baseOffset: 0,
              extentOffset: paragraph.text.toPlainText().length,
            ),
          ),
          hasLength(1),
          reason: 'The complete localized CTA must stay on one line',
        );
        final labelRect = tester.getRect(label);
        expect(labelRect.left, greaterThanOrEqualTo(actionRect.left));
        expect(labelRect.right, lessThanOrEqualTo(actionRect.right));
        await captureScreen(tester, 'explanation-$lang-$res', metrics);
        await tester.pumpWidget(const SizedBox.shrink());
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'breakTriangle',
        );
        await paintAssembly(tester);
        checkPanel();
        await captureScreen(tester, 'reduction-before-$lang-$res', metrics);
        await tester.tap(type('_ChoiceButton').first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));
        await paintAssembly(tester);
        checkPanel();
        expect(
          tester
              .widget<ForestFireSimulation>(find.byType(ForestFireSimulation))
              .reducedRegions,
          {0},
        );
        await captureScreen(tester, 'reduction-after-$lang-$res', metrics);
        await tester.pump(const Duration(milliseconds: 1500));
        expect(
          [
            for (var i = 0; i < 6; i++)
              tester
                  .widget<Opacity>(
                    find.byKey(ValueKey('forest-fire-opacity-$i')),
                  )
                  .opacity,
          ],
          [0.0, 0.0, 1.0, 1.0, 1.0, 1.0],
        );
        await captureScreen(
          tester,
          'reduction-extinguished-$lang-$res',
          metrics,
        );
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
