import 'package:fire_prevention_challenge/features/game/widgets/interaction_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double opacity(WidgetTester tester) => tester
      .widget<FadeTransition>(find.byType(FadeTransition).last)
      .opacity
      .value;

  Widget reveal({
    Object trigger = 'a',
    bool reduced = false,
    Duration? delay,
  }) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Center(
        child: MotionReveal(
          trigger: trigger,
          delay: delay ?? Duration.zero,
          child: const SizedBox(width: 120, height: 80, child: Text('Ready')),
        ),
      ),
    ),
  );

  testWidgets('entrance settles without changing its reserved layout', (
    tester,
  ) async {
    await tester.pumpWidget(reveal(delay: const Duration(milliseconds: 55)));
    final reserved = tester.getSize(find.byType(MotionReveal));
    expect(opacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 30));
    expect(opacity(tester), 0, reason: 'Bubble waits briefly for the mascot');
    await tester.pump(const Duration(milliseconds: 140));
    expect(opacity(tester), inExclusiveRange(0, 1));
    expect(tester.getSize(find.byType(MotionReveal)), reserved);
    await tester.pump(const Duration(seconds: 1));
    expect(opacity(tester), 1);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('only a changed message replays, not timer or audio rebuilds', (
    tester,
  ) async {
    await tester.pumpWidget(reveal());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(reveal());
    expect(opacity(tester), 1);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(reveal(trigger: 'b'));
    expect(opacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 120));
    expect(opacity(tester), inExclusiveRange(0, 1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion finishes both new and running entrances', (
    tester,
  ) async {
    await tester.pumpWidget(reveal(reduced: true));
    expect(opacity(tester), 1);
    await tester.pumpWidget(reveal(trigger: 'b', reduced: false));
    await tester.pump(const Duration(milliseconds: 80));
    expect(opacity(tester), lessThan(1));
    await tester.pumpWidget(reveal(trigger: 'b', reduced: true));
    expect(opacity(tester), 1);
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('new feedback preserves child state and accepts an early tap', (
    tester,
  ) async {
    var trigger = 0;
    Widget tree() => MaterialApp(
      home: Center(
        child: MotionReveal(trigger: trigger, child: const _Counter()),
      ),
    );
    await tester.pumpWidget(tree());
    await tester.pump(const Duration(milliseconds: 70));
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    trigger++;
    await tester.pumpWidget(tree());
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('press cancellation and disabling restore the original scale', (
    tester,
  ) async {
    var enabled = true;
    var activations = 0;
    Widget tree() => MaterialApp(
      home: Center(
        child: PressFeedback(
          enabled: enabled,
          child: TextButton(
            onPressed: enabled ? () => activations++ : null,
            child: const Text('Next'),
          ),
        ),
      ),
    );
    double scale() =>
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;
    await tester.pumpWidget(tree());
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Next')),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(scale(), lessThan(1));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(scale(), 1);
    expect(activations, 0);
    final second = await tester.startGesture(
      tester.getCenter(find.text('Next')),
    );
    await tester.pump();
    enabled = false;
    await tester.pumpWidget(tree());
    expect(scale(), 1);
    await second.up();
    await tester.pumpAndSettle();
    expect(activations, 0);
    enabled = true;
    await tester.pumpWidget(tree());
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(
      activations,
      1,
      reason: 'The wrapper never adds a gameplay callback',
    );
  });
}

class _Counter extends StatefulWidget {
  const _Counter();
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var count = 0;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => count++),
    child: Text('$count'),
  );
}
