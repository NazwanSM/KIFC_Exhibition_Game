import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/kifc_theme.dart';
import 'widgets/environment_motion.dart';
import 'widgets/game_photo.dart';
import 'widgets/game_mascot.dart';

const _fireCardAspectRatio = 1.8;

Duration _motionDuration(BuildContext context, Duration duration) =>
    MediaQuery.maybeOf(context)?.disableAnimations == true
    ? Duration.zero
    : duration;

String _points(num value, bool english) {
  final text = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
  return english ? text : text.replaceAll('.', ',');
}

typedef _CauseScenario = ({String text, bool human, String photo, String reason});

/// Four trigger situations for Chapter 3. Lightning is the only natural one.
List<_CauseScenario> _causeScenarios(bool english) => <_CauseScenario>[
  (
    text: english
        ? 'Vegetation is burned to clear land while conditions are dry.'
        : 'Tanaman dibakar untuk membuka lahan saat cuaca kering.',
    human: true,
    photo: 'assets/images/field/fire-klaten.jpg',
    reason: english
        ? 'Burning vegetation to clear land is a human activity.'
        : 'Membakar tanaman untuk membuka lahan bisa membuat api merambat ke sekitarnya.',
  ),
  (
    text: english
        ? 'A lit cigarette butt is thrown into dry grass.'
        : 'Puntung rokok yang masih menyala dibuang ke rerumputan kering.',
    human: true,
    photo: 'assets/images/field/cigarette-leaves.jpg',
    reason: english
        ? 'A lit cigarette carries heat that can ignite dry vegetation.'
        : 'Bara pada puntung rokok bisa menyulut rumput kering di sekitarnya.',
  ),
  (
    text: english
        ? 'Lightning strikes very dry vegetation.'
        : 'Petir menyambar tanaman yang sudah kering.',
    human: false,
    photo: 'assets/images/field/lightning-forest.jpg',
    reason: english
        ? 'Lightning is a natural ignition source that can ignite dry vegetation.'
        : 'Sambaran petir membawa panas yang bisa menyulut tanaman kering.',
  ),
  (
    text: english
        ? 'A small fire is left unattended near dry land.'
        : 'Api kecil dibiarkan tanpa pengawasan di dekat lahan kering.',
    human: true,
    photo: 'assets/images/field/small-campfire.jpg',
    reason: english
        ? 'Leaving a fire unattended is a human action that can allow it to spread.'
        : 'Api yang dibiarkan menyala bisa merambat ke bahan kering di sekitarnya.',
  ),
];

class ExhibitionGame extends StatefulWidget {
  const ExhibitionGame({super.key, this.stopwatchFactory = Stopwatch.new});
  final Stopwatch Function() stopwatchFactory;

  @override
  State<ExhibitionGame> createState() => _ExhibitionGameState();
}

class _ExhibitionGameState extends State<ExhibitionGame> {
  AppLocale _locale = AppLocale.indonesian;
  _Page _page = _Page.welcome;
  _RiskOption? _riskAnswer;
  int _riskWrong = 0;
  bool _riskRevealed = false;
  final Map<_FireSlot, _FirePiece> _triangle = <_FireSlot, _FirePiece>{};
  bool? _lastDropCorrect;
  final Set<_FireSlot> _breakTried = <_FireSlot>{};
  _FireSlot? _breakChoice;
  int _causeIndex = 0;
  int _causePoints = 0;
  bool? _causeChoice;
  _PreventionAction? _stopAnswer;
  int _stopWrong = 0;
  bool _stopRevealed = false;
  int _karhutlaCardIndex = 0;
  final Set<_RiskToken> _finalFound = <_RiskToken>{};
  int _seconds = 10;
  Timer? _timer;
  // One shared timer moves the visitor on after feedback. Every explicit
  // navigation and reset bumps the token so a pending move never fires twice.
  Timer? _autoAdvance;
  int _advanceToken = 0;
  Timer? _resetTimer;
  late final Stopwatch _finalClock = widget.stopwatchFactory();
  bool _preparingFinal = false;
  int _preparationTicket = 0;
  int _idleSeconds = 15;

  bool get _en => _locale == AppLocale.english;
  int get _trianglePoints => _triangle.length;
  int get _finalRaw => math.max(
    0,
    _finalFound.where((item) => item.risk).length -
        _finalFound.where((item) => !item.risk).length,
  );
  double get _finalBonus => _finalRaw / 4;

  @override
  void dispose() {
    _timer?.cancel();
    _autoAdvance?.cancel();
    _resetTimer?.cancel();
    _finalClock.stop();
    super.dispose();
  }

  bool get _endPage => _page == _Page.score || _page == _Page.closing;

  void _go(_Page page) {
    _preparationTicket++;
    _timer?.cancel();
    _autoAdvance?.cancel();
    _advanceToken++;
    _finalClock.stop();
    _resetTimer?.cancel();
    setState(() {
      // Revisiting an activity starts that activity again. A cancelled
      // feedback timer must never leave a returning visitor on locked input.
      if (page != _page) {
        switch (page) {
          case _Page.triangleBuild:
            _triangle.clear();
            _lastDropCorrect = null;
          case _Page.breakTriangle:
            _breakTried.clear();
            _breakChoice = null;
          case _Page.risk:
            _riskAnswer = null;
            _riskWrong = 0;
            _riskRevealed = false;
          case _Page.causeQuiz:
            _causeIndex = 0;
            _causePoints = 0;
            _causeChoice = null;
          case _Page.stopDecision:
            _stopAnswer = null;
            _stopWrong = 0;
            _stopRevealed = false;
          default:
            break;
        }
      }
      _page = page;
      _preparingFinal = false;
    });
    if (_endPage) _resetInactivity();
  }

  /// Runs [action] after feedback has had time to be read, unless the visitor
  /// navigates away or the session restarts first. Long feedback carries the
  /// correct answer and its reason, so it stays on screen longer.
  void _scheduleAdvance(VoidCallback action, {required bool long}) {
    _autoAdvance?.cancel();
    final token = ++_advanceToken;
    _autoAdvance = Timer(
      // Reading time remains available when decorative motion is disabled.
      Duration(milliseconds: long ? 4500 : 2000),
      () {
        if (!mounted || token != _advanceToken) return;
        action();
      },
    );
  }

