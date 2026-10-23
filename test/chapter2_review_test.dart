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

Future<void> launchScreen(
  WidgetTester tester, {
  required Size size,
  required AppLocale locale,
  required String page,
  int? cardIndex,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: KifcTheme.light(),
      debugShowCheckedModeBanner: false,
      home: RepaintBoundary(
        key: const ValueKey('review-target'),
        child: ExhibitionGame(
          initialLocale: locale,
          initialPage: page,
          initialCardIndex: cardIndex,
        ),
      ),
    ),
  );
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final provider = (element.widget as Image).image;
      // Animated images emit their first frame on the test frame clock.
      // Awaiting precacheImage inside runAsync would wait for a pump forever.
      if (provider is AssetImage && provider.assetName.endsWith('.webp')) {
        continue;
      }
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> captureScreen(
  WidgetTester tester,
  String name,
  Map<String, Object> metrics,
) async {
  if (Platform.environment['KIFC_CAPTURE'] != '1') return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('review-target')),
  );
  await tester.runAsync(() async {
    final dir = Directory(
      Platform.environment['KIFC_CAPTURE_DIR'] ?? 'build/review-chapter2-score',
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

  const sizes = [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ];

  for (final size in sizes) {
    for (final locale in AppLocale.values) {
      final lang = ['id', 'en', 'ko'][locale.index];
      final res = '${size.width.toInt()}x${size.height.toInt()}';

      // Test Chapter 2 Card 1: Definition
      testWidgets('KIFC-05 definition card fits and renders $lang-$res', (
        tester,
      ) async {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'karhutlaCards',
          cardIndex: 0,
        );
        expect(tester.takeException(), isNull);
        expect(
          find.byKey(const ValueKey('karhutla-definition')),
          findsOneWidget,
        );
        await captureScreen(tester, 'kifc05-definition-$lang-$res', {
          'ticket': 'KIFC-05',
          'card': 'definition',
          'language': lang,
          'width': size.width,
          'height': size.height,
        });
        await tester.pumpWidget(const SizedBox.shrink());
      });

      // Test Chapter 2 Card 2: Cause
      testWidgets('KIFC-06 cause card fits and renders $lang-$res', (
        tester,
      ) async {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'karhutlaCards',
          cardIndex: 1,
        );
        expect(tester.takeException(), isNull);
        expect(find.byKey(const ValueKey('karhutla-cause')), findsOneWidget);
        await captureScreen(tester, 'kifc06-cause-$lang-$res', {
          'ticket': 'KIFC-06',
          'card': 'cause',
          'language': lang,
          'width': size.width,
          'height': size.height,
        });
        await tester.pumpWidget(const SizedBox.shrink());
      });

      // Test Chapter 2 Card 3: Prevention
      testWidgets('KIFC-07 prevention card fits and renders $lang-$res', (
        tester,
      ) async {
        await launchScreen(
          tester,
          size: size,
          locale: locale,
          page: 'karhutlaCards',
          cardIndex: 2,
        );
        expect(tester.takeException(), isNull);
        expect(
          find.byKey(const ValueKey('karhutla-prevention')),
          findsOneWidget,
        );
        await captureScreen(tester, 'kifc07-prevention-$lang-$res', {
          'ticket': 'KIFC-07',
          'card': 'prevention',
          'language': lang,
          'width': size.width,
          'height': size.height,
        });
        await tester.pumpWidget(const SizedBox.shrink());
      });

      // Test Score Page with KIFC-11 Closing Banner
      testWidgets(
        'KIFC-11 score page fits and renders closing banner $lang-$res',
        (tester) async {
          await launchScreen(tester, size: size, locale: locale, page: 'score');
          expect(tester.takeException(), isNull);
          expect(
            find.byKey(const ValueKey('score-closing-banner')),
            findsOneWidget,
          );
          await captureScreen(tester, 'kifc11-score-$lang-$res', {
            'ticket': 'KIFC-11',
            'language': lang,
            'width': size.width,
            'height': size.height,
          });
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }
}
