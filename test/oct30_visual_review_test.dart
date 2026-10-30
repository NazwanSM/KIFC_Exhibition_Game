import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

const sizes = [
  Size(360, 640),
  Size(411, 731),
  Size(720, 1280),
  Size(1080, 1920),
  Size(2160, 3840),
];

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
      testWidgets('R30-01 welcome controls $suffix', (tester) async {
        await launchScreen(tester, size: size, locale: locale, page: 'welcome');
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);
        for (final language in AppLocale.values) {
          expect(find.text(language.label), findsOneWidget);
        }
        final audio = find.byKey(const ValueKey('audio-settings'));
        expect(audio, findsOneWidget);
        expect(tester.getRect(audio).bottom, lessThan(size.height));
        final languageRow = tester.getRect(find.text(AppLocale.english.label));
        expect(
          tester.getRect(audio).center.dy,
          closeTo(languageRow.center.dy, 2),
        );
        await captureScreen(tester, 'welcome-$suffix', {
          'ticket': 'KIFC-R30-01',
          'source': 'Flutter widget render',
          'language': locale.name,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        });
        await tester.tap(audio);
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.byKey(const ValueKey('audio-close')), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('audio-close')));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.tap(kind('_WelcomeStartButton'));
        await tester.pump(const Duration(milliseconds: 600));
        expect(kind('_TriangleBuild'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        AppCopy.locale = AppLocale.indonesian;
      });
    }
  }
}
