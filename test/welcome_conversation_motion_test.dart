import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'game_flow_test.dart' show loadGameFonts;

final _conversation = find.byKey(const ValueKey('welcome-conversation'));
Finder get _tail =>
    find.descendant(of: _conversation, matching: find.byType(ClipPath));
Finder get _message =>
    find.descendant(of: _conversation, matching: find.byType(LocalizedText));

double _paintOpacity(Finder finder) {
  var result = 1.0;
  finder.evaluate().single.visitAncestorElements((element) {
    final widget = element.widget;
    if (widget is FadeTransition) result *= widget.opacity.value;
    return true;
  });
  return result;
}

void _checkConnection(WidgetTester tester) {
  final body = find
      .ancestor(of: _message, matching: find.byType(Container))
      .first;
  // A separate pointer must share the fade too. When drawn as one shape, its
  // opacity and transform are the body's paint opacity and transform.
  final pointer = _tail.evaluate().isEmpty ? body : _tail;
  expect(
    _paintOpacity(pointer),
    closeTo(_paintOpacity(_message), .000001),
    reason: 'The pointer must never float visibly beside a fading bubble',
  );
  expect(
    tester.getCenter(pointer).dy,
    closeTo(tester.getCenter(body).dy, .001),
    reason: 'The pointer must travel with the bubble, including its slide',
  );
}

Future<void> _capture(WidgetTester tester, String name, Size size) async {
  final path = Platform.environment['KIFC_WELCOME_TAIL_CAPTURE'];
  if (path == null) return;
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('welcome-motion-capture')),
    );
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final directory = Directory(path)..createSync(recursive: true);
    File(
      '${directory.path}/$name.png',
    ).writeAsBytesSync(bytes!.buffer.asUint8List());
    File('${directory.path}/$name.json').writeAsStringSync(
      jsonEncode({
        'source': 'Flutter widget render at a controlled animation frame',
        'viewport': [size.width.toInt(), size.height.toInt()],
        'physicalTVValidated': false,
      }),
    );
  });
}

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });

  Future<void> launch(
    WidgetTester tester,
    Size size, {
    bool reduced = false,
    String page = 'welcome',
    AppLocale locale = AppLocale.indonesian,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(() => AppCopy.locale = AppLocale.indonesian);
    await tester.pumpWidget(
      MaterialApp(
        theme: KifcTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(size: size, disableAnimations: reduced),
          child: RepaintBoundary(
            key: const ValueKey('welcome-motion-capture'),
            child: ExhibitionGame(
              key: ValueKey((page, locale)),
              initialPage: page,
              initialLocale: locale,
              audioBackend: const SilentGameAudioBackend(),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        await precacheImage((element.widget as Image).image, element);
      }
    });
    await tester.pump(const Duration(milliseconds: 600));
  }

  for (final size in const [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    final res = '${size.width.toInt()}x${size.height.toInt()}';
    testWidgets('welcome tail follows bubble for every language at $res', (
      tester,
    ) async {
      await launch(tester, size);
      // Include direct ID -> KO, which has the same untranslated source text.
      for (final locale in [
        AppLocale.english,
        AppLocale.indonesian,
        AppLocale.korean,
      ]) {
        final name = '${locale.name}-$res';
        await tester.tap(find.text(locale.label));
        await tester.pump();
        expect(
          _paintOpacity(_message),
          0,
          reason: 'Every changed language starts the same entrance',
        );
        expect(
          _paintOpacity(
            find.descendant(of: _conversation, matching: find.byType(Image)),
          ),
          0,
          reason: 'The mascot also replays for direct Indonesia–Korea changes',
        );
        _checkConnection(tester);
        await tester.pump(const Duration(milliseconds: 40));
        _checkConnection(tester);
        await _capture(tester, '$name-040ms', size);
        await tester.pump(const Duration(milliseconds: 115));
        expect(_paintOpacity(_message), inExclusiveRange(0, 1));
        _checkConnection(tester);
        await _capture(tester, '$name-155ms', size);
        await tester.pump(const Duration(milliseconds: 345));
        expect(_paintOpacity(_message), 1);
        _checkConnection(tester);
        await _capture(tester, '$name-500ms', size);
        await tester.tap(find.text(locale.label));
        await tester.pump();
        expect(
          _paintOpacity(_message),
          1,
          reason: 'Reselecting the active language does not replay',
        );
        expect(tester.takeException(), isNull);
      }
    });
  }

  testWidgets('welcome tail and bubble respect reduced motion', (tester) async {
    await launch(tester, const Size(411, 731), reduced: true);
    for (final locale in AppLocale.values.reversed) {
      await tester.tap(find.text(locale.label));
      await tester.pump();
      expect(_paintOpacity(_message), 1);
      _checkConnection(tester);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('shared closing bubble keeps its pointer on the mascot side', (
    tester,
  ) async {
    const size = Size(411, 731);
    for (final locale in AppLocale.values) {
      await launch(tester, size, page: 'closing', locale: locale);
      final host = find.byKey(const ValueKey('closing-conversation'));
      final message = find.descendant(
        of: host,
        matching: find.byType(LocalizedText),
      );
      final body = find
          .ancestor(of: message, matching: find.byType(Container))
          .first;
      final box = tester.getSize(body);
      final decoration =
          tester.widget<Container>(body).decoration! as ShapeDecoration;
      final outline = decoration.shape.getOuterPath(Offset.zero & box);
      expect(outline.contains(Offset(box.width - 5, box.height / 2)), isTrue);
      expect(
        outline.contains(Offset(box.width - 2, box.height / 2 + 12)),
        isFalse,
      );
      expect(
        tester
            .getCenter(find.descendant(of: host, matching: find.byType(Image)))
            .dx,
        greaterThan(tester.getCenter(body).dx),
      );
      expect(tester.takeException(), isNull);
      await _capture(tester, 'closing-${locale.name}-411x731-500ms', size);
    }
  });

  testWidgets('welcome bubble has no dividing border at the tail connection', (
    tester,
  ) async {
    await launch(tester, const Size(411, 731));
    final body = find
        .ancestor(of: _message, matching: find.byType(Container))
        .first;
    final padding = tester
        .widget<Container>(body)
        .padding!
        .resolve(TextDirection.ltr);
    // This is the body/arrow junction, immediately before its reading padding.
    final x = tester.getTopLeft(_message).dx - padding.left - .5;
    final y = tester.getCenter(body).dy;
    await tester.runAsync(() async {
      final image = await tester
          .renderObject<RenderRepaintBoundary>(
            find.byKey(const ValueKey('welcome-motion-capture')),
          )
          .toImage();
      final data = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!;
      for (final offset in [-2, 0, 2]) {
        final pixel = ((y + offset).floor() * image.width + x.floor()) * 4;
        final rgb = [
          data.getUint8(pixel),
          data.getUint8(pixel + 1),
          data.getUint8(pixel + 2),
        ];
        for (var channel = 0; channel < 3; channel++) {
          expect(
            rgb[channel],
            closeTo([247, 245, 238][channel], 2),
            reason:
                'The tail junction must be continuous cream fill, without the card border',
          );
        }
      }
      image.dispose();
    });
  });
}
