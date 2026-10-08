import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/kifc_theme.dart';

Duration _motionDuration(BuildContext context, Duration duration) =>
    MediaQuery.maybeOf(context)?.disableAnimations == true
    ? Duration.zero
    : duration;

class ExhibitionGame extends StatefulWidget {
  const ExhibitionGame({super.key});

  @override
  State<ExhibitionGame> createState() => _ExhibitionGameState();
}

class _ExhibitionGameState extends State<ExhibitionGame> {
  AppLocale _locale = AppLocale.indonesian;
  _Page _page = _Page.welcome;
  final Set<_LandCue> _observed = <_LandCue>{};
  _RiskOption? _riskAnswer;
  final Map<_FireSlot, _FirePiece> _triangle = <_FireSlot, _FirePiece>{};
  bool? _lastDropCorrect;
  _FireSlot? _breakChoice;
  int _causeIndex = 0;
  int _causePoints = 0;
  bool? _causeChoice;
  bool? _stopAnswer;
  final Set<_RiskToken> _finalFound = <_RiskToken>{};
  int _seconds = 10;
  Timer? _timer;
  Timer? _resetTimer;

  bool get _en => _locale == AppLocale.english;
  int get _trianglePoints => _triangle.length;
  int get _stopPoints =>
      (_stopAnswer == true ? 1 : 0) +
      (_finalFound.where((item) => item.risk).length == 4 ? 1 : 0);

  @override
  void dispose() {
    _timer?.cancel();
    _resetTimer?.cancel();
    super.dispose();
  }

  void _go(_Page page) => setState(() => _page = page);

  void _restart() {
    _timer?.cancel();
    _resetTimer?.cancel();
    setState(() {
      _page = _Page.welcome;
      _observed.clear();
      _riskAnswer = null;
      _triangle.clear();
      _lastDropCorrect = null;
      _breakChoice = null;
      _causeIndex = 0;
      _causePoints = 0;
      _causeChoice = null;
      _stopAnswer = null;
      _finalFound.clear();
      _seconds = 10;
    });
  }

  void _dropPiece(_FireSlot slot, _FirePiece piece) {
    if (_triangle.containsKey(slot)) return;
    setState(() {
      final correct = piece.slot == slot;
      _lastDropCorrect = correct;
      if (correct) _triangle[slot] = piece;
    });
  }

  void _chooseCause(bool humanCause) {
    setState(() => _causeChoice = humanCause);
  }

  void _advanceCause(bool correct) {
    setState(() {
      if (correct) _causePoints++;
      _causeIndex++;
      _causeChoice = null;
    });
  }

  void _openFinal() {
    _timer?.cancel();
    setState(() {
      _page = _Page.finalChallenge;
      _seconds = 10;
      _finalFound.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _page == _Page.finalChallenge) {
        _startFinalCountdown();
      }
    });
  }

  void _startFinalCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
        _timer = Timer(const Duration(milliseconds: 420), () {
          if (mounted) _go(_Page.score);
        });
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _openClosing() {
    _go(_Page.closing);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 12), _restart);
  }

  @override
  Widget build(BuildContext context) {
    final page = switch (_page) {
      _Page.welcome => _WelcomePage(
        locale: _locale,
        onLocale: (locale) => setState(() => _locale = locale),
        onStart: () => _go(_Page.observe),
      ),
      _Page.observe => _ObservePage(
        english: _en,
        observed: _observed,
        onObserve: (cue) => setState(() => _observed.add(cue)),
        onContinue: () => _go(_Page.risk),
        onBack: _restart,
      ),
      _Page.risk => _RiskPage(
        english: _en,
        answer: _riskAnswer,
        onAnswer: (answer) => setState(() => _riskAnswer = answer),
        onContinue: () => _go(_Page.triangleIntro),
        onBack: () => _go(_Page.observe),
      ),
      _Page.triangleIntro => _TriangleIntro(
        english: _en,
        onStart: () => _go(_Page.triangleBuild),
        onBack: () => _go(_Page.risk),
      ),
      _Page.triangleBuild => _TriangleBuild(
        english: _en,
        pieces: _triangle,
        lastDropCorrect: _lastDropCorrect,
        onDrop: _dropPiece,
        onContinue: () => _go(_Page.breakTriangle),
        onBack: () => _go(_Page.triangleIntro),
        onRestart: _restart,
      ),
      _Page.breakTriangle => _BreakTriangle(
        english: _en,
        selected: _breakChoice,
        onSelect: (slot) => setState(() => _breakChoice = slot),
        onContinue: () => _go(_Page.causeIntro),
        onBack: () => _go(_Page.triangleBuild),
      ),
      _Page.causeIntro => _CauseIntro(
        english: _en,
        onStart: () => _go(_Page.causeQuiz),
        onBack: () => _go(_Page.breakTriangle),
      ),
      _Page.causeQuiz => _CauseQuiz(
        english: _en,
        index: _causeIndex,
        points: _causePoints,
        choice: _causeChoice,
        onChoose: _chooseCause,
        onNext: _advanceCause,
        onFinish: () => _go(_Page.stopIntro),
        onBack: () => _go(_Page.causeIntro),
      ),
      _Page.stopIntro => _StopIntro(
        english: _en,
        onStart: () => _go(_Page.stopDecision),
        onBack: () => _go(_Page.causeQuiz),
      ),
      _Page.stopDecision => _StopDecision(
        english: _en,
        answer: _stopAnswer,
        onAnswer: (answer) => setState(() => _stopAnswer = answer),
        onContinue: _openFinal,
        onBack: () => _go(_Page.stopIntro),
      ),
      _Page.finalChallenge => _FinalChallenge(
        english: _en,
        seconds: _seconds,
        found: _finalFound,
        onTap: (token) => setState(() => _finalFound.add(token)),
        onBack: () {
          _timer?.cancel();
          _go(_Page.stopDecision);
        },
      ),
      _Page.score => _ScorePage(
        english: _en,
        triangle: _trianglePoints,
        causes: _causePoints,
        prevention: _stopPoints,
        onContinue: _openClosing,
        onAgain: _restart,
      ),
      _Page.closing => _ClosingPage(english: _en, onAgain: _restart),
    };
    return AnimatedSwitcher(
      duration: _motionDuration(context, const Duration(milliseconds: 320)),
      reverseDuration: _motionDuration(
        context,
        const Duration(milliseconds: 220),
      ),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(.025, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: KeyedSubtree(key: ValueKey(_page), child: page),
    );
  }
}

