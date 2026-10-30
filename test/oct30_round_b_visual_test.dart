import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'oct30_visual_review_test.dart' show sizes, kind;

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
      testWidgets('R30-04 closing allowance display $suffix', (tester) async {
        await launchScreen(tester, size: size, locale: locale, page: 'closing');
        await tester.pump(const Duration(milliseconds: 500));
        final notice = AppCopy.translate(
          locale == AppLocale.english
              ? 'Touch the screen to continue, or wait 30 seconds.'
              : 'Sentuh layar untuk lanjut, atau tunggu 30 detik.',
        );
        expect(find.text(notice), findsOneWidget);
        expect(tester.takeException(), isNull);
        await captureScreen(tester, 'closing-$suffix', {
          'ticket': 'KIFC-R30-04',
          'source': 'Flutter widget render',
          'language': locale.name,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        });
        await tester.tapAt(Offset(size.width * .01, size.height * .01));
        await tester.pump(const Duration(milliseconds: 400));
        expect(kind('_WelcomePage'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        AppCopy.locale = AppLocale.indonesian;
      });
    }
  }
}
