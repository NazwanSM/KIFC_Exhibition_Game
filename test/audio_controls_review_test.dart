import 'package:fire_prevention_challenge/core/audio/audio_controls.dart';
import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chapter2_review_test.dart' show captureScreen;
import 'game_flow_test.dart' show loadGameFonts;
import 'game_audio_test.dart' show RecordingAudioBackend;

void main() {
  setUpAll(() async {
    await loadGameFonts();
    await (FontLoader(
      'NotoSansKR',
    )..addFont(rootBundle.load('assets/fonts/NotoSansKR-Variable.ttf'))).load();
  });
  for (final size in const [
    Size(360, 640),
    Size(411, 731),
    Size(720, 1280),
    Size(1080, 1920),
    Size(2160, 3840),
  ]) {
    for (final locale in AppLocale.values) {
      final lang = ['id', 'en', 'ko'][locale.index];
      final res = '${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('G04 sound controls $lang-$res', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final backend = RecordingAudioBackend();
        await tester.pumpWidget(
          RepaintBoundary(
            key: const ValueKey('review-target'),
            child: MaterialApp(
              theme: KifcTheme.light(),
              debugShowCheckedModeBanner: false,
              home: ExhibitionGame(
                initialLocale: locale,
                audioBackend: backend,
              ),
            ),
          ),
        );
        await tester.runAsync(() async {
          for (final element in find.byType(Image).evaluate()) {
            await precacheImage((element.widget as Image).image, element);
          }
        });
        await tester.pump(const Duration(milliseconds: 400));
        final meta = <String, Object>{
          'ticket': 'KIFC-G04',
          'source':
              'Flutter widget render; fake audio backend, no speaker proof',
          'language': lang,
          'width': size.width,
          'height': size.height,
        };
        final control = find.byKey(const ValueKey('audio-settings'));
        expect(control, findsOneWidget);
        expect(backend.preparations, 0, reason: 'No autoplay before gesture');
        await captureScreen(tester, 'audio-welcome-$lang-$res', meta);
        await tester.tap(control);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.byType(Slider), findsNWidgets(4));
        expect(tester.takeException(), isNull);
        await captureScreen(tester, 'audio-panel-$lang-$res', meta);
        final credits = find.byKey(const ValueKey('audio-credits'));
        await tester.ensureVisible(credits);
        await tester.tap(credits);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.textContaining('Safari — syncopika'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await captureScreen(tester, 'audio-credits-$lang-$res', meta);
        await tester.tap(find.text(AppCopy.translate(locale == AppLocale.english ? 'Close' : 'Tutup')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.byType(Slider), findsNWidgets(4));
        final audio = GameAudioScope.of(tester.element(control));
        await tester.tap(find.byKey(const ValueKey('audio-mute')));
        await tester.pump();
        expect(audio.muted, isTrue);
        expect(backend.mixes.last.playing, isFalse);
        await captureScreen(tester, 'audio-muted-$lang-$res', meta);
        await tester.tap(find.byKey(const ValueKey('audio-close')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        final start = locale == AppLocale.english
            ? 'Start Challenge'
            : locale == AppLocale.korean
            ? '도전 시작'
            : 'Mulai Tantangan';
        await tester.tap(find.text(start));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(control, findsOneWidget);
        expect(audio.muted, isTrue, reason: 'Mute survives page changes');
        await tester.tap(control);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await captureScreen(tester, 'audio-stage-panel-$lang-$res', meta);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await audio.settled;
        expect(backend.disposals, 1);
      });
    }
  }
  testWidgets('closing keeps a sound control available', (tester) async {
    tester.view.physicalSize = const Size(411, 731);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('review-target'),
        child: MaterialApp(
          theme: KifcTheme.light(),
          home: const ExhibitionGame(
            initialPage: 'closing',
            audioBackend: SilentGameAudioBackend(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const ValueKey('audio-settings')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('audio-settings')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Slider), findsNWidgets(4));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('sound errors can be retried and lifecycle respects mute', (
    tester,
  ) async {
    final backend = RecordingAudioBackend()..fail = true;
    await tester.pumpWidget(
      MaterialApp(
        theme: KifcTheme.light(),
        home: ExhibitionGame(audioBackend: backend),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('audio-settings')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const ValueKey('audio-retry')), findsOneWidget);
    backend.fail = false;
    await tester.tap(find.byKey(const ValueKey('audio-retry')));
    await tester.pump();
    expect(backend.mixes.last.playing, isTrue);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(backend.mixes.last.playing, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(backend.mixes.last.playing, isTrue);
    await tester.tap(find.byKey(const ValueKey('audio-mute')));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(backend.mixes.last.playing, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