enum _Page {
  welcome,
  observe,
  risk,
  triangleIntro,
  triangleBuild,
  breakTriangle,
  causeIntro,
  causeQuiz,
  stopIntro,
  stopDecision,
  finalChallenge,
  score,
  closing,
}

enum _LandCue { sunlight, vegetation, air }

enum _FireSlot { heat, fuel, oxygen }

enum _FirePiece { heat, fuel, oxygen, water, rain, cold }

extension _FireCopy on _FireSlot {
  String title(bool en) => switch (this) {
    _FireSlot.heat => en ? 'Heat' : 'Panas',
    _FireSlot.fuel => en ? 'Fuel' : 'Bahan bakar',
    _FireSlot.oxygen => en ? 'Oxygen' : 'Oksigen',
  };
  String note(bool en) => switch (this) {
    _FireSlot.heat => en ? 'What starts the fire' : 'Pemicu awal api',
    _FireSlot.fuel => en ? 'What can burn' : 'Bahan yang mudah terbakar',
    _FireSlot.oxygen => en ? 'Comes from the air' : 'Berasal dari udara',
  };
  IconData get icon => switch (this) {
    _FireSlot.heat => Icons.wb_sunny_outlined,
    _FireSlot.fuel => Icons.forest_outlined,
    _FireSlot.oxygen => Icons.air,
  };
}

extension _PieceCopy on _FirePiece {
  _FireSlot? get slot => switch (this) {
    _FirePiece.heat => _FireSlot.heat,
    _FirePiece.fuel => _FireSlot.fuel,
    _FirePiece.oxygen => _FireSlot.oxygen,
    _ => null,
  };
  String label(bool en) => switch (this) {
    _FirePiece.heat => en ? 'Sun heat' : 'Panas matahari',
    _FirePiece.fuel => en ? 'Dry wood' : 'Kayu kering',
    _FirePiece.oxygen => en ? 'Oxygen from air' : 'Oksigen dari udara',
    _FirePiece.water => en ? 'Water' : 'Air',
    _FirePiece.rain => en ? 'Rain' : 'Hujan',
    _FirePiece.cold => en ? 'Cold air' : 'Udara dingin',
  };
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({
    required this.locale,
    required this.onLocale,
    required this.onStart,
  });
  final AppLocale locale;
  final ValueChanged<AppLocale> onLocale;
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: KifcTheme.forest950,
    body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const _Photo(tone: Color(0x9B0C2B1F)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _PartnerHeader(dark: true),
                const SizedBox(height: 18),
                _LanguagePicker(locale: locale, onChanged: onLocale),
                const SizedBox(height: 14),
                _VisualTag(
                  label: locale == AppLocale.english
                      ? 'Healthy peatland: calm water, protected vegetation'
                      : 'Lahan gambut sehat: air tenang, vegetasi terjaga',
                ),
                const Spacer(),
                const Text(
                  'KIFC EXHIBITION ROOM / MANGGALA AGNI',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Fire Prevention\nChallenge',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    height: 1.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  locale == AppLocale.english
                      ? 'Read the landscape, spot the trigger, and stop risk before it grows.'
                      : 'Baca lanskap, kenali pemicunya, lalu cegah risikonya sebelum membesar.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Text(
                  locale == AppLocale.english
                      ? '4 chapters • around 3 minutes • no sound needed'
                      : '4 babak • sekitar 3 menit • nyaman dimainkan tanpa suara',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 12),
                _Primary(
                  label: locale == AppLocale.english
                      ? 'Start Challenge'
                      : 'Mulai Tantangan',
                  icon: Icons.play_arrow_rounded,
                  onPressed: onStart,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _ObservePage extends StatelessWidget {
  const _ObservePage({
    required this.english,
    required this.observed,
    required this.onObserve,
    required this.onContinue,
    required this.onBack,
  });
  final bool english;
  final Set<_LandCue> observed;
  final ValueChanged<_LandCue> onObserve;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _DarkStage(
    chapter: 1,
    english: english,
    eyebrow: english
        ? 'CHAPTER 1 / READ THE LANDSCAPE'
        : 'BABAK 1 / BACA LANSKAP',
    title: english ? 'What do you notice?' : 'Apa yang kamu lihat?',
    subtitle: english
        ? 'There are three clues. Touch each one to see what can make fire easier to start.'
        : 'Ada tiga petunjuk. Sentuh satu per satu untuk melihat apa yang membuat api lebih mudah menyala.',
    onBack: onBack,
    body: _LandscapePanel(
      dry: observed.length == 3,
      children: <Widget>[
        _Hotspot(
          cue: _LandCue.sunlight,
          selected: observed.contains(_LandCue.sunlight),
          label: english
              ? 'Sunlight dries vegetation'
              : 'Matahari mengeringkan vegetasi',
          alignment: const Alignment(.68, -.46),
          onTap: () => onObserve(_LandCue.sunlight),
        ),
        _Hotspot(
          cue: _LandCue.vegetation,
          selected: observed.contains(_LandCue.vegetation),
          label: english
              ? 'Dry vegetation becomes fuel'
              : 'Vegetasi kering jadi bahan bakar',
          alignment: const Alignment(-.60, .08),
          onTap: () => onObserve(_LandCue.vegetation),
        ),
        _Hotspot(
          cue: _LandCue.air,
          selected: observed.contains(_LandCue.air),
          label: english ? 'Air carries oxygen' : 'Udara membawa oksigen',
          alignment: const Alignment(.58, .65),
          onTap: () => onObserve(_LandCue.air),
        ),
      ],
    ),
    footer: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          '${observed.length}/3 ${english ? 'clues found • no points yet' : 'petunjuk ditemukan • belum dinilai'}',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 10),
        _Primary(
          label: observed.length == 3
              ? (english ? 'See the Risk' : 'Lihat Risikonya')
              : (english ? 'Find 3 Clues' : 'Temukan 3 Petunjuk'),
          onPressed: observed.length == 3 ? onContinue : null,
        ),
      ],
    ),
  );
}

