import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'game_flow_test.dart' show GameFlow, loadGameFonts, renderedTextByKey;

void main() {
  setUpAll(loadGameFonts);
  for (final sample in [
    (wrong: <int>{}, impacts: 0, score: '7', title: 'Makin Paham Risikonya'),
    (wrong: <int>{}, impacts: 1, score: '7,25', title: 'Siap Cegah Karhutla'),
    (wrong: {0, 1}, impacts: 1, score: '5,25', title: 'Ayo, Coba Lagi'),
    (wrong: {0, 1}, impacts: 2, score: '5,5', title: 'Makin Paham Risikonya'),
  ]) {
    testWidgets(
      'unscored peat cards preserve proportional category at ${sample.score}',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final flow = GameFlow(
          tester,
          english: false,
          size: const Size(411, 731),
        );
        await flow.launch();
        await flow.toCharacteristics(wrongCauseIndices: sample.wrong);
        // Rereading card1 cannot add a score point.
        await flow.readCharacteristics();
        await tester.tap(find.byKey(const ValueKey('peat-card-0')));
        await flow.pump(500);
        await tester.tap(find.byKey(const ValueKey('peat-card-0')));
        await flow.pump(500);
        await flow.finalChallenge();
        for (final impact in ['haze', 'ecosystemDamage'].take(sample.impacts)) {
          await flow.token(impact);
        }
        await flow.finish(perfect: false);
        expect(renderedTextByKey(tester, 'total-score'), sample.score);
        expect(find.text('/ 8 poin'), findsOneWidget);
        expect(find.text('Memilih tindakan aman'), findsNothing);
        expect(find.text(sample.title), findsOneWidget);
        await flow.capture(
          'score-category-${sample.score.replaceAll(",", "-")}',
        );
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
