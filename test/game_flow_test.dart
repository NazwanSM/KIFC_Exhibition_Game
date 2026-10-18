import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:fire_prevention_challenge/features/game/widgets/environment_motion.dart';

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
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('review-capture')),
    );
    await tester.runAsync(() async {
      final shot = await boundary.toImage(pixelRatio: 1);
      final bytes = await shot.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('build/review-rev06-07');
      await dir.create(recursive: true);
      await File('${dir.path}/${english ? 'en' : 'id'}-${size.width.toInt()}-$stage.png')
          .writeAsBytes(bytes!.buffer.asUint8List());
      shot.dispose();
    });
  }
  String text(String id, String en) => english ? en : id;
  Finder type(String name) =>
      find.byWidgetPredicate((widget) => widget.runtimeType.toString() == name);
  Future<void> pump([int milliseconds = 400]) async {
    await tester.pump();
    await tester.pump(Duration(milliseconds: milliseconds));
    await tester.pump();
  }

  void check(String stage) {
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
        for (final pose in ['welcome', 'presenting', 'hint_safety', 'success']) {
          await precacheImage(
            ResizeImage(AssetImage('assets/images/mascot/manggala_agni_$pose.png'), width: 320),
            context,
          );
        }
      }
    });
    await pump();
    if (english) await tap('English');
    check('welcome');
  }

  Future<void> tap(String label) async {
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
    await tester.drag(water, tester.getCenter(heatSlot) - tester.getCenter(water));
    await pump();
    expect(find.textContaining(text('Foto ini belum cocok', 'Try another element')), findsOneWidget);
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
    if (!english && size.width == 411) {
      await tap('Ulangi');
      expect(find.text('Susun tiga unsur api.'), findsOneWidget);
      expect(find.text('Mulai Tantangan'), findsNothing);
      for (final pair in [(0, 0), (2, 1), (4, 2)]) {
        final card = type('_DraggablePiece').at(pair.$1);
        final slot = type('_DropSlot').at(pair.$2);
        await tester.drag(
          card,
          tester.getCenter(slot) - tester.getCenter(card),
        );
        await pump();
        check('repeat triangle');
      }
    }
    await tap(text('Kenali Segitiga Api', 'Learn About the Fire Triangle'));
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
      await capture('demo-${demo.$1 == text('Panas', 'Heat') ? 'heat' : demo.$1 == text('Bahan bakar', 'Fuel') ? 'fuel' : 'oxygen'}');
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
    await tap(text('Pahami Karhutla', 'Understand Forest Fires'));
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await capture('karhutla-definition');
    expect(type('_Hotspot'), findsNothing);
    await tap(text('Lanjut', 'Continue'));
    expect(find.byKey(const ValueKey('karhutla-impact')), findsOneWidget);
    await tap(text('Kembali', 'Back'));
    expect(find.byKey(const ValueKey('karhutla-definition')), findsOneWidget);
    await tap(text('Lanjut', 'Continue'));
    await capture('karhutla-impact');
    await tap(text('Lanjut', 'Continue'));
    expect(find.byKey(const ValueKey('karhutla-prevention')), findsOneWidget);
    await capture('karhutla-prevention');
    await tap(text('Lihat Risikonya', 'See the Risk'));
    await tap(text('Hutan basah', 'Wet forest'));
    await tap(
      text(
        'Tanaman kering di dekat sumber api',
        'Dry vegetation with an ignition source',
      ),
    );
    await tap(text('Kenali Penyebabnya', 'Explore the Causes'));
    for (var index = 0; index < 4; index++) {
      await tap(
        index == 2 || (wrongCause && index == 0)
            ? text('Faktor alam', 'Natural factor')
            : text('Aktivitas manusia', 'Human activity'),
      );
      await tap(
        index == 3
            ? text('Lihat Hasil Babak', 'See Your Result')
            : text('Situasi Berikutnya', 'Next Clue'),
      );
    }
    await tap(text('Coba Batasi Rambatannya', 'Move to Prevention'));
    await pump(4200);
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
    final selected = tester
        .widgetList(type('_ChoiceButton'))
        .where((w) => (w as dynamic).selected as bool);
    expect(selected, hasLength(1));
    expect(
      (tester.widget(find.byKey(ValueKey('decision-$name'))) as dynamic).error,
      name != 'separateFuel',
    );
  }

  Future<void> finalChallenge() async {
    // Mascot images can evict final-grid images from the shared image cache.
    // Let real image decoding finish before advancing the fake test clock.
    await tester.runAsync(() async {
      final context = tester.element(find.byType(ExhibitionGame));
      for (final file in Directory('assets/images/field').listSync().whereType<File>()) {
        final path = file.path.replaceAll(String.fromCharCode(92), '/');
        await precacheImage(AssetImage(path), context);
      }
    });
    await tester.tap(find.byKey(const ValueKey('open-final')));
    await pump();
    await pump();
    expect(find.text('10'), findsOneWidget);
    expect(clock.isRunning, isTrue);
    check('final start');
  }

  Future<void> token(String name) async {
    await tester.tap(find.byKey(ValueKey('risk-$name')), warnIfMissed: false);
    await pump(30);
    check('risk $name');
  }

  Future<void> finish() async {
    clock.advance(const Duration(seconds: 9));
    await pump(100);
    expect(find.text('1'), findsOneWidget);
    clock.advance(const Duration(seconds: 1));
    await pump(100);
    expect(find.text('0'), findsOneWidget);
    await pump(450);
    check('score');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadGameFonts);
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
        home: const ExhibitionGame(),
      ),
    );
    await tester.tap(find.text('Mulai Tantangan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Susun tiga unsur api.'), findsOneWidget);
  });
  testWidgets('explains the fire triangle after the three elements are placed', (
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

    await tester.tap(find.text('Kenali Segitiga Api'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Tiga unsur, satu api.'), findsOneWidget);
  });
  for (final english in [false, true]) {
    for (final size in [const Size(411, 731), const Size(360, 640)]) {
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
        await flow.choose(unsafe ? 'approach' : 'separateFuel');
        // The first choice stays locked; a different unsafe option never becomes selected with it.
        expect(
          (tester.widget(find.byKey(const ValueKey('decision-addFuel')))
                  as dynamic)
              .onTap,
          isNull,
        );
        expect(
          (tester.widget(find.byKey(const ValueKey('decision-addFuel')))
                  as dynamic)
              .selected,
          isFalse,
        );
        await flow.finalChallenge();
        await flow.token('dryVegetation');
        await flow.token('dryVegetation');
        await flow.token('cigarette');
        if (size.width == 411) {
          await flow.token('unmanagedFire');
          await flow.token('dryWood');
          if (unsafe) {
            await flow.token('rain');
            await flow.token('healthyVegetation');
          }
        }
        final raw = unsafe || size.width == 360 ? 2 : 4;
        expect(
          find.text(
            flow.text(
              '$raw/4 poin · ${unsafe ? 2 : 0} pilihan salah',
              '$raw/4 points · 0 incorrect',
            ),
          ),
          findsOneWidget,
        );
        await flow.finish();
        final expected = unsafe
            ? '7,5'
            : size.width == 360
            ? (english ? '8.5' : '8,5')
            : '9';
        expect(find.byKey(const ValueKey('total-score')), findsOneWidget);
        expect(
          (tester.widget(find.byKey(const ValueKey('total-score'))) as Text)
              .data,
          expected,
        );
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
          await flow.tap('Explore the Exhibition');
          expect(find.text('Start Challenge'), findsOneWidget);
        } else {
          await flow.tap(flow.text('Selesai', 'Closing Message'));
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
            await flow.tap('Play Again');
            expect(find.text('What is a forest fire?'), findsOneWidget);
            expect(find.text('0/3 clues explored'), findsOneWidget);
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
        await flow.choose('addFuel');
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
    );
  }
}
