import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/widgets/progressive_reading_text.dart';

final manifest =
    jsonDecode(
          File(
            'design/quick-specs/korean-full-pdf-2026-11-05.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;
void main() {
  setUpAll(() async {
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  setUp(() => AppCopy.locale = AppLocale.korean);
  tearDown(() => AppCopy.locale = AppLocale.indonesian);
  test(
    'all approved Korean PDF copy is exact including spaces and newlines',
    () {
      for (final item in manifest['items'] as List) {
        for (final key in item['keys'] as List) {
          expect(
            AppCopy.translate(key as String),
            item['text'],
            reason: item['id'],
          );
        }
      }
    },
  );
  for (final width in [130.0, 164.0, 188.0, 324.0, 363.0]) {
    testWidgets('PDF lines stay exact in narrow and full-width blocks $width', (
      t,
    ) async {
      for (final item in manifest['items'] as List) {
        final source = (item['keys'] as List).first as String;
        await t.pumpWidget(
          MaterialApp(
            home: Center(
              child: SizedBox(
                width: width,
                child: LocalizedText(
                  source,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    letterSpacing: .25,
                  ),
                ),
              ),
            ),
          ),
        );
        final rich = find.byType(RichText);
        final p = t.renderObject<RenderParagraph>(rich);
        final text = p.text.toPlainText();
        expect(text.replaceAll('\u2060', ''), item['text'], reason: item['id']);
        var start = 0;
        for (final line in (item['lines'] as List).cast<String>()) {
          final joined = AppCopy.keepKoreanWordBreaks(line);
          final end = start + joined.length;
          final boxes = p.getBoxesForSelection(
            TextSelection(baseOffset: start, extentOffset: end),
          );
          expect(
            boxes.map((b) => (b.top * 10).round()).toSet(),
            hasLength(1),
            reason: '${item['id']}: $line',
          );
          expect(
            boxes.every((b) => b.left >= -1 && b.right <= p.size.width + 1),
            isTrue,
            reason: '${item['id']}: line exceeds block',
          );
          start = end + 1;
        }
        expect(t.takeException(), isNull, reason: item['id']);
      }
      await t.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('PDF copy fits bounded height with system text scaling', (
    t,
  ) async {
    final item = (manifest['items'] as List).firstWhere(
      (x) => x['id'] == 'final-F03',
    );
    await t.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 160,
            height: 40,
            child: LocalizedText(
              (item['keys'] as List).first as String,
              textScaler: TextScaler.linear(2),
              style: const TextStyle(fontSize: 13, letterSpacing: .25),
            ),
          ),
        ),
      ),
    );
    final p = t.renderObject<RenderParagraph>(find.byType(RichText));
    final boxes = p.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: p.text.toPlainText().length),
    );
    expect(p.size.height, lessThanOrEqualTo(40));
    expect(boxes.every((b) => b.right <= 160), isTrue);
    expect(boxes.map((b) => (b.top * 10).round()).toSet(), hasLength(4));
    expect(t.takeException(), isNull);
  });
  testWidgets('PDF reading layout preserves original reveal offsets', (
    t,
  ) async {
    final item = (manifest['items'] as List).firstWhere(
      (x) => x['id'] == 'reading-2-body',
    );
    final text = item['text'] as String;
    Size? previous;
    for (final end in [0, 8, text.length]) {
      await t.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 164,
              child: ProgressiveReadingText(
                text: text,
                visibleCharacters: end,
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ),
        ),
      );
      final size = t.getSize(find.byType(ProgressiveReadingText));
      if (previous != null) expect(size, previous);
      previous = size;
      expect(
        t
            .renderObject<RenderParagraph>(find.byType(RichText))
            .text
            .toPlainText()
            .replaceAll('\u2060', ''),
        text,
      );
    }
    await t.pumpWidget(const SizedBox.shrink());
  });
}