class _RiskPage extends StatelessWidget {
  const _RiskPage({
    required this.english,
    required this.answer,
    required this.onAnswer,
    required this.onContinue,
    required this.onBack,
  });
  final bool english;
  final _RiskOption? answer;
  final ValueChanged<_RiskOption> onAnswer;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 1,
    english: english,
    eyebrow: english
        ? 'CHAPTER 1 / SCAN THE RISK'
        : 'BABAK 1 / LIHAT KONDISINYA',
    title: english
        ? 'Where could fire start more easily?'
        : 'Di mana api lebih mudah mulai?',
    subtitle: english
        ? 'Choose the condition with the highest fire risk.'
        : 'Pilih kondisi yang paling mudah memicu kebakaran.',
    onBack: onBack,
    bodyScrollable: false,
    body: Column(
      children: <Widget>[
        _RiskCard(
          option: _RiskOption.wetForest,
          english: english,
          selected: answer == _RiskOption.wetForest,
          correct: false,
          onTap: () => onAnswer(_RiskOption.wetForest),
        ),
        const SizedBox(height: 8),
        _RiskCard(
          option: _RiskOption.dryVegetationWithIgnition,
          english: english,
          selected: answer == _RiskOption.dryVegetationWithIgnition,
          correct: true,
          onTap: () => onAnswer(_RiskOption.dryVegetationWithIgnition),
        ),
        const SizedBox(height: 8),
        _RiskCard(
          option: _RiskOption.wetGrassland,
          english: english,
          selected: answer == _RiskOption.wetGrassland,
          correct: false,
          onTap: () => onAnswer(_RiskOption.wetGrassland),
        ),
        if (answer != null) ...<Widget>[
          const SizedBox(height: 10),
          _Feedback(
            ok: answer == _RiskOption.dryVegetationWithIgnition,
            text: answer == _RiskOption.dryVegetationWithIgnition
                ? (english
                      ? 'That’s right. Dry fuel plus a spark or heat source raises the risk quickly.'
                      : 'Benar. Bahan kering yang bertemu panas atau percikan membuat risiko meningkat.')
                : (english
                      ? 'Try again. Look for dry fuel and something that can ignite it.'
                      : 'Coba lagi. Cari bahan yang kering dan sesuatu yang bisa memicunya.'),
          ),
        ],
      ],
    ),
    footer: _Primary(
      label: english ? 'See the Fire Triangle' : 'Lihat Segitiga Api',
      onPressed: answer == _RiskOption.dryVegetationWithIgnition
          ? onContinue
          : null,
    ),
  );
}

enum _RiskOption { wetForest, dryVegetationWithIgnition, wetGrassland }

extension _RiskOptionCopy on _RiskOption {
  String label(bool english) => switch (this) {
    _RiskOption.wetForest => english ? 'Wet forest' : 'Hutan basah',
    _RiskOption.dryVegetationWithIgnition =>
      english
          ? 'Dry vegetation with an ignition source'
          : 'Vegetasi kering dengan sumber penyulut api',
    _RiskOption.wetGrassland =>
      english ? 'Wet grassland' : 'Padang rumput basah',
  };
}

class _TriangleIntro extends StatelessWidget {
  const _TriangleIntro({
    required this.english,
    required this.onStart,
    required this.onBack,
  });
  final bool english;
  final VoidCallback onStart;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 2,
    english: english,
    eyebrow: english
        ? 'CHAPTER 2 / THREE ELEMENTS'
        : 'BABAK 2 / TIGA UNSUR API',
    title: english ? 'Fire needs all three.' : 'Api butuh tiga unsur.',
    subtitle: english
        ? 'Heat, fuel, and oxygen work together to keep a fire burning.'
        : 'Panas, bahan bakar, dan oksigen bekerja bersama agar api tetap menyala.',
    onBack: onBack,
    body: const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: _TriangleDiagram(count: 0),
    ),
    footer: _Primary(
      label: english ? 'Try the Triangle' : 'Coba Susun Segitiganya',
      onPressed: onStart,
    ),
  );
}

class _TriangleBuild extends StatelessWidget {
  const _TriangleBuild({
    required this.english,
    required this.pieces,
    required this.lastDropCorrect,
    required this.onDrop,
    required this.onContinue,
    required this.onBack,
    required this.onRestart,
  });
  final bool english;
  final Map<_FireSlot, _FirePiece> pieces;
  final bool? lastDropCorrect;
  final void Function(_FireSlot, _FirePiece) onDrop;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  @override
  Widget build(BuildContext context) {
    final complete = pieces.length == 3;
    return _LightStage(
      chapter: 2,
      english: english,
      eyebrow: english
          ? 'CHAPTER 2 / PUT IT TOGETHER'
          : 'BABAK 2 / SUSUN TIGA UNSUR',
      title: complete
          ? (english
                ? 'All three are in place.'
                : 'Tiga unsurnya sudah lengkap.')
          : (english ? 'Match the elements.' : 'Susun tiga unsur api.'),
      subtitle: complete
          ? (english
                ? 'With heat, fuel, and oxygen together, fire can keep burning.'
                : 'Saat ketiganya bertemu, api bisa terus menyala.')
          : lastDropCorrect == true
          ? (english
                ? 'That fits. Now find the next card.'
                : 'Pas. Sekarang cari kartu berikutnya.')
          : lastDropCorrect == false
          ? (english
                ? 'Not quite. Match the card with the element named above.'
                : 'Belum cocok. Cocokkan kartu dengan nama unsur di atas.')
          : (english
                ? 'Drag each card to the element it belongs to.'
                : 'Seret setiap kartu ke kotak unsur yang cocok.'),
      onBack: onBack,
      onRestart: onRestart,
      body: Column(
        children: <Widget>[
          Row(
            children: _FireSlot.values
                .map(
                  (slot) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: slot == _FireSlot.oxygen ? 0 : 7,
                      ),
                      child: _DropSlot(
                        slot: slot,
                        english: english,
                        piece: pieces[slot],
                        onDrop: onDrop,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          _TriangleDiagram(count: pieces.length, compact: true),
          const SizedBox(height: 9),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.42,
            children: _FirePiece.values
                .where((piece) => !pieces.values.contains(piece))
                .map((piece) => _DraggablePiece(piece: piece, english: english))
                .toList(),
          ),
          if (complete) ...<Widget>[
            const SizedBox(height: 12),
            _Feedback(
              ok: true,
              text: english
                  ? 'Nice. Remove just one element and the fire triangle is interrupted.'
                  : 'Bagus. Jika satu unsur dihilangkan, rangkaian pembakaran terputus.',
            ),
          ],
        ],
      ),
      footer: _Primary(
        label: english ? 'Find a Prevention Step' : 'Cari Cara Mencegahnya',
        onPressed: complete ? onContinue : null,
      ),
    );
  }
}

class _BreakTriangle extends StatelessWidget {
  const _BreakTriangle({
    required this.english,
    required this.selected,
    required this.onSelect,
    required this.onContinue,
    required this.onBack,
  });
  final bool english;
  final _FireSlot? selected;
  final ValueChanged<_FireSlot> onSelect;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 2,
    english: english,
    eyebrow: english
        ? 'CHAPTER 2 / PREVENT EARLY'
        : 'BABAK 2 / CEGAH SEJAK AWAL',
    title: english
        ? 'How can the chain be stopped?'
        : 'Bagaimana rantainya diputus?',
    subtitle: english
        ? 'Choose one prevention principle to try in this simulation.'
        : 'Pilih satu prinsip pencegahan yang ingin kamu coba dalam simulasi ini.',
    onBack: onBack,
    body: Column(
      children: <Widget>[
        _TriangleDiagram(count: 3, dim: selected),
        const SizedBox(height: 16),
        ..._FireSlot.values.map(
          (slot) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _ChoiceButton(
              label:
                  '${slot.title(english)} → ${english ? (slot == _FireSlot.fuel
                            ? 'Create space between fuel'
                            : slot == _FireSlot.heat
                            ? 'Reduce the heat source'
                            : 'Reduce oxygen supply') : (slot == _FireSlot.fuel
                            ? 'Buat jarak pada bahan bakar'
                            : slot == _FireSlot.heat
                            ? 'Kurangi sumber panas'
                            : 'Kurangi suplai oksigen')}',
              selected: selected == slot,
              onTap: () => onSelect(slot),
            ),
          ),
        ),
        if (selected != null)
          _Feedback(
            ok: true,
            text: english
                ? 'Good choice. Reducing one element can interrupt the triangle. In real situations, follow official procedures and trained personnel.'
                : 'Tepat. Mengurangi satu unsur dapat memutus rantai api. Di lapangan, selalu ikuti prosedur dan arahan petugas.',
          ),
      ],
    ),
    footer: _Primary(
      label: english ? 'Trace the Trigger' : 'Telusuri Pemicunya',
      onPressed: selected == null ? null : onContinue,
    ),
  );
}