  void _resetInactivity() {
    if (!_endPage) return;
    _resetTimer?.cancel();
    setState(() => _idleSeconds = 15);
    _resetTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_endPage) {
        timer.cancel();
        return;
      }
      if (_idleSeconds <= 1) {
        _restart();
        return;
      }
      setState(() => _idleSeconds--);
    });
  }

  void _restart() {
    _preparationTicket++;
    _timer?.cancel();
    _autoAdvance?.cancel();
    _advanceToken++;
    _resetTimer?.cancel();
    _finalClock.stop();
    setState(() {
      _page = _Page.welcome;
      _riskAnswer = null;
      _riskWrong = 0;
      _riskRevealed = false;
      _triangle.clear();
      _lastDropCorrect = null;
      _breakTried.clear();
      _breakChoice = null;
      _causeIndex = 0;
      _causePoints = 0;
      _causeChoice = null;
      _stopAnswer = null;
      _stopWrong = 0;
      _stopRevealed = false;
      _karhutlaCardIndex = 0;
      _finalFound.clear();
      _seconds = 10;
      _preparingFinal = false;
      _idleSeconds = 15;
    });
  }

  void _dropPiece(_FireSlot slot, _FirePiece piece) {
    if (_triangle.containsKey(slot)) return;
    setState(() {
      final correct = piece.slot == slot;
      _lastDropCorrect = correct;
      if (correct) _triangle[slot] = piece;
    });
    if (_triangle.length == 3) {
      _scheduleAdvance(() => _go(_Page.triangleExplanation), long: false);
    }
  }

  void _resetTriangle() {
    // Rebuilding cancels a pending automatic move so it cannot fire twice.
    _autoAdvance?.cancel();
    _advanceToken++;
    setState(() {
      _triangle.clear();
      _lastDropCorrect = null;
      _breakChoice = null;
      _breakTried.clear();
    });
  }

  void _chooseBreak(_FireSlot slot) {
    if (_breakTried.contains(slot)) return;
    setState(() {
      _breakChoice = slot;
      _breakTried.add(slot);
    });
    // The demo is unscored; it moves on once all three elements are explored.
    if (_breakTried.length == _FireSlot.values.length) {
      _scheduleAdvance(() => _go(_Page.karhutlaCards), long: false);
    }
  }

  void _chooseRisk(_RiskOption option) {
    if (_riskRevealed || _riskAnswer == option ||
        _riskAnswer == _RiskOption.dryVegetationWithIgnition) {
      return;
    }
    final correct = option == _RiskOption.dryVegetationWithIgnition;
    setState(() {
      _riskAnswer = option;
      if (!correct) _riskWrong++;
      if (_riskWrong >= 2) _riskRevealed = true;
    });
    if (correct) {
      _scheduleAdvance(() => _go(_Page.causeQuiz), long: false);
    } else if (_riskRevealed) {
      _scheduleAdvance(() => _go(_Page.causeQuiz), long: true);
    }
  }

  void _chooseCause(bool humanCause) {
    if (_causeChoice != null) return;
    final scenarios = _causeScenarios(_en);
    final lastScenario = _causeIndex == scenarios.length - 1;
    setState(() {
      _causeChoice = humanCause;
      if (humanCause == scenarios[_causeIndex].human) _causePoints++;
    });
    _scheduleAdvance(() {
      if (lastScenario) {
        _go(_Page.stopDecision);
      } else {
        setState(() {
          _causeIndex++;
          _causeChoice = null;
        });
      }
    }, long: false);
  }

  void _chooseStop(_PreventionAction action) {
    if (_stopRevealed || _stopAnswer == action || _stopAnswer?.correct == true) {
      return;
    }
    setState(() {
      _stopAnswer = action;
      if (!action.correct) _stopWrong++;
      if (_stopWrong >= 2) _stopRevealed = true;
    });
    if (action.correct) {
      _scheduleAdvance(_openFinal, long: false);
    } else if (_stopRevealed) {
      _scheduleAdvance(_openFinal, long: true);
    }
  }

  Future<void> _openFinal() async {
    if (_preparingFinal) return;
    final ticket = ++_preparationTicket;
    setState(() => _preparingFinal = true);
    await Future.wait(
      _RiskToken.values.map(
        (token) => precacheImage(AssetImage(token.photo), context),
      ),
    );
    if (!mounted ||
        ticket != _preparationTicket ||
        _page != _Page.stopDecision) {
      return;
    }
    _timer?.cancel();
    setState(() {
      _page = _Page.finalChallenge;
      _seconds = 10;
      _finalFound.clear();
      _preparingFinal = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _page == _Page.finalChallenge) {
        _timer = Timer(
          _motionDuration(context, const Duration(milliseconds: 320)),
          _startFinalCountdown,
        );
      }
    });
  }

  void _startFinalCountdown() {
    if (!mounted || _page != _Page.finalChallenge) return;
    _timer?.cancel();
    _finalClock
      ..reset()
      ..start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _page != _Page.finalChallenge) {
        timer.cancel();
        return;
      }
      final remaining = math.max(0, 10 - _finalClock.elapsed.inSeconds);
      if (remaining != _seconds) setState(() => _seconds = remaining);
      if (remaining == 0) {
        timer.cancel();
        _finalClock.stop();
        _timer = Timer(const Duration(milliseconds: 420), () {
          if (mounted && _page == _Page.finalChallenge) _go(_Page.score);
        });
      }
    });
  }

  void _openClosing() => _go(_Page.closing);

  void _playAgain() {
    _restart();
    _go(_Page.triangleBuild);
  }

  @override
  Widget build(BuildContext context) {
    final page = switch (_page) {
      _Page.welcome => _WelcomePage(
        locale: _locale,
        onLocale: (locale) => setState(() => _locale = locale),
        onStart: () => _go(_Page.triangleBuild),
      ),
      _Page.risk => _RiskPage(
        english: _en,
        answer: _riskAnswer,
        wrongAttempts: _riskWrong,
        onAnswer: _chooseRisk,
        onBack: () => _go(_Page.karhutlaCards),
      ),
      _Page.triangleBuild => _TriangleBuild(
        english: _en,
        pieces: _triangle,
        lastDropCorrect: _lastDropCorrect,
        onDrop: _dropPiece,
        onBack: _restart,
        onRestart: _resetTriangle,
      ),
      _Page.triangleExplanation => _TriangleExplanation(
        english: _en,
        onContinue: () => _go(_Page.breakTriangle),
        onBack: () => _go(_Page.triangleBuild),
      ),
      _Page.breakTriangle => _BreakTriangle(
        english: _en,
        selected: _breakChoice,
        tried: _breakTried,
        onSelect: _chooseBreak,
        onBack: () => _go(_Page.triangleBuild),
      ),
      _Page.karhutlaCards => _KarhutlaCards(
        english: _en,
        index: _karhutlaCardIndex,
        onAdvance: () => setState(() {
          if (_karhutlaCardIndex < 2) _karhutlaCardIndex++;
        }),
        onComplete: () => _go(_Page.risk),
        onBack: () {
          if (_karhutlaCardIndex > 0) {
            setState(() => _karhutlaCardIndex--);
          } else {
            _go(_Page.breakTriangle);
          }
        },
      ),
      _Page.causeQuiz => _CauseQuiz(
        english: _en,
        index: _causeIndex,
        choice: _causeChoice,
        onChoose: _chooseCause,
        onBack: () => _go(_Page.risk),
      ),
      _Page.stopDecision => _StopDecision(
        english: _en,
        answer: _stopAnswer,
        wrongAttempts: _stopWrong,
        preparing: _preparingFinal,
        onAnswer: _chooseStop,
        onBack: () => _go(_Page.causeQuiz),
      ),
      _Page.finalChallenge => _FinalChallenge(
        english: _en,
        seconds: _seconds,
        found: _finalFound,
        onTap: (token) {
          if (_seconds > 0 && !_finalFound.contains(token)) {
            setState(() => _finalFound.add(token));
          }
        },
        onBack: () {
          _timer?.cancel();
          _go(_Page.stopDecision);
        },
      ),
      _Page.score => _ScorePage(
        english: _en,
        triangle: _trianglePoints,
        causes: _causePoints,
        decision: _stopAnswer == _PreventionAction.separateFuel ? 1 : 0,
        finalRaw: _finalRaw,
        bonus: _finalBonus,
        idleSeconds: _idleSeconds,
        onContinue: _openClosing,
        onAgain: _playAgain,
        onHome: _restart,
      ),
      _Page.closing => _ClosingPage(
        english: _en,
        onAgain: _playAgain,
        onExplore: _restart,
        idleSeconds: _idleSeconds,
      ),
    };
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetInactivity(),
      onPointerMove: (_) => _resetInactivity(),
      onPointerSignal: (_) => _resetInactivity(),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedSwitcher(
            duration: _motionDuration(
              context,
              const Duration(milliseconds: 320),
            ),
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
          ),
          Positioned.fill(
            child: AmbientFog(
              dark: _page == _Page.welcome || _page == _Page.closing,
            ),
          ),
        ],
      ),
    );
  }
}

enum _Page {
  welcome,
  risk,
  triangleBuild,
  triangleExplanation,
  breakTriangle,
  karhutlaCards,
  causeQuiz,
  stopDecision,
  finalChallenge,
  score,
  closing,
}

enum _FireSlot { heat, fuel, oxygen }

enum _FirePiece { heat, fuel, oxygen, water, rain, cold }

