import 'package:flutter/material.dart';

enum AppLocale { indonesian, english, korean }

extension AppLocaleLabel on AppLocale {
  String get label => switch (this) {
    AppLocale.indonesian => 'Bahasa Indonesia',
    AppLocale.english => 'English',
    AppLocale.korean => '한국어',
  };
}

/// Current exhibition locale. The app has one game surface and updates this
/// together with its locale state when the visitor changes language.
abstract final class AppCopy {
  static final _locale = ValueNotifier<AppLocale>(AppLocale.indonesian);

  static ValueNotifier<AppLocale> get localeListenable => _locale;

  static AppLocale get locale => _locale.value;
  static set locale(AppLocale value) => _locale.value = value;

  static String translate(String source) {
    if (locale != AppLocale.korean) return source;
    final exact = _korean[source];
    if (exact != null) return exact;
    // Cause feedback combines a translated explanation with an answer prefix
    // and, on the last question, a summary. Translate those parts separately.
    for (final summary in const [
      'Kebakaran bisa dipicu manusia maupun alam. Mencegahnya lebih baik daripada memadamkannya.',
      'Risk can come from people or nature. The best prevention happens before there is a flame.',
    ]) {
      if (source.endsWith(' $summary')) {
        final explanation = source.substring(
          0,
          source.length - summary.length - 1,
        );
        return '${translate(explanation)} ${translate(summary)}';
      }
    }
    for (final prefix in const <String, String>{
      'Yang ini dipicu aktivitas manusia. ': '사람의 행동으로 시작된 불이에요. ',
      'Yang ini dipicu faktor alam. ': '자연 현상으로 시작된 불이에요. ',
      'The answer is human activity. ': '사람의 행동으로 시작된 불이에요. ',
      'The answer is a natural factor. ': '자연 현상으로 시작된 불이에요. ',
      'Correct. ': '맞아요. ',
    }.entries) {
      if (source.startsWith(prefix.key)) {
        return '${prefix.value}${translate(source.substring(prefix.key.length))}';
      }
    }
    final tried = RegExp(
      r'^(\d)/3 (?:elements tried|unsur sudah dicoba)$',
    ).firstMatch(source);
    if (tried != null) return '불의 요소 ${tried.group(1)}/3 확인';
    final readCards = RegExp(
      r'^(\d)/3 (?:cards opened|kartu sudah dibuka)$',
    ).firstMatch(source);
    if (readCards != null) return '카드 ${readCards.group(1)}/3 확인';
    final selected = RegExp(
      r'^(\d) (?:images selected|gambar dipilih)$',
    ).firstMatch(source);
    if (selected != null) return '${selected.group(1)}개 선택됨';
    final summary = RegExp(
      r'^(\d) (?:correct|benar) · (\d) (?:incorrect|salah) · (\d) (?:missed|terlewat)$',
    ).firstMatch(source);
    if (summary != null) {
      return '정답 ${summary.group(1)} · 오답 ${summary.group(2)} · 놓침 ${summary.group(3)}';
    }
    final chapter = RegExp(r'^(?:CHAPTER|BABAK) (\d)/4$').firstMatch(source);
    if (chapter != null) return '${chapter.group(1)}장 / 4장';
    final causeQuestion = RegExp(
      r'^(?:CHAPTER|BABAK) (\d+) / (?:CLUE|SITUASI|SOAL) (\d+) (?:OF|DARI) (\d+)$',
    ).firstMatch(source);
    if (causeQuestion != null) {
      return '${causeQuestion.group(1)}장 / 상황 ${causeQuestion.group(2)} / ${causeQuestion.group(3)}';
    }
    final elements = RegExp(r'^(\d)/3 (?:elements|unsur)$').firstMatch(source);
    if (elements != null) return '요소 ${elements.group(1)}/3';
    final situation = RegExp(
      r'^(?:FIELD SITUATION|SITUASI) (\d)$',
    ).firstMatch(source);
    if (situation != null) return '상황 ${situation.group(1)}';
    final seconds = RegExp(
      r'^(\d+) ?(?:seconds|sec|detik)$',
    ).firstMatch(source);
    if (seconds != null) return '${seconds.group(1)}초';
    final progress = RegExp(
      r'^(\d+)/4 (?:challenge points|poin di babak akhir)(?: → \+(\d+(?:[.,]\d+)?) bonus| = (\d+(?:[.,]\d+)?) poin bonus)$',
    ).firstMatch(source);
    if (progress != null) {
      final bonus = (progress.group(2) ?? progress.group(3) ?? '0').replaceAll(
        ',',
        '.',
      );
      return '마지막 도전 ${progress.group(1)}/4점 · 보너스 +$bonus점';
    }
    final idle = RegExp(
      r'^(?:Returns home after|Layar kembali ke awal dalam) (\d+) (?:seconds without interaction\.|detik jika tidak disentuh\.)$',
    ).firstMatch(source);
    if (idle != null) return '터치가 없으면 ${idle.group(1)}초 후 처음 화면으로 돌아가요.';
    if (source.startsWith('You spotted ')) {
      final rest = source.substring('You spotted '.length);
      final label = rest.split('.').first;
      final koreanLabel = _korean[label] ?? label;
      if (rest.contains('Rain does not start a fire.') ||
          rest.contains('Hujan bukan pemicu api.')) {
        return '$koreanLabel을(를) 찾았어요. 비는 불을 일으키지 않아요. 놓친 위험 요소도 확인해 보세요.';
      }
      if (rest.contains('Wet forest is harder to ignite.') ||
          rest.contains('Hutan basah lebih sulit terbakar.')) {
        return '$koreanLabel을(를) 찾았어요. 수분이 많은 숲은 쉽게 불이 붙지 않아요. 놓친 위험 요소도 확인해 보세요.';
      }
    }
    if (source.contains(' sudah kamu temukan. ')) {
      final parts = source.split(' sudah kamu temukan. ');
      final label = _korean[parts.first] ?? parts.first;
      final ending = parts.length > 1 ? translate(parts.last) : '';
      return '$label을(를) 찾았어요. $ending';
    }
    if (source.contains('Hujan dan hutan basah bukan risiko')) {
      return '이 장면에서 비와 습한 숲은 위험 요소가 아니에요. 놓친 위험 요소도 확인해 보세요.';
    }
    if (source.contains('Hujan bukan pemicu api.')) {
      return '비는 불을 일으키지 않아요. 놓친 위험 요소도 확인해 보세요.';
    }
    if (source.contains('Hutan basah lebih sulit terbakar.')) {
      return '수분이 많은 숲은 쉽게 불이 붙지 않아요. 놓친 위험 요소도 확인해 보세요.';
    }
    if (source.contains('Mendekati api berbahaya.')) {
      return '불에 가까이 가면 위험해요. 거리를 두고 담당자에게 알리세요. 담당자는 연료를 분리해 불길이 번지는 것을 막을 수 있어요.';
    }
    if (source.contains('Menambah bahan bakar justru bisa memperbesar api.')) {
      return '연료가 많아지면 불이 더 번질 수 있어요. 실제 화재에 가까이 가지 말고 담당자에게 알리세요.';
    }
    if (source.contains('Api yang tidak terkendali dapat merambat.')) {
      return '걷잡을 수 없는 불은 번질 수 있어요. 아직 선택하지 않은 사진을 살펴보세요.';
    }
    return source;
  }

  static TextStyle? koreanStyle(TextStyle? style) => locale == AppLocale.korean
      ? (style ?? const TextStyle()).copyWith(
          fontFamily: 'NotoSansKR',
          fontVariations: [
            FontVariation(
              'wght',
              (style?.fontWeight ?? FontWeight.w400).value.toDouble(),
            ),
          ],
        )
      : style;
}

/// Text used by the game screens. Translating at the display edge also covers
/// copy composed by quiz answers, dynamic prompts and shared button widgets.
class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<AppLocale>(
    valueListenable: AppCopy._locale,
    builder: (context, _, _) => Text(
      AppCopy.translate(data),
      style: AppCopy.koreanStyle(style),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel == null
          ? null
          : AppCopy.translate(semanticsLabel!),
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    ),
  );
}