class _CauseIntro extends StatelessWidget {
  const _CauseIntro({
    required this.english,
    required this.onStart,
    required this.onBack,
  });
  final bool english;
  final VoidCallback onStart;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 3,
    english: english,
    eyebrow: english
        ? 'CHAPTER 3 / TRACE THE TRIGGER'
        : 'BABAK 3 / CARI PEMICU',
    title: english ? 'Follow the clues.' : 'Ikuti jejaknya.',
    subtitle: english
        ? 'Look closely, then decide whether the trigger comes from people or nature.'
        : 'Perhatikan situasinya, lalu tentukan apakah pemicunya berasal dari manusia atau alam.',
    onBack: onBack,
    body: const _PhotoCard(
      label: 'Simulasi kondisi lapangan: vegetasi mengering dan mudah terbakar',
      tone: Color(0x80553B2B),
    ),
    footer: _Primary(
      label: english ? 'Start Looking' : 'Mulai Cari Petunjuk',
      onPressed: onStart,
    ),
  );
}

class _CauseQuiz extends StatelessWidget {
  const _CauseQuiz({
    required this.english,
    required this.index,
    required this.points,
    required this.choice,
    required this.onChoose,
    required this.onNext,
    required this.onFinish,
    required this.onBack,
  });
  final bool english;
  final int index;
  final int points;
  final bool? choice;
  final ValueChanged<bool> onChoose;
  final ValueChanged<bool> onNext;
  final VoidCallback onFinish;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    final scenarios = <(String, bool)>[
      (
        english
            ? 'Vegetation is burned to clear land while conditions are dry.'
            : 'Vegetasi dibakar untuk membuka lahan saat kondisinya kering.',
        true,
      ),
      (
        english
            ? 'A lit cigarette butt is thrown into dry grass.'
            : 'Puntung rokok menyala dibuang ke rerumputan kering.',
        true,
      ),
      (
        english
            ? 'Lightning strikes very dry vegetation.'
            : 'Petir menyambar vegetasi yang sangat kering.',
        false,
      ),
      (
        english
            ? 'A small fire is left unattended near dry land.'
            : 'Api kecil ditinggalkan tanpa pengawasan dekat lahan kering.',
        true,
      ),
    ];
    if (index >= scenarios.length) {
      return _LightStage(
        chapter: 3,
        english: english,
        eyebrow: english ? 'CHAPTER 3 / COMPLETE' : 'BABAK 3 / LENGKAP',
        title: english ? 'You found the triggers.' : 'Jejak pemicunya terbaca.',
        subtitle: english
            ? '$points of 4 answers were on target.'
            : '$points dari 4 jawabanmu sudah tepat.',
        onBack: onBack,
        body: _Feedback(
          ok: true,
          text: english
              ? 'Risk can come from people or nature. The best prevention happens before there is a flame.'
              : 'Risiko bisa datang dari manusia maupun alam. Pencegahan paling baik dilakukan sebelum ada nyala api.',
        ),
        footer: _Primary(
          label: english ? 'Move to Prevention' : 'Lanjut ke Pencegahan',
          onPressed: onFinish,
        ),
      );
    }
    final scenario = scenarios[index];
    final answered = choice != null;
    final correct = choice == scenario.$2;
    return _LightStage(
      chapter: 3,
      english: english,
      eyebrow: english
          ? 'CHAPTER 3 / CLUE ${index + 1} OF 4'
          : 'BABAK 3 / BUKTI ${index + 1} DARI 4',
      title: english
          ? 'What most likely triggered this risk?'
          : 'Apa yang paling mungkin memicu risiko ini?',
      subtitle: english
          ? 'Read the situation, then choose where the trigger came from.'
          : 'Baca situasinya, lalu pilih asal pemicunya.',
      onBack: onBack,
      body: Column(
        children: <Widget>[
          _PhotoCard(label: scenario.$1, tone: const Color(0x80553B2B)),
          const SizedBox(height: 14),
          _ChoiceButton(
            label: english ? 'Human activity' : 'Aktivitas manusia',
            selected: choice == true,
            error: answered && choice == true && !correct,
            onTap: answered ? () {} : () => onChoose(true),
          ),
          const SizedBox(height: 9),
          _ChoiceButton(
            label: english ? 'Natural factor' : 'Faktor alam',
            selected: choice == false,
            error: answered && choice == false && !correct,
            onTap: answered ? () {} : () => onChoose(false),
          ),
        ],
      ),
      footer: answered
          ? Column(
              children: <Widget>[
                _Feedback(
                  ok: correct,
                  text: correct
                      ? (scenario.$2
                            ? (english
                                  ? 'That’s right. Everyday human actions can create a fire risk when land is dry.'
                                  : 'Benar. Aktivitas manusia sehari-hari bisa memicu risiko saat lahan kering.')
                            : (english
                                  ? 'That’s right. Lightning can start a fire when vegetation is very dry.'
                                  : 'Benar. Petir dapat memicu api ketika vegetasi sangat kering.'))
                      : (english
                            ? 'Not quite. Look once more at what is happening in the scene before you continue.'
                            : 'Belum tepat. Perhatikan lagi kejadian pada kartu sebelum melanjutkan.'),
                ),
                const SizedBox(height: 8),
                _Primary(
                  label: index == scenarios.length - 1
                      ? (english ? 'See Your Result' : 'Lihat Hasil Babak')
                      : (english ? 'Next Clue' : 'Petunjuk Berikutnya'),
                  onPressed: () => onNext(correct),
                ),
              ],
            )
          : Text(
              english
                  ? 'Choose the answer that fits the situation best.'
                  : 'Pilih jawaban yang paling sesuai dengan situasinya.',
              style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
            ),
    );
  }
}

