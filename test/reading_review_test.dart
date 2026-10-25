import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'assembly_review_test.dart' show paintAssembly;
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
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
      testWidgets('15-second feedback and results fit $lang-$res', (
        tester,
      ) async {
        final metadata = <String, Object>{
          'ticket': 'KIFC-X01-feedback15',
          'source': 'Flutter widget render',
          'language': lang,
          'width': size.width,
          'height': size.height,
          'physicalTVReachValidated': false,
        };
        for (final (state, page) in const [
          ('cause-correct', 'causeQuiz'),
          ('cause-wrong', 'causeQuiz'),
          ('peat-correct', 'risk'),
          ('peat-revealed', 'risk'),
          ('impact-review', 'finalReview'),
          ('score', 'score'),
          ('closing', 'closing'),
        ]) {
          await tester.pumpWidget(const SizedBox.shrink());
          await launchScreen(tester, size: size, locale: locale, page: page);
          if (page == 'causeQuiz') {
            await tester.tap(
              kind('_ChoiceButton').at(state == 'cause-correct' ? 0 : 1),
            );
          }
          if (page == 'risk') {
            Future<void> choose(int index) => tester.tap(
              find.descendant(
                of: kind('_RiskCard').at(index),
                matching: find.byType(InkWell),
              ),
            );
            if (state == 'peat-revealed') {
              await choose(0);
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 500));
              await choose(2);
            } else {
              await choose(1);
            }
          }
          await tester.pump();
          await tester.pump(const Duration(seconds: 3));
          await tester.pump(const Duration(milliseconds: 500));
          expect(
            kind(switch (page) {
              'causeQuiz' => '_CauseQuiz',
              'risk' => '_RiskPage',
              'score' => '_ScorePage',
              'closing' => '_ClosingPage',
              _ => '_FinalChallenge',
            }),
            findsOneWidget,
          );
          await paintAssembly(tester);
          expect(tester.takeException(), isNull);
          await captureScreen(tester, '$state-$lang-$res', metadata);
          await tester.tapAt(Offset(size.width * .01, size.height * .01));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
          expect(tester.takeException(), isNull);
          if (page == 'causeQuiz') {
            expect(kind('_Feedback'), findsNothing);
          } else if (page == 'risk') {
            expect(kind('_CauseQuiz'), findsOneWidget);
          } else if (page == 'score') {
            expect(kind('_ClosingPage'), findsOneWidget);
          } else if (page == 'closing') {
            expect(kind('_WelcomePage'), findsOneWidget);
          } else {
            expect(kind('_ScorePage'), findsOneWidget);
          }
        }
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