extension _FireCopy on _FireSlot {
  String title(bool en) => switch (this) {
    _FireSlot.heat => en ? 'Heat' : 'Panas',
    _FireSlot.fuel => en ? 'Fuel' : 'Bahan bakar',
    _FireSlot.oxygen => en ? 'Oxygen' : 'Oksigen',
  };
  String get photo => switch (this) {
    _FireSlot.heat => 'assets/images/field/sunlit-grass.jpg',
    _FireSlot.fuel => 'assets/images/field/dry-wood-client.jpg',
    _FireSlot.oxygen => 'assets/images/field/oxygen-air.jpg',
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
  String get photo => switch (this) {
    _FirePiece.heat => 'assets/images/field/sunlit-grass.jpg',
    _FirePiece.fuel => 'assets/images/field/dry-wood-client.jpg',
    _FirePiece.oxygen => 'assets/images/field/oxygen-air.jpg',
    _FirePiece.water => 'assets/images/field/water-surface.jpg',
    _FirePiece.rain => 'assets/images/field/rain-splash.jpg',
    _FirePiece.cold => 'assets/images/field/cool-mist.jpg',
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
                const SizedBox(height: 14),
                _LanguagePicker(
                  locale: locale,
                  onChanged: onLocale,
                  contextLabel: locale == AppLocale.english
                      ? 'Calm waterways · protected vegetation'
                      : 'Hutan gambut dan aliran air',
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
                    fontFamily: 'ArchivoBlack',
                    fontSize: 36,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  locale == AppLocale.english
                      ? 'Read the landscape, spot the trigger, and stop risk before it grows.'
                      : 'Kenali penyebab kebakaran dan cari tahu cara menjaga hutan dari api.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                const Expanded(
                  child: Center(child: GameMascot(pose: MascotPose.welcome, height: 130)),
                ),
                Text(
                  locale == AppLocale.english
                      ? '4 chapters • around 3 minutes • no sound needed'
                      : '4 babak • sekitar 3 menit • bisa dimainkan tanpa suara',
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

class _RiskPage extends StatelessWidget {
  const _RiskPage({
    required this.english,
    required this.answer,
    required this.wrongAttempts,
    required this.onAnswer,
    required this.onBack,
  });
  final bool english;
  final _RiskOption? answer;
  final int wrongAttempts;
  final ValueChanged<_RiskOption> onAnswer;
  final VoidCallback onBack;

  static const _RiskOption _correct = _RiskOption.dryVegetationWithIgnition;

  @override
  Widget build(BuildContext context) {
    final solved = answer == _correct;
    final revealed = solved || wrongAttempts >= 2;
    final locked = revealed;
    return _LightStage(
      chapter: 2,
      english: english,
      eyebrow: english
          ? 'CHAPTER 2 / SCAN THE RISK'
          : 'BABAK 2 / KENALI RISIKONYA',
      title: english
          ? 'Where could fire start more easily?'
          : 'Di mana api lebih mudah muncul?',
      subtitle: english
          ? 'Choose the condition with the highest fire risk.'
          : 'Dari tiga kondisi ini, mana yang paling mudah terbakar?',
      onBack: onBack,
      bodyScrollable: false,
      body: LayoutBuilder(builder: (context, bounds) {
        final cardHeight = ((bounds.maxHeight - 16) / 3).clamp(52.0, 72.0);
        return Column(
        children: <Widget>[
          _RiskCard(
            height: cardHeight,
            option: _RiskOption.wetForest,
            english: english,
            selected: answer == _RiskOption.wetForest,
            correct: false,
            onTap: locked ? null : () => onAnswer(_RiskOption.wetForest),
          ),
          const SizedBox(height: 8),
          _RiskCard(
            option: _correct,
            height: cardHeight,
            english: english,
            selected: revealed,
            correct: true,
            onTap: locked ? null : () => onAnswer(_correct),
          ),
          const SizedBox(height: 8),
          _RiskCard(
            option: _RiskOption.wetGrassland,
            height: cardHeight,
            english: english,
            selected: answer == _RiskOption.wetGrassland,
            correct: false,
            onTap: locked ? null : () => onAnswer(_RiskOption.wetGrassland),
          ),
        ],
      );
      }),
      footer: _footer(
        solved: solved,
        revealed: revealed,
        answered: answer != null,
      ),
    );
  }

  Widget _footer({
    required bool solved,
    required bool revealed,
    required bool answered,
  }) {
    if (!answered) {
      return Text(
        english
            ? 'Choose the answer that fits the situation best.'
            : 'Pilih salah satu jawaban untuk melihat penjelasannya.',
        style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
      );
    }
    if (solved) {
      return _Feedback(
        ok: true,
        text: english
            ? 'That’s right. Dry fuel plus a spark or heat source raises the risk quickly.'
            : 'Bahan kering mudah tersulut jika ada sumber api di dekatnya. Kondisi ini paling berisiko.',
      );
    }
    if (!revealed) {
      return _Feedback(
        ok: false,
        text: english
            ? 'Not quite. Look for dry fuel and something that can ignite it. You get one more try.'
            : 'Belum tepat. Cari bahan yang kering dan sumber api yang bisa menyulutnya. Kamu masih punya satu kesempatan lagi.',
      );
    }
    return _Feedback(
      ok: false,
      text: english
          ? 'The riskiest condition is dry vegetation with an ignition source. Dry fuel catches fire easily when heat is nearby.'
          : 'Kondisi paling berisiko adalah tanaman kering di dekat sumber api. Bahan kering mudah tersulut oleh panas.',
    );
  }
}

class _MascotDialogue extends StatelessWidget {
  const _MascotDialogue({required this.text, this.compact = false});
  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: compact ? 78 : 94,
        child: GameMascot(pose: MascotPose.presenting, height: compact ? 124 : 170),
      ),
      // The speech tail connects the ranger with the reading card.
      ClipPath(
        clipper: _SpeechTail(),
        child: const ColoredBox(color: KifcTheme.paper, child: SizedBox(width: 10, height: 18)),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(compact ? 12 : 16),
          decoration: BoxDecoration(
            color: KifcTheme.paper,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: KifcTheme.line),
          ),
          child: Text(text, style: TextStyle(color: KifcTheme.ink, fontSize: compact ? 13 : 14, height: 1.4)),
        ),
      ),
    ],
  );
}

class _SpeechTail extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width, 0)
    ..lineTo(0, size.height / 2)
    ..lineTo(size.width, size.height)
    ..close();

  @override
  bool shouldReclip(_SpeechTail oldClipper) => false;
}

class _KarhutlaCards extends StatelessWidget {
  const _KarhutlaCards({required this.english, required this.index, required this.onAdvance, required this.onComplete, required this.onBack});
  final bool english;
  final int index;
  final VoidCallback onAdvance;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Working narrative: replace content by stable ID when client copy arrives.
    // Each card keeps one idea, and its own lead-in line so the subtitles do
    // not repeat the same generic sentence.
    final cards = english
        ? [
            (
              'karhutla-definition',
              'What is a forest fire?',
              'A forest or land fire burns vegetation such as grass, leaves, and trees. When it spreads out of control, it can reach nearby areas.',
              'You have seen how fire starts. What happens when it spreads?',
            ),
            (
              'karhutla-impact',
              'Why does it matter?',
              'Fire can damage habitats, and smoke can affect nearby communities. Preventing fires helps protect both forests and people.',
              'A fire harms more than the trees in its path.',
            ),
            (
              'karhutla-prevention',
              'Prevent it early.',
              'Dry vegetation is easier to ignite when a source of heat is nearby. Keep ignition sources away. If you see a fire, keep your distance and alert trained personnel.',
              'Most forest fires can be stopped before they grow.',
            ),
          ]
        : [
            (
              'karhutla-definition',
              'Apa itu karhutla?',
              'Karhutla adalah kebakaran hutan dan lahan. Api membakar rumput, daun, atau pepohonan dan bisa menjalar ke sekitarnya jika tidak terkendali.',
              'Tadi kamu melihat api menyala. Bagaimana jika api itu menjalar?',
            ),
            (
              'karhutla-impact',
              'Mengapa perlu dicegah?',
              'Api bisa merusak tempat hidup satwa, sementara asapnya mengganggu warga. Mencegah karhutla berarti menjaga hutan sekaligus melindungi kehidupan di sekitarnya.',
              'Api tidak hanya membakar pepohonan di jalurnya.',
            ),
            (
              'karhutla-prevention',
              'Cegah sebelum membesar.',
              'Tanaman kering lebih mudah tersulut jika ada sumber api di dekatnya. Jauhkan sumber api dari bahan kering. Jika melihat kebakaran, jaga jarak dan laporkan kepada petugas.',
              'Sebagian besar karhutla bisa dicegah sebelum membesar.',
            ),
          ];
    final card = cards[index];
    return _DarkStage(
      chapter: 2,
      english: english,
      eyebrow: english ? 'CHAPTER 2 / FOREST FIRE' : 'BABAK 2 / KARHUTLA',
      title: card.$2,
      subtitle: card.$4,
      groupFooter: true,
      onBack: onBack,
      body: Column(
        key: ValueKey(card.$1),
          mainAxisSize: MainAxisSize.min,
          children: [
            _MascotDialogue(text: card.$3),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var i = 0; i < cards.length; i++)
                Container(margin: const EdgeInsets.symmetric(horizontal: 3), width: i == index ? 24 : 7, height: 7,
                  decoration: BoxDecoration(color: i == index ? KifcTheme.amber : Colors.white38, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 10),
              Text('${index + 1}/3', style: const TextStyle(color: Colors.white70)),
            ]),
          ],
      ),
      footer: _Primary(label: index == 2 ? (english ? 'See the Risk' : 'Lihat Risikonya') : (english ? 'Continue' : 'Lanjut'), dark: true, onPressed: index == 2 ? onComplete : onAdvance),
    );
  }
}

enum _RiskOption { wetForest, dryVegetationWithIgnition, wetGrassland }

extension _RiskOptionVisual on _RiskOption {
  String get photo => switch (this) {
    _RiskOption.wetForest => 'assets/images/forest/kereng-bangkirai.jpg',
    _RiskOption.dryVegetationWithIgnition =>
      'assets/images/field/dry-landscape.jpg',
    _RiskOption.wetGrassland => 'assets/images/field/wet-grass.jpg',
  };
}

extension _RiskOptionCopy on _RiskOption {
  String label(bool english) => switch (this) {
    _RiskOption.wetForest => english ? 'Wet forest' : 'Hutan basah',
    _RiskOption.dryVegetationWithIgnition =>
      english
          ? 'Dry vegetation with an ignition source'
          : 'Tanaman kering di dekat sumber api',
    _RiskOption.wetGrassland =>
      english ? 'Wet grassland' : 'Padang rumput basah',
  };
}