class _StopIntro extends StatelessWidget {
  const _StopIntro({
    required this.english,
    required this.onStart,
    required this.onBack,
  });
  final bool english;
  final VoidCallback onStart;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 4,
    english: english,
    eyebrow: english ? 'CHAPTER 4 / PREVENT' : 'BABAK 4 / PILIH TINDAKAN',
    title: english ? 'Take the safer step.' : 'Ambil langkah yang aman.',
    subtitle: english
        ? 'You know the triggers. Now choose what helps before risk grows.'
        : 'Kamu sudah tahu pemicunya. Sekarang pilih tindakan sebelum risikonya membesar.',
    onBack: onBack,
    body: const _PhotoCard(
      label:
          'Simulasi pencegahan: bahan bakar dipisahkan oleh petugas berwenang',
      tone: Color(0x80604231),
    ),
    footer: _Primary(
      label: english ? 'Make Your Choice' : 'Pilih Tindakan',
      onPressed: onStart,
    ),
  );
}

class _StopDecision extends StatelessWidget {
  const _StopDecision({
    required this.english,
    required this.answer,
    required this.onAnswer,
    required this.onContinue,
    required this.onBack,
  });
  final bool english;
  final bool? answer;
  final ValueChanged<bool> onAnswer;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 4,
    english: english,
    eyebrow: english
        ? 'CHAPTER 4 / MAKE A CHOICE'
        : 'BABAK 4 / AMBIL KEPUTUSAN',
    title: english ? 'Which action is safest?' : 'Mana tindakan paling aman?',
    subtitle: english
        ? 'Imagine you spot a risky condition. Choose the action that helps prevent spread.'
        : 'Bayangkan kamu melihat kondisi berisiko. Pilih tindakan yang membantu mencegah api menyebar.',
    onBack: onBack,
    body: Column(
      children: <Widget>[
        _ChoiceButton(
          label: english
              ? 'Create space between fuel before fire starts'
              : 'Buat jarak pada bahan bakar sebelum ada api',
          selected: answer == true,
          onTap: () => onAnswer(true),
        ),
        const SizedBox(height: 9),
        _ChoiceButton(
          label: english
              ? 'Move closer to a real fire'
              : 'Mendekati api untuk melihat lebih jelas',
          selected: answer == false,
          onTap: () => onAnswer(false),
        ),
        const SizedBox(height: 9),
        _ChoiceButton(
          label: english
              ? 'Add more fuel'
              : 'Menambah bahan yang mudah terbakar',
          selected: answer == false,
          onTap: () => onAnswer(false),
        ),
        if (answer != null) ...<Widget>[
          const SizedBox(height: 12),
          _Feedback(
            ok: answer!,
            text: answer!
                ? (english
                      ? 'Correct. Trained personnel create space between fuel to limit how fire can travel.'
                      : 'Benar. Petugas berwenang membuat jarak pada bahan bakar untuk mengurangi jalur rambatan api.')
                : (english
                      ? 'Not safe. Do not approach a real fire or add fuel. Report it and follow trained personnel.'
                      : 'Belum aman. Jangan mendekati api atau menambah bahan bakar. Laporkan dan ikuti arahan petugas.'),
          ),
        ],
      ],
    ),
    footer: _Primary(
      label: english ? 'Start Final Challenge' : 'Masuk Tantangan Akhir',
      onPressed: answer == null ? null : onContinue,
    ),
  );
}

