import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'chapter2_review_test.dart' show launchScreen, captureScreen;
import 'game_flow_test.dart' show loadGameFonts;

void main() {
  setUpAll(loadGameFonts);
  testWidgets('impact review uses a large cropped half-body mascot', (
    tester,
  ) async {
    await launchScreen(
      tester,
      size: const Size(411, 731),
      locale: AppLocale.indonesian,
      page: 'finalReview',
    );
    await tester.pump(const Duration(seconds: 1));
    final crop = find.byKey(const ValueKey('final-review-mascot-crop'));
    expect(crop, findsOneWidget);
    expect(tester.getSize(crop).width, greaterThanOrEqualTo(156));
    expect(find.byKey(const ValueKey('final-review-continue')), findsOneWidget);
    expect(
      tester.getRect(crop).bottom,
      closeTo(
        tester.getRect(find.byKey(const ValueKey('final-review-continue'))).top,
        .5,
      ),
      reason: 'The half-body crop must meet the button without a gap.',
    );
    expect(tester.takeException(), isNull);
    await captureScreen(tester, 'impact-half-body-id-411x731', {
      'source': 'Flutter widget render, static mascot fallback',
      'width': 411,
      'height': 731,
    });
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('correct cause mascot is docked farther right', (tester) async {
    await launchScreen(
      tester,
      size: const Size(411, 731),
      locale: AppLocale.indonesian,
      page: 'causeQuiz',
    );
    await tester.tap(
      find
          .byWidgetPredicate((w) => w.runtimeType.toString() == '_ChoiceButton')
          .first,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final crop = find.byKey(const ValueKey('feedback-mascot-crop'));
    expect(tester.getRect(crop).right, greaterThan(450));
    expect(tester.takeException(), isNull);
    await captureScreen(tester, 'cause-right-id-411x731', {
      'source': 'Flutter widget render, static mascot fallback',
      'width': 411,
      'height': 731,
    });
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
