import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/features/game/widgets/progressive_reading_text.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/rendering.dart';

void main() {
  testWidgets(
    'Korean reveal keeps a word together across the visible boundary',
    (tester) async {
      AppCopy.locale = AppLocale.korean;
      addTearDown(() => AppCopy.locale = AppLocale.indonesian);
      final semantics = tester.ensureSemantics();
      const original = '산불은 충분한 열을 확인해요.';
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: SizedBox(
          width: 100,
              child: ProgressiveReadingText(
                text: original,
            visibleCharacters: 2,
            style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(ProgressiveReadingText)).label,
        original.substring(0, 2),
      );
      final rich = find.descendant(
        of: find.byType(ProgressiveReadingText),
        matching: find.byType(RichText),
      );
      final paragraph = tester.renderObject<RenderParagraph>(rich);
      final joined = paragraph.text.toPlainText();
      expect(joined.replaceAll('\u2060', ''), original);
      final word = '산\u2060불\u2060은';
      final start = joined.indexOf(word);
      expect(start, greaterThanOrEqualTo(0));
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: start, extentOffset: start + word.length),
      );
      expect(boxes.map((b) => b.top).toSet(), hasLength(1));
      semantics.dispose();
    },
  );
  testWidgets('word reveal preserves the full paragraph height', (
    tester,
  ) async {
    const paragraph =
        'Kebakaran hutan dapat terjadi ketika panas dan bahan bakar bertemu.';
    Widget surface(int count) => MaterialApp(
      home: Center(
        child: SizedBox(
          width: 130,
          child: ProgressiveReadingText(
            text: paragraph,
            visibleCharacters: count,
          ),
        ),
      ),
    );
    await tester.pumpWidget(surface(0));
    final before = tester.getSize(find.byType(ProgressiveReadingText));
    await tester.pumpWidget(surface(20));
    expect(tester.getSize(find.byType(ProgressiveReadingText)), before);
    await tester.pumpWidget(surface(paragraph.length));
    expect(tester.getSize(find.byType(ProgressiveReadingText)), before);
  });
}