class _FinalChallenge extends StatelessWidget {
  const _FinalChallenge({
    required this.english,
    required this.seconds,
    required this.found,
    required this.onTap,
    required this.onBack,
  });
  final bool english;
  final int seconds;
  final Set<_RiskToken> found;
  final ValueChanged<_RiskToken> onTap;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 4,
    english: english,
    eyebrow: english ? 'CHAPTER 4 / FINAL CHECK' : 'BABAK 4 / TANTANGAN AKHIR',
    title: english ? 'Find the fire risks.' : 'Cari pemicu risikonya.',
    subtitle: english
        ? 'Touch the 4 things that can make fire easier to start.'
        : 'Sentuh 4 hal yang bisa membuat api lebih mudah mulai.',
    onBack: onBack,
    trailing: _TimerChip(seconds: seconds, english: english),
    body: Column(
      children: <Widget>[
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _RiskToken.values
              .map(
                (token) => _RiskTokenCard(
                  token: token,
                  english: english,
                  found: found.contains(token),
                  onTap: () => onTap(token),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(
          '${found.where((item) => item.risk).length}/4 ${english ? 'risk triggers found' : 'pemicu risiko ditemukan'}',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    ),
    footer: _SafetyNote(english: english),
  );
}

enum _RiskToken {
  dryVegetation,
  cigarette,
  unmanagedFire,
  healthyVegetation,
  dryWood,
  rain,
}

extension _RiskTokenCopy on _RiskToken {
  bool get risk => switch (this) {
    _RiskToken.dryVegetation ||
    _RiskToken.cigarette ||
    _RiskToken.unmanagedFire ||
    _RiskToken.dryWood => true,
    _ => false,
  };
  String label(bool en) => switch (this) {
    _RiskToken.dryVegetation => en ? 'Dry vegetation' : 'Vegetasi kering',
    _RiskToken.cigarette => en ? 'Cigarette butt' : 'Puntung rokok',
    _RiskToken.unmanagedFire => en ? 'Uncontrolled fire' : 'Api tak terkendali',
    _RiskToken.healthyVegetation =>
      en ? 'Healthy vegetation' : 'Vegetasi sehat',
    _RiskToken.dryWood => en ? 'Dry wood' : 'Kayu kering',
    _RiskToken.rain => en ? 'Rain' : 'Hujan',
  };
}

class _ScorePage extends StatelessWidget {
  const _ScorePage({
    required this.english,
    required this.triangle,
    required this.causes,
    required this.prevention,
    required this.onContinue,
    required this.onAgain,
  });
  final bool english;
  final int triangle;
  final int causes;
  final int prevention;
  final VoidCallback onContinue;
  final VoidCallback onAgain;
  int get total => triangle + causes + prevention;
  String get title => total >= 8
      ? (english ? 'Fire Prevention Hero' : 'Pahlawan Pencegahan Kebakaran')
      : total >= 6
      ? (english ? 'Fire Awareness Champion' : 'Duta Kesadaran Kebakaran')
      : (english ? 'Keep Exploring' : 'Terus Jelajahi');
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 4,
    english: english,
    eyebrow: english
        ? 'JOURNEY COMPLETE / RESULT'
        : 'PERJALANAN SELESAI / HASIL',
    title: title,
    subtitle: english
        ? 'You have completed the challenge. Here is what you picked up along the way.'
        : 'Kamu sudah menyelesaikan tantangan. Ini yang berhasil kamu tangkap di sepanjang perjalanan.',
    onBack: onAgain,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 168,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: KifcTheme.line),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 76,
                  fontWeight: FontWeight.w700,
                  height: .9,
                ),
              ),
              Text(
                english ? 'of 9 points' : 'dari 9 poin',
                style: const TextStyle(color: KifcTheme.mutedInk),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ScoreRow(
          label: english ? 'Understanding fire' : 'Memahami api',
          score: '$triangle/3',
        ),
        _ScoreRow(
          label: english ? 'Finding triggers' : 'Mengenali pemicu',
          score: '$causes/4',
        ),
        _ScoreRow(
          label: english ? 'Prevention choices' : 'Memilih pencegahan',
          score: '$prevention/2',
        ),
        const SizedBox(height: 18),
        Text(
          english
              ? 'Every early action matters.'
              : 'Setiap tindakan awal berarti.',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          english
              ? 'Notice dry fuel, avoid ignition sources, and report early signs. Prevention starts long before a fire spreads.'
              : 'Perhatikan bahan kering, hindari sumber penyalaan, dan laporkan tanda awal. Pencegahan dimulai jauh sebelum api menyebar.',
        ),
      ],
    ),
    footer: Column(
      children: <Widget>[
        _Primary(
          label: english ? 'Read the Closing Message' : 'Lihat Pesan Penutup',
          onPressed: onContinue,
        ),
        const SizedBox(height: 8),
        _Secondary(
          label: english ? 'Play Again' : 'Main Lagi',
          onPressed: onAgain,
        ),
      ],
    ),
  );
}

class _ClosingPage extends StatelessWidget {
  const _ClosingPage({required this.english, required this.onAgain});
  final bool english;
  final VoidCallback onAgain;
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 4,
    english: english,
    eyebrow: english
        ? 'KNOWLEDGE FOR THE FUTURE'
        : 'MENJAGA HUTAN, MENJAGA MASA DEPAN',
    title: english
        ? 'Prevention Starts with Understanding.'
        : 'Pencegahan dimulai dari kita.',
    subtitle: english
        ? 'Small choices can protect forests, peatland, and the people around them.'
        : 'Pilihan kecil bisa menjaga hutan, gambut, dan orang-orang di sekitarnya.',
    onBack: onAgain,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PhotoCard(
          label:
              'Gambut terjaga • kanal sehat • dokumentasi pemantauan Manggala Agni',
          tone: Color(0x800C2B1F),
        ),
        const SizedBox(height: 14),
        const Text(
          'KIFC / Kerja sama untuk hutan yang lebih aman',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          english
              ? 'Cooperation, knowledge, and the right action help keep forests and land safer from fire.'
              : 'Kerja sama, pengetahuan, dan tindakan yang tepat membantu menjaga hutan dan lahan dari kebakaran.',
        ),
      ],
    ),
    footer: Column(
      children: <Widget>[
        _Primary(
          label: english ? 'Play Again' : 'Main Lagi',
          onPressed: onAgain,
        ),
        const SizedBox(height: 8),
        _Secondary(
          label: english ? 'Return to Welcome' : 'Kembali ke Layar Awal',
          onPressed: onAgain,
        ),
        const SizedBox(height: 12),
        Text(
          english
              ? 'This screen returns to the welcome page after 12 seconds.'
              : 'Layar ini kembali ke halaman awal setelah 12 detik.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: KifcTheme.mutedInk),
        ),
      ],
    ),
  );
}

class _DarkStage extends StatelessWidget {
  const _DarkStage({
    required this.chapter,
    required this.english,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
    required this.onBack,
  });
  final int chapter;
  final bool english;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: KifcTheme.forest950,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _PartnerHeader(dark: true),
            const SizedBox(height: 17),
            _TopBar(
              chapter: chapter,
              english: english,
              dark: true,
              onBack: onBack,
            ),
            const SizedBox(height: 14),
            _Eyebrow(text: eyebrow, dark: true),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(child: body),
            const SizedBox(height: 16),
            footer,
          ],
        ),
      ),
    ),
  );
}

class _LightStage extends StatelessWidget {
  const _LightStage({
    required this.chapter,
    required this.english,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
    required this.onBack,
    this.onRestart,
    this.trailing,
    this.bodyScrollable = true,
  });
  final int chapter;
  final bool english;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;
  final VoidCallback onBack;
  final VoidCallback? onRestart;
  final Widget? trailing;
  final bool bodyScrollable;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: KifcTheme.paper,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _PartnerHeader(),
            const SizedBox(height: 15),
            _TopBar(
              chapter: chapter,
              english: english,
              onBack: onBack,
              onRestart: onRestart,
              trailing: trailing,
            ),
            const SizedBox(height: 15),
            _Eyebrow(text: eyebrow),
            Text(
              title,
              style: const TextStyle(
                fontSize: 29,
                height: 1.07,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle.isNotEmpty) ...<Widget>[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: KifcTheme.mutedInk,
                  fontSize: 14,
                  height: 1.25,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: bodyScrollable ? SingleChildScrollView(child: body) : body,
            ),
            const SizedBox(height: 14),
            footer,
          ],
        ),
      ),
    ),
  );
}

