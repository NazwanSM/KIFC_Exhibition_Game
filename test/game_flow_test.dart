import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:fire_prevention_challenge/features/game/widgets/environment_motion.dart';
import 'package:fire_prevention_challenge/features/game/widgets/game_mascot.dart';

String renderedTextByKey(WidgetTester tester, String key) => tester
    .widget<Text>(
      find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(Text),
      ),
    )
    .data!;

class ControlledStopwatch extends Stopwatch {
  Duration _time = Duration.zero;
  bool _running = false;
  @override
  Duration get elapsed => _time;
  @override
  bool get isRunning => _running;
  @override
  void start() => _running = true;
  @override
  void stop() => _running = false;
  @override
  void reset() => _time = Duration.zero;
  void advance(Duration duration) {
    if (_running) _time += duration;
  }
}

Future<void> loadGameFonts() async {
  final archivo = FontLoader('Archivo');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    archivo.addFont(rootBundle.load('assets/fonts/Archivo-$weight.ttf'));
  }
  await archivo.load();
  await (FontLoader(
    'ArchivoBlack',
  )..addFont(rootBundle.load('assets/fonts/ArchivoBlack-Regular.ttf'))).load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
}

class GameFlow {
  GameFlow(this.tester, {required this.english, required this.size});
  final WidgetTester tester;
  final bool english;
  final Size size;
  final clock = ControlledStopwatch();
  Future<void> capture(String stage) async {
    if (Platform.environment['KIFC_CAPTURE'] != '1') return;
    // Large photo sets can evict resized mascot images. Wait for the currently
    // visible providers to decode before recording visual review evidence.
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        final provider = (element.widget as Image).image;
        if (provider is AssetImage && provider.assetName.endsWith('.webp')) {
          continue;
        }
        await precacheImage((element.widget as Image).image, element);
      }
    });
    // A timer may just have replaced the page. Render the completed transition,
    // rather than saving the outgoing frame under the incoming page's name.
    await tester.pump(const Duration(milliseconds: 400));
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('review-capture')),
    );
    await tester.runAsync(() async {
      final shot = await boundary.toImage(pixelRatio: 1);
      final bytes = await shot.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory(
        Platform.environment['KIFC_CAPTURE_DIR'] ?? 'build/review-rev01',
      );
      await dir.create(recursive: true);
      await File(
        '${dir.path}/${english ? 'en' : 'id'}-${size.width.toInt()}-$stage.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      final targets = <Map<String, Object>>[];
      for (final element in touchTargets.evaluate()) {
        final finder = find.byElementPredicate((e) => e == element);
        final rect = tester.getRect(finder);
        final labels = tester
            .widgetList<Text>(
              find.descendant(of: finder, matching: find.byType(Text)),
            )
            .map((text) => text.data ?? '')
            .join(' / ');
        targets.add({
          'label': labels,
          'centerY': rect.center.dy / size.height,
          'width': rect.width,
          'height': rect.height,
        });
      }
      await File(
        '${dir.path}/${english ? 'en' : 'id'}-${size.width.toInt()}-$stage.json',
      ).writeAsString(jsonEncode(targets));
      shot.dispose();
    });
  }

  String text(String id, String en) => english ? en : id;
  Finder type(String name) =>
      find.byWidgetPredicate((widget) => widget.runtimeType.toString() == name);
  Finder get touchTargets => find.byWidgetPredicate(
    (widget) =>
        widget is ButtonStyleButton && widget.onPressed != null ||
        widget is InkWell && widget.onTap != null ||
        widget is Draggable,
  );
  Future<void> pump([int milliseconds = 400]) async {
    await tester.pump();
    await tester.pump(Duration(milliseconds: milliseconds));
    await tester.pump();
  }

  void check(String stage) {
    if (size.height >= 900) {
      for (final element in touchTargets.evaluate()) {
        final rect = tester.getRect(
          find.byElementPredicate((e) => e == element),
        );
        expect(
          rect.center.dy,
          inInclusiveRange(size.height * .15, size.height * .85),
          reason: 'Touch controls must stay in the central area: $stage',
        );
        expect(
          rect.shortestSide,
          greaterThanOrEqualTo(44),
          reason: 'Touch controls need a usable target on the TV: $stage',
        );
      }
    }
    final crop = find.byKey(const ValueKey('feedback-mascot-crop'));
    if (crop.evaluate().isNotEmpty) {
      final cropRect = tester.getRect(crop);
      expect(
        cropRect.bottom,
        closeTo(size.height, .5),
        reason: 'The half-body crop must end at the screen edge: $stage',
      );
      final picture = find.descendant(of: crop, matching: find.byType(Image));
      expect(
        tester.getSize(picture).width,
        lessThanOrEqualTo(cropRect.width + .5),
        reason: 'The crop must preserve both sides of the mascot: $stage',
      );
    }
    expect(
      tester.takeException(),
      isNull,
      reason: '$stage at $size ($english)',
    );
    for (final state in tester.stateList<ScrollableState>(
      find.byType(Scrollable),
    )) {
      expect(
        state.position.maxScrollExtent,
        lessThanOrEqualTo(.5),
        reason: '$stage must fit without scroll at $size',
      );
    }
  }

  /// Waits out the automatic move that follows feedback, then checks the
  /// screen it lands on. Short feedback advances after about 2 seconds.
  Future<void> advance(String stage, {int milliseconds = 2200}) async {
    await pump(milliseconds);
    await tester.pump(const Duration(milliseconds: 400));
    check(stage);
  }

  Future<void> launch() async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: KifcTheme.light(),
        home: RepaintBoundary(
          key: const ValueKey('review-capture'),
          child: ExhibitionGame(stopwatchFactory: () => clock),
        ),
      ),
    );
    await tester.runAsync(() async {
      final context = tester.element(find.byType(ExhibitionGame));
      for (final file in Directory(
        'assets/images',
      ).listSync(recursive: true).whereType<File>()) {
        final path = file.path.replaceAll(String.fromCharCode(92), '/');
        if (RegExp(r'\.(png|jpe?g)$').hasMatch(path)) {
          await precacheImage(AssetImage(path), context);
        }
      }
      if (Platform.environment['KIFC_CAPTURE'] == '1') {
        for (final pose in [
          'welcome',
          'presenting',
          'hint_safety',
          'success',
        ]) {
          await precacheImage(
            ResizeImage(
              AssetImage('assets/images/mascot/manggala_agni_$pose.png'),
              width: 320,
            ),
            context,
          );
        }
      }
    });
    await pump();
    if (english) await tap('English');
    check('welcome');
    await capture('welcome');
  }

  Future<void> tap(String label) async {
    if (size.height >= 900) {
      final rect = tester.getRect(find.text(label).first);
      expect(
        rect.center.dy,
        inInclusiveRange(size.height * .15, size.height * .85),
        reason: 'Navigation must stay away from panel edges: $label',
      );
    }
    await tester.tap(find.text(label).first);
    await pump();
    check(label);
  }

  Future<void> toDecision({bool wrongCause = false}) async {
    await tap(text('Mulai Tantangan', 'Start Challenge'));
    await capture('assembly');
    final trianglePanelSize = tester.getSize(type('_FireScene'));
    final water = type('_DraggablePiece').at(1);
    final heatSlot = type('_DropSlot').first;
    await tester.drag(
      water,
      tester.getCenter(heatSlot) - tester.getCenter(water),
    );
    await pump();
    expect(
      find.textContaining(
        text('Air bukan salah satu unsur', 'Water is not one of the elements'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('fire')), findsNothing);
    final scrims = find.byWidgetPredicate(
      (w) => w is SizedBox && w.height == 42 && w.child is DecoratedBox,
    );
    for (final element in scrims.evaluate()) {
      expect(
        (element.findRenderObject()! as RenderBox).size.width,
        greaterThan(50),
      );
    }
    for (final pair in [(0, 0), (2, 1), (4, 2)]) {
      final card = type('_DraggablePiece').at(pair.$1);
      final slot = type('_DropSlot').at(pair.$2);
      await tester.drag(card, tester.getCenter(slot) - tester.getCenter(card));
      await pump();
      check('triangle drop ${pair.$1}');
    }
    // Completing the elements shows the full client feedback and moves on by itself;
    // there is no intermediate button to press.
    expect(
      find.textContaining(
        text(
          'Tepat! Api dapat menyala ketika panas yang cukup',
          'Correct! Fire can start when sufficient heat',
        ),
      ),
      findsOneWidget,
    );
    await capture('triangle-complete');
    await advance('fire-explanation', milliseconds: 14200);
    expect(
      find.text(
        text(
          'Api Dapat Muncul Saat Tiga Unsur Bertemu',
          'Fire Can Start When Three Elements Meet',
        ),
      ),
      findsOneWidget,
    );
    await capture('fire-explanation');
    await tap(text('Coba Kurangi Satu Unsur', 'Try Reducing an Element'));
    expect(
      tester.getSize(type('_FireScene')),
      trianglePanelSize,
      reason: 'Prevention must use the same panel as the build activity',
    );
    for (final demo in [
      (
        text('Panas', 'Heat'),
        text('Suhu turun, api mereda.', 'Less heat, a weaker flame.'),
      ),
      (
        text('Bahan bakar', 'Fuel'),
        text(
          'Beri jarak agar api sulit menjalar.',
          'Gaps interrupt the spread.',
        ),
      ),
      (
        text('Oksigen', 'Oxygen'),
        text(
          'Api perlu oksigen dari udara.',
          'Fire needs oxygen from the air.',
        ),
      ),
    ]) {
      final tab = find.descendant(
        of: type('_ChoiceButton'),
        matching: find.text(demo.$1),
      );
      await tester.tap(tab);
      await pump();
      check('triangle demo ${demo.$1}');
      expect(find.text(demo.$2), findsOneWidget);
      await capture(
        'demo-${demo.$1 == text('Panas', 'Heat')
            ? 'heat'
            : demo.$1 == text('Bahan bakar', 'Fuel')
            ? 'fuel'
            : 'oxygen'}',
      );
      expect(
        type('_AnswerMark'),
        findsNothing,
        reason: 'Exploration has no correct or incorrect answers',
      );
      expect(
        tester.getSize(type('_FireScene')),
        trianglePanelSize,
        reason: 'Reducing an element changes the flame, not the panel size',
      );
    }
    // The demo is unscored and only moves on once all three elements are tried.
    expect(
      find.text(text('3/3 unsur sudah dicoba', '3/3 elements tried')),
      findsOneWidget,
    );
    await capture('demo-complete');
    await advance('karhutla');
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await capture('karhutla-definition');
    await tap(text('Lanjut', 'Continue'));
    expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
    await tap(text('Kembali', 'Back'));
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await tap(text('Lanjut', 'Continue'));
    await capture('karhutla-cause');
    await tap(text('Lanjut', 'Continue'));
    expect(find.byKey(const ValueKey('karhutla-prevention')), findsOneWidget);
    await capture('karhutla-prevention');
    await tap(text('Mulai Kuis', 'Start Quiz'));
    // One wrong pick earns a mascot hint and a single extra attempt.
    await tap(text('A. Hutan mangrove', 'A. Mangrove forest'));
    await tap(text('A. Hutan mangrove', 'A. Mangrove forest'));
    expect(
      find.textContaining(
        text('lapisan tanah organik tebal', 'thick organic soil layer'),
      ),
      findsOneWidget,
    );
    await capture('risk-hint');
    if (wrongCause) {
      await tap(
        text('C. Hutan pada tanah mineral', 'C. Forest on mineral soil'),
      );
      expect(
        tester
            .widgetList(type('_RiskCard'))
            .every((w) => (w as dynamic).onTap == null),
        isTrue,
      );
      await capture('risk-reveal');
    } else {
      await tap(text('B. Hutan rawa gambut', 'B. Peat swamp forest'));
      await capture('risk-correct');
    }
    await advance('cause-quiz', milliseconds: wrongCause ? 12200 : 18200);
    expect(
      find.text(
        text('Apa penyebabnya?', 'What most likely triggered this risk?'),
      ),
      findsOneWidget,
    );
    for (var index = 0; index < 4; index++) {
      await tap(
        (index == 2) != wrongCause
            ? text('Faktor alam', 'Natural factor')
            : text('Aktivitas manusia', 'Human activity'),
      );
      expect(
        find.byWidgetPredicate((w) => w.runtimeType.toString() == '_Feedback'),
        findsOneWidget,
        reason: 'Every answer shows feedback before the automatic move',
      );
      if (!wrongCause && index == 3) await capture('cause-correct');
      await advance('cause feedback ${index + 1}');
    }
    expect(find.byKey(const ValueKey('decision-separateFuel')), findsOneWidget);
    await pump(4000);
    final waiting = tester.widget<FireSpreadVisual>(
      find.byType(FireSpreadVisual),
    );
    expect(
      waiting.progress,
      lessThan(.43),
      reason: 'Fire must wait on the near side while the visitor decides',
    );
  }

  Future<void> choose(String name) async {
    await tester.tap(
      find
          .descendant(
            of: find.byKey(ValueKey('decision-$name')),
            matching: find.byType(Text),
          )
          .first,
    );
    await pump();
    check('decision $name');
    await pump(1500);
    final spread = tester.widget<FireSpreadVisual>(
      find.byType(FireSpreadVisual),
    );
    expect(spread.stopped, name == 'separateFuel');
    expect(
      spread.progress,
      name == 'separateFuel' ? lessThanOrEqualTo(.43) : 1,
      reason: 'A fuel break prevents further spread; unsafe choices do not',
    );
  }

  /// Prepares the final challenge. The safe answer already scheduled the move,
  /// so this only has to let the pending timer and the pre-cache finish.
  Future<void> finalChallenge() async {
    // Mascot images can evict final-grid images from the shared image cache.
    // Let real image decoding finish before advancing the fake test clock.
    await tester.runAsync(() async {
      final context = tester.element(find.byType(ExhibitionGame));
      for (final path in const [
        'assets/images/field/dry-leaf-litter.jpg',
        'assets/images/field/cigarette-leaves.jpg',
        'assets/images/field/fire-klaten.jpg',
        'assets/images/forest/kereng-bangkirai.jpg',
        'assets/images/field/dry-wood-client.jpg',
        'assets/images/field/rain-splash.jpg',
      ]) {
        await precacheImage(AssetImage(path), context);
      }
    });
    await pump(5000);
    // The transition awaits real image decoding, independent of fake timers.
    // New chapter assets must not make this depend on the global cache order.
    for (var attempt = 0; attempt < 50; attempt++) {
      if (find
          .byKey(const ValueKey('final-selection-grid'))
          .evaluate()
          .isNotEmpty) {
        break;
      }
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await pump(20);
    }
    await pump(800);
    expect(find.text('10'), findsOneWidget);
    expect(clock.isRunning, isTrue);
    check('final start');
    await capture('final-challenge');
  }

  Future<void> token(String name) async {
    await tester.tap(find.byKey(ValueKey('risk-$name')), warnIfMissed: false);
    await pump(30);
    check('risk $name');
  }

  Future<void> finish({bool? perfect}) async {
    final grid = find.byKey(const ValueKey('final-selection-grid'));
    final gridRect = tester.getRect(grid);
    clock.advance(const Duration(seconds: 9));
    await pump(100);
    expect(find.text('1'), findsOneWidget);
    clock.advance(const Duration(seconds: 1));
    await pump(100);
    expect(find.text('0'), findsOneWidget);
    await pump(450);
    check('final review');
    expect(find.byKey(const ValueKey('final-review-continue')), findsOneWidget);
    expect(tester.getRect(grid), gridRect);
    if (perfect != null) {
      expect(
        tester.widget<GameMascot>(find.byType(GameMascot)).pose,
        perfect ? MascotPose.success : MascotPose.hintSafety,
      );
    }
    await capture('final-review');
    await tester.tap(find.byKey(const ValueKey('final-review-continue')));
    await pump();
    check('score');
    await capture('score');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadGameFonts);
  for (final english in [false, true]) {
    testWidgets('final choices stay neutral until time expires ($english)', (
      tester,
    ) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final flow = GameFlow(
        tester,
        english: english,
        size: const Size(360, 640),
      );
      await flow.launch();
      await flow.toDecision();
      await flow.choose('separateFuel');
      await flow.finalChallenge();
      expect(find.byKey(const ValueKey('final-raw-score')), findsNothing);
      await flow.token('dryVegetation');
      await flow.token('dryVegetation');
      expect(
        find.text(flow.text('0 gambar dipilih', '0 images selected')),
        findsOneWidget,
      );
      await flow.token('dryVegetation');
      await flow.token('rain');
      expect(
        find.text(flow.text('2 gambar dipilih', '2 images selected')),
        findsOneWidget,
      );
      final grid = find.byKey(const ValueKey('final-selection-grid'));
      final gridRect = tester.getRect(grid);
      expect(
        find.descendant(of: grid, matching: find.byIcon(Icons.check_rounded)),
        findsNothing,
      );
      expect(
        find.descendant(of: grid, matching: find.byIcon(Icons.close_rounded)),
        findsNothing,
      );
      await flow.capture('final-neutral-selection');

      // The deadline itself locks selection, even before the next timer tick.
      flow.clock.advance(const Duration(seconds: 10));
      await tester.tap(find.byKey(const ValueKey('risk-dryWood')));
      await flow.pump(100);
      await flow.pump(450);
      await flow.pump(400);
      flow.check('final review mixed');
      expect(
        tester.getRect(grid),
        gridRect,
        reason: 'Review reveals results on the same board without moving it',
      );
      expect(
        find.text(
          flow.text(
            '1 benar · 1 salah · 3 terlewat',
            '1 correct · 1 incorrect · 3 missed',
          ),
        ),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('final-correct-count')), findsNothing);
      final message = renderedTextByKey(tester, 'final-review-message');
      expect(message, contains(english ? 'dry vegetation' : 'Tanaman kering'));
      expect(message, contains(english ? 'Rain' : 'Hujan'));
      expect(
        tester.widget<GameMascot>(find.byType(GameMascot)).pose,
        MascotPose.hintSafety,
      );
      for (final card in tester.widgetList(flow.type('_RiskTokenCard'))) {
        expect((card as dynamic).onTap, isNull);
      }
      await flow.capture('final-review-mixed');
      await flow.pump(6000);
      expect(
        find.byKey(const ValueKey('final-review-continue')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('final-review-continue')));
      await flow.pump();
      expect(renderedTextByKey(tester, 'total-score'), '8');
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  for (final reduced in [false, true]) {
    testWidgets('countdown ring follows remaining time (reduced=$reduced)', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: reduced);
      addTearDown(() {
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final flow = GameFlow(tester, english: false, size: const Size(411, 731));
      await flow.launch();
      await flow.toDecision();
      await flow.choose('separateFuel');
      await flow.finalChallenge();
      final ring = find.byKey(const ValueKey('final-countdown-progress'));
      expect(ring, findsOneWidget);
      double value() => tester.widget<CircularProgressIndicator>(ring).value!;
      Color? color() => tester.widget<CircularProgressIndicator>(ring).color;
      expect(value(), 1);
      expect(color(), KifcTheme.answerCorrect);

      flow.clock.advance(const Duration(seconds: 4));
      await flow.pump(120);
      await flow.pump(120);
      expect(find.text('6'), findsOneWidget);
      expect(color(), KifcTheme.answerCorrect);

      flow.clock.advance(const Duration(seconds: 1));
      await flow.pump(120);
      await flow.pump(120);
      expect(value(), closeTo(.5, .001));
      expect(find.text('5'), findsOneWidget);
      expect(color(), KifcTheme.amber);
      if (!reduced) await flow.capture('countdown-half');

      flow.clock.advance(const Duration(seconds: 1));
      await flow.pump(120);
      await flow.pump(120);
      expect(find.text('4'), findsOneWidget);
      expect(color(), KifcTheme.amber);

      flow.clock.advance(const Duration(seconds: 1));
      await flow.pump(120);
      await flow.pump(120);
      expect(find.text('3'), findsOneWidget);
      expect(color(), KifcTheme.answerIncorrect);
      if (!reduced) await flow.capture('countdown-three-seconds');

      flow.clock.advance(const Duration(milliseconds: 500));
      await flow.pump(120);
      await flow.pump(120);
      expect(value(), closeTo(.25, .001));
      expect(find.text('3'), findsOneWidget);

      flow.clock.advance(const Duration(milliseconds: 500));
      await flow.pump(120);
      await flow.pump(120);
      expect(value(), closeTo(.2, .001));
      expect(find.text('2'), findsOneWidget);
      if (!reduced) await flow.capture('countdown-two-seconds');

      flow.clock.advance(const Duration(seconds: 2));
      await flow.pump(100);
      expect(value(), 0);
      expect(find.text('0'), findsOneWidget);
      expect(color(), KifcTheme.answerIncorrect);
      await flow.pump(450);
      expect(
        find.byKey(const ValueKey('final-review-continue')),
        findsOneWidget,
      );
      expect(find.text('0 benar · 0 salah · 4 terlewat'), findsOneWidget);
      expect(
        renderedTextByKey(tester, 'final-review-message'),
        startsWith('Belum ada gambar yang dipilih.'),
      );
      await tester.tap(find.byKey(const ValueKey('final-review-continue')));
      await flow.pump();
      expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('reduced motion preserves time to read feedback', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(() {
      tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final flow = GameFlow(tester, english: false, size: const Size(360, 640));
    await flow.launch();
    await flow.toDecision();
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('back navigation reopens playable activities', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final flow = GameFlow(tester, english: false, size: const Size(360, 640));
    await flow.launch();
    await flow.toDecision();
    await flow.tap('Kembali');
    final cause = tester.widgetList(flow.type('_ChoiceButton'));
    expect(cause.every((w) => (w as dynamic).onTap != null), isTrue);
    await flow.tap('Kembali');
    final risks = tester.widgetList(flow.type('_RiskCard'));
    expect(risks.every((w) => (w as dynamic).onTap != null), isTrue);
    await flow.tap('Kembali');
    await flow.tap('Kembali');
    await flow.tap('Kembali');
    await flow.tap('Kembali');
    expect(find.text('Kurangi satu unsur.'), findsOneWidget);
    expect(
      tester
          .widgetList(flow.type('_ChoiceButton'))
          .every((w) => (w as dynamic).onTap != null),
      isTrue,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('starts chapter one by assembling the three fire elements', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(411, 731);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      MaterialApp(theme: KifcTheme.light(), home: const ExhibitionGame()),
    );
    await tester.tap(find.text('Mulai Tantangan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Pilih tiga unsur api.'), findsOneWidget);
  });
  testWidgets(
    'explains the fire triangle after the three elements are placed',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(411, 731);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
        MaterialApp(theme: KifcTheme.light(), home: const ExhibitionGame()),
      );
      await tester.tap(find.text('Mulai Tantangan'));
      await tester.pump(const Duration(milliseconds: 400));
      Finder type(String name) => find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == name,
      );
      for (final pair in [(0, 0), (2, 1), (4, 2)]) {
        final card = type('_DraggablePiece').at(pair.$1);
        final slot = type('_DropSlot').at(pair.$2);
        await tester.drag(
          card,
          tester.getCenter(slot) - tester.getCenter(card),
        );
        await tester.pump(const Duration(milliseconds: 400));
      }

      // No button press: feedback is shown, then the flow continues on its own.
      await tester.pump(const Duration(milliseconds: 14200));
      await tester.pump();
      expect(
        find.text('Api Dapat Muncul Saat Tiga Unsur Bertemu'),
        findsOneWidget,
      );
    },
  );
  testWidgets('rebuilding cancels the pending automatic move', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(411, 731);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      MaterialApp(theme: KifcTheme.light(), home: const ExhibitionGame()),
    );
    await tester.tap(find.text('Mulai Tantangan'));
    await tester.pump(const Duration(milliseconds: 400));
    Finder type(String name) => find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == name,
    );
    for (final pair in [(0, 0), (2, 1), (4, 2)]) {
      final card = type('_DraggablePiece').at(pair.$1);
      final slot = type('_DropSlot').at(pair.$2);
      await tester.drag(card, tester.getCenter(slot) - tester.getCenter(card));
      await tester.pump(const Duration(milliseconds: 400));
    }

    // The automatic move is pending. Rebuilding must call it off.
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.tap(find.text('Ulangi'));
    await tester.pump();
    expect(find.text('Pilih tiga unsur api.'), findsOneWidget);

    // Well past the automatic delay, the screen must not have changed.
    await tester.pump(const Duration(milliseconds: 4000));
    await tester.pump();
    expect(find.text('Pilih tiga unsur api.'), findsOneWidget);
    expect(find.text('Api Dapat Muncul Saat Tiga Unsur Bertemu'), findsNothing);
  });
  for (final english in [false, true]) {
    for (final size in [
      const Size(411, 731),
      const Size(360, 640),
      const Size(720, 1280),
      const Size(1080, 1920),
    ]) {
      testWidgets('Bilingual complete flow and scoring $english $size', (
        tester,
      ) async {
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final flow = GameFlow(tester, english: english, size: size);
        await flow.launch();
        await flow.toDecision();
        final unsafe = !english && size.width == 411;
        if (unsafe) {
          // A first wrong attempt still allows one more try.
          await flow.choose('approach');
          expect(
            (tester.widget(find.byKey(const ValueKey('decision-addFuel')))
                    as dynamic)
                .onTap,
            isNotNull,
            reason: 'A first wrong answer keeps one extra attempt open',
          );
          expect(
            (tester.widget(find.byKey(const ValueKey('decision-addFuel')))
                    as dynamic)
                .error,
            isFalse,
          );
          // A second wrong attempt reveals the safe action and locks input.
          await flow.choose('addFuel');
          expect(
            find.textContaining(flow.text('Tindakan aman', 'The safe action')),
            findsOneWidget,
          );
          expect(
            (tester.widget(find.byKey(const ValueKey('decision-separateFuel')))
                    as dynamic)
                .selected,
            isTrue,
          );
          expect(
            (tester.widget(find.byKey(const ValueKey('decision-addFuel')))
                    as dynamic)
                .onTap,
            isNull,
          );
          await flow.capture('stop-reveal');
        } else {
          if (size.width == 360) {
            await flow.choose('approach');
          }
          await flow.choose('separateFuel');
          expect(
            (tester.widget(find.byKey(const ValueKey('decision-addFuel')))
                    as dynamic)
                .onTap,
            isNull,
            reason: 'The correct answer locks the remaining options',
          );
        }
        await flow.finalChallenge();
        await flow.token('dryVegetation');
        await flow.token('dryVegetation');
        await flow.token('dryVegetation');
        await flow.token('cigarette');
        if (size.width != 360) {
          await flow.token('unmanagedFire');
          await flow.token('dryWood');
          if (unsafe) {
            await flow.token('rain');
            await flow.token('healthyVegetation');
          }
        }
        expect(find.byKey(const ValueKey('final-raw-score')), findsNothing);
        expect(
          find.text(
            flow.text(
              '${unsafe
                  ? 6
                  : size.width == 360
                  ? 2
                  : 4} gambar dipilih',
              '${size.width == 360 ? 2 : 4} images selected',
            ),
          ),
          findsOneWidget,
        );
        await flow.finish(perfect: !unsafe && size.width != 360);
        final expected = unsafe
            ? '7,5'
            : size.width == 360
            ? (english ? '8.5' : '8,5')
            : '9';
        expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
        expect(renderedTextByKey(tester, 'total-score'), expected);
        if (size.width == 411 && !english) {
          await flow.pump(14000);
          expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('total-score')));
          await flow.pump(100);
          await flow.pump(2000);
          expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
          await flow.pump(13000);
          expect(
            find.text(flow.text('Mulai Tantangan', 'Start Challenge')),
            findsOneWidget,
          );
        } else if (size.width == 411) {
          await flow.tap('Closing Message');
          await flow.capture('closing');
          await flow.tap('Explore the Exhibition');
          expect(find.text('Start Challenge'), findsOneWidget);
        } else {
          await flow.tap(flow.text('Selesai', 'Closing Message'));
          await flow.capture('closing');
          await flow.pump(14000);
          expect(
            find.text(flow.text('Jelajahi Pameran', 'Explore the Exhibition')),
            findsOneWidget,
          );
          if (english) {
            await tester.tap(
              find.text('Korea–Indonesia Forest Cooperation Center'),
            );
            await flow.pump(2000);
            expect(find.text('Explore the Exhibition'), findsOneWidget);
            // Playing again starts a fresh session at Chapter 1, not the old
            // landscape page.
            await flow.tap('Play Again');
            expect(find.text('Choose three elements.'), findsOneWidget);
            expect(find.text('Start Challenge'), findsNothing);
          } else {
            await flow.pump(1100);
            expect(find.text('Mulai Tantangan'), findsOneWidget);
          }
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      });
    }
  }
  for (final english in [false, true]) {
    testWidgets(
      'Wrong cause and unsafe fuel feedback fit the compact screen $english',
      (tester) async {
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final flow = GameFlow(
          tester,
          english: english,
          size: const Size(360, 640),
        );
        await flow.launch();
        await flow.toDecision(wrongCause: true);
        // First wrong attempt: the mascot hint must fit.
        await flow.choose('addFuel');
        // Second wrong attempt: the revealed answer must fit as well.
        await flow.choose('approach');
        expect(
          find.textContaining(
            flow.text('Tindakan aman adalah', 'The safe action is'),
          ),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
    );
  }
}
