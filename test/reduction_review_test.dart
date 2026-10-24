import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'assembly_review_test.dart' show paintAssembly;
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'reduction_interaction_test.dart' show kind, strengths;

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
      final resolution = '${size.width.toInt()}x${size.height.toInt()}';
      testWidgets(
        'KIFC-04 cumulative spatial reduction and continuation fit $lang-$resolution',
        (tester) async {
          final metadata = <String, Object>{
            'ticket': 'KIFC-04',
            'source': 'Flutter widget render',
            'language': lang,
            'width': size.width,
            'height': size.height,
            'physicalTVReachValidated': false,
          };
          Future<void> capture(String stage) async {
            expect(tester.takeException(), isNull);
            await captureScreen(tester, '$stage-$lang-$resolution', metadata);
          }

          await launchScreen(
            tester,
            size: size,
            locale: locale,
            page: 'breakTriangle',
          );
          await paintAssembly(tester);
          final panel = tester.getRect(kind('_FireScene'));
          expect(
            find.byKey(const ValueKey('reduction-continue')),
            findsNothing,
          );
          await capture('initial');
          for (var element = 0; element < 3; element++) {
            await tester.tap(kind('_ChoiceButton').at(element));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 500));
            await paintAssembly(tester);
            expect(tester.getRect(kind('_FireScene')).size, panel.size);
            final caption = locale == AppLocale.english
                ? ['Heat reduced', 'Fuel reduced', 'Oxygen reduced'][element]
                : [
                    'Panas dikurangi',
                    'Bahan bakar dikurangi',
                    'Oksigen dikurangi',
                  ][element];
            expect(find.text(AppCopy.translate(caption)), findsOneWidget);
            expect(
              kind('_AnswerMark'),
              findsNothing,
              reason: 'Exploration is unscored, not right/wrong',
            );
            expect(strengths(tester).any((v) => v > 0 && v < 1), isTrue);
            await capture('${['heat', 'fuel', 'oxygen'][element]}-changing');
            await tester.pump(const Duration(milliseconds: 2300));
            expect(
              strengths(tester),
              const [
                [0.0, 0.0, 1.0, 1.0, 1.0, 1.0],
                [0.0, 0.0, 0.0, 0.0, 1.0, 1.0],
                [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
              ][element],
            );
            await capture('${['heat', 'fuel', 'oxygen'][element]}-out');
          }
          final continueButton = find.byKey(
            const ValueKey('reduction-continue'),
          );
          expect(continueButton.hitTestable(), findsOneWidget);
          if (size.height >= 900) {
            expect(
              tester.getCenter(continueButton).dy,
              inInclusiveRange(size.height * .15, size.height * .85),
            );
          }
          await tester.tap(kind('_ChoiceButton').at(2));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 350));
          expect(strengths(tester), everyElement(0));
          expect(
            find.text(
              AppCopy.translate(
                locale == AppLocale.english
                    ? '3/3 elements tried'
                    : '3/3 unsur sudah dicoba',
              ),
            ),
            findsOneWidget,
          );
          await capture('repeated-selection');
          await tester.tap(continueButton);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
          expect(
            find.byKey(const ValueKey('karhutla-definition')),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }
}