const Map<String, String> _korean = <String, String>{
  // KIFC-09: unscored flip cards.
  'Kartu': '카드',
  'Sentuh untuk membuka': '터치해서 열어 보세요',
  'Card': '카드',
  'Touch to open': '터치해서 열어 보세요',
  'CHAPTER 4 / PEAT FIRE CHARACTERISTICS': '4장 / 이탄지 화재의 특징',
  'BABAK 4 / CIRI KEBAKARAN GAMBUT': '4장 / 이탄지 화재의 특징',
  'What Are the Characteristics of Peatland Fires?': '이탄지 화재에는 어떤 특징이 있을까요?',
  'Apa Saja Karakteristik Kebakaran di Ekosistem Gambut?':
      '이탄지 화재에는 어떤 특징이 있을까요?',
  'Touch cards 1–3 to discover each characteristic.': '1~3번 카드를 터치해 특징을 알아보세요.',
  'Sentuh kartu 1–3 untuk mengenali setiap cirinya.': '1~3번 카드를 터치해 특징을 알아보세요.',
  'Fire can smolder beneath the ground surface.': '불씨가 지표면 아래에서 타들어 갈 수 있어요.',
  'Api dapat membara di bawah permukaan tanah.': '불씨가 지표면 아래에서 타들어 갈 수 있어요.',
  'These fires are difficult to extinguish.': '화재를 진압하기 어려워요.',
  'Kebakaran sulit dipadamkan.': '화재를 진압하기 어려워요.',
  'Fire can reignite.': '불이 다시 붙을 수 있어요.',
  'Api dapat menyala kembali.': '불이 다시 붙을 수 있어요.',
  'All three can happen in peatland fires. Ready to explore their impacts?':
      '이탄지 화재에는 이 세 가지 특징이 있어요. 이제 그 영향도 알아볼까요?',
  'Ketiganya bisa terjadi pada kebakaran gambut. Yuk, kenali dampaknya juga.':
      '이탄지 화재에는 이 세 가지 특징이 있어요. 이제 그 영향도 알아볼까요?',
  'Take your time. You can turn each card over again.':
      '천천히 읽어 보세요. 카드를 다시 뒤집어 볼 수 있어요.',
  'Baca pelan-pelan, ya. Kamu bisa membalik kartunya lagi.':
      '천천히 읽어 보세요. 카드를 다시 뒤집어 볼 수 있어요.',
  'Explore the Impacts': '영향 알아보기',
  'Kenali Dampaknya': '영향 알아보기',
  '/ 8 points': '/ 8점',
  '/ 8 poin': '/ 8점',
  // KIFC-10: impacts, neutral selection and timed review.
  'How Do Forest Fires Affect Peatland Ecosystems?':
      '산림 화재는 이탄지 생태계에 어떤 영향을 줄까요?',
  'Apa Saja Dampak Kebakaran Hutan pada Ekosistem Gambut?':
      '산림 화재는 이탄지 생태계에 어떤 영향을 줄까요?',
  'Choose all the relevant impacts.': '해당하는 영향을 모두 골라 보세요.',
  'Pilih semua dampak yang sesuai.': '해당하는 영향을 모두 골라 보세요.',
  'Time’s up. Review your choices and the impacts you missed.':
      '시간이 끝났어요. 선택한 답과 놓친 영향을 확인해 보세요.',
  'Waktu habis. Cermati pilihanmu dan dampak yang masih terlewat.':
      '시간이 끝났어요. 선택한 답과 놓친 영향을 확인해 보세요.',
  'Photo credits': '사진 출처',
  'Kredit foto': '사진 출처',
  'Close': '닫기',
  'Tutup': '닫기',
  'Haze': '연무',
  'Kabut asap': '연무',
  'Ecosystem damage': '생태계 훼손',
  'Kerusakan ekosistem': '생태계 훼손',
  'High carbon emissions': '많은 탄소 배출',
  'Emisi karbon tinggi': '많은 탄소 배출',
  'Lower ground surface (subsidence)': '지표면 높이 감소 (지반 침하)',
  'Penurunan tinggi permukaan tanah atau subsidens': '지표면 높이 감소 (지반 침하)',
  'Improved air quality': '대기 질 개선',
  'Peningkatan kualitas udara': '대기 질 개선',
  'Increased carbon stored in peat soil': '이탄 토양의 탄소 저장량 증가',
  'Peningkatan cadangan karbon dalam tanah gambut': '이탄 토양의 탄소 저장량 증가',
  'Impact challenge bonus': '영향 찾기 보너스',
  'Bonus mengenali dampak': '영향 찾기 보너스',
  'Missed impact': '놓친 영향',
  'Dampak terlewat': '놓친 영향',
  'Correct impact': '맞아요. 화재의 영향이에요',
  'Benar, ini dampak kebakaran': '맞아요. 화재의 영향이에요',
  'Not a fire impact': '화재의 영향이 아니에요',
  'Bukan dampak kebakaran': '화재의 영향이 아니에요',
  'No impacts were selected. The four impacts are haze, ecosystem damage, high carbon emissions, and subsidence.':
      '선택한 영향이 없어요. 네 가지 영향은 연무, 생태계 훼손, 많은 탄소 배출, 지반 침하예요.',
  'Belum ada dampak yang dipilih. Empat dampaknya adalah kabut asap, kerusakan ekosistem, emisi karbon tinggi, dan subsidens.':
      '선택한 영향이 없어요. 네 가지 영향은 연무, 생태계 훼손, 많은 탄소 배출, 지반 침하예요.',
  'You found all four impacts. Fire damages ecosystems and releases carbon stored in peat.':
      '네 가지 영향을 모두 찾았어요. 화재는 생태계를 훼손하고 이탄에 저장된 탄소를 방출해요.',
  'Keempat dampak sudah kamu temukan. Kebakaran merusak ekosistem dan melepaskan karbon yang tersimpan dalam gambut.':
      '네 가지 영향을 모두 찾았어요. 화재는 생태계를 훼손하고 이탄에 저장된 탄소를 방출해요.',
  'Fire worsens air quality and reduces peat carbon stores. Neither improvement is an impact of fire.':
      '화재는 대기 질을 악화시키고 이탄의 탄소 저장량을 줄여요. 두 가지 증가나 개선은 화재의 영향이 아니에요.',
  'Kebakaran memperburuk kualitas udara dan mengurangi cadangan karbon gambut. Kedua peningkatan itu bukan dampaknya.':
      '화재는 대기 질을 악화시키고 이탄의 탄소 저장량을 줄여요. 두 가지 증가나 개선은 화재의 영향이 아니에요.',
  'Smoke worsens air quality. Cleaner air is not an impact of fire. Check the missed impacts too.':
      '연기는 대기 질을 악화시켜요. 더 깨끗한 공기는 화재의 영향이 아니에요. 놓친 영향도 확인해 보세요.',
  'Asap memperburuk kualitas udara. Udara yang lebih bersih bukan dampak kebakaran. Cermati juga dampak yang terlewat.':
      '연기는 대기 질을 악화시켜요. 더 깨끗한 공기는 화재의 영향이 아니에요. 놓친 영향도 확인해 보세요.',
  'Fire releases stored carbon, so peat carbon stores decrease. Check the missed impacts too.':
      '화재로 저장된 탄소가 방출되면 이탄의 탄소 저장량이 줄어들어요. 놓친 영향도 확인해 보세요.',
  'Kebakaran melepaskan karbon yang tersimpan, sehingga cadangan karbon gambut berkurang. Cermati juga dampak yang terlewat.':
      '화재로 저장된 탄소가 방출되면 이탄의 탄소 저장량이 줄어들어요. 놓친 영향도 확인해 보세요.',
  'Smoke from peat fires creates haze and worsens air quality. This impact was missed.':
      '이탄 화재의 연기는 연무를 만들고 대기 질을 악화시켜요. 이 영향을 놓쳤어요.',
  'Asap kebakaran gambut menimbulkan kabut asap dan memperburuk kualitas udara. Dampak ini masih terlewat.':
      '이탄 화재의 연기는 연무를 만들고 대기 질을 악화시켜요. 이 영향을 놓쳤어요.',
  'Fire damages vegetation and habitats in peatland ecosystems. This impact was missed.':
      '화재는 이탄지 생태계의 식물과 서식지를 훼손해요. 이 영향을 놓쳤어요.',
  'Kebakaran merusak vegetasi dan habitat pada ekosistem gambut. Dampak ini masih terlewat.':
      '화재는 이탄지 생태계의 식물과 서식지를 훼손해요. 이 영향을 놓쳤어요.',
  'Burning peat releases stored carbon into the atmosphere. This impact was missed.':
      '이탄이 타면 저장된 탄소가 대기로 방출돼요. 이 영향을 놓쳤어요.',
  'Gambut yang terbakar melepaskan karbon tersimpan ke atmosfer. Dampak ini masih terlewat.':
      '이탄이 타면 저장된 탄소가 대기로 방출돼요. 이 영향을 놓쳤어요.',
  'Loss of peat can lower the ground surface. This is called subsidence, another impact to recognize.':
      '이탄층이 사라지면 지표면이 낮아질 수 있어요. 이것을 지반 침하라고 해요.',
  'Hilangnya lapisan gambut dapat menurunkan permukaan tanah. Inilah subsidens, salah satu dampak yang perlu dikenali.':
      '이탄층이 사라지면 지표면이 낮아질 수 있어요. 이것을 지반 침하라고 해요.',
  'Sentuh di mana saja untuk lanjut.': '화면 어디든 터치하면 계속해요.',
  'Tap anywhere to continue.': '화면 어디든 터치하면 계속해요.',
  'Api Dapat Muncul Saat Tiga Unsur Bertemu': '세 요소가 만나면 불이 날 수 있어요',
  'Fire Can Start When Three Elements Meet': '세 요소가 만나면 불이 날 수 있어요',
  'Kebakaran dapat terjadi di mana saja jika panas yang cukup, bahan bakar, dan oksigen bertemu.':
      '충분한 열, 연료, 산소가 만나면 어디서든 불이 날 수 있어요.',
  'Fire can occur anywhere when sufficient heat, fuel, and oxygen meet.':
      '충분한 열, 연료, 산소가 만나면 어디서든 불이 날 수 있어요.',
  'Kebakaran dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut. Karena itu, pencegahan penting dilakukan agar kebakaran tidak terjadi.':
      '충분한 열, 연료, 산소가 만나면 불이 날 수 있어요. 사람의 활동으로 이 세 요소가 한곳에 모일 수 있어요. 그래서 불이 나지 않도록 미리 예방하는 것이 중요해요.',
  'Fire can occur when sufficient heat, fuel, and oxygen meet. Human activity can bring these three elements together. Prevention helps keep a fire from starting.':
      '충분한 열, 연료, 산소가 만나면 불이 날 수 있어요. 사람의 활동으로 이 세 요소가 한곳에 모일 수 있어요. 그래서 불이 나지 않도록 미리 예방하는 것이 중요해요.',
  'Choose three elements.': '불의 세 요소를 고르세요.',
  'Pilih tiga unsur api.': '불의 세 요소를 고르세요.',
  'Drag the right photos into the empty spaces.': '알맞은 사진 세 장을 빈칸으로 드래그하세요.',
  'Seret tiga foto yang tepat ke tempat kosong.': '알맞은 사진 세 장을 빈칸으로 드래그하세요.',
  'This photo is already in place. Try another photo.':
      '이미 놓은 사진이에요. 다른 사진을 골라보세요.',
  'Foto ini sudah terpasang. Coba foto lain.': '이미 놓은 사진이에요. 다른 사진을 골라보세요.',
  'Sparks': '불꽃',
  'Percikan api': '불꽃',
  'Stone': '돌',
  'Batu': '돌',
  'Drag each photo to the matching element.': '각 사진을 알맞은 요소로 드래그하세요.',
  'Seret setiap foto ke unsur yang sesuai.': '각 사진을 알맞은 요소로 드래그하세요.',
  'Find all three elements to start the fire.': '불이 붙는 데 필요한 세 가지 요소를 찾아보세요.',
  'Temukan ketiga unsur agar api menyala.': '불이 붙는 데 필요한 세 가지 요소를 찾아보세요.',
  'That fits. Find the remaining elements.': '잘 맞혔어요. 나머지 요소도 찾아보세요.',
  'Sudah cocok. Temukan unsur lainnya.': '잘 맞혔어요. 나머지 요소도 찾아보세요.',
  'Water is not one of the elements of the fire triangle.':
      '물은 불의 삼요소 중 하나가 아니에요.',
  'Air bukan salah satu unsur dalam Segitiga Api.': '물은 불의 삼요소 중 하나가 아니에요.',
  'Rain is not one of the elements of the fire triangle.':
      '비는 불의 삼요소 중 하나가 아니에요.',
  'Hujan bukan salah satu unsur dalam Segitiga Api.': '비는 불의 삼요소 중 하나가 아니에요.',
  'Stone is not an element of the fire triangle.': '돌은 불의 삼요소에 해당하지 않아요.',
  'Batu bukan unsur yang dicari dalam Segitiga Api.': '돌은 불의 삼요소에 해당하지 않아요.',
  'Sparks carry heat. Place them in Heat.': '불꽃은 열을 내요. 열 칸에 놓아보세요.',
  'Percikan api membawa panas. Letakkan pada unsur Panas.':
      '불꽃은 열을 내요. 열 칸에 놓아보세요.',
  'Dry wood is fuel. Place it in Fuel.': '마른 나무는 연료예요. 연료 칸에 놓아보세요.',
  'Kayu kering menjadi bahan bakar. Letakkan pada unsur Bahan bakar.':
      '마른 나무는 연료예요. 연료 칸에 놓아보세요.',
  'Oxygen is present in air, even without wind. Place it in Oxygen.':
      '바람이 불지 않아도 공기에는 산소가 있어요. 산소 칸에 놓아보세요.',
  'Oksigen ada dalam udara, meski tidak ada angin. Letakkan pada unsur Oksigen.':
      '바람이 불지 않아도 공기에는 산소가 있어요. 산소 칸에 놓아보세요.',
  'Correct! Fire can start when sufficient heat, fuel, and oxygen meet. These three elements form the fire triangle. Reducing any one of them can help control fire.':
      '맞아요! 충분한 열과 연료, 산소가 만나면 불이 붙을 수 있어요. 이 세 가지를 불의 삼요소라고 해요. 그중 하나를 줄이면 불을 통제하는 데 도움이 돼요.',
  'Tepat! Api dapat menyala ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Ketiga unsur ini disebut Segitiga Api. Mengurangi salah satu unsur dapat membantu mengendalikan api.':
      '맞아요! 충분한 열과 연료, 산소가 만나면 불이 붙을 수 있어요. 이 세 가지를 불의 삼요소라고 해요. 그중 하나를 줄이면 불을 통제하는 데 도움이 돼요.',
  'Choose one answer.': '답을 하나 골라 보세요.',
  'Pilih satu jawaban.': '답을 하나 골라 보세요.',
  'Fire beneath the ground': '땅속에서 타는 불',
  'Api di bawah permukaan tanah': '땅속에서 타는 불',
  'KIFC EXHIBITION ROOM / MANGGALA AGNI': 'KIFC 전시관 / 망갈라 아그니',
  'Calm waterways · protected vegetation': '고요한 수로와 보호받는 숲',
  'Hutan gambut dan aliran air': '이탄지 숲과 물길',
  'Fire Prevention\nChallenge': '산불 예방\n챌린지',
  'Hello! Discover how fires start and what we can do to protect the forest.':
      '안녕하세요! 산불이 어떻게 시작되는지 알아보고 숲을 지키는 방법을 함께 배워 봐요.',
  'Halo! Yuk, kenali penyebab kebakaran dan cari tahu cara menjaga hutan dari api.':
      '안녕하세요! 산불의 원인을 알아보고 숲을 지키는 방법을 함께 배워 봐요.',
  'Start Challenge': '도전 시작',
  'Mulai Tantangan': '도전 시작',
  'Tap to begin': '눌러서 시작하기',
  'Ketuk untuk memulai': '눌러서 시작하기',
  'CHAPTER 2 / PEAT SWAMP FOREST': '2장 / 이탄습지 숲',
  'BABAK 2 / HUTAN RAWA GAMBUT': '2장 / 이탄습지 숲',
  'In which type of forest can fire smolder beneath the ground surface, making it difficult to extinguish?':
      '어느 유형의 숲에서 불이 땅속 아래에서 연소되어 진압하기 어려울까요?',
  'Pada jenis hutan manakah kebakaran dapat membara di bawah permukaan tanah sehingga sulit dipadamkan?':
      '어느 유형의 숲에서 불이 땅속 아래에서 연소되어 진압하기 어려울까요?',
  'Choose the forest type that has a peat layer.': '이탄층이 있는 숲 유형을 선택하세요.',
  'Pilih jenis hutan yang memiliki lapisan gambut.': '이탄층이 있는 숲 유형을 선택하세요.',
  'A. Hutan mangrove': 'A. 맹그로브 숲',
  'A. Mangrove forest': 'A. 맹그로브 숲',
  'B. Hutan rawa gambut': 'B. 이탄습지 숲',
  'B. Peat swamp forest': 'B. 이탄습지 숲',
  'C. Hutan pada tanah mineral': 'C. 광질토양 숲',
  'C. Forest on mineral soil': 'C. 광질토양 숲',
  'Hutan mangrove': '맹그로브 숲',
  'Mangrove forest': '맹그로브 숲',
  'Hutan rawa gambut': '이탄습지 숲',
  'Peat swamp forest': '이탄습지 숲',
  'Hutan pada tanah mineral': '광질토양 숲',
  'Forest on mineral soil': '광질토양 숲',
  'Start Quiz': '퀴즈 시작',
  'Mulai Kuis': '퀴즈 시작',
  'Tepat! Kebakaran di hutan rawa gambut yang mengering sulit dipadamkan karena api dapat membara di bawah permukaan tanah. Bara sulit terdeteksi dan dapat memicu api kembali meskipun api di permukaan sudah padam.':
      '맞아요! 메마른 이탄습지 숲의 화재는 불씨가 지표면 아래에서 타들어 갈 수 있어 진압하기 어려워요. 땅속의 불씨는 발견하기 어렵고, 지표면의 불이 꺼진 뒤에도 다시 불길을 일으킬 수 있어요.',
  'Correct! Fires in dried-out peat swamp forests are difficult to extinguish because fire can smolder beneath the ground surface. Embers are hard to detect and can rekindle flames even after the surface fire is out.':
      '맞아요! 메마른 이탄습지 숲의 화재는 불씨가 지표면 아래에서 타들어 갈 수 있어 진압하기 어려워요. 땅속의 불씨는 발견하기 어렵고, 지표면의 불이 꺼진 뒤에도 다시 불길을 일으킬 수 있어요.',
  'Belum tepat. Coba ingat jenis hutan yang memiliki lapisan tanah organik tebal. Api dapat membara di dalam lapisan tersebut sehingga sulit dipadamkan.':
      '아직 아니에요. 유기물 토양층이 두껍게 쌓인 숲 유형을 떠올려 보세요. 불길이 그 층 안에서 타들어가 진압하기 어려워요.',
  'Not quite. Think about the forest type with a thick organic soil layer. Fire can smolder inside that layer, making it difficult to extinguish.':
      '아직 아니에요. 유기물 토양층이 두껍게 쌓인 숲 유형을 떠올려 보세요. 불길이 그 층 안에서 타들어가 진압하기 어려워요.',
  'Jawaban yang tepat adalah hutan rawa gambut. Api dapat membara di dalam lapisan tanah organik tebal di bawah permukaan sehingga sulit dipadamkan.':
      '정답은 이탄습지 숲이에요. 지표면 아래 두꺼운 유기물 층에서 불씨가 타들어 갈 수 있어 진압하기 어려워요.',
  'The correct answer is peat swamp forest. Fire can smolder beneath the ground in thick organic soil, making it hard to extinguish.':
      '정답은 이탄습지 숲이에요. 지표면 아래 두꺼운 유기물 층에서 불씨가 타들어 갈 수 있어 진압하기 어려워요.',
  'CHAPTER 2 / SCAN THE RISK': '2장 / 위험 살펴보기',
  'BABAK 2 / KENALI RISIKONYA': '2장 / 위험 살펴보기',
  'Where could fire start more easily?': '어디에서 불이 더 쉽게 날까요?',
  'Di mana api lebih mudah muncul?': '어디에서 불이 더 쉽게 날까요?',
  'Choose the condition with the highest fire risk.':
      '산불 위험이 가장 높은 상황을 골라 보세요.',
  'Dari tiga kondisi ini, mana yang paling mudah terbakar?':
      '산불 위험이 가장 높은 상황을 골라 보세요.',
  'That’s right. Dry fuel plus a spark or heat source raises the risk quickly.':
      '맞아요. 마른 풀과 나뭇잎은 불씨나 열원이 있으면 쉽게 불이 붙어요.',
  'Bahan kering mudah tersulut jika ada sumber api di dekatnya. Kondisi ini paling berisiko.':
      '맞아요. 마른 풀과 나뭇잎은 불씨나 열원이 있으면 쉽게 불이 붙어요.',
  'Not quite. Look for dry fuel and something that can ignite it. You get one more try.':
      '아직 아니에요. 마른 연료와 불을 붙일 수 있는 원인을 찾아보세요. 한 번 더 선택할 수 있어요.',
  'Belum tepat. Cari bahan yang kering dan sumber api yang bisa menyulutnya. Kamu masih punya satu kesempatan lagi.':
      '아직 아니에요. 마른 연료와 불을 붙일 수 있는 원인을 찾아보세요. 한 번 더 선택할 수 있어요.',
  'Tapi, Apa Itu Kebakaran Hutan?': '산불이란 무엇일까요?',
  'What Is a Forest Fire?': '산불이란 무엇일까요?',
  'Mengapa Kebakaran Hutan Bisa Terjadi?': '산불은 왜 일어날까요?',
  'Why Do Forest Fires Happen?': '산불은 왜 일어날까요?',
  'Kebakaran hutan dapat terjadi ketika tiga unsur api bertemu.':
      '불의 세 요소가 만나면 산불이 발생할 수 있어요.',
  'A forest fire can occur when the three elements of fire meet.':
      '불의 세 요소가 만나면 산불이 발생할 수 있어요.',
  'Mengapa Kebakaran Hutan Perlu Kita Cegah?': '산불을 왜 예방해야 할까요?',
  'Why Must We Prevent Forest Fires?': '산불을 왜 예방해야 할까요?',
  'Kebakaran hutan adalah peristiwa terbakarnya vegetasi dan bahan organik di kawasan hutan, dengan api yang menyebar secara bebas dan tidak terkendali.':
      '산불은 산림에서 식생과 유기물이 타는 현상으로, 불길이 자유롭고 통제할 수 없게 번져 나가는 것을 말해요.',
  'A forest fire is the burning of vegetation and organic matter in a forest area, with flames spreading freely and uncontrollably.':
      '산불은 산림에서 식생과 유기물이 타는 현상으로, 불길이 자유롭고 통제할 수 없게 번져 나가는 것을 말해요.',
  'Kebakaran hutan dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu dalam kondisi yang memungkinkan api menyala. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut sehingga meningkatkan risiko kebakaran.':
      '산불은 충분한 열, 연료, 산소가 불이 붙을 수 있는 조건에서 만날 때 발생해요. 사람의 활동은 이 세 요소를 만나게 하여 산불 위험을 높일 수 있어요.',
  'A forest fire can occur when sufficient heat, fuel, and oxygen meet under conditions that allow fire to ignite. Human activities can bring these three elements together, increasing the risk of fire.':
      '산불은 충분한 열, 연료, 산소가 불이 붙을 수 있는 조건에서 만날 때 발생해요. 사람의 활동은 이 세 요소를 만나게 하여 산불 위험을 높일 수 있어요.',
  'Kebakaran hutan merusak lingkungan dan menimbulkan kerugian ekologis, ekonomi, sosial budaya, serta politik. Kerusakan tersebut mengganggu kemampuan hutan untuk menjalankan fungsinya dengan baik.':
      '산불은 환경을 파괴하고 생태적, 경제적, 사회문화적, 정치적 피해를 일으켜요. 이러한 피해는 숲이 제 기능을 제대로 수행하는 능력을 방해해요.',
  'Forest fires damage the environment and cause ecological, economic, socio-cultural, and political losses. Such damage disrupts the forest’s ability to perform its functions properly.':
      '산불은 환경을 파괴하고 생태적, 경제적, 사회문화적, 정치적 피해를 일으켜요. 이러한 피해는 숲이 제 기능을 제대로 수행하는 능력을 방해해요.',
  'Mencegah Kebakaran Lebih Baik daripada Memadamkan.': '화재 예방이 진압보다 낫습니다.',
  'Preventing Fires Is Better Than Fighting Them.': '화재 예방이 진압보다 낫습니다.',
  'What is a forest fire?': '산불이란 무엇일까요?',
  'Apa itu karhutla?': '산불이란 무엇일까요?',
  'Why does it matter?': '왜 예방해야 할까요?',
  'Mengapa perlu dicegah?': '왜 예방해야 할까요?',
  'Prevent it early.': '미리 예방해요.',
  'Cegah sebelum membesar.': '미리 예방해요.',
  'CHAPTER 2 / FOREST FIRE': '2장 / 산불이란?',
  'BABAK 2 / KARHUTLA': '2장 / 산불이란?',
  'See the Risk': '위험 확인하기',
  'Lihat Risikonya': '위험 확인하기',
  'Continue': '계속',
  'Lanjut': '계속',
  'Wet forest': '습한 숲',
  'Hutan basah': '습한 숲',
  'Dry vegetation with an ignition source': '마른 식물과 불씨',
  'Tanaman kering di dekat sumber api': '마른 식물과 불씨',
  'Wet grassland': '비에 젖은 풀밭',
  'Padang rumput basah': '비에 젖은 풀밭',
  'CHAPTER 1 / PUT IT TOGETHER': '1장 / 불의 세 요소',
  'BABAK 1 / SATUKAN TIGA UNSUR': '1장 / 불의 세 요소',
  'The fire has started.': '불이 붙었어요.',
  'Api mulai menyala.': '불이 붙었어요.',
  'Build the fire triangle.': '불의 세 요소를 모아 보세요.',
  'Susun tiga unsur api.': '불의 세 요소를 모아 보세요.',
  'All three elements are now together.':
      '세 요소가 모두 모였어요. 충분한 열이 마른 연료에 닿으면 불이 붙어요.',
  'Ketiga unsur sudah lengkap. Dengan panas yang cukup untuk menyulut bahan bakar, api bisa menyala.':
      '세 요소가 모두 모였어요. 충분한 열이 마른 연료에 닿으면 불이 붙어요.',
  'That fits. Find the next element.': '잘 맞았어요. 다음 요소를 찾아보세요.',
  'Sudah cocok. Lanjutkan dengan foto lainnya.': '잘 맞았어요. 다음 요소를 찾아보세요.',
  'Try another element for that card.': '이 카드에는 다른 요소를 놓아 보세요.',
  'Foto ini belum cocok di sini. Coba tempat lain atau pilih foto lainnya.':
      '이 카드에는 다른 요소를 놓아 보세요.',
  'Drag each photo to its element.': '사진을 알맞은 요소에 끌어다 놓으세요.',
  'Seret foto dari bawah ke tempat yang cocok.': '사진을 알맞은 요소에 끌어다 놓으세요.',
  'CHAPTER 1 / FIRE TRIANGLE': '1장 / 불의 삼요소',
  'BABAK 1 / SEGITIGA API': '1장 / 불의 삼요소',
  'Three elements, one fire.': '불이 타려면 세 요소가 필요해요.',
  'Tiga unsur, satu api.': '불이 타려면 세 요소가 필요해요.',
  'Together, they form the fire triangle.': '열, 연료, 산소를 불의 삼요소라고 해요.',
  'Ketiganya dikenal sebagai segitiga api.': '열, 연료, 산소를 불의 삼요소라고 해요.',
  'Try Reducing an Element': '요소 하나 줄여 보기',
  'Coba Kurangi Satu Unsur': '요소 하나 줄여 보기',
  'Less heat, a weaker flame.': '열이 줄면 불꽃도 약해져요.',
  'Suhu turun, api mereda.': '열이 줄면 불꽃도 약해져요.',
  'Gaps interrupt the spread.': '마른 연료 사이에 간격을 두면 불길이 번지기 어려워요.',
  'Beri jarak agar api sulit menjalar.': '마른 연료 사이에 간격을 두면 불길이 번지기 어려워요.',
  'CHAPTER 3 / FIND THE CAUSE': '3장 / 원인 찾기',
  'BABAK 3 / CARI PENYEBAB': '3장 / 원인 찾기',
  'Human activity': '사람의 행동',
  'Aktivitas manusia': '사람의 행동',
  'Natural factor': '자연 현상',
  'Faktor alam': '자연 현상',
  'CHAPTER 4 / MAKE A CHOICE': '4장 / 안전한 선택',
  'BABAK 4 / PILIH TINDAKAN': '4장 / 안전한 선택',
  'Stop the spread.': '불길이 번지지 않게 해요.',
  'Batasi rambatan api.': '불길이 번지지 않게 해요.',
  'Preparing challenge…': '도전을 준비하고 있어요…',
  'Menyiapkan tantangan…': '도전을 준비하고 있어요…',
  'Spot the fire risks.': '산불 위험 요소를 찾아보세요.',
  'Temukan risiko kebakaran.': '산불 위험 요소를 찾아보세요.',
  'Complete': '완료',
  'Selesai': '완료',
  'See Overall Result': '전체 결과 보기',
  'Lihat Hasil Akhir': '전체 결과 보기',
  'Time’s up. Review your choices and the risks you missed.':
      '시간이 끝났어요. 선택한 항목과 놓친 위험 요소를 확인해 보세요.',
  'Waktu habis. Cermati pilihanmu dan risiko yang masih terlewat.':
      '시간이 끝났어요. 선택한 항목과 놓친 위험 요소를 확인해 보세요.',
  'Choose the fire risks. Tap again to change your selection.':
      '산불 위험을 고르세요. 다시 누르면 선택을 취소할 수 있어요.',
  'Pilih gambar berisiko. Ketuk lagi untuk membatalkan pilihan.':
      '산불 위험을 고르세요. 다시 누르면 선택을 취소할 수 있어요.',
  'Home': '처음 화면',
  'Beranda': '처음 화면',
  'Back': '뒤로',
  'Kembali': '뒤로',
  'Restart': '다시 시작',
  'Ulangi': '다시 시작',
  'CHALLENGE COMPLETE': '도전 완료',
  'TANTANGAN SELESAI': '도전 완료',
  'Play Again': '다시 하기',
  'Main Lagi': '다시 하기',
  'Elements placed': '불의 요소 맞히기',
  'Menyusun unsur': '불의 요소 맞히기',
  'Recognising causes': '산불 원인 찾기',
  'Mengenali penyebab': '산불 원인 찾기',
  'Safe decision': '안전한 행동 고르기',
  'Memilih tindakan aman': '안전한 행동 고르기',
  'Final challenge bonus': '마지막 도전 보너스',
  'Bonus tantangan akhir': '마지막 도전 보너스',
  'Selected': '선택됨',
  'Dipilih': '선택됨',
  'Missed risk': '놓친 위험',
  'Risiko terlewat': '놓친 위험',
  'Correct risk': '위험 요소',
  'Benar, ini berisiko': '위험 요소',
  'Not a risk': '위험 요소 아님',
  'Gambar ini tidak berisiko': '위험 요소 아님',
  'Time remaining': '남은 시간',
  'Sisa waktu': '남은 시간',
  'sec': '초',
  'detik': '초',
  'Heat': '열',
  'Panas': '열',
  'Fuel': '연료',
  'Bahan bakar': '연료',
  'Oxygen': '산소',
  'Oksigen': '산소',
  'Dry vegetation': '마른 식물',
  'dry vegetation': '마른 식물',
  'Tanaman kering': '마른 식물',
  'Cigarette': '불붙은 담배꽁초',
  'Puntung rokok': '불붙은 담배꽁초',
  'Unattended fire': '방치된 불',
  'Api tanpa pengawasan': '방치된 불',
  'Dry wood': '마른 나무',
  'dry wood': '마른 나무',
  'Kayu kering': '마른 나무',
  'Rain': '비',
  'Hujan': '비',
  'Healthy vegetation': '수분이 충분한 숲',
  'Belum ada gambar yang dipilih. Perhatikan empat risiko yang kutandai di atas.':
      '아직 선택한 항목이 없어요. 위에서 표시된 위험 요소 네 가지를 찾아보세요.',
  'Keempat risiko sudah kamu temukan. Jauhkan sumber api dari tanaman dan kayu kering.':
      '위험 요소 네 가지를 모두 찾았어요. 불씨를 마른 풀과 나무에서 멀리하세요.',
  'Hujan bukan pemicu api.': '비는 불을 일으키지 않아요.',
  'Hutan basah lebih sulit terbakar.': '수분이 많은 숲은 불이 쉽게 붙지 않아요.',
  'Lihat juga risiko yang terlewat.': '놓친 위험 요소도 확인해 보세요.',
  ' Keep ignition sources away from dry plants and wood.':
      ' 불씨를 마른 풀과 나무에서 멀리하세요.',
  'Vegetation is burned to clear land while conditions are dry.':
      '건조한 날씨에 땅을 개간하려고 풀과 나무를 태워요.',
  'Tanaman dibakar untuk membuka lahan saat cuaca kering.':
      '건조한 날씨에 땅을 개간하려고 풀과 나무를 태워요.',
  'Burning vegetation to clear land is a human activity.':
      '땅을 개간하려고 식물을 태우는 것은 사람의 행동이에요.',
  'Membakar tanaman untuk membuka lahan bisa membuat api merambat ke sekitarnya.':
      '땅을 개간하려고 식물을 태우면 주변으로 불이 번질 수 있어요.',
  'A lit cigarette butt is thrown into dry grass.':
      '불이 꺼지지 않은 담배꽁초를 마른 풀밭에 버렸어요.',
  'Puntung rokok yang masih menyala dibuang ke rerumputan kering.':
      '불이 꺼지지 않은 담배꽁초를 마른 풀밭에 버렸어요.',
  'A lit cigarette carries heat that can ignite dry vegetation.':
      '불씨가 남은 담배꽁초는 마른 식물에 불을 붙일 수 있어요.',
  'Bara pada puntung rokok bisa menyulut rumput kering di sekitarnya.':
      '담배꽁초의 불씨가 주변의 마른 풀에 옮겨붙을 수 있어요.',
  'Lightning strikes very dry vegetation.': '번개가 바싹 마른 식물에 떨어졌어요.',
  'Petir menyambar tanaman yang sudah kering.': '번개가 바싹 마른 식물에 떨어졌어요.',
  'Lightning is a natural ignition source that can ignite dry vegetation.':
      '번개는 마른 식물에 불을 붙일 수 있는 자연 발화 원인이에요.',
  'Sambaran petir membawa panas yang bisa menyulut tanaman kering.':
      '번개는 마른 식물에 불을 붙일 수 있는 자연 발화 원인이에요.',
  'A small fire is left unattended near dry land.':
      '작은 불을 마른 땅 근처에 피워 두고 자리를 비웠어요.',
  'Api kecil dibiarkan tanpa pengawasan di dekat lahan kering.':
      '작은 불을 마른 땅 근처에 피워 두고 자리를 비웠어요.',
  'Leaving a fire unattended is a human action that can allow it to spread.':
      '불을 지켜보지 않고 두면 주변으로 번질 수 있어요.',
  'Api yang dibiarkan menyala bisa merambat ke bahan kering di sekitarnya.':
      '불을 지켜보지 않고 두면 주변의 마른 연료로 번질 수 있어요.',
  'Sun heat': '햇볕의 열',
  'Panas matahari': '햇볕의 열',
  'Oxygen from air': '공기 중 산소',
  'Oksigen dari udara': '공기 중 산소',
  'Water': '물',
  'Air': '물',
  'Cold air': '차가운 공기',
  'Udara dingin': '차가운 공기',
  'Choose the answer that fits the situation best.':
      '상황에 가장 알맞은 답을 골라 설명을 확인해 보세요.',
  'Pilih salah satu jawaban untuk melihat penjelasannya.':
      '상황에 가장 알맞은 답을 골라 설명을 확인해 보세요.',
  'The riskiest condition is dry vegetation with an ignition source. Dry fuel catches fire easily when heat is nearby.':
      '마른 식물 가까이에 불씨가 있으면 가장 위험해요. 마른 연료는 열원이 가까우면 쉽게 불이 붙어요.',
  'Kondisi paling berisiko adalah tanaman kering di dekat sumber api. Bahan kering mudah tersulut oleh panas.':
      '마른 식물 가까이에 불씨가 있으면 가장 위험해요. 마른 연료는 열원이 가까우면 쉽게 불이 붙어요.',
  'A forest or land fire burns vegetation such as grass, leaves, and trees. When it spreads out of control, it can reach nearby areas.':
      '산불은 풀과 낙엽, 나무 같은 식물을 태워요. 불길이 걷잡을 수 없이 번지면 주변 지역까지 피해를 줄 수 있어요.',
  'Karhutla adalah kebakaran hutan dan lahan. Api membakar rumput, daun, atau pepohonan dan bisa menjalar ke sekitarnya jika tidak terkendali.':
      '산불은 풀과 낙엽, 나무 같은 식물을 태워요. 불길이 걷잡을 수 없이 번지면 주변 지역까지 피해를 줄 수 있어요.',
  'You have seen how fire starts. What happens when it spreads?':
      '불이 어떻게 시작되는지 살펴봤어요. 불길이 번지면 어떤 일이 생길까요?',
  'Tadi kamu melihat api menyala. Bagaimana jika api itu menjalar?':
      '불이 어떻게 시작되는지 살펴봤어요. 불길이 번지면 어떤 일이 생길까요?',
  'Fire can damage habitats, and smoke can affect nearby communities. Preventing fires helps protect both forests and people.':
      '불은 야생동물의 보금자리를 망가뜨리고 연기는 주변 주민에게 피해를 줄 수 있어요. 산불 예방은 숲과 사람을 함께 지켜요.',
  'Api bisa merusak tempat hidup satwa, sementara asapnya mengganggu warga. Mencegah karhutla berarti menjaga hutan sekaligus melindungi kehidupan di sekitarnya.':
      '불은 야생동물의 보금자리를 망가뜨리고 연기는 주변 주민에게 피해를 줄 수 있어요. 산불 예방은 숲과 사람을 함께 지켜요.',
  'A fire harms more than the trees in its path.': '불은 나무뿐 아니라 숲에 사는 생명도 해쳐요.',
  'Api tidak hanya membakar pepohonan di jalurnya.':
      '불은 나무뿐 아니라 숲에 사는 생명도 해쳐요.',
  'Dry vegetation is easier to ignite when a source of heat is nearby. Keep ignition sources away. If you see a fire, keep your distance and alert trained personnel.':
      '마른 식물은 열원이 가까우면 쉽게 불이 붙어요. 불씨를 멀리하고, 불을 발견하면 가까이 가지 말고 훈련된 담당자에게 알리세요.',
  'Tanaman kering lebih mudah tersulut jika ada sumber api di dekatnya. Jauhkan sumber api dari bahan kering. Jika melihat kebakaran, jaga jarak dan laporkan kepada petugas.':
      '마른 식물은 열원이 가까우면 쉽게 불이 붙어요. 불씨를 멀리하고, 불을 발견하면 가까이 가지 말고 담당자에게 알리세요.',
  'Most forest fires can be stopped before they grow.': '산불은 커지기 전에 예방할 수 있어요.',
  'Sebagian besar karhutla bisa dicegah sebelum membesar.':
      '산불은 커지기 전에 예방할 수 있어요.',
  'Heat ignites fuel such as dry wood. Oxygen from the air keeps it burning. Sunlight can dry vegetation, but it still needs an ignition source to catch fire.':
      '열은 마른 나무 같은 연료에 불을 붙여요. 공기 중 산소는 불이 계속 타도록 도와요. 햇볕이 식물을 말릴 수는 있지만, 불이 붙으려면 발화 원인이 필요해요.',
  'Panas menyulut bahan bakar, seperti kayu kering. Oksigen dari udara membantu api terus menyala. Matahari bisa mengeringkan tanaman, tetapi api tetap perlu sumber penyulut.':
      '열은 마른 나무 같은 연료에 불을 붙여요. 공기 중 산소는 불이 계속 타도록 도와요. 햇볕이 식물을 말릴 수는 있지만, 불이 붙으려면 발화 원인이 필요해요.',
  'Cooling burning material removes heat. When it is no longer hot enough to keep burning, the flame goes out.':
      '불타는 물질을 식히면 열이 줄어요. 계속 탈 만큼 뜨겁지 않으면 불꽃이 꺼져요.',
  'Bahan yang terbakar perlu didinginkan. Jika suhunya sudah cukup turun, api tak lagi bisa bertahan dan akan padam.':
      '불타는 물질을 식히면 열이 줄어요. 계속 탈 만큼 뜨겁지 않으면 불꽃이 꺼져요.',
  'With less dry material in its path, fire has less fuel to reach. Material already burning may still need to be extinguished.':
      '불길이 번지는 길에 마른 연료가 적으면 더 퍼지기 어려워요. 이미 타고 있는 물질은 따로 꺼야 할 수 있어요.',
  'Jika bahan kering diberi jarak, api lebih sulit menjalar. Bahan yang sudah terbakar tetap perlu dipadamkan.':
      '불길이 번지는 길에 마른 연료가 적으면 더 퍼지기 어려워요. 이미 타고 있는 물질은 따로 꺼야 할 수 있어요.',
  'Fire needs oxygen from the air.': '불은 공기 중 산소가 있어야 타요.',
  'Api perlu oksigen dari udara.': '불은 공기 중 산소가 있어야 타요.',
  'Limiting oxygen at the flame can smother it. This is difficult in open land; still air alone does not remove oxygen.':
      '불꽃에 닿는 산소를 줄이면 불을 끌 수 있어요. 탁 트인 곳에서는 어렵고, 바람이 멈춰도 공기 중 산소는 그대로 있어요.',
  'Membatasi oksigen bisa memadamkan api, tetapi sulit di lahan terbuka. Tanpa angin pun, udara tetap mengandung oksigen.':
      '불꽃에 닿는 산소를 줄이면 불을 끌 수 있어요. 탁 트인 곳에서는 어렵고, 바람이 멈춰도 공기 중 산소는 그대로 있어요.',
  'Three elements keep fire burning.': '불이 계속 타려면 세 요소가 필요해요.',
  'Bagaimana kalau satu unsur dikurangi?': '요소 하나를 줄이면 어떻게 될까요?',
  'Explore each element to see why reducing it can weaken the fire or slow its spread.':
      '요소를 하나씩 줄여 보며 불이 약해지거나 번지는 속도가 느려지는지 살펴보세요.',
  'Api perlu ketiga unsur ini agar terus menyala. Saat satu unsur berkurang, nyala atau rambatannya bisa ikut berkurang.':
      '요소를 하나씩 줄여 보며 불이 약해지거나 번지는 속도가 느려지는지 살펴보세요.',
  'CHAPTER 1 / INTERACTIVE DEMO': '1장 / 요소 줄여 보기',
  'BABAK 1 / DEMO INTERAKTIF': '1장 / 요소 줄여 보기',
  'Touch an element and watch the flame change. You can try all three.':
      '요소를 눌러 불꽃이 어떻게 달라지는지 살펴보세요. 세 가지 모두 해 볼 수 있어요.',
  'Pilih unsur yang ingin dikurangi, lalu amati apinya. Kamu bisa mencoba ketiganya.':
      '요소를 눌러 불꽃이 어떻게 달라지는지 살펴보세요. 세 가지 모두 해 볼 수 있어요.',
  'You tried all three elements. Next, see how fires start in the field.':
      '세 요소를 모두 확인했어요. 이제 현장에서 불이 어떻게 시작되는지 살펴봐요.',
  'Ketiga unsur sudah kamu coba. Sekarang kita lihat bagaimana karhutla bisa terjadi.':
      '세 요소를 모두 확인했어요. 이제 현장에서 불이 어떻게 시작되는지 살펴봐요.',
  'Risk can come from people or nature. The best prevention happens before there is a flame.':
      '산불은 사람의 행동이나 자연 현상으로 시작될 수 있어요. 불이 나기 전에 예방하는 것이 가장 좋아요.',
  'Kebakaran bisa dipicu manusia maupun alam. Mencegahnya lebih baik daripada memadamkannya.':
      '산불은 사람의 행동이나 자연 현상으로 시작될 수 있어요. 불이 나기 전에 예방하는 것이 가장 좋아요.',
  'What most likely triggered this risk?': '무엇이 산불 위험을 일으켰을까요?',
  'Apa penyebabnya?': '무엇이 산불 위험을 일으켰을까요?',
  'Read the situation, then choose where the trigger came from.':
      '상황을 읽고 원인이 어디에서 비롯됐는지 골라 보세요.',
  'Baca situasinya. Apakah api dipicu aktivitas manusia atau faktor alam?':
      '상황을 읽고 원인이 어디에서 비롯됐는지 골라 보세요.',
  'Correct. ': '맞아요. ',
  'The answer is ': '정답은 ',
  'Separate the fuel': '연료를 분리해요',
  'Pisahkan bahan bakar': '연료를 분리해요',
  'Move closer to the fire': '불 가까이 다가가요',
  'Dekati api': '불 가까이 다가가요',
  'Add more fuel': '연료를 더해요',
  'Tambahkan bahan bakar': '연료를 더해요',
  'The fuel break stops further spread in this simulation. In a real incident, keep your distance and contact trained personnel.':
      '이 시뮬레이션에서는 연료 사이를 끊어 불길이 더 번지지 않게 했어요. 실제 화재에서는 거리를 두고 훈련된 담당자에게 연락하세요.',
  'Bahan bakar yang terpisah membuat api sulit menjalar. Jika melihat kebakaran, jaga jarak dan hubungi petugas terlatih.':
      '연료 사이를 끊으면 불길이 더 번지기 어려워요. 실제 화재에서는 거리를 두고 훈련된 담당자에게 연락하세요.',
  'Which action should trained personnel take?': '훈련된 담당자는 어떤 조치를 해야 할까요?',
  'Apa yang bisa dilakukan petugas terlatih agar api tidak terus menjalar?':
      '훈련된 담당자는 어떤 조치를 해야 할까요?',
  'Not quite. Think about what keeps the fire from reaching more material. You get one more try.':
      '다시 생각해 보세요. 불이 다른 연료에 닿지 않게 하려면 어떻게 해야 할까요? 한 번 더 선택할 수 있어요.',
  'Belum tepat. Pikirkan tindakan yang membuat api sulit mencapai bahan lain. Kamu masih punya satu kesempatan lagi.':
      '다시 생각해 보세요. 불이 다른 연료에 닿지 않게 하려면 어떻게 해야 할까요? 한 번 더 선택할 수 있어요.',
  'BREAK': '방화선',
  'SEKAT': '방화선',
  'Drop here': '여기에 놓기',
  'Taruh di sini': '여기에 놓기',
  'Do not approach a real fire. Report it and follow trained personnel.':
      '실제 화재에 가까이 가지 마세요. 신고하고 훈련된 담당자의 안내를 따르세요.',
  'Jika melihat kebakaran, jaga jarak. Laporkan kepada petugas dan ikuti arahannya.':
      '실제 화재에 가까이 가지 마세요. 신고하고 담당자의 안내를 따르세요.',
  'Waktu habis.': '시간이 끝났어요.',
  ' images selected': '개 선택됨',
  ' gambar dipilih': '개 선택됨',
  ' → +': ' → +',
  ' / 9 points': ' / 9점',
  ' / 9 poin': ' / 9점',
  'Tantangan\nCegah Karhutla': '산불 예방\n챌린지',
  'JELAJAHI HUTAN & GAMBUT': '숲과 이탄지 둘러보기',
  'EXPLORE FORESTS & PEATLANDS': '숲과 이탄지 둘러보기',
  'Choose one object.': '물체 하나를 선택하세요.',
  'Pilih satu objek.': '물체 하나를 선택하세요.',
  'Tap the matching element.': '알맞은 요소를 누르세요.',
  'Ketuk unsur yang sesuai.': '알맞은 요소를 누르세요.',
  'Correct': '정답',
  'Benar': '정답',
  'Try again': '다시 해 보세요',
  'Coba lagi.': '다시 해 보세요.',
  'Back to Welcome': '처음 화면으로',
  'Kembali ke Beranda': '처음 화면으로',
  'Fire Prevention Hero': '산불 예방 지킴이',
  'Siap Cegah Karhutla': '산불 예방 지킴이',
  'Fire Awareness Champion': '산불 안전 챔피언',
  'Makin Paham Risikonya': '산불 안전 챔피언',
  'Keep Exploring': '계속 알아봐요',
  'Ayo, Coba Lagi': '계속 알아봐요',
  'Closing Message': '마무리 인사',
  'Final challenge': '마지막 도전',
  'Final result': '최종 결과',
  'SCORE': '점수',
  'POIN': '점수',
  'You spotted ': '찾은 위험 요소: ',
  ' sudah kamu temukan. ': '을(를) 찾았어요. ',
  'You did not choose any pictures. Look for the four risks marked above.':
      '선택한 항목이 없어요. 위에 표시된 위험 요소 네 가지를 찾아보세요.',
  'You found all four risks. Keep ignition sources away from dry plants and wood.':
      '위험 요소 네 가지를 모두 찾았어요. 불씨를 마른 풀과 나무에서 멀리하세요.',
  'Rain and wet forest are not risks in this scene.':
      '이 장면에서 비와 습한 숲은 위험 요소가 아니에요.',
  'Hujan dan hutan basah bukan risiko pada contoh ini.':
      '이 장면에서 비와 습한 숲은 위험 요소가 아니에요.',
  'Wet forest is harder to ignite.': '수분이 많은 숲은 쉽게 불이 붙지 않아요.',
  'Rain does not start a fire.': '비는 불을 일으키지 않아요.',
  'Review the risks you missed.': '놓친 위험 요소도 확인해 보세요.',
  'A lit cigarette can ignite dry fuel.': '불이 남은 담배꽁초는 마른 연료에 불을 붙일 수 있어요.',
  'Puntung rokok yang masih menyala dapat menyulut bahan kering.':
      '불이 남은 담배꽁초는 마른 연료에 불을 붙일 수 있어요.',
  'An unattended fire can spread to dry material.': '방치된 불은 마른 연료로 번질 수 있어요.',
  'Api yang dibiarkan bisa merambat ke bahan kering.':
      '방치된 불은 마른 연료로 번질 수 있어요.',
  'Dry vegetation and wood can burn easily.': '마른 풀과 나무는 쉽게 불이 붙어요.',
  'Tanaman dan kayu kering mudah terbakar.': '마른 풀과 나무는 쉽게 불이 붙어요.',
  'Choose the risks': '위험 요소를 골라 보세요',
  'Pilih gambar berisiko': '위험 요소를 골라 보세요',
  'The fire is burning. Moving on to the fire triangle…':
      '불이 붙었어요. 이제 불의 삼요소를 살펴봐요…',
  'Reduce one element.': '요소 하나를 줄여 보세요.',
  'Moving closer puts you in danger. Keep your distance and alert trained personnel. They can separate fuel to limit the spread.':
      '불에 가까이 가면 위험해요. 거리를 두고 훈련된 담당자에게 알리세요. 담당자는 연료를 분리해 불길이 번지는 것을 막을 수 있어요.',
  'More fuel helps the fire spread. Trained personnel can separate fuel to limit it. Keep away from a real fire.':
      '연료가 많아지면 불이 더 번질 수 있어요. 실제 화재에 가까이 가지 말고 훈련된 담당자에게 알리세요.',
  'Here is your result. Keep exploring the exhibition.':
      '결과를 확인하고 전시를 더 둘러보세요.',
  'Keep ignition sources away from dry fuel. Report signs of fire and follow trained personnel.':
      '불씨를 마른 연료에서 멀리하세요. 불을 발견하면 신고하고 담당자의 안내를 따르세요.',
  'Protect forests.\nProtect lives.': '숲을 지키고\n생명을 지켜요.',
  'Thanks for playing! Keep fire away from dry vegetation. If you see a fire, report it to trained personnel.':
      '함께해 줘서 고마워요! 불씨를 마른 식물에서 멀리하세요. 불을 발견하면 담당자에게 알려 주세요.',
  'Cooperation, knowledge and innovation for forest and land fire prevention.':
      '협력과 지식, 혁신으로 산불을 예방합니다.',
  'Explore the Exhibition': '전시 둘러보기',
  'Jelajahi Pameran': '전시 둘러보기',
  'FIELD SITUATION ': '현장 상황 ',
  'SITUASI ': '현장 상황 ',
  'CHAPTER 3 / CLUE ': '3장 / 단서 ',
  'BABAK 3 / SITUASI ': '3장 / 상황 ',
  ' OF 4': ' / 4',
  ' DARI 4': ' / 4',
  'Fire Triangle Complete': '불의 삼요소 완성',
  'Segitiga Api Lengkap': '불의 삼요소 완성',
  'Fire needs heat, fuel, and oxygen. Reducing any one of them helps prevent fire.':
      '불이 타려면 열, 연료, 산소가 필요해요. 요소 하나를 줄이면 불을 예방하는 데 도움이 돼요.',
  'Api membutuhkan panas, bahan bakar, dan oksigen. Mengurangi salah satunya membantu mencegah kebakaran.':
      '불이 타려면 열, 연료, 산소가 필요해요. 요소 하나를 줄이면 불을 예방하는 데 도움이 돼요.',
  'Controlled-fire demonstration': '관리되는 불 시연',
  'Keep peatlands wet\nIn peatlands, prevention starts with maintaining moisture and avoiding ignition sources.':
      '이탄지를 촉촉하게\n이탄지는 습기를 유지하고 불씨를 피하는 것부터 산불 예방이 시작돼요.',
  'Jaga gambut tetap basah\nDi lahan gambut, pencegahan dimulai dengan menjaga kelembapan dan menghindari sumber api.':
      '이탄지를 촉촉하게\n이탄지는 습기를 유지하고 불씨를 피하는 것부터 산불 예방이 시작돼요.',
  'Sound settings': '소리 설정',
  'Pengaturan suara': '소리 설정',
  'Sound': '소리',
  'Suara': '소리',
  'Set a comfortable listening level.': '편안하게 들리는 크기로 조절하세요.',
  'Atur suara agar nyaman didengar.': '편안하게 들리는 크기로 조절하세요.',
  'Sound on': '소리 켜기',
  'Suara aktif': '소리 켜기',
  'Overall volume': '전체 음량',
  'Volume utama': '전체 음량',
  'Music': '음악',
  'Musik': '음악',
  'Forest sounds': '숲의 소리',
  'Suasana hutan': '숲의 소리',
  'Interaction effects': '효과음',
  'Efek interaksi': '효과음',
  'Sound could not start. Tap to try again.': '소리를 재생하지 못했어요. 다시 시도해 주세요.',
  'Suara belum bisa diputar. Sentuh untuk mencoba lagi.':
      '소리를 재생하지 못했어요. 다시 시도해 주세요.',
  'Try sound again': '소리 다시 재생',
  'Coba suara lagi': '소리 다시 재생',
  'No sound needed. All instructions appear on screen.': '화면에 안내가 표시됩니다.',
  'Tanpa suara. Semua instruksi tampil di layar.': '화면에 안내가 표시됩니다.',
  'Tap an object, then a slot. You can also drag.':
      '물체를 누른 다음 알맞은 칸을 누르세요. 끌어다 놓아도 돼요.',
  'Ketuk objek, lalu kolom yang sesuai.': '물체를 누른 다음 알맞은 칸을 누르세요. 끌어다 놓아도 돼요.',
  'Choose objects that keep a fire burning.': '불이 계속 타게 하는 요소를 골라 보세요.',
  'Pilih objek yang membuat api tetap menyala.': '불이 계속 타게 하는 요소를 골라 보세요.',
  'Choose an object': '물체를 선택하세요',
  'Pilih objek': '물체를 선택하세요',
  'Wind brings air that contains oxygen.': '바람은 산소가 포함된 공기를 움직여요.',
  'Angin membawa udara yang mengandung oksigen.': '바람은 산소가 포함된 공기를 움직여요.',
  'Correct. Heat helps the combustion process.': '맞아요. 열은 연소를 돕습니다.',
  'Benar. Panas membantu proses pembakaran.': '맞아요. 열은 연소를 돕습니다.',
  'Try again. Rainwater helps keep fuel wet.': '다시 해 보세요. 빗물은 연료를 젖은 상태로 유지해요.',
  'Coba lagi. Air hujan membantu menjaga bahan bakar tetap basah.':
      '다시 해 보세요. 빗물은 연료를 젖은 상태로 유지해요.',
  'Complete the Fire Triangle.': '불의 삼요소를 완성하세요.',
  'Lengkapi Segitiga Api.': '불의 삼요소를 완성하세요.',
  'Arrange the three elements of fire, then discover how to protect forest and land from fire.':
      '불의 세 요소를 맞춰 보고, 산불로부터 숲과 땅을 지키는 방법을 알아보세요.',
  'Susun tiga unsur api, lalu temukan cara melindungi hutan dan lahan dari kebakaran.':
      '불의 세 요소를 맞춰 보고, 산불로부터 숲과 땅을 지키는 방법을 알아보세요.',
  'Three elements. One\nchallenge.': '세 가지 요소, 하나의\n도전.',
  'Tiga unsur. Satu\ntantangan.': '세 가지 요소, 하나의\n도전.',
  'Discover what keeps fire burning. Choose, match, then learn how to prevent it.':
      '불이 계속 타는 이유를 알아보세요. 요소를 맞추고 산불 예방법을 배워요.',
  'Kenali unsur yang membuat api menyala. Pilih, cocokkan, lalu pelajari pencegahannya.':
      '불이 계속 타는 이유를 알아보세요. 요소를 맞추고 산불 예방법을 배워요.',
  'TANTANGAN SELESAI / HASIL': '도전 완료 / 결과',
  'Lihat hasilmu, lalu lanjut jelajahi pameran.': '결과를 확인하고 전시를 더 둘러보세요.',
  'CHALLENGE COMPLETE / RESULT': '도전 완료 / 결과',
  'Pilih tindakan': '행동을 선택하세요',
  'Wind': '바람',
  'Angin': '바람',
  'Solar heat': '햇볕의 열',
  'Dry grass': '마른 풀',
  'Rumput kering': '마른 풀',
  'Rainwater': '빗물',
  'Air hujan': '빗물',
  'Wet soil': '젖은 흙',
  'Tanah basah': '젖은 흙',
  '8.5': '8.5',
  'point': '점',
  'poin': '점',
  'ENGLISH': '영어',
  'INDONESIA': '인도네시아어',
  'Indonesia peat swamp forest\nMorning light, still water, dense vegetation':
      '인도네시아 이탄지 숲\n아침 햇살과 잔잔한 물, 울창한 숲',
  'Hutan rawa gambut Indonesia\nCahaya pagi, air tenang, vegetasi rapat':
      '인도네시아 이탄지 숲\n아침 햇살과 잔잔한 물, 울창한 숲',
  'Water and vegetation in a peat forest': '이탄지 숲의 물과 식생',
  'Start': '시작',
  'Mulai': '시작',
  'Fire Prevention Challenge': '산불 예방 챌린지',
  'Korea–Indonesia Forest Cooperation Center': '한·인도네시아 산림협력센터',
  'Petugas terlatih': '훈련된 담당자',
  'Cigarette butt': '불붙은 담배꽁초',
  'cigarette butt': '불붙은 담배꽁초',
  'Puntung menyala': '불붙은 담배꽁초',
  'Uncontrolled fire': '걷잡을 수 없는 불',
  'uncontrolled fire': '걷잡을 수 없는 불',
  'Api tak terkendali': '걷잡을 수 없는 불',
  'At least one element is needed to complete the fire triangle.':
      '불의 삼요소를 완성하려면 요소를 하나 이상 맞혀야 해요.',
  'Choose all fire risks before the countdown ends.':
      '카운트다운이 끝나기 전에 산불 위험 요소를 모두 골라 보세요.',
  'Pilih semua risiko kebakaran sebelum waktu habis.':
      '카운트다운이 끝나기 전에 산불 위험 요소를 모두 골라 보세요.',
  '2/4 challenge points → +0.5 bonus': '마지막 도전 2/4점 · 보너스 +0.5점',
  '3/4 challenge points → +0.75 bonus': '마지막 도전 3/4점 · 보너스 +0.75점',
  '2/4 poin di babak akhir = 0,5 poin bonus': '마지막 도전 2/4점 · 보너스 +0.5점',
  '3/4 poin di babak akhir = 0,75 poin bonus': '마지막 도전 3/4점 · 보너스 +0.75점',
  'Jaga hutan,\njaga kehidupan.': '숲을 지키고\n생명을 지켜요.',
  'Terima kasih sudah bermain! Jauhkan sumber api dari bahan kering. Jika melihat kebakaran, segera laporkan kepada petugas.':
      '함께해 줘서 고마워요! 불씨를 마른 식물에서 멀리하세요. 불을 발견하면 담당자에게 알려 주세요.',
  'Kerja sama, pengetahuan, dan inovasi untuk mencegah kebakaran hutan dan lahan.':
      '협력과 지식, 혁신으로 산불을 예방합니다.',
  'The safe action is to separate the fuel.': '안전한 방법은 연료를 분리하는 거예요.',
  'Tindakan aman adalah memisahkan bahan bakar.': '안전한 방법은 연료를 분리하는 거예요.',
  'Moving closer puts you in danger.': '불에 가까이 가면 위험해요.',
  'Mendekati api berbahaya.': '불에 가까이 가면 위험해요.',
  'More fuel helps the fire spread.': '연료가 많아지면 불이 더 번질 수 있어요.',
  'Menambah bahan bakar justru bisa memperbesar api.':
      '연료가 많아지면 불이 더 번질 수 있어요.',
  'Oxygen in air supports fire.': '공기 중 산소는 불이 타도록 도와요.',
  'Oksigen di udara mendukung api.': '공기 중 산소는 불이 타도록 도와요.',
  'Energy to start a fire.': '불을 시작하게 하는 열에너지예요.',
  'Energi untuk memulai api.': '불을 시작하게 하는 열에너지예요.',
  'Material that can burn.': '불에 탈 수 있는 물질이에요.',
  'Material yang dapat terbakar.': '불에 탈 수 있는 물질이에요.',
  'Build the Fire Triangle': '불의 삼요소 맞추기',
  'Bangun Segitiga Api': '불의 삼요소 맞추기',
  'FIRE PREVENTION HERO': '산불 예방 지킴이',
  'FIRE AWARENESS CHAMPION': '산불 안전 챔피언',
  'KEEP EXPLORING': '계속 알아봐요',
  'Your score': '내 점수',
  'Skor kamu': '내 점수',
  'Fuel break · further spread stops': '방화선으로 불길의 확산을 막았어요',
  'Bahan bakar terpisah · api sulit menjalar': '연료 사이를 끊어 불길의 확산을 막았어요',
  'More fuel · fire spreads further': '연료가 많아져 불길이 더 번져요',
  'Bahan bakar bertambah · api makin menjalar': '연료가 많아져 불길이 더 번져요',
  'SIMULATION · fire spreads through nearby fuel': '시뮬레이션 · 불길이 주변 연료로 번져요',
  'SIMULASI · api menjalar ke bahan kering': '시뮬레이션 · 불길이 주변 연료로 번져요',
  'One element reduced': '요소 하나를 줄였어요',
  'Satu unsur berkurang': '요소 하나를 줄였어요',
  'No images were selected. Look at the four risks marked above.':
      '아직 선택한 항목이 없어요. 위에 표시된 위험 요소 네 가지를 찾아보세요.',
  'You found all four risks.': '위험 요소 네 가지를 모두 찾았어요.',
  'Check the missed risks too.': '놓친 위험 요소도 확인해 보세요.',
  ' Check the missed risks too.': ' 놓친 위험 요소도 확인해 보세요.',
  'A cigarette that is still lit can ignite dry fuel. That is one of the risks you missed.':
      '불씨가 남은 담배꽁초는 마른 연료에 불을 붙일 수 있어요. 놓친 위험 요소 중 하나예요.',
  'Puntung yang masih menyala bisa menyulut bahan kering. Itu salah satu risiko yang terlewat.':
      '불씨가 남은 담배꽁초는 마른 연료에 불을 붙일 수 있어요. 놓친 위험 요소 중 하나예요.',
  'Uncontrolled fire can spread. Look at the image you have not selected.':
      '걷잡을 수 없는 불은 번질 수 있어요. 아직 선택하지 않은 사진을 살펴보세요.',
  'Api yang tidak terkendali dapat merambat. Perhatikan gambar yang belum kamu pilih.':
      '걷잡을 수 없는 불은 번질 수 있어요. 아직 선택하지 않은 사진을 살펴보세요.',
  'Dry plants and wood can burn easily. Look at the missed risks marked above.':
      '마른 풀과 나무는 쉽게 불이 붙어요. 위에 표시된 위험 요소를 살펴보세요.',
  'Tanaman dan kayu kering mudah terbakar. Cermati juga risiko yang kutandai di atas.':
      '마른 풀과 나무는 쉽게 불이 붙어요. 위에 표시된 위험 요소를 살펴보세요.',
  'Rain and wet forest are not risks in these examples.':
      '이 장면에서 비와 습한 숲은 위험 요소가 아니에요.',
  '1/4 challenge points → +0.25 bonus': '마지막 도전 1/4점 · 보너스 +0.25점',
  '4/4 challenge points → +1 bonus': '마지막 도전 4/4점 · 보너스 +1점',
  'FIELD SITUATION 1': '현장 상황 1',
  'FIELD SITUATION 2': '현장 상황 2',
  'FIELD SITUATION 3': '현장 상황 3',
  'FIELD SITUATION 4': '현장 상황 4',
  'SITUASI 1': '현장 상황 1',
  'SITUASI 2': '현장 상황 2',
  'SITUASI 3': '현장 상황 3',
  'SITUASI 4': '현장 상황 4',
  'CHAPTER 4 / FINAL CHALLENGE': '4장 / 마지막 도전',
  'BABAK 4 / TANTANGAN AKHIR': '4장 / 마지막 도전',
  'Use the photos to identify fire risks.': '사진에서 산불 위험 요소를 찾아보세요.',
  'Look at the selected risks before continuing.': '선택한 위험 요소를 살펴본 뒤 계속하세요.',
  'HOME': '처음 화면',
  'RESET': '다시 시작',
  'Tap to restart': '눌러서 다시 시작',
  'Ketuk untuk mengulang': '눌러서 다시 시작',
  'PHOTO': '사진',
  'Api menyala. Lanjut ke segitiga api…': '불이 붙었어요. 이제 불의 삼요소를 살펴봐요…',
  'Kurangi satu unsur.': '요소 하나를 줄여 보세요.',
  'Mendekati api berbahaya. Petugas terlatih bisa memisahkan bahan bakar agar api sulit menjalar. Jika melihat kebakaran, jaga jarak dan laporkan.':
      '불에 가까이 가면 위험해요. 거리를 두고 훈련된 담당자에게 알리세요. 담당자는 연료를 분리해 불길이 번지는 것을 막을 수 있어요.',
  'Menambah bahan bakar justru bisa memperbesar api. Petugas terlatih bisa memisahkannya agar api sulit menjalar. Tetap jaga jarak dari kebakaran.':
      '연료가 많아지면 불이 더 번질 수 있어요. 실제 화재에 가까이 가지 말고 훈련된 담당자에게 알리세요.',
  ' Lihat juga risiko yang terlewat.': ' 놓친 위험 요소도 확인해 보세요.',
  '/ 9 points': '/ 9점',
  '/ 9 poin': '/ 9점',
  'Jauhkan sumber api dari bahan yang mudah terbakar. Jika melihat kebakaran, laporkan dan ikuti arahan petugas.':
      '불씨를 마른 연료에서 멀리하세요. 불을 발견하면 신고하고 담당자의 안내를 따르세요.',
  'Indonesian peat swamp forest\nMorning light, still water, dense vegetation':
      '인도네시아 이탄지 숲\n아침 햇살과 잔잔한 물, 울창한 숲',
  'Jaga gambut tetap basah\nDi lahan gambut, pencegahan dimulai dari menjaga kelembapan dan menghindari sumber api.':
      '이탄지를 촉촉하게\n이탄지는 습기를 유지하고 불씨를 피하는 것부터 산불 예방이 시작돼요.',
};
