import 'package:fire_prevention_challenge/core/audio/game_audio.dart';
import 'package:fire_prevention_challenge/core/localization/app_locale.dart';
import 'package:fire_prevention_challenge/core/theme/kifc_theme.dart';
import 'package:fire_prevention_challenge/features/game/exhibition_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => AppCopy.locale = AppLocale.korean);
  tearDown(() => AppCopy.locale = AppLocale.indonesian);

  testWidgets('welcome title updates immediately on every language switch', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(720, 1280);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: KifcTheme.light(),
        home: const ExhibitionGame(audioBackend: SilentGameAudioBackend()),
      ),
    );
    expect(find.text('Fire Prevention\nChallenge'), findsOneWidget);

    for (final label in ['한국어', 'English', '한국어', 'Bahasa Indonesia']) {
      await tester.tap(find.text(label));
      await tester.pump();
      final korean = label == '한국어';
      expect(
        find.text(korean ? '산불 예방\n챌린지' : 'Fire Prevention\nChallenge'),
        findsOneWidget,
      );
      expect(
        find.text(korean ? 'Fire Prevention\nChallenge' : '산불 예방\n챌린지'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('translates composed cause feedback, including the last summary', () {
    const reason =
        'Membakar tanaman untuk membuka lahan bisa membuat api merambat ke sekitarnya.';
    const summary =
        'Kebakaran bisa dipicu manusia maupun alam. Mencegahnya lebih baik daripada memadamkannya.';
    expect(
      AppCopy.translate('Yang ini dipicu aktivitas manusia. $reason'),
      '사람의 행동으로 시작된 불이에요. 땅을 개간하려고 식물을 태우면 주변으로 불이 번질 수 있어요.',
    );
    expect(
      AppCopy.translate('Yang ini dipicu faktor alam. $reason $summary'),
      '자연 현상으로 시작된 불이에요. ${AppCopy.translate(reason)} ${AppCopy.translate(summary)}',
    );
    expect(
      AppCopy.translate('$reason $summary'),
      '${AppCopy.translate(reason)} ${AppCopy.translate(summary)}',
    );
    const englishReason =
        'Burning vegetation to clear land is a human activity.';
    expect(
      AppCopy.translate('Correct. $englishReason'),
      '맞아요. ${AppCopy.translate(englishReason)}',
    );
    expect(
      AppCopy.translate('The answer is human activity. $englishReason'),
      '사람의 행동으로 시작된 불이에요. ${AppCopy.translate(englishReason)}',
    );
  });

  test('translates every dynamic cause question heading', () {
    for (var index = 1; index <= 4; index++) {
      for (final source in [
        'BABAK 3 / SITUASI $index DARI 4',
        'BABAK 3 / SOAL $index DARI 4',
        'CHAPTER 3 / CLUE $index OF 4',
      ]) {
        expect(AppCopy.translate(source), '3장 / 상황 $index / 4');
      }
    }
  });

  test('translates every bonus with Korean decimal formatting', () {
    for (var score = 0; score <= 4; score++) {
      final bonus = score == 0 || score == 4
          ? (score ~/ 4).toString()
          : (score / 4).toString();
      for (final number in [bonus, bonus.replaceAll('.', ',')]) {
        expect(
          AppCopy.translate(
            '$score/4 poin di babak akhir = $number poin bonus',
          ),
          '마지막 도전 $score/4점 · 보너스 +$bonus점',
        );
      }
    }
  });

  test(
    'translates Chapter 2 reading cards and closing score banner to Korean',
    () {
      expect(
        AppCopy.translate('Tapi, Apa Itu Kebakaran Hutan?'),
        '산불이란 무엇일까요?',
      );
      expect(AppCopy.translate('What Is a Forest Fire?'), '산불이란 무엇일까요?');
      expect(
        AppCopy.translate('Mengapa Kebakaran Hutan Bisa Terjadi?'),
        '산불은 왜 일어날까요?',
      );
      expect(AppCopy.translate('Why Do Forest Fires Happen?'), '산불은 왜 일어날까요?');
      expect(
        AppCopy.translate(
          'Kebakaran hutan dapat terjadi ketika tiga unsur api bertemu.',
        ),
        '불의 세 요소가 만나면 산불이 발생할 수 있어요.',
      );
      expect(
        AppCopy.translate(
          'A forest fire can occur when the three elements of fire meet.',
        ),
        '불의 세 요소가 만나면 산불이 발생할 수 있어요.',
      );
      expect(
        AppCopy.translate('Mengapa Kebakaran Hutan Perlu Kita Cegah?'),
        '산불을 왜 예방해야 할까요?',
      );
      expect(
        AppCopy.translate('Why Must We Prevent Forest Fires?'),
        '산불을 왜 예방해야 할까요?',
      );
      expect(
        AppCopy.translate('Mencegah Kebakaran Lebih Baik daripada Memadamkan.'),
        '화재 예방이 진압보다 낫습니다.',
      );
      expect(
        AppCopy.translate('Preventing Fires Is Better Than Fighting Them.'),
        '화재 예방이 진압보다 낫습니다.',
      );
    },
  );
}
