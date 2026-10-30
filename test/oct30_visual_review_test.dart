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
      testWidgets('R30-02 chapter labels across pages $suffix', (tester) async {
        for (final (page, card) in [
          ('triangleBuild', 0),
          ('triangleExplanation', 0),
          ('breakTriangle', 0),
          ('karhutlaCards', 0),
          ('karhutlaCards', 1),
          ('karhutlaCards', 2),
          ('risk', 0),
          ('causeQuiz', 0),
          ('peatCharacteristics', 0),
          ('finalChallenge', 0),
          ('finalReview', 0),
          ('score', 0),
        ]) {
          await tester.pumpWidget(const SizedBox.shrink());
          await launchScreen(
            tester,
            size: size,
            locale: locale,
            page: page,
            cardIndex: card,
          );
          await tester.pump(const Duration(milliseconds: 700));
          expect(tester.takeException(), isNull, reason: '$page-$card-$suffix');
          final label = tester
              .widget<Text>(
                find.descendant(
                  of: kind('_Eyebrow'),
                  matching: find.byType(Text),
                ),
              )
              .data!;
          expect(label, isNot(contains('/')));
          expect(label.trim(), isNotEmpty);
          final chapter = switch (page) {
            'triangleBuild' || 'triangleExplanation' || 'breakTriangle' => 1,
            'karhutlaCards' || 'risk' => 2,
            'causeQuiz' => 3,
            _ => 4,
          };
          if (page != 'score') {
            expect(label, switch (locale) {
              AppLocale.indonesian => 'BABAK $chapter',
              AppLocale.english => 'CHAPTER $chapter',
              AppLocale.korean => '$chapter장',
            });
          }
          final progress = AppCopy.translate(
            locale == AppLocale.english
                ? 'CHAPTER $chapter/4'
                : 'BABAK $chapter/4',
          );
          // The active challenge intentionally shows its countdown here instead.
          expect(
            find.text(progress),
            (page == 'finalChallenge' || page == 'finalReview')
                ? findsNothing
                : findsOneWidget,
            reason: '$page-$card-$suffix',
          );
          await captureScreen(tester, '$page-$card-$suffix', {
            'ticket': 'KIFC-R30-02',
            'source': 'Flutter widget render',
            'language': locale.name,
            'width': size.width,
            'height': size.height,
            'page': page,
            'card': card,
            'eyebrow': label,
            'physicalTVReachValidated': false,
          });
        }
        await tester.pumpWidget(const SizedBox.shrink());
        AppCopy.locale = AppLocale.indonesian;
      });
    }
  }
}