class _LiquidGlass extends StatelessWidget {
  const _LiquidGlass({
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.tint = const Color(0x24FFFFFF),
    this.padding,
    this.borderColor,
    this.borderWidth = 1,
  });
  final Widget child;
  final BorderRadius borderRadius;
  final Color tint;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor ?? Colors.white.withValues(alpha: .4),
            width: borderWidth,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: child,
      ),
    ),
  );
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.locale, required this.onChanged});
  final AppLocale locale;
  final ValueChanged<AppLocale> onChanged;

  @override
  Widget build(BuildContext context) => _LiquidGlass(
    borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
    tint: Colors.white.withValues(alpha: .28),
    padding: const EdgeInsets.all(3),
    child: Row(
      children: AppLocale.values
          .map(
            (candidate) => Expanded(
              child: InkWell(
                onTap: () => onChanged(candidate),
                borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
                child: AnimatedContainer(
                  duration: _motionDuration(
                    context,
                    const Duration(milliseconds: 180),
                  ),
                  curve: Curves.easeOut,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: locale == candidate
                        ? Colors.white.withValues(alpha: .16)
                        : Colors.transparent,
                    border: locale == candidate
                        ? Border.all(color: KifcTheme.amber, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(
                      KifcTheme.controlRadius,
                    ),
                  ),
                  child: Text(
                    candidate.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _PartnerHeader extends StatelessWidget {
  const _PartnerHeader({this.dark = false});
  final bool dark;
  static const _assets = <String>[
    'assets/images/logos/01-kementerian-kehutanan.png',
    'assets/images/logos/02-korea-forest-service.png',
    'assets/images/logos/03-kifc.png',
    'assets/images/logos/04-manggala-agni.jpeg',
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 28,
    child: Row(
      children: _assets
          .map(
            (asset) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white.withValues(alpha: .9)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.chapter,
    required this.english,
    required this.onBack,
    this.dark = false,
    this.onRestart,
    this.trailing,
  });
  final int chapter;
  final bool english;
  final VoidCallback onBack;
  final bool dark;
  final VoidCallback? onRestart;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _SmallButton(
        label: english ? 'Back' : 'Kembali',
        icon: Icons.arrow_back,
        dark: dark,
        onPressed: onBack,
      ),
      const Spacer(),
      trailing ??
          _ChapterProgress(chapter: chapter, english: english, dark: dark),
      const Spacer(),
      if (onRestart != null)
        _SmallButton(
          label: english ? 'Restart' : 'Ulangi',
          icon: Icons.restart_alt,
          dark: dark,
          onPressed: onRestart!,
        )
      else
        const SizedBox(width: 76),
    ],
  );
}

class _ChapterProgress extends StatelessWidget {
  const _ChapterProgress({
    required this.chapter,
    required this.english,
    required this.dark,
  });
  final int chapter;
  final bool english;
  final bool dark;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ...List<Widget>.generate(
        4,
        (index) => Container(
          width: 11,
          height: 2,
          margin: const EdgeInsets.only(right: 3),
          color: index < chapter
              ? KifcTheme.amber
              : (dark ? Colors.white30 : KifcTheme.line),
        ),
      ),
      Text(
        english ? 'CHAPTER $chapter/4' : 'BABAK $chapter/4',
        style: TextStyle(
          color: dark ? Colors.white70 : KifcTheme.mutedInk,
          fontSize: 9,
        ),
      ),
    ],
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text, this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: TextStyle(
        color: dark ? Colors.white70 : KifcTheme.mutedInk,
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.dark,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool dark;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: dark ? Colors.white : KifcTheme.ink,
        side: BorderSide(color: dark ? Colors.white70 : KifcTheme.forest800),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        ),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    ),
  );
}

class _Primary extends StatelessWidget {
  const _Primary({required this.label, this.icon, required this.onPressed});
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: KifcTheme.forest800,
        disabledBackgroundColor: KifcTheme.forest800.withValues(alpha: .4),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        ),
        elevation: 0,
      ),
      icon: icon == null ? const SizedBox.shrink() : Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ),
  );
}

class _Secondary extends StatelessWidget {
  const _Secondary({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: KifcTheme.ink,
        side: const BorderSide(color: KifcTheme.forest800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        ),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ),
  );
}

class _Photo extends StatelessWidget {
  const _Photo({this.tone = const Color(0x8A0C2B1F)});
  final Color tone;
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Image.asset(
        'assets/images/forest/kereng-bangkirai.jpg',
        fit: BoxFit.cover,
      ),
      ColoredBox(color: tone),
    ],
  );
}

class _VisualTag extends StatelessWidget {
  const _VisualTag({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => _LiquidGlass(
    borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
    tint: Colors.white.withValues(alpha: .12),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );
}

class _LandscapePanel extends StatelessWidget {
  const _LandscapePanel({required this.dry, required this.children});
  final bool dry;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      const _Photo(),
      AnimatedContainer(
        duration: _motionDuration(context, const Duration(milliseconds: 450)),
        curve: Curves.easeOutCubic,
        color: dry ? const Color(0xAA593B2B) : const Color(0x8A0C2B1F),
      ),
      ...children,
    ],
  );
}

