import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show launchScreen;
import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);

Future<void> launch(WidgetTester tester, String page) => launchScreen(
  tester,
  size: const Size(411, 731),
  locale: AppLocale.indonesian,
  page: page,
);

void main() {
  setUpAll(loadGameFonts);
  testWidgets('R30-04 closing keeps 30 seconds; other feedback keeps 15', (
    tester,
  ) async {
    await launch(tester, 'closing');
    expect((tester.widget(kind('_ClosingPage')) as dynamic).readingSeconds, 30);
    await tester.pump(const Duration(seconds: 15));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 14));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('R30-04 early tap cancels closing deadline', (tester) async {
    await launch(tester, 'closing');
    await tester.pump(const Duration(seconds: 16));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.tapAt(const Offset(4, 4));
    await tester.pump(const Duration(milliseconds: 400));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 40));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('R30-04 dialog and inactive app pause closing allowance', (
    tester,
  ) async {
    await launch(tester, 'closing');
    await tester.pump(const Duration(seconds: 5));
    await tester.tap(find.byKey(const ValueKey('audio-settings')));
    await tester.pump(const Duration(milliseconds: 300));
    int remaining() =>
        (tester.widget(kind('_ClosingPage')) as dynamic).readingSeconds as int;
    final beforeDialog = remaining();
    await tester.pump(const Duration(seconds: 40));
    expect(remaining(), beforeDialog);
    await tester.tap(find.byKey(const ValueKey('audio-close')));
    await tester.pump(const Duration(milliseconds: 300));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    final beforePause = remaining();
    await tester.pump(const Duration(seconds: 40));
    expect(remaining(), beforePause);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(Duration(seconds: beforePause - 1));
    expect(kind('_ClosingPage'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(kind('_WelcomePage'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
