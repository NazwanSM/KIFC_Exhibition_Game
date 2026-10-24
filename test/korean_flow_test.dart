import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'game_flow_test.dart' show GameFlow, loadGameFonts, renderedTextByKey;

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  for (final size in const [Size(411, 731), Size(1080, 1920)]) {
    testWidgets('Korean complete flow and fresh replay $size', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final flow = GameFlow(tester, english: false, korean: true, size: size);
      await flow.launch();
      await flow.toCharacteristics();
      await flow.readCharacteristics();
      await flow.finalChallenge();
      for (final impact in [
        'haze',
        'ecosystemDamage',
        'carbonEmissions',
        'subsidence',
      ]) {
        await flow.token(impact);
      }
      await flow.finish(perfect: true);
      expect(renderedTextByKey(tester, 'total-score'), '8');
      await flow.tap(flow.text('Selesai', 'Closing Message'));
      await flow.capture('closing');
      await flow.tap(flow.text('Main Lagi', 'Play Again'));
      expect(
        find.text(flow.text('Pilih tiga unsur api.', 'Choose three elements.')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('fire')), findsNothing);
      expect(flow.type('_DropSlot'), findsNWidgets(3));
      await flow.capture('fresh-replay');
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
