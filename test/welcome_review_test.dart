import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> launchWelcome(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: KifcTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const RepaintBoundary(
        key: ValueKey('welcome-review'),
        child: ExhibitionGame(audioBackend: SilentGameAudioBackend()),
      ),
    ),
  );
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> captureWelcome(
  WidgetTester tester,
  String name,
  Map<String, Object> metrics,
) async {
  if (Platform.environment['KIFC_CAPTURE'] != '1') return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('welcome-review')),
  );
  await tester.runAsync(() async {
    final dir = Directory(
      Platform.environment['KIFC_CAPTURE_DIR'] ?? 'build/review-kifc-01',
    );
    await dir.create(recursive: true);
    final shot = await boundary.toImage(pixelRatio: 1);
    final bytes = await shot.toByteData(format: ui.ImageByteFormat.png);
    await File(
      '${dir.path}/$name.png',
    ).writeAsBytes(bytes!.buffer.asUint8List());
    await File(
      '${dir.path}/$name.json',
    ).writeAsString(const JsonEncoder.withIndent('  ').convert(metrics));
    shot.dispose();
  });
}

void main() {
  setUpAll(() async {
    for (final family in {
      'Archivo': [
        'Archivo-Regular.ttf',
        'Archivo-Medium.ttf',
        'Archivo-SemiBold.ttf',
        'Archivo-Bold.ttf',
        'Archivo-ExtraBold.ttf',
      ],
      'ArchivoBlack': ['ArchivoBlack-Regular.ttf'],
      'NotoSansKR': ['NotoSansKR-Variable.ttf'],
    }.entries) {
      final loader = FontLoader(family.key);
      for (final asset in family.value) {
        loader.addFont(rootBundle.load('assets/fonts/$asset'));
      }
      await loader.load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });

  for (final size in const [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final language in AppLocale.values) {
      final code = ['id', 'en', 'ko'][language.index];
      final name = '$code-${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('welcome fits and starts without scrolling $name', (
        tester,
      ) async {
        await launchWelcome(tester, size);
        await tester.tap(find.text(language.label));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);

        // All language choices must remain on one line, including the longest.
        expect(
          tester.getSize(find.text('Bahasa Indonesia')).height,
          closeTo(tester.getSize(find.text('English')).height, 1),
        );
        final title = find.text(
          language == AppLocale.korean
              ? '산불 예방\n챌린지'
              : 'Fire Prevention\nChallenge',
        );
        final startLabel = switch (language) {
          AppLocale.indonesian => 'Mulai Tantangan',
          AppLocale.english => 'Start Challenge',
          AppLocale.korean => '도전 시작',
        };
        final start = find.ancestor(
          of: find.text(startLabel),
          matching: find.byWidgetPredicate(
            (widget) => widget is ElevatedButton,
          ),
        );
        final titleRect = tester.getRect(title);
        final conversation = tester.getRect(
          find.byKey(const ValueKey('welcome-conversation')),
        );
        final button = tester.getRect(start);
        expect(titleRect.bottom, lessThan(conversation.top));
        expect(conversation.bottom, lessThan(button.top));
        expect(button.width, greaterThan(size.width * .65));
        expect(button.height, greaterThanOrEqualTo(64));
        expect(button.bottom, lessThan(size.height * .92));
        expect(button.center.dy, greaterThan(size.height * .5));
        expect(start.hitTestable(), findsOneWidget);
        await captureWelcome(tester, name, {
          'language': code,
          'width': size.width,
          'height': size.height,
          'buttonCenterYFraction': button.center.dy / size.height,
          'buttonWidth': button.width,
          'buttonHeight': button.height,
          'physicalTVReachValidated': false,
        });
        await tester.tap(start);
        await tester.pump(const Duration(milliseconds: 400));
        expect(
          find.text('Pilih tiga unsur api.'),
          language == AppLocale.indonesian ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }

  testWidgets('start gives press feedback and cancels without starting', (
    tester,
  ) async {
    await launchWelcome(tester, const Size(411, 731));
    final start = find.ancestor(
      of: find.text('Mulai Tantangan'),
      matching: find.byWidgetPredicate((widget) => widget is ElevatedButton),
    );
    final press = await tester.startGesture(tester.getCenter(start));
    final originalRect = tester.getRect(start);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));
    final scale = find.byKey(const ValueKey('welcome-start-feedback'));
    expect(tester.widget<AnimatedScale>(scale).scale, lessThan(1));
    expect(tester.getRect(start).width, lessThan(originalRect.width));
    await captureWelcome(tester, 'id-411x731-pressed', {'state': 'pressed'});
    await press.cancel();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));
    expect(tester.widget<AnimatedScale>(scale).scale, 1);
    expect(find.text('Fire Prevention\nChallenge'), findsOneWidget);
    expect(find.text('Pilih tiga unsur api.'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