class _TriangleBuild extends StatelessWidget {
  const _TriangleBuild({
    required this.english,
    required this.pieces,
    required this.lastDropCorrect,
    required this.onDrop,
    required this.onBack,
    required this.onRestart,
  });
  final bool english;
  final Map<_FireSlot, _FirePiece> pieces;
  final bool? lastDropCorrect;
  final void Function(_FireSlot, _FirePiece) onDrop;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  @override
  Widget build(BuildContext context) {
    final complete = pieces.length == 3;
    return _LightStage(
      chapter: 1,
      english: english,
      eyebrow: english
          ? 'CHAPTER 1 / PUT IT TOGETHER'
          : 'BABAK 1 / SATUKAN TIGA UNSUR',
      title: complete
          ? (english ? 'The fire has started.' : 'Api mulai menyala.')
          : (english ? 'Build the fire triangle.' : 'Susun tiga unsur api.'),
      subtitle: complete
          ? (english
                ? 'All three elements are now together.'
                : 'Ketiga unsur sudah lengkap. Dengan panas yang cukup untuk menyulut bahan bakar, api bisa menyala.')
          : lastDropCorrect == true
          ? (english
                ? 'That fits. Find the next element.'
                : 'Sudah cocok. Lanjutkan dengan foto lainnya.')
          : lastDropCorrect == false
          ? (english
                ? 'Try another element for that card.'
                : 'Foto ini belum cocok di sini. Coba tempat lain atau pilih foto lainnya.')
          : (english
                ? 'Drag each photo to its element.'
                : 'Seret foto dari bawah ke tempat yang cocok.'),
      onBack: onBack,
      onRestart: onRestart,
      groupFooter: true,
      bodyScrollable: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _FireScene(
            active: pieces.keys.toSet(),
            english: english,
            onDrop: onDrop,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: _fireCardAspectRatio,
            children:
                const <_FirePiece>[
                      _FirePiece.heat,
                      _FirePiece.water,
                      _FirePiece.fuel,
                      _FirePiece.rain,
                      _FirePiece.oxygen,
                      _FirePiece.cold,
                    ]
                    .map(
                      (piece) => _DraggablePiece(
                        piece: piece,
                        english: english,
                        used: pieces.values.contains(piece),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
      footer: complete
          ? _AutoNote(
              text: english
                  ? 'The fire is burning. Moving on to the fire triangle…'
                  : 'Api menyala. Lanjut ke segitiga api…',
            )
          : const SizedBox.shrink(),
    );
  }
}

class _TriangleExplanation extends StatelessWidget {
  const _TriangleExplanation({
    required this.english,
    required this.onContinue,
    required this.onBack,
  });
  final bool english;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 1,
    english: english,
    eyebrow: english ? 'CHAPTER 1 / FIRE TRIANGLE' : 'BABAK 1 / SEGITIGA API',
    title: english ? 'Three elements, one fire.' : 'Tiga unsur, satu api.',
    bodyScrollable: false,
    subtitle: english ? 'Together, they form the fire triangle.' : 'Ketiganya dikenal sebagai segitiga api.',
    onBack: onBack,
    body: Column(
      children: [
        Expanded(child: Center(child: _MascotDialogue(
          compact: true,
          text: english
              ? 'Heat ignites fuel such as dry wood. Oxygen from the air keeps it burning. Sunlight can dry vegetation, but it still needs an ignition source to catch fire.'
              : 'Panas menyulut bahan bakar, seperti kayu kering. Oksigen dari udara membantu api terus menyala. Matahari bisa mengeringkan tanaman, tetapi api tetap perlu sumber penyulut.',
        ))),
        const SizedBox(height: 10),
        _FireScene(active: _FireSlot.values.toSet(), english: english),
      ],
    ),
    footer: _Primary(
      label: english ? 'Try Reducing an Element' : 'Coba Kurangi Satu Unsur',
      onPressed: onContinue,
    ),
  );
}

class _BreakTriangle extends StatelessWidget {
  const _BreakTriangle({
    required this.english,
    required this.selected,
    required this.tried,
    required this.onSelect,
    required this.onBack,
  });
  final bool english;
  final _FireSlot? selected;
  final Set<_FireSlot> tried;
  final ValueChanged<_FireSlot> onSelect;
  final VoidCallback onBack;

  (String, String) get explanation => switch (selected) {
    _FireSlot.heat => (
      english ? 'Less heat, a weaker flame.' : 'Suhu turun, api mereda.',
      english
          ? 'Cooling burning material removes heat. When it is no longer hot enough to keep burning, the flame goes out.'
          : 'Bahan yang terbakar perlu didinginkan. Jika suhunya sudah cukup turun, api tak lagi bisa bertahan dan akan padam.',
    ),
    _FireSlot.fuel => (
      english
          ? 'Gaps interrupt the spread.'
          : 'Beri jarak agar api sulit menjalar.',
      english
          ? 'With less dry material in its path, fire has less fuel to reach. Material already burning may still need to be extinguished.'
          : 'Jika bahan kering diberi jarak, api lebih sulit menjalar. Bahan yang sudah terbakar tetap perlu dipadamkan.',
    ),
    _FireSlot.oxygen => (
      english
          ? 'Fire needs oxygen from the air.'
          : 'Api perlu oksigen dari udara.',
      english
          ? 'Limiting oxygen at the flame can smother it. This is difficult in open land; still air alone does not remove oxygen.'
          : 'Membatasi oksigen bisa memadamkan api, tetapi sulit di lahan terbuka. Tanpa angin pun, udara tetap mengandung oksigen.',
    ),
    null => (
      english
          ? 'Three elements keep fire burning.'
          : 'Bagaimana kalau satu unsur dikurangi?',
      english
          ? 'Explore each element to see why reducing it can weaken the fire or slow its spread.'
          : 'Api perlu ketiga unsur ini agar terus menyala. Saat satu unsur berkurang, nyala atau rambatannya bisa ikut berkurang.',
    ),
  };

  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 1,
    english: english,
    eyebrow: english
        ? 'CHAPTER 1 / INTERACTIVE DEMO'
        : 'BABAK 1 / DEMO INTERAKTIF',
    title: english ? 'Reduce one element.' : 'Kurangi satu unsur.',
    subtitle: english
        ? 'Touch an element and watch the flame change. You can try all three.'
        : 'Pilih unsur yang ingin dikurangi, lalu amati apinya. Kamu bisa mencoba ketiganya.',
    onBack: onBack,
    bodyScrollable: false,
    groupFooter: true,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _FireScene(
          active: _FireSlot.values.toSet(),
          english: english,
          reduced: selected,
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            for (final slot in _FireSlot.values) ...<Widget>[
              if (slot != _FireSlot.values.first) const SizedBox(width: 6),
              Expanded(
                child: _ChoiceButton(
                  label: slot.title(english),
                  selected: selected == slot,
                  graded: false,
                  onTap: () => onSelect(slot),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          key: const ValueKey<String>('triangle-demo-explanation'),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .8),
            border: Border.all(color: KifcTheme.line),
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                explanation.$1,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                explanation.$2,
                style: const TextStyle(fontSize: 12, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    ),
    footer: tried.length == _FireSlot.values.length
        ? _AutoNote(
            text: english
                ? 'You tried all three elements. Next, see how fires start in the field.'
                : 'Ketiga unsur sudah kamu coba. Sekarang kita lihat bagaimana karhutla bisa terjadi.',
          )
        : Text(
            '${tried.length}/3 ${english ? 'elements tried' : 'unsur sudah dicoba'}',
            style: const TextStyle(
              color: KifcTheme.mutedInk,
              fontSize: 12,
              height: 1.25,
            ),
          ),
  );
}

class _CauseQuiz extends StatelessWidget {
  const _CauseQuiz({
    required this.english,
    required this.index,
    required this.choice,
    required this.onChoose,
    required this.onBack,
  });
  final bool english;
  final int index;
  final bool? choice;
  final ValueChanged<bool> onChoose;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    final scenarios = _causeScenarios(english);
    final scenario = scenarios[index];
    final answered = choice != null;
    final correct = choice == scenario.human;
    final lastScenario = index == scenarios.length - 1;
    final summary = english
        ? 'Risk can come from people or nature. The best prevention happens before there is a flame.'
        : 'Kebakaran bisa dipicu manusia maupun alam. Mencegahnya lebih baik daripada memadamkannya.';
    return _LightStage(
      chapter: 3,
      english: english,
      eyebrow: english
          ? 'CHAPTER 3 / CLUE ${index + 1} OF 4'
          : 'BABAK 3 / SITUASI ${index + 1} DARI 4',
      title: english
          ? 'What most likely triggered this risk?'
          : 'Apa penyebabnya?',
      subtitle: english
          ? 'Read the situation, then choose where the trigger came from.'
          : 'Baca situasinya. Apakah api dipicu aktivitas manusia atau faktor alam?',
      onBack: onBack,
      body: Column(
        children: <Widget>[
          _ScenarioCard(
            label: scenario.text,
            index: index + 1,
            photo: scenario.photo,
            english: english,
          ),
          const SizedBox(height: 8),
          _ChoiceButton(
            height: 44,
            label: english ? 'Human activity' : 'Aktivitas manusia',
            selected: choice == true,
            error: answered && choice == true && !correct,
            onTap: answered ? null : () => onChoose(true),
          ),
          const SizedBox(height: 6),
          _ChoiceButton(
            height: 44,
            label: english ? 'Natural factor' : 'Faktor alam',
            selected: choice == false,
            error: answered && choice == false && !correct,
            onTap: answered ? null : () => onChoose(false),
          ),
        ],
      ),
      footer: answered
          ? _Feedback(
              ok: correct,
              text: english
                  ? (correct
                        ? 'Correct. ${scenario.reason}${lastScenario ? ' $summary' : ''}'
                        : 'The answer is ${scenario.human ? 'human activity.' : 'a natural factor.'} ${scenario.reason}${lastScenario ? ' $summary' : ''}')
                  : (correct
                        ? '${scenario.reason}${lastScenario ? ' $summary' : ''}'
                        : 'Yang ini dipicu ${scenario.human ? 'aktivitas manusia' : 'faktor alam'}. ${scenario.reason}${lastScenario ? ' $summary' : ''}'),
            )
          : Text(
              english
                  ? 'Choose the answer that fits the situation best.'
                  : 'Pilih salah satu jawaban untuk melihat penjelasannya.',
              style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
            ),
    );
  }
}

enum _PreventionAction { separateFuel, approach, addFuel }

extension _PreventionCopy on _PreventionAction {
  bool get correct => this == _PreventionAction.separateFuel;
  String label(bool en) => switch (this) {
    _PreventionAction.separateFuel =>
      en ? 'Separate the fuel' : 'Pisahkan bahan bakar',
    _PreventionAction.approach => en ? 'Move closer to the fire' : 'Dekati api',
    _PreventionAction.addFuel => en ? 'Add more fuel' : 'Tambahkan bahan bakar',
  };
  String feedback(bool en) => switch (this) {
    _PreventionAction.separateFuel =>
      en
          ? 'The fuel break stops further spread in this simulation. In a real incident, keep your distance and contact trained personnel.'
          : 'Bahan bakar yang terpisah membuat api sulit menjalar. Jika melihat kebakaran, jaga jarak dan hubungi petugas terlatih.',
    _PreventionAction.approach =>
      en
          ? 'Moving closer puts you in danger. Keep your distance and alert trained personnel. They can separate fuel to limit the spread.'
          : 'Mendekati api berbahaya. Petugas terlatih bisa memisahkan bahan bakar agar api sulit menjalar. Jika melihat kebakaran, jaga jarak dan laporkan.',
    _PreventionAction.addFuel =>
      en
          ? 'More fuel helps the fire spread. Trained personnel can separate fuel to limit it. Keep away from a real fire.'
          : 'Menambah bahan bakar justru bisa memperbesar api. Petugas terlatih bisa memisahkannya agar api sulit menjalar. Tetap jaga jarak dari kebakaran.',
  };
}

class _StopDecision extends StatelessWidget {
  const _StopDecision({
    required this.english,
    required this.answer,
    required this.wrongAttempts,
    required this.preparing,
    required this.onAnswer,
    required this.onBack,
  });
  final bool english;
  final _PreventionAction? answer;
  final int wrongAttempts;
  final bool preparing;
  final ValueChanged<_PreventionAction> onAnswer;
  final VoidCallback onBack;

  static const _PreventionAction _correct = _PreventionAction.separateFuel;

  @override
  Widget build(BuildContext context) {
    final solved = answer == _correct;
    final revealed = solved || wrongAttempts >= 2;
    final locked = revealed;
    return _LightStage(
      chapter: 4,
      english: english,
      eyebrow: english ? 'CHAPTER 4 / MAKE A CHOICE' : 'BABAK 4 / PILIH TINDAKAN',
      title: english ? 'Stop the spread.' : 'Batasi rambatan api.',
      subtitle: english
          ? 'Which action should trained personnel take?'
          : 'Apa yang bisa dilakukan petugas terlatih agar api tidak terus menjalar?',
      onBack: onBack,
      bodyScrollable: false,
      body: LayoutBuilder(
        builder: (context, bounds) {
          final sceneHeight = math.min(
            174.0,
            math.max(48.0, bounds.maxHeight - 152),
          );
          return Column(
            children: <Widget>[
              _SpreadScene(
                english: english,
                height: sceneHeight,
                action: answer,
                decision: true,
              ),
              const SizedBox(height: 8),
              ..._PreventionAction.values.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _ChoiceButton(
                    key: ValueKey('decision-${action.name}'),
                    height: 44,
                    label: action.label(english),
                    selected: action == _correct ? revealed : answer == action,
                    error: answer == action && !action.correct,
                    onTap: locked ? null : () => onAnswer(action),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (answer != null) ...<Widget>[
            _Feedback(
              ok: solved,
              text: solved
                  ? _correct.feedback(english)
                  : (revealed
                        ? (english
                              ? 'The safe action is to separate the fuel. ${_correct.feedback(english)}'
                              : 'Tindakan aman adalah memisahkan bahan bakar. ${_correct.feedback(english)}')
                        : (english
                              ? 'Not quite. Think about what keeps the fire from reaching more material. You get one more try.'
                              : 'Belum tepat. Pikirkan tindakan yang membuat api sulit mencapai bahan lain. Kamu masih punya satu kesempatan lagi.')),
            ),
            const SizedBox(height: 8),
          ],
          if (preparing)
            _Primary(
              key: const ValueKey('open-final'),
              label: english ? 'Preparing challenge…' : 'Menyiapkan tantangan…',
              onPressed: null,
            ),
        ],
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final correct = found.where((item) => item.risk).length;
    final wrong = found.length - correct;
    final net = math.max(0, correct - wrong);
    return _LightStage(
      chapter: 4,
      english: english,
      eyebrow: english
          ? 'CHAPTER 4 / FINAL CHALLENGE'
          : 'BABAK 4 / TANTANGAN AKHIR',
      title: english ? 'Spot the fire risks.' : 'Temukan risiko kebakaran.',
      subtitle: english
          ? 'Choose only risky objects or conditions. Correct +1, incorrect −1.'
          : 'Sentuh gambar yang bisa memicu atau memperbesar kebakaran. Benar +1, salah −1.',
      onBack: onBack,
      trailing: _TimerChip(seconds: seconds, english: english),
      bodyScrollable: false,
      body: LayoutBuilder(
        builder: (context, bounds) {
          final cardHeight = math.min(
            112.0,
            math.max(52.0, (bounds.maxHeight - 51) / 2),
          );
          return Column(
            children: <Widget>[
              SizedBox(
                height: cardHeight * 2 + 8,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: ((bounds.maxWidth - 16) / 3) / cardHeight,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
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
              ),
              const SizedBox(height: 10),
              Text(
                english
                    ? '$net/4 points · $wrong incorrect'
                    : '$net/4 poin · $wrong pilihan salah',
                key: const ValueKey('final-raw-score'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        },
      ),
      footer: _SafetyNote(english: english),
    );
  }
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
    _RiskToken.dryVegetation => en ? 'Dry vegetation' : 'Tanaman kering',
    _RiskToken.cigarette => en ? 'Cigarette butt' : 'Puntung menyala',
    _RiskToken.unmanagedFire => en ? 'Uncontrolled fire' : 'Api tak terkendali',
    _RiskToken.healthyVegetation => en ? 'Healthy vegetation' : 'Hutan basah',
    _RiskToken.dryWood => en ? 'Dry wood' : 'Kayu kering',
    _RiskToken.rain => en ? 'Rain' : 'Hujan',
  };
  String get photo => switch (this) {
    _RiskToken.dryVegetation => 'assets/images/field/dry-leaf-litter.jpg',
    _RiskToken.cigarette => 'assets/images/field/cigarette-leaves.jpg',
    _RiskToken.unmanagedFire => 'assets/images/field/fire-klaten.jpg',
    _RiskToken.healthyVegetation => 'assets/images/forest/kereng-bangkirai.jpg',
    _RiskToken.dryWood => 'assets/images/field/dry-wood-client.jpg',
    _RiskToken.rain => 'assets/images/field/rain-splash.jpg',
  };
}

class _ScorePage extends StatelessWidget {
  const _ScorePage({
    required this.english,
    required this.triangle,
    required this.causes,
    required this.decision,
    required this.finalRaw,
    required this.bonus,
    required this.idleSeconds,
    required this.onContinue,
    required this.onAgain,
    required this.onHome,
  });
  final bool english;
  final int triangle, causes, decision, finalRaw, idleSeconds;
  final double bonus;
  final VoidCallback onContinue, onAgain, onHome;
  double get total => triangle + causes + decision + bonus;
  String get title => total >= 8
      ? (english ? 'Fire Prevention Hero' : 'Siap Cegah Karhutla')
      : total >= 6
      ? (english ? 'Fire Awareness Champion' : 'Makin Paham Risikonya')
      : (english ? 'Keep Exploring' : 'Ayo, Coba Lagi');
  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 4,
    english: english,
    eyebrow: english
        ? 'CHALLENGE COMPLETE / RESULT'
        : 'TANTANGAN SELESAI / HASIL',
    title: title,
    subtitle: english
        ? 'Here is your result. Keep exploring the exhibition.'
        : 'Lihat hasilmu, lalu lanjut jelajahi pameran.',
    onBack: onHome,
    backLabel: english ? 'Home' : 'Beranda',
    bodyScrollable: false,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: KifcTheme.success,
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                _points(total, english),
                key: const ValueKey('total-score'),
                style: const TextStyle(
                  fontSize: 56,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  english ? '/ 9 points' : '/ 9 poin',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _ScoreRow(
          label: english ? 'Elements placed' : 'Menyusun unsur',
          score: '$triangle/3',
        ),
        _ScoreRow(
          label: english ? 'Recognising causes' : 'Mengenali penyebab',
          score: '$causes/4',
        ),
        _ScoreRow(
          label: english ? 'Safe decision' : 'Memilih tindakan aman',
          score: '$decision/1',
        ),
        _ScoreRow(
          label: english ? 'Final challenge bonus' : 'Bonus tantangan akhir',
          score: '${_points(bonus, english)}/1',
        ),
        Text(
          english
              ? '$finalRaw/4 challenge points → +${_points(bonus, english)} bonus'
              : '$finalRaw/4 poin di babak akhir = ${_points(bonus, english)} poin bonus',
          style: const TextStyle(fontSize: 11, color: KifcTheme.mutedInk),
        ),
        const SizedBox(height: 12),
        Text(
          english
              ? 'Keep ignition sources away from dry fuel. Report signs of fire and follow trained personnel.'
              : 'Jauhkan sumber api dari bahan yang mudah terbakar. Jika melihat kebakaran, laporkan dan ikuti arahan petugas.',
          style: const TextStyle(fontSize: 13, height: 1.3),
        ),
      ],
    ),
    footer: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Primary(
          label: english ? 'Closing Message' : 'Selesai',
          onPressed: onContinue,
        ),
        const SizedBox(height: 8),
        _Secondary(
          label: english ? 'Play Again' : 'Main Lagi',
          onPressed: onAgain,
        ),
        const SizedBox(height: 8),
        _IdleNotice(english: english, seconds: idleSeconds),
      ],
    ),
  );
}

class _ClosingPage extends StatelessWidget {
  const _ClosingPage({
    required this.english,
    required this.onAgain,
    required this.onExplore,
    required this.idleSeconds,
  });
  final bool english;
  final VoidCallback onAgain, onExplore;
  final int idleSeconds;
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 680;
    return Scaffold(
      backgroundColor: KifcTheme.forest950,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/forest/kereng-bangkirai.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(-.18, 0),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: <double>[0, .15, .32, .52, .77, 1],
                colors: <Color>[
                  Color(0xAB0A241B),
                  Color(0xA30A241B),
                  Color(0x440A241B),
                  Color(0xE00A241B),
                  Color(0xF50A241B),
                  Color(0xFF0A241B),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _PartnerHeader(dark: true),
                  SizedBox(height: compact ? 10 : 16),
                  Row(
                    children: <Widget>[
                      _SmallButton(
                        label: english ? 'Home' : 'Beranda',
                        icon: Icons.arrow_back,
                        onPressed: onExplore,
                        dark: true,
                      ),
                      const Spacer(),
                      Text(
                        english ? 'CHALLENGE COMPLETE' : 'TANTANGAN SELESAI',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .4,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Flexible(child: GameMascot(pose: MascotPose.success, height: compact ? 78 : 105)),
                        _Eyebrow(
                          text: english
                              ? 'THANK YOU FOR PLAYING'
                              : 'TERIMA KASIH SUDAH BERMAIN',
                          dark: true,
                        ),
                        Text(
                          english
                              ? 'Protect forests.\nProtect lives.'
                              : 'Jaga hutan,\njaga kehidupan.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 30 : 34,
                            fontWeight: FontWeight.w800,
                            height: 1.06,
                            letterSpacing: -.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          english
                              ? 'Keep ignition sources away from dry vegetation. If you see a fire, alert trained personnel.'
                              : 'Mulai dari hal sederhana: jauhkan sumber api dari bahan kering. Jika melihat kebakaran, segera laporkan kepada petugas.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: compact ? 18 : 24),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 12),
                        const Text(
                          'Korea–Indonesia Forest Cooperation Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          english
                              ? 'Cooperation, knowledge and innovation for forest and land fire prevention.'
                              : 'Kerja sama, pengetahuan, dan inovasi untuk mencegah kebakaran hutan dan lahan.',
                          style: const TextStyle(
                            color: Color(0xCFEEF3E9),
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: compact ? 18 : 24),
                  SizedBox(
                    height: 46,
                    child: FilledButton(
                      onPressed: onAgain,
                      style: FilledButton.styleFrom(
                        backgroundColor: KifcTheme.paper,
                        foregroundColor: KifcTheme.forest950,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            KifcTheme.controlRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        english ? 'Play Again' : 'Main Lagi',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Secondary(
                    label: english
                        ? 'Explore the Exhibition'
                        : 'Jelajahi Pameran',
                    onPressed: onExplore,
                    dark: true,
                  ),
                  const SizedBox(height: 10),
                  _IdleNotice(
                    english: english,
                    seconds: idleSeconds,
                    dark: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdleNotice extends StatelessWidget {
  const _IdleNotice({
    required this.english,
    required this.seconds,
    this.dark = false,
  });
  final bool english;
  final int seconds;
  final bool dark;
  @override
  Widget build(BuildContext context) => Text(
    english
        ? 'Returns home after $seconds seconds without interaction.'
        : 'Layar kembali ke awal dalam $seconds detik jika tidak disentuh.',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 10,
      color: dark ? Colors.white70 : KifcTheme.mutedInk,
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
    this.groupFooter = false,
  });
  final int chapter;
  final bool english;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;
  final VoidCallback onBack;
  final bool groupFooter;
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 680;
    return Scaffold(
      backgroundColor: KifcTheme.forest950,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _PartnerHeader(dark: true),
              SizedBox(height: compact ? 9 : 17),
              _TopBar(
                chapter: chapter,
                english: english,
                dark: true,
                onBack: onBack,
              ),
              SizedBox(height: compact ? 9 : 14),
              _Eyebrow(text: eyebrow, dark: true),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  height: 1.08,
                  fontSize: compact ? 26 : 29,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: compact ? 13 : 14,
                  height: 1.25,
                ),
              ),
              SizedBox(height: compact ? 12 : 20),
              if (groupFooter)
                Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [body, const SizedBox(height: 20), footer])))
              else ...[
                Expanded(child: body),
                SizedBox(height: compact ? 10 : 16),
                footer,
              ],
            ],
          ),
        ),
      ),
    );
  }
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
    this.backLabel,
    this.groupFooter = false,
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
  final String? backLabel;
  final bool groupFooter;
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 680;
    return Scaffold(
      backgroundColor: KifcTheme.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _PartnerHeader(),
              SizedBox(height: compact ? 9 : 15),
              _TopBar(
                chapter: chapter,
                english: english,
                onBack: onBack,
                backLabel: backLabel,
                onRestart: onRestart,
                trailing: trailing,
              ),
              SizedBox(height: compact ? 9 : 15),
              _Eyebrow(text: eyebrow),
              Text(
                title,
                style: TextStyle(
                  fontSize: compact ? 26 : 29,
                  height: 1.07,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: KifcTheme.mutedInk,
                    fontSize: compact ? 13 : 14,
                    height: 1.25,
                  ),
                ),
              ],
              SizedBox(height: compact ? 10 : 16),
              if (groupFooter)
                Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [body, const SizedBox(height: 16), footer])))
              else ...[
              Expanded(
                child: bodyScrollable
                    ? SingleChildScrollView(child: body)
                    : body,
              ),
              SizedBox(height: compact ? 9 : 14),
              footer,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LiquidGlass extends StatelessWidget {
  const _LiquidGlass({
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.tint = const Color(0x24FFFFFF),
    this.padding,
  });
  final Widget child;
  final BorderRadius borderRadius;
  final Color tint;
  final EdgeInsetsGeometry? padding;

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
            color: Colors.white.withValues(alpha: .4),
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
  const _LanguagePicker({
    required this.locale,
    required this.onChanged,
    required this.contextLabel,
  });
  final AppLocale locale;
  final ValueChanged<AppLocale> onChanged;
  final String contextLabel;

  @override
  Widget build(BuildContext context) => _LiquidGlass(
    borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
    tint: Colors.white.withValues(alpha: .2),
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: AppLocale.values
              .map(
                (candidate) => Expanded(
                  child: InkWell(
                    onTap: () => onChanged(candidate),
                    borderRadius: BorderRadius.circular(
                      KifcTheme.controlRadius,
                    ),
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
        const SizedBox(height: 7),
        Container(height: 1, color: Colors.white.withValues(alpha: .25)),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.water_drop_outlined,
              size: 14,
              color: Colors.white.withValues(alpha: .9),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                contextLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .94),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
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
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 246,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark ? Colors.white.withValues(alpha: .48) : KifcTheme.line,
        ),
        boxShadow: dark
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: .12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _assets
            .map(
              (asset) => SizedBox(
                width: 38,
                height: 30,
                child: Image.asset(asset, fit: BoxFit.contain),
              ),
            )
            .toList(),
      ),
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
    this.backLabel,
  });
  final int chapter;
  final bool english;
  final VoidCallback onBack;
  final bool dark;
  final VoidCallback? onRestart;
  final Widget? trailing;
  final String? backLabel;
  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _SmallButton(
        label: backLabel ?? (english ? 'Back' : 'Kembali'),
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
  const _Primary({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.dark = false,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool dark;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 46,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: KifcTheme.forest800,
        disabledBackgroundColor: dark
            ? KifcTheme.forest800.withValues(alpha: .88)
            : KifcTheme.warmPanel,
        foregroundColor: Colors.white,
        disabledForegroundColor: dark ? Colors.white : KifcTheme.mutedInk,
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
  const _Secondary({
    required this.label,
    required this.onPressed,
    this.dark = false,
  });
  final String label;
  final VoidCallback onPressed;
  final bool dark;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 44,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: dark ? Colors.white : KifcTheme.ink,
        side: BorderSide(color: dark ? Colors.white54 : KifcTheme.forest800),
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

class _RiskCard extends StatelessWidget {
  const _RiskCard({
    required this.option,
    required this.english,
    required this.selected,
    required this.correct,
    required this.onTap,
    this.height = 72,
  });
  final _RiskOption option;
  final bool english;
  final bool selected;
  final bool correct;
  final VoidCallback? onTap;
  final double height;
  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: _motionDuration(context, const Duration(milliseconds: 180)),
    curve: Curves.easeOutBack,
    scale: selected ? 1.01 : 1,
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: selected ? _answerGradient(correct) : null,
            border: Border.all(
              color: selected
                  ? (correct
                        ? KifcTheme.answerCorrect
                        : KifcTheme.answerIncorrect)
                  : KifcTheme.line,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: SizedBox(
                  width: 52,
                  height: 48,
                  child: GamePhoto(option.photo),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.label(english),
                  style: TextStyle(
                    color: selected ? Colors.white : KifcTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selected) ...<Widget>[
                const SizedBox(width: 8),
                _AnswerMark(correct: correct),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({
    required this.label,
    required this.index,
    required this.photo,
    required this.english,
  });
  final String label;
  final int index;
  final String photo;
  final bool english;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 116),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      border: Border.all(color: KifcTheme.line),
    ),
    child: Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(width: 78, height: 84, child: GamePhoto(photo)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                english ? 'FIELD SITUATION $index' : 'SITUASI $index',
                style: const TextStyle(
                  color: KifcTheme.mutedInk,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

LinearGradient _answerGradient(bool correct) => LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: correct
      ? const <Color>[KifcTheme.answerCorrect, KifcTheme.forest800]
      : const <Color>[KifcTheme.answerIncorrect, KifcTheme.answerIncorrectDeep],
);

class _AnswerMark extends StatelessWidget {
  const _AnswerMark({required this.correct});
  final bool correct;

  @override
  Widget build(BuildContext context) => Icon(
    correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
    color: Colors.white,
    size: 18,
  );
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.ok, required this.text});
  final bool ok;
  final String text;
  @override
  Widget build(BuildContext context) => !ok
      ? _MascotWrongFeedback(text: text)
      : TweenAnimationBuilder<double>(
    duration: _motionDuration(context, const Duration(milliseconds: 240)),
    curve: Curves.easeOutCubic,
    tween: Tween<double>(begin: .94, end: 1),
    builder: (context, scale, child) =>
        Transform.scale(scale: scale, child: child),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: _answerGradient(ok),
        borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        border: Border.all(
          color: ok ? KifcTheme.answerCorrect : KifcTheme.answerIncorrect,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (ok ? KifcTheme.forest950 : KifcTheme.answerIncorrectDeep)
                .withValues(alpha: .13),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GameMascot(pose: ok ? MascotPose.success : MascotPose.hintSafety, height: 46),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MascotWrongFeedback extends StatelessWidget {
  const _MascotWrongFeedback({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 150),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          width: 108,
          height: 150,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: 190,
              maxWidth: 190,
              minHeight: 270,
              maxHeight: 270,
              child: const GameMascot(pose: MascotPose.hintSafety, height: 270),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 96, top: 8, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipPath(
                clipper: _SpeechTail(),
                child: const ColoredBox(color: KifcTheme.paper, child: SizedBox(width: 10, height: 18)),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: KifcTheme.paper,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: KifcTheme.answerIncorrect.withValues(alpha: .45)),
                  ),
                  child: Text(text, style: const TextStyle(color: KifcTheme.ink, fontSize: 13, height: 1.25)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AutoNote extends StatelessWidget {
  const _AutoNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      gradient: _answerGradient(true),
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      border: Border.all(color: KifcTheme.answerCorrect),
    ),
    child: Row(
      children: <Widget>[
        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.error = false,
    this.graded = true,
    this.height = 48,
  });
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool error;
  final bool graded;
  final double height;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: _motionDuration(context, const Duration(milliseconds: 180)),
    curve: Curves.easeOutCubic,
    decoration: BoxDecoration(
      color: selected ? null : Colors.white,
      gradient: selected ? _answerGradient(!error) : null,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      boxShadow: selected
          ? <BoxShadow>[
              BoxShadow(
                color:
                    (error
                            ? KifcTheme.answerIncorrectDeep
                            : KifcTheme.forest950)
                        .withValues(alpha: .16),
                offset: const Offset(0, 3),
                blurRadius: 10,
              ),
            ]
          : null,
    ),
    child: SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: selected ? Colors.white : KifcTheme.ink,
          disabledForegroundColor: selected ? Colors.white : KifcTheme.ink,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          side: BorderSide(
            color: selected
                ? (error ? KifcTheme.answerIncorrect : KifcTheme.answerCorrect)
                : KifcTheme.line,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
        ),
        child: Row(
          children: <Widget>[
            if (graded) const SizedBox(width: 26),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (graded)
              SizedBox(
                width: 26,
                child: selected ? _AnswerMark(correct: !error) : null,
              ),
          ],
        ),
      ),
    ),
  );
}

class _SpreadScene extends StatefulWidget {
  const _SpreadScene({
    required this.english,
    required this.height,
    this.action,
    this.decision = false,
  });
  final bool english;
  final double height;
  final _PreventionAction? action;
  final bool decision;
  @override
  State<_SpreadScene> createState() => _SpreadSceneState();
}

class _SpreadSceneState extends State<_SpreadScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spread = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      _spread.value = widget.decision && widget.action == null ? .42 : 1;
    } else if (!_started) {
      _started = true;
      _spread.animateTo(
        widget.decision ? .42 : 1,
        duration: Duration(seconds: widget.decision ? 4 : 6),
      );
    }
  }

  @override
  void didUpdateWidget(covariant _SpreadScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.action != oldWidget.action) {
      if (widget.action?.correct == true) {
        _spread.animateTo(
          .43,
          duration: _motionDuration(context, const Duration(milliseconds: 900)),
          curve: Curves.easeOutCubic,
        );
      } else {
        _spread.animateTo(
          1,
          duration: _motionDuration(context, const Duration(milliseconds: 900)),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _spread.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stopped = widget.action?.correct == true;
    final caption = stopped
        ? (widget.english
              ? 'Fuel break · further spread stops'
              : 'Bahan bakar terpisah · api sulit menjalar')
        : widget.action == _PreventionAction.addFuel
        ? (widget.english
              ? 'More fuel · fire spreads further'
              : 'Bahan bakar bertambah · api makin menjalar')
        : (widget.english
              ? 'SIMULATION · fire spreads through nearby fuel'
              : 'SIMULASI · api menjalar ke bahan kering');
    return ClipRRect(
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, bounds) => Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                'assets/images/field/dry-landscape.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xB20C2119), Color(0x180C2119)],
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: stopped ? 1 : 0,
                  duration: _motionDuration(
                    context,
                    const Duration(milliseconds: 400),
                  ),
                  child: const _FuelBreak(),
                ),
              ),
              AnimatedBuilder(
                animation: _spread,
                builder: (context, _) => FireSpreadVisual(
                  progress: _spread.value,
                  stopped: stopped,
                  boosted: widget.action == _PreventionAction.addFuel,
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                top: 9,
                child: Text(
                  caption,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    shadows: <Shadow>[
                      Shadow(color: Colors.black87, blurRadius: 5),
                    ],
                  ),
                ),
              ),
              if (stopped && bounds.maxHeight > 90)
                Positioned(
                  left: bounds.maxWidth * .57,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xE6263B2C),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      widget.english ? 'BREAK' : 'SEKAT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FuelBreak extends StatelessWidget {
  const _FuelBreak();

  @override
  Widget build(BuildContext context) => ClipPath(
    clipper: const _FuelBreakClipper(),
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Magnify the bare track in the lower-left of the source photograph.
        Transform.scale(
          scale: 1.65,
          alignment: Alignment.bottomLeft,
          child: Image.asset(
            'assets/images/field/dry-landscape.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0x6689795D), Color(0x88756347)],
            ),
          ),
        ),
      ],
    ),
  );
}

class _FuelBreakClipper extends CustomClipper<Path> {
  const _FuelBreakClipper();

  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width * .49, size.height * .56)
    ..lineTo(size.width * .498, size.height * .568)
    ..lineTo(size.width * .512, size.height * .555)
    ..lineTo(size.width * .53, size.height * .56)
    ..lineTo(size.width * .548, size.height * .68)
    ..lineTo(size.width * .566, size.height * .74)
    ..lineTo(size.width * .579, size.height * .85)
    ..lineTo(size.width * .61, size.height)
    ..lineTo(size.width * .46, size.height)
    ..lineTo(size.width * .475, size.height * .86)
    ..lineTo(size.width * .472, size.height * .81)
    ..lineTo(size.width * .484, size.height * .68)
    ..close();

  @override
  bool shouldReclip(covariant _FuelBreakClipper oldClipper) => false;
}

class _FireScene extends StatelessWidget {
  const _FireScene({
    required this.active,
    required this.english,
    this.onDrop,
    this.reduced,
  });
  final Set<_FireSlot> active;
  final bool english;
  static const height = 190.0;
  final void Function(_FireSlot, _FirePiece)? onDrop;
  final _FireSlot? reduced;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
    child: SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, bounds) {
          final compact = height < 220;
          final nodeWidth = math.min(122.0, bounds.maxWidth * .31);
          final nodeHeight = nodeWidth / _fireCardAspectRatio;
          // A shared row teaches the three factors without a triangle diagram.
          final centers = <_FireSlot, Offset>{
            for (final slot in _FireSlot.values)
              slot: Offset(
                bounds.maxWidth * (slot.index + .5) / 3,
                height - 12 - nodeHeight / 2,
              ),
          };
          final visible = active.where((slot) => slot != reduced).toSet();
          final flameSize = compact ? math.min(82.0, height * .47) : 132.0;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                'assets/images/field/dry-landscape.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
              const ColoredBox(color: Color(0x7D152D23)),
              Align(
                alignment: const Alignment(0, -.5),
                child: AnimatedContainer(
                  duration: _motionDuration(
                    context,
                    const Duration(milliseconds: 450),
                  ),
                  width: flameSize * 1.6,
                  height: flameSize * 1.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // A soft halo instead of a solid disc, so the light blends
                    // into the photo behind the flame.
                    gradient: RadialGradient(
                      colors: <Color>[
                        Color.fromRGBO(255, 152, 56, visible.length * .12),
                        Color.fromRGBO(255, 125, 32, visible.length * .05),
                        const Color(0x00FF7D20),
                      ],
                      stops: const <double>[0, .45, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                width: math.max(48, (bounds.maxWidth - nodeWidth) / 2 - 24),
                child: Text(
                  reduced == null
                      ? '${active.length}/3 ${english ? 'elements' : 'unsur'}'
                      : (english
                            ? 'One element reduced'
                            : 'Satu unsur berkurang'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: (bounds.maxWidth - flameSize) / 2,
                top: 10,
                width: flameSize,
                height: flameSize,
                child: AnimatedSwitcher(
                  duration: _motionDuration(
                    context,
                    const Duration(milliseconds: 500),
                  ),
                  child: active.length == 3
                      ? _LivingFlame(
                          key: const ValueKey('fire'),
                          small: reduced != null,
                          size: flameSize,
                        )
                      : const SizedBox(key: ValueKey('no-fire')),
                ),
              ),
              ..._FireSlot.values.map(
                (slot) => Positioned(
                  left: centers[slot]!.dx - nodeWidth / 2,
                  top: centers[slot]!.dy - nodeHeight / 2,
                  width: nodeWidth,
                  height: nodeHeight,
                  child: _DropSlot(
                    slot: slot,
                    english: english,
                    filled: active.contains(slot),
                    reduced: reduced == slot,
                    compact: true,
                    onDrop: onDrop,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _LivingFlame extends StatelessWidget {
  const _LivingFlame({super.key, required this.small, required this.size});
  final bool small;
  final double size;
  @override
  Widget build(BuildContext context) =>
      PhotographicFlame(size: size, small: small);
}

class _DropSlot extends StatelessWidget {
  const _DropSlot({
    required this.slot,
    required this.english,
    required this.filled,
    required this.reduced,
    required this.compact,
    required this.onDrop,
  });
  final _FireSlot slot;
  final bool english;
  final bool filled;
  final bool reduced;
  final bool compact;
  final void Function(_FireSlot, _FirePiece)? onDrop;
  @override
  Widget build(BuildContext context) => DragTarget<_FirePiece>(
    onWillAcceptWithDetails: (details) => onDrop != null && !filled,
    onAcceptWithDetails: (details) => onDrop?.call(slot, details.data),
    builder: (context, candidate, rejected) => AnimatedOpacity(
      duration: _motionDuration(context, const Duration(milliseconds: 350)),
      opacity: reduced ? .38 : 1,
      child: SizedBox(
        height: compact ? 56 : 76,
        child: _PhotoFrame(
          color: filled ? KifcTheme.forest800 : const Color(0xE6F5F3ED),
          border: Border.all(
            color: candidate.isNotEmpty ? KifcTheme.amber : Colors.white70,
            width: candidate.isNotEmpty ? 2 : 1,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (filled) GamePhoto(slot.photo),
              if (filled) const ColoredBox(color: Color(0x850C2119)),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      slot.title(english),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: filled ? Colors.white : KifcTheme.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (!filled && onDrop != null)
                      Text(
                        english ? 'Drop here' : 'Taruh di sini',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: KifcTheme.mutedInk,
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Clips the photo edge to edge and paints its outline above it. A decoration
/// border on Container would inset the image and expose pale corner wedges.
class _PhotoFrame extends StatelessWidget {
  const _PhotoFrame({
    required this.child,
    required this.border,
    this.color = KifcTheme.forest800,
  });
  final Widget child;
  final BoxBorder border;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(KifcTheme.controlRadius);
    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: color,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: border,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraggablePiece extends StatelessWidget {
  const _DraggablePiece({
    required this.piece,
    required this.english,
    required this.used,
  });
  final _FirePiece piece;
  final bool english;
  final bool used;
  @override
  Widget build(BuildContext context) => used
      ? Opacity(
          opacity: .32,
          child: _PieceCard(piece: piece, english: english),
        )
      : Draggable<_FirePiece>(
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
    height: 106 / _fireCardAspectRatio,
    decoration: BoxDecoration(
      color: KifcTheme.forest800,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      boxShadow: elevated
          ? <BoxShadow>[const BoxShadow(color: Colors.black26, blurRadius: 8)]
          : null,
    ),
    child: _PhotoFrame(
      border: Border.all(color: KifcTheme.line),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GamePhoto(piece.photo),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 42,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, Color(0xE6001710)],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                piece.label(english),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  shadows: <Shadow>[
                    Shadow(color: Colors.black87, blurRadius: 3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
      key: ValueKey('risk-${token.name}'),
      onTap: found ? null : onTap,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      child: SizedBox(
        width: 104,
        height: 100,
        child: _PhotoFrame(
          border: Border.all(
            color: found
                ? (token.risk ? KifcTheme.forest800 : Colors.redAccent)
                : KifcTheme.line,
            width: found ? 2 : 1,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GamePhoto(token.photo),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: <double>[0, .4, 1],
                    colors: <Color>[
                      Color(0x1100120C),
                      Color(0x2200120C),
                      Color(0xED00180F),
                    ],
                  ),
                ),
              ),
              if (found)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Semantics(
                    label: token.risk
                        ? (english ? 'Correct risk' : 'Benar, ini berisiko')
                        : (english
                              ? 'Not a risk'
                              : 'Gambar ini tidak berisiko'),
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                        color: token.risk
                            ? KifcTheme.forest800
                            : const Color(0xFFA13B28),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        token.risk ? Icons.check_rounded : Icons.close_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 8, 5, 10),
                  child: Text(
                    token.label(english),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
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
    padding: const EdgeInsets.symmetric(vertical: 6),
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
              : 'Jika melihat kebakaran, jaga jarak. Laporkan kepada petugas dan ikuti arahannya.',
          style: const TextStyle(fontSize: 12, color: KifcTheme.forest800),
        ),
      ),
    ],
  );
}
