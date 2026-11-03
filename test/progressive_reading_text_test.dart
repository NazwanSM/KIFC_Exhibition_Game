import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/features/game/widgets/progressive_reading_text.dart';

void main() {
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
