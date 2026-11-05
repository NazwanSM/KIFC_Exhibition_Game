import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:fire_prevention_challenge/features/game/reading_timing.dart';
import 'package:fire_prevention_challenge/features/game/widgets/game_mascot.dart';
import 'package:fire_prevention_challenge/features/game/widgets/progressive_reading_text.dart';
import 'game_flow_test.dart' show loadGameFonts;
import 'reading_integration_test.dart' show ReadingPlayer, waitForReading;
import 'chapter2_review_test.dart' show captureScreen;

final data =
    jsonDecode(
          File('assets/audio/narration/reading_timing.json').readAsStringSync(),
        )
        as Map<String, dynamic>;
Map<String, dynamic> entry(String key) => (data['items'] as List)
    .cast<Map<String, dynamic>>()
    .firstWhere((x) => x['locale'] == 'ko' && x['key'] == key);
void main() {
  setUpAll(() async {
    await loadGameFonts();
    await rootBundle.loadString('assets/audio/narration/reading_timing.json');
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  tearDown(() => AppCopy.locale = AppLocale.indonesian);
  test('new Korean recordings replace provisional old-audio cues', () {
    for (final key in ['karhutla-cause', 'karhutla-prevention']) {
      final x = entry(key);
      expect(x['pending_audio_regeneration'], isNot(true));
      expect(x['timing_source'], contains('new owner recording'));
      expect(x.containsKey('audio_script_text'), isFalse);
    }
  });
  for (final size in const [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final (key, card) in [
      ('karhutla-cause', 1),
      ('karhutla-prevention', 2),
    ]) {
      testWidgets(
        'Korean refreshed narration reveals words and holds completion $key $size',
        (t) async {
          t.view.physicalSize = size;
          t.view.devicePixelRatio = 1;
          addTearDown(t.view.resetPhysicalSize);
          addTearDown(t.view.resetDevicePixelRatio);
          final p = ReadingPlayer();
          final timing = ReadingTiming.fromJson(entry(key));
          await t.pumpWidget(
            MaterialApp(
              theme: KifcTheme.light(),
              home: RepaintBoundary(
                key: const ValueKey('review-target'),
                child: ExhibitionGame(
                  initialPage: 'triangleExplanation',
                  initialLocale: AppLocale.korean,
                  audioBackend: const SilentGameAudioBackend(),
                  narrationPlayer: p,
                ),
              ),
            ),
          );
          for (var step = 0; step <= card; step++) {
            await t.tap(find.text('계속'));
            await t.pump();
            await t.pump(const Duration(milliseconds: 400));
            await waitForReading(
              t,
              card: [
                'karhutla-definition',
                'karhutla-cause',
                'karhutla-prevention',
              ][step],
            );
          }
          await t.pump(const Duration(seconds: 4));
          await t.pump();
          expect(p.played.last, 'ko/$key.mp3');
          final paragraph = find.byType(ProgressiveReadingText);
          final halfway = Duration(
            microseconds: timing.duration.inMicroseconds ~/ 2,
          );
          p.events.add(halfway);
          await t.pump();
          await t.pump();
          final shown = t.widget<ProgressiveReadingText>(paragraph);
          expect(shown.text, timing.text);
          expect(shown.visibleCharacters, timing.visibleText(halfway).length);
          expect(shown.visibleCharacters, greaterThan(0));
          expect(shown.visibleCharacters, lessThan(timing.text.length));
          expect(
            t.widget<GameMascot>(find.byType(GameMascot)).narrating,
            isTrue,
          );
          await captureScreen(
            t,
            '$key-partial-${size.width.toInt()}x${size.height.toInt()}',
            {
              'source':
                  'Flutter widget render; controlled narration position; static mascot fallback',
              'width': size.width,
              'height': size.height,
              'positionSeconds': halfway.inMicroseconds / 1000000,
              'visibleCharacters': shown.visibleCharacters,
              'text': shown.text,
            },
          );
          p.sessions.last.complete();
          await t.pump();
          await t.pump(const Duration(milliseconds: 999));
          expect(find.byKey(ValueKey(key)), findsOneWidget);
          expect(
            t.widget<ProgressiveReadingText>(paragraph).visibleCharacters,
            timing.text.length,
          );
          expect(
            t.widget<GameMascot>(find.byType(GameMascot)).narrating,
            isFalse,
          );
          await captureScreen(
            t,
            '$key-complete-${size.width.toInt()}x${size.height.toInt()}',
            {
              'source':
                  'Flutter widget render; controlled speech completion; static mascot fallback',
              'width': size.width,
              'height': size.height,
              'holdMilliseconds': 999,
            },
          );
          await t.pump(const Duration(milliseconds: 1));
          await t.pump(const Duration(milliseconds: 400));
          if (card == 1) {
            expect(
              find.byKey(const ValueKey('karhutla-prevention')),
              findsOneWidget,
            );
          } else {
            expect(
              find.byWidgetPredicate(
                (w) => w.runtimeType.toString() == '_RiskPage',
              ),
              findsOneWidget,
            );
          }
          expect(t.takeException(), isNull);
          await t.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }
}
