import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
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
  GameFlow(
    this.tester, {
    required this.english,
    required this.size,
    this.korean = false,
    this.audioBackend,
  });
  final bool korean;
  final GameAudioBackend? audioBackend;
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
        '${dir.path}/${korean
            ? 'ko'
            : english
            ? 'en'
            : 'id'}-${size.width.toInt()}-$stage.png',
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
        '${dir.path}/${korean
            ? 'ko'
            : english
            ? 'en'
            : 'id'}-${size.width.toInt()}-$stage.json',
      ).writeAsString(jsonEncode(targets));
      shot.dispose();
    });
  }

  String text(String id, String en) {
    if (!korean) return english ? en : id;
    // Existing expectations use short fragments; the UI translates full scripts.
    return switch (id) {
      'Air bukan salah satu unsur' => '물은 불의 삼요소',
      'Tepat! Api dapat menyala ketika panas yang cukup' => '맞아요! 충분한 열과 연료',
      'lapisan tanah organik tebal' => '유기물 토양층',
      _ => AppCopy.translate(id),
    };
  }

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
    if (korean) {
      const branding = [
        'KIFC EXHIBITION ROOM / MANGGALA AGNI',
        'Bahasa Indonesia',
        'English',
        'Korea–Indonesia Forest Cooperation Center',
      ];
      for (final label in tester.widgetList<Text>(find.byType(Text))) {
        final value = label.data ?? '';
        if (branding.contains(value)) continue;
        expect(
          value.replaceAll('KIFC', ''),
          isNot(matches(RegExp(r'[A-Za-z]{3,}'))),
          reason: 'Untranslated player text at $stage: $value',
        );
      }
    }
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
      if (type('_PeatCharacteristics').evaluate().isEmpty) {
        expect(
          cropRect.bottom,
          closeTo(size.height, .5),
          reason: 'The feedback crop must end at the screen edge: $stage',
        );
      } // Reading-card companion sits above its persistent Continue button.
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

  /// Read the feedback, then use a separate background tap to move once.
  Future<void> advance(String stage, {int milliseconds = 2200}) async {
    await pump(milliseconds);
    await tester.tapAt(const Offset(4, 4));
    await pump();
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
          child: ExhibitionGame(
            audioBackend: audioBackend ?? const SilentGameAudioBackend(),
            stopwatchFactory: () => clock,
          ),
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
    if (korean) await tap('한국어');
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

  Future<void> toCharacteristics({
    bool wrongCause = false,
    Set<int> wrongCauseIndices = const {},
  }) async {
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
    // Completing the elements shows the full feedback until a separate tap.
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
    await advance('fire-explanation', milliseconds: 1200);
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
    await tester.tap(find.byKey(const ValueKey('reduction-continue')));
    await pump();
    check('karhutla');
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
    await advance('cause-quiz', milliseconds: 1200);
    expect(
      find.text(
        text('Apa penyebabnya?', 'What most likely triggered this risk?'),
      ),
      findsOneWidget,
    );
    for (var index = 0; index < 4; index++) {
      await tap(
        (index == 2) != (wrongCause || wrongCauseIndices.contains(index))
            ? text('Faktor alam', 'Natural factor')
            : text('Aktivitas manusia', 'Human activity'),
      );
      expect(
        find.byWidgetPredicate((w) => w.runtimeType.toString() == '_Feedback'),
        findsOneWidget,
        reason:
            'Every answer shows feedback before a separate continuation tap',
      );
      if (!wrongCause && index == 3) await capture('cause-correct');
      await advance('cause feedback ${index + 1}');
    }
    expect(find.byKey(const ValueKey('peat-card-0')), findsOneWidget);
  }

  Future<void> readCharacteristics() async {
    for (var index = 0; index < 3; index++) {
      await tester.tap(find.byKey(ValueKey('peat-card-$index')));
      await pump(500);
      check('peat card $index');
    }
    await capture('peat-characteristics-read');
  }

  /// Opens the timed challenge after the unscored information cards.
  Future<void> finalChallenge() async {
    // Mascot images can evict final-grid images from the shared image cache.
    // Let real image decoding finish before advancing the fake test clock.
    await tester.runAsync(() async {
      final context = tester.element(find.byType(ExhibitionGame));
      for (final path in const [
        'assets/images/field/haze-sumatra-nasa.jpg',
        'assets/images/field/peat-fire-selangor.jpg',
        'assets/images/field/fire-klaten.jpg',
        'assets/images/forest/kereng-bangkirai.jpg',
        'assets/images/field/peat-subsidence-nara.jpg',
        'assets/images/field/oxygen-canopy.jpg',
      ]) {
        await precacheImage(AssetImage(path), context);
      }
    });
    await tester.tap(find.byKey(const ValueKey('peat-cards-continue')));
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
    expect(find.text('30'), findsOneWidget);
    expect(clock.isRunning, isTrue);
    check('final start');
    await capture('final-challenge');
  }

  Future<void> token(String name) async {
    await tester.tap(find.byKey(ValueKey('impact-$name')), warnIfMissed: false);
    await pump(30);
    check('risk $name');
  }

  Future<void> finish({bool? perfect}) async {
    final grid = find.byKey(const ValueKey('final-selection-grid'));
    final gridRect = tester.getRect(grid);
    clock.advance(const Duration(seconds: 29));
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
      await flow.toCharacteristics();
      await flow.readCharacteristics();
      await flow.finalChallenge();
      expect(find.byKey(const ValueKey('final-raw-score')), findsNothing);
      await flow.token('haze');
      await flow.token('haze');
      expect(
        find.text(flow.text('0 gambar dipilih', '0 images selected')),
        findsOneWidget,
      );
      await flow.token('haze');
      await flow.token('carbonStorage');
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
      flow.clock.advance(const Duration(seconds: 30));
      await tester.tap(find.byKey(const ValueKey('impact-subsidence')));
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
      expect(
        message,
        contains(
          english
              ? 'peat carbon stores decrease'
              : 'cadangan karbon gambut berkurang',
        ),
      );
      expect(
        tester.widget<GameMascot>(find.byType(GameMascot)).pose,
        MascotPose.hintSafety,
      );
      for (final card in tester.widgetList(flow.type('_ImpactTokenCard'))) {
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
      expect(renderedTextByKey(tester, 'total-score'), '7');
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
      await flow.toCharacteristics();
      await flow.readCharacteristics();
      await flow.finalChallenge();
      final ring = find.byKey(const ValueKey('final-countdown-progress'));
      expect(ring, findsOneWidget);
      double value() => tester.widget<CircularProgressIndicator>(ring).value!;
      Color? color() => tester.widget<CircularProgressIndicator>(ring).color;
      expect(value(), 1);
      expect(color(), KifcTheme.answerCorrect);

      flow.clock.advance(const Duration(seconds: 14));
      await flow.pump(120);
      await flow.pump(120);
      expect(find.text('16'), findsOneWidget);
      expect(color(), KifcTheme.answerCorrect);

      flow.clock.advance(const Duration(seconds: 1));
      await flow.pump(120);
      await flow.pump(120);
      expect(value(), closeTo(.5, .001));
      expect(find.text('15'), findsOneWidget);
      expect(color(), KifcTheme.amber);
      if (!reduced) await flow.capture('countdown-half');

      flow.clock.advance(const Duration(seconds: 3));
      await flow.pump(120);
      await flow.pump(120);
      expect(find.text('12'), findsOneWidget);
      expect(color(), KifcTheme.amber);

      flow.clock.advance(const Duration(seconds: 3));
      await flow.pump(120);
      await flow.pump(120);
      expect(find.text('9'), findsOneWidget);
      expect(color(), KifcTheme.answerIncorrect);
      if (!reduced) await flow.capture('countdown-three-seconds');

      flow.clock.advance(const Duration(milliseconds: 1500));
      await flow.pump(120);
      await flow.pump(120);
      expect(value(), closeTo(.25, .001));
      expect(find.text('8'), findsOneWidget);

      flow.clock.advance(const Duration(milliseconds: 1500));
      await flow.pump(120);
      await flow.pump(120);
      expect(value(), closeTo(.2, .001));
      expect(find.text('6'), findsOneWidget);
      if (!reduced) await flow.capture('countdown-two-seconds');

      flow.clock.advance(const Duration(seconds: 6));
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
        startsWith('Belum ada dampak yang dipilih.'),
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
    await flow.toCharacteristics();
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('back navigation reopens playable activities', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final flow = GameFlow(tester, english: false, size: const Size(360, 640));
    await flow.launch();
    await flow.toCharacteristics();
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
      MaterialApp(
        theme: KifcTheme.light(),
        home: const ExhibitionGame(audioBackend: SilentGameAudioBackend()),
      ),
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
        MaterialApp(
          theme: KifcTheme.light(),
          home: const ExhibitionGame(audioBackend: SilentGameAudioBackend()),
        ),
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

      // A separate tap advances after reading; elapsed time alone does not.
      await tester.pump(const Duration(milliseconds: 14200));
      await tester.tapAt(const Offset(4, 4));
      await tester.pump(const Duration(milliseconds: 400));
      expect(
        find.text('Api Dapat Muncul Saat Tiga Unsur Bertemu'),
        findsOneWidget,
      );
    },
  );
  testWidgets('rebuilding keeps the activity ready for new input', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(411, 731);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: KifcTheme.light(),
        home: const ExhibitionGame(audioBackend: SilentGameAudioBackend()),
      ),
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

    // Rebuilding resets all completion state.
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.tap(find.text('Ulangi'));
    await tester.pump();
    expect(find.text('Pilih tiga unsur api.'), findsOneWidget);

    // Elapsed reading time must not change the reset activity.
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
        await flow.toCharacteristics();
        final mixedFinal = !english && size.width == 411;
        await flow.readCharacteristics();
        await flow.finalChallenge();
        await flow.token('haze');
        await flow.token('haze');
        await flow.token('haze');
        await flow.token('ecosystemDamage');
        if (size.width != 360) {
          await flow.token('carbonEmissions');
          await flow.token('subsidence');
          if (mixedFinal) {
            await flow.token('carbonStorage');
            await flow.token('cleanAir');
          }
        }
        expect(find.byKey(const ValueKey('final-raw-score')), findsNothing);
        expect(
          find.text(
            flow.text(
              '${mixedFinal
                  ? 6
                  : size.width == 360
                  ? 2
                  : 4} gambar dipilih',
              '${size.width == 360 ? 2 : 4} images selected',
            ),
          ),
          findsOneWidget,
        );
        await flow.finish(perfect: !mixedFinal && size.width != 360);
        final expected = mixedFinal
            ? '7,5'
            : size.width == 360
            ? (english ? '7.5' : '7,5')
            : '8';
        expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
        expect(renderedTextByKey(tester, 'total-score'), expected);
        await flow.pump(5000);
        expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
        if (size.width == 411 && !english) {
          await tester.tap(find.byKey(const ValueKey('total-score')));
          await flow.pump();
        } else {
          await flow.tap(flow.text('Selesai', 'Closing Message'));
        }
        await flow.capture('closing');
        await flow.pump(5000);
        expect(flow.type('_ClosingPage'), findsOneWidget);
        if (english && size.width != 411) {
          await flow.tap('Play Again');
          expect(find.text('Choose three elements.'), findsOneWidget);
        } else if (english) {
          await flow.tap('Explore the Exhibition');
          expect(find.text('Start Challenge'), findsOneWidget);
        } else {
          await tester.tapAt(const Offset(4, 4));
          await flow.pump();
          expect(find.text('Mulai Tantangan'), findsOneWidget);
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      });
    }
  }
  for (final english in [false, true]) {
    testWidgets(
      'Wrong cause flow reaches unscored information cards $english',
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
        await flow.toCharacteristics(wrongCause: true);
        await flow.readCharacteristics();
        expect(
          find.byKey(const ValueKey('peat-cards-continue')),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
    );
  }
}