class _Hotspot extends StatelessWidget {
  const _Hotspot({
    required this.cue,
    required this.selected,
    required this.label,
    required this.alignment,
    required this.onTap,
  });
  final _LandCue cue;
  final bool selected;
  final String label;
  final Alignment alignment;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: AnimatedScale(
      duration: _motionDuration(context, const Duration(milliseconds: 180)),
      curve: Curves.easeOutBack,
      scale: selected ? 1.025 : 1,
      child: _LiquidGlass(
        borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        tint: selected
            ? KifcTheme.amber.withValues(alpha: .25)
            : Colors.white.withValues(alpha: .12),
        borderColor: selected
            ? KifcTheme.amber
            : Colors.white.withValues(alpha: .4),
        borderWidth: selected ? 2 : 1,
        child: TextButton.icon(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
            ),
          ),
          icon: Icon(
            selected ? Icons.check_circle_outline : Icons.circle_outlined,
            color: selected ? KifcTheme.amber : Colors.white,
            size: 17,
          ),
          label: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    ),
  );
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({
    required this.option,
    required this.english,
    required this.selected,
    required this.correct,
    required this.onTap,
  });
  final _RiskOption option;
  final bool english;
  final bool selected;
  final bool correct;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: _motionDuration(context, const Duration(milliseconds: 180)),
    curve: Curves.easeOutBack,
    scale: selected ? 1.01 : 1,
    child: Material(
      color: KifcTheme.forest800,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        child: Container(
          height: 86,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? (correct ? KifcTheme.amber : Colors.redAccent)
                  : KifcTheme.line,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/forest/kereng-bangkirai.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              ColoredBox(color: KifcTheme.forest950.withValues(alpha: .78)),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  option.label(english),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.label, required this.tone});
  final String label;
  final Color tone;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 175,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const _Photo(),
        ColoredBox(color: tone),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.ok, required this.text});
  final bool ok;
  final String text;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    duration: _motionDuration(context, const Duration(milliseconds: 240)),
    curve: Curves.easeOutCubic,
    tween: Tween<double>(begin: .94, end: 1),
    builder: (context, scale, child) =>
        Transform.scale(scale: scale, child: child),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ok ? KifcTheme.success : KifcTheme.warning,
        borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            ok ? Icons.check_circle_outline : Icons.info_outline,
            color: KifcTheme.forest800,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.25),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.error = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool error;
  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: _motionDuration(context, const Duration(milliseconds: 180)),
    curve: Curves.easeOutBack,
    scale: selected ? 1.01 : 1,
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: selected
              ? (error ? KifcTheme.warning : KifcTheme.success)
              : null,
          foregroundColor: KifcTheme.ink,
          side: BorderSide(
            color: selected
                ? (error ? Colors.deepOrange : KifcTheme.amber)
                : KifcTheme.line,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

class _TriangleDiagram extends StatelessWidget {
  const _TriangleDiagram({required this.count, this.dim, this.compact = false});
  final int count;
  final _FireSlot? dim;
  final bool compact;
  @override
  Widget build(BuildContext context) => Center(
    child: CustomPaint(
      size: compact ? const Size(120, 105) : const Size(170, 145),
      painter: _TrianglePainter(count: count, dim: dim),
      child: SizedBox(width: compact ? 120 : 170, height: compact ? 105 : 145),
    ),
  );
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.count, this.dim});
  final int count;
  final _FireSlot? dim;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = KifcTheme.forest800;
    final path = Path()
      ..moveTo(size.width / 2, 5)
      ..lineTo(6, size.height - 4)
      ..lineTo(size.width - 6, size.height - 4)
      ..close();
    canvas.drawPath(path, paint);
    final text = TextPainter(
      text: TextSpan(
        text: '$count/3',
        style: const TextStyle(
          color: KifcTheme.ink,
          fontSize: 29,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset((size.width - text.width) / 2, 54));
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter old) =>
      old.count != count || old.dim != dim;
}

class _DropSlot extends StatelessWidget {
  const _DropSlot({
    required this.slot,
    required this.english,
    required this.piece,
    required this.onDrop,
  });
  final _FireSlot slot;
  final bool english;
  final _FirePiece? piece;
  final void Function(_FireSlot, _FirePiece) onDrop;
  @override
  Widget build(BuildContext context) => DragTarget<_FirePiece>(
    onWillAcceptWithDetails: (details) => piece == null,
    onAcceptWithDetails: (details) => onDrop(slot, details.data),
    builder: (context, candidate, rejected) => Container(
      height: 88,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: piece == null ? Colors.white : KifcTheme.success,
        borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        border: Border.all(
          color: candidate.isNotEmpty ? KifcTheme.amber : KifcTheme.line,
          width: candidate.isNotEmpty ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(slot.icon, size: 16, color: KifcTheme.forest800),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  slot.title(english),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            piece?.label(english) ?? slot.note(english),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              height: 1.1,
              color: piece == null ? KifcTheme.mutedInk : KifcTheme.ink,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DraggablePiece extends StatelessWidget {
  const _DraggablePiece({required this.piece, required this.english});
  final _FirePiece piece;
  final bool english;
  @override
  Widget build(BuildContext context) => Draggable<_FirePiece>(
    data: piece,
    feedback: Material(
      color: Colors.transparent,
      child: _PieceCard(piece: piece, english: english, elevated: true),
    ),
    childWhenDragging: Opacity(
      opacity: .28,
      child: _PieceCard(piece: piece, english: english),
    ),
    child: _PieceCard(piece: piece, english: english),
  );
}

class _PieceCard extends StatelessWidget {
  const _PieceCard({
    required this.piece,
    required this.english,
    this.elevated = false,
  });
  final _FirePiece piece;
  final bool english;
  final bool elevated;
  @override
  Widget build(BuildContext context) => Container(
    width: 106,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      border: Border.all(color: KifcTheme.line),
      boxShadow: elevated
          ? <BoxShadow>[const BoxShadow(color: Colors.black26, blurRadius: 8)]
          : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 30,
            width: double.infinity,
            child: Image.asset(
              'assets/images/forest/kereng-bangkirai.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          piece.label(english),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _RiskTokenCard extends StatelessWidget {
  const _RiskTokenCard({
    required this.token,
    required this.english,
    required this.found,
    required this.onTap,
  });
  final _RiskToken token;
  final bool english;
  final bool found;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: _motionDuration(context, const Duration(milliseconds: 180)),
    curve: Curves.easeOutBack,
    scale: found ? 1.035 : 1,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      child: Container(
        width: 104,
        height: 116,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: found && token.risk ? KifcTheme.success : Colors.white,
          border: Border.all(
            color: found
                ? (token.risk ? KifcTheme.forest800 : Colors.redAccent)
                : KifcTheme.line,
            width: found ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 34,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/forest/kereng-bangkirai.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            Text(
              token.label(english),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.seconds, required this.english});
  final int seconds;
  final bool english;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 58,
    height: 58,
    child: _LiquidGlass(
      borderRadius: BorderRadius.circular(999),
      tint: Colors.white.withValues(alpha: .45),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: KifcTheme.amber, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: _motionDuration(
                context,
                const Duration(milliseconds: 160),
              ),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Text(
                '$seconds',
                key: ValueKey(seconds),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: .9,
                ),
              ),
            ),
            Text(
              english ? 'sec' : 'detik',
              style: const TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.score});
  final String label;
  final String score;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: <Widget>[
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(score, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _SafetyNote extends StatelessWidget {
  const _SafetyNote({required this.english});
  final bool english;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Icon(Icons.info_outline, size: 17, color: KifcTheme.forest800),
      SizedBox(width: 7),
      Expanded(
        child: Text(
          english
              ? 'Do not approach a real fire. Report it and follow trained personnel.'
              : 'Jangan mendekati api nyata. Laporkan dan ikuti arahan petugas.',
          style: const TextStyle(fontSize: 12, color: KifcTheme.forest800),
        ),
      ),
    ],
  );
}
