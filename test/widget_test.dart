import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:fire_prevention_challenge/app.dart';

void main() {
  testWidgets('renders the Figma welcome flow', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(411, 731));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const KifcApp());

    expect(find.textContaining('Fire Prevention'), findsOneWidget);
    expect(find.text('Mulai Tantangan'), findsOneWidget);
  });
}
