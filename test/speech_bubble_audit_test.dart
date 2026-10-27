import 'dart:ui' as ui;

import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'game_flow_test.dart' show loadGameFonts;

Finder kind(String name) =>
    find.byWidgetPredicate((widget) => widget.runtimeType.toString() == name);

double paintOpacity(Finder finder) {
  var value = 1.0;
  finder.evaluate().single.visitAncestorElements((element) {
    if (element.widget case final FadeTransition fade) {
      value *= fade.opacity.value;
    }
    return true;
  });
  return value;
}

void checkPaint(WidgetTester tester, Finder host) {
  final message = find.descendant(
    of: host,
    matching: find.byType(LocalizedText),
  );
  final body = find
      .ancestor(of: message, matching: find.byType(Container))
      .first;
  final pointers = find.descendant(of: host, matching: find.byType(ClipPath));
  for (final pointer in pointers.evaluate()) {
    expect(
      paintOpacity(find.byWidget(pointer.widget)),
      closeTo(paintOpacity(message), .000001),
      reason: 'A pointer may not stay visible while its reading card fades',
    );
  }
  expect(paintOpacity(body), closeTo(paintOpacity(message), .000001));
}

void main() {
  setUpAll(loadGameFonts);

  Future<void> launch(WidgetTester tester, String page) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(411, 731);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(() => AppCopy.locale = AppLocale.indonesian);
    await tester.pumpWidget(
      MaterialApp(
        theme: KifcTheme.light(),
        home: RepaintBoundary(
          key: const ValueKey('audit-capture'),
          child: ExhibitionGame(
            initialPage: page,
            initialLocale: AppLocale.indonesian,
            audioBackend: const SilentGameAudioBackend(),
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        await precacheImage((element.widget as Image).image, element);
      }
    });
  }

  for (final scenario in [
    ('karhutlaCards', '_MascotDialogue'),
    ('finalReview', '_FinalReviewDialogue'),
  ]) {
    testWidgets('${scenario.$1} pointer follows its card during entrance', (
      tester,
    ) async {
      await launch(tester, scenario.$1);
      var elapsed = 0;
      for (final ms in [0, 40, 155, 500]) {
        await tester.pump(Duration(milliseconds: ms - elapsed));
        elapsed = ms;
        checkPaint(tester, kind(scenario.$2));
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final correct in [false, true]) {
    testWidgets('feedback tail is seamless on ${correct ? 'right' : 'left'}', (
      tester,
    ) async {
      await launch(tester, 'risk');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(
        find.descendant(
          of: kind('_RiskCard').at(correct ? 1 : 0),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();
      checkPaint(tester, kind('_MascotFeedback'));
      await tester.pump(const Duration(milliseconds: 500));
      final message = find.descendant(
        of: kind('_MascotFeedback'),
        matching: find.byType(LocalizedText),
      );
      final body = find
          .ancestor(of: message, matching: find.byType(Container))
          .first;
      final padding = tester
          .widget<Container>(body)
          .padding!
          .resolve(TextDirection.ltr);
      final x = correct
          ? tester.getBottomRight(message).dx + padding.right + .5
          : tester.getTopLeft(message).dx - padding.left - .5;
      final y = tester.getCenter(body).dy;
      await tester.runAsync(() async {
        final image = await tester
            .renderObject<RenderRepaintBoundary>(
              find.byKey(const ValueKey('audit-capture')),
            )
            .toImage();
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        try {
          for (final dy in [-2, 0, 2]) {
            final offset = ((y + dy).floor() * image.width + x.floor()) * 4;
            for (var channel = 0; channel < 3; channel++) {
              expect(
                bytes.getUint8(offset + channel),
                closeTo([247, 245, 238][channel], 2),
                reason:
                    'The pointer join must be cream, without a dividing outline',
              );
            }
          }
        } finally {
          image.dispose();
        }
      });
      expect(tester.takeException(), isNull);
    });
  }
}
