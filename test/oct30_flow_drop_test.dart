import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
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
