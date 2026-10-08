import 'package:flutter_test/flutter_test.dart';

import 'package:fire_prevention_challenge/app.dart';

void main() {
  testWidgets('renders the Android exhibition shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KifcApp());

    expect(find.text('Fire Prevention Challenge'), findsOneWidget);
    expect(find.textContaining('Android touchscreen'), findsOneWidget);
  });
}
