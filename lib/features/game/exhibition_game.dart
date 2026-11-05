import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' show FontVariation, ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_locale.dart';
import '../../core/audio/game_audio.dart';
import '../../core/audio/audioplayers_backend.dart';
import '../../core/audio/audio_controls.dart';
import '../../core/audio/narration_coordinator.dart';
import '../../core/theme/kifc_theme.dart';
import 'widgets/peat_characteristic_card.dart';
import 'widgets/forest_burn_video.dart';
import 'widgets/game_photo.dart';
import 'widgets/game_mascot.dart';
import 'widgets/animated_mascot.dart';
import 'widgets/interaction_motion.dart';
import 'widgets/touchscreen_area.dart';
import 'widgets/terrain_backdrop.dart';
import 'widgets/progressive_reading_text.dart';
import 'reading_timing.dart';
import 'reading_playback_state.dart';
import 'widgets/mascot_asset_cache.dart';

const _fireCardAspectRatio = 1.8;
const finalChallengeSeconds = 30;
const maxGamePoints = 8;

double _assemblyMascotWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).height < 680 ? 156.0 : 185.0;

const _feedbackMascotScale = 1.4;
const _feedbackMascotCrop = .72;

double _stageFooterGap(BuildContext context) => _compactLayout(context) ? 9 : 14;

bool _compactLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).height -
        MediaQuery.viewPaddingOf(context).vertical <
    680;

Duration _motionDuration(BuildContext context, Duration duration) =>
    MediaQuery.maybeOf(context)?.disableAnimations == true
    ? Duration.zero
    : duration;

String _points(num value, bool english) {
  final text = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
  return english || AppCopy.locale == AppLocale.korean
      ? text
      : text.replaceAll('.', ',');
}

typedef _CauseScenario = ({
  String text,
  bool human,
  String photo,
  String reason,
});

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
  const ExhibitionGame({
    super.key,
    this.stopwatchFactory = Stopwatch.new,
    this.initialPage,
    this.initialCardIndex,
    this.initialLocale,
    this.audioBackend,
    this.narrationPlayer,
    this.greetingInterval = const Duration(seconds: 20),
    this.readingStopwatchFactory = Stopwatch.new,
  });
  final Stopwatch Function() stopwatchFactory;
  final String? initialPage;
  final int? initialCardIndex;
  final AppLocale? initialLocale;
  final GameAudioBackend? audioBackend;
  final NarrationPlayer? narrationPlayer;
  final Duration greetingInterval;
  final Stopwatch Function() readingStopwatchFactory;

  @override
  State<ExhibitionGame> createState() => _ExhibitionGameState();
}

class _ExhibitionGameState extends State<ExhibitionGame>
    with WidgetsBindingObserver {
  late final GameAudioController _audio = GameAudioController(
    backend: widget.audioBackend ?? AudioplayersGameBackend(),
  );
  AppLocale _locale = AppLocale.indonesian;
  _Page _page = _Page.welcome;
  _RiskOption? _riskAnswer;
  int _riskWrong = 0;
  bool _riskRevealed = false;
  final Map<_FireSlot, _FirePiece> _triangle = <_FireSlot, _FirePiece>{};
  bool? _lastDropCorrect;
  _FirePiece? _lastDroppedPiece;
  int _causeIndex = 0;
  int _causePoints = 0;
  bool? _causeChoice;
  final Set<int> _peatOpened = {};
  final Set<int> _peatFlipped = {};
  int _karhutlaCardIndex = 0;
  final Set<_ImpactToken> _finalFound = <_ImpactToken>{};
  int _seconds = finalChallengeSeconds;
  final ValueNotifier<double> _finalProgress = ValueNotifier(1);
  Timer? _timer;
  Timer? _feedbackTimer;
  int _feedbackEpoch = 0;
  int _readingSeconds = 15;
  late final Stopwatch _finalClock = widget.stopwatchFactory();
  bool _preparingFinal = false;
  bool _finishingFinal = false;
  int _preparationTicket = 0;
  bool _mascotsPrepared = false;
  late final NarrationCoordinator _voice = NarrationCoordinator(
    player: widget.narrationPlayer ?? AssetNarrationPlayer(),
    onSpeaking: _onSpeaking,
  );
  Timer? _greetingTimer, _voiceLoadTimeout;
  bool _closingVoicePending = false;
  bool _speaking = false, _voiceAudible = false, _appForeground = true;
  final _readingState = ReadingPlaybackState();
  ReadingTiming? _readingTiming;
  StreamSubscription<Duration>? _readingPositions;
  Timer? _readingTimer, _readingVoiceTimeout, _readingTransitionTimer;
  Timer? _readingCompletionTimer;
  int _readingCompletionTicks = 0;
  late final Stopwatch _readingClock = widget.readingStopwatchFactory();
  Duration _readingOffset = Duration.zero;
  int _readingSession = 0, _readingEpoch = 0;
  bool _readingSilent = false, _readingFailed = false, _readingPaused = false;
  bool _readingStarted = false;
  bool _readingVoicePending = false,
      _readingFinishPending = false,
      _readingTransitioning = false;

  void _stopReading() {
    _readingCompletionTimer?.cancel();
    _readingCompletionTicks = 0;
    _readingSession++;
    _readingTimer?.cancel();
    _readingTimer = null;
    _readingVoiceTimeout?.cancel();
    _readingVoiceTimeout = null;
    _readingClock.stop();
    _readingPositions?.cancel();
    _readingPositions = null;
    _readingTiming = null;
    _readingFailed = false;
    _readingStarted = false;
    _readingPaused = false;
    _readingVoicePending = false;
    _readingFinishPending = false;
  }

  Future<void> _beginReading() async {
    _stopReading();
    final session = _readingSession;
    try {
      final data =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/audio/narration/reading_timing.json',
                ),
              )
              as Map<String, dynamic>;
      if (!mounted ||
          session != _readingSession ||
          _page != _Page.karhutlaCards) {
        return;
      }
      final key = [
        'karhutla-definition',
        'karhutla-cause',
        'karhutla-prevention',
      ][_karhutlaCardIndex];
      final lang = switch (_locale) {
        AppLocale.indonesian => 'id',
        AppLocale.english => 'en',
        AppLocale.korean => 'ko',
      };
      final item = (data['items'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((x) => x['key'] == key && x['locale'] == lang);
      final timing = ReadingTiming.fromJson(item);
      _readingEpoch = _readingState.open(timing.duration);
      _readingPaused =
          !_appForeground || ModalRoute.of(context)?.isCurrent == false;
      if (_readingPaused) _readingState.pause();
      _readingSilent = !_audio.audible;
      setState(() {
        _readingTiming = timing;
        _readingFailed = false;
      });
      if (_audio.unavailable) {
        _readingError(session);
      } else if (_readingSilent) {
        _startSilentReading();
      } else {
        _readingVoicePending = true;
        setState(() => _speaking = true);
        _readingVoiceTimeout = Timer(
          const Duration(seconds: 4),
          _startReadingVoice,
        );
      }
    } catch (_) {
      _readingError(session);
    }
  }

  void _startReadingVoice() {
    if (!_readingVoicePending ||
        !mounted ||
        _page != _Page.karhutlaCards ||
        _readingPaused) {
      return;
    }
    final timing = _readingTiming;
    if (timing == null) return;
    _readingVoicePending = false;
    _readingVoiceTimeout?.cancel();
    _readingVoiceTimeout = null;
    final session = _readingSession;
    final player = _voice.player;
    _voice.speak(
      '${timing.locale}/${timing.key}.mp3',
      _audio.level(AudioLayer.master),
      onStart: () {
        if (player is PositionedNarrationPlayer) {
          _readingPositions = (player as PositionedNarrationPlayer).positions
              .listen((position) => _readingTick(session, position));
        }
      },
      onFinished: () => _readingFinished(session),
      onError: () => _readingError(session),
    );
  }

  void _startSilentReading() {
    _readingSilent = true;
    _readingStarted = true;
    _readingOffset = _readingState.position;
    _readingClock.reset();
    if (!_readingPaused) _readingClock.start();
    final session = _readingSession;
    _readingTimer?.cancel();
    _readingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_appForeground || (ModalRoute.of(context)?.isCurrent == false)) {
        _readingClock.stop();
      } else {
        if (!_readingClock.isRunning) _readingClock.start();
        _readingTick(session, _readingOffset + _readingClock.elapsed);
      }
    });
  }

  void _readingTick(int session, Duration position) {
    if (!mounted ||
        session != _readingSession ||
        _page != _Page.karhutlaCards ||
        _readingPaused) {
      return;
    }
    final previousEnd = _readingStarted
        ? _readingTiming?.visibleText(_readingState.position).length
        : null;
    final advance = _readingState.update(_readingEpoch, position);
    if (advance) {
      _queueReadingAdvance();
      return;
    }
    final nextEnd = _readingTiming?.visibleText(_readingState.position).length;
    // The player reports every animation frame. Keep its exact position, but
    // rebuild only when that position actually reveals different text.
    if (!_readingStarted || previousEnd != nextEnd) {
      setState(() => _readingStarted = true);
    }
  }

  void _readingFinished(int session) {
    if (!mounted ||
        session != _readingSession ||
        _page != _Page.karhutlaCards) {
      return;
    }
    if (_readingPaused) {
      _readingFinishPending = true;
      return;
    }
    if (_readingState.advanceOnce(_readingEpoch)) {
      _queueReadingAdvance();
    }
  }

  void _queueReadingAdvance() {
    if (_readingCompletionTicks > 0) return;
    _readingTimer?.cancel();
    _readingClock.stop();
    setState(() {
      _readingStarted = true;
      _readingState.position = _readingTiming?.duration ?? _readingState.position;
      _readingCompletionTicks = 10;
    });
    _runReadingCompletionDelay();
  }

  void _runReadingCompletionDelay() {
    _readingCompletionTimer?.cancel();
    final session = _readingSession;
    _readingCompletionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || session != _readingSession || _page != _Page.karhutlaCards) {
        timer.cancel();
        return;
      }
      if (_readingPaused || !_appForeground) return;
      if (--_readingCompletionTicks == 0) {
        timer.cancel();
        _advanceReading(claimed: true);
      }
    });
  }

  void _readingError(int session) {
    if (!mounted ||
        session != _readingSession ||
        _page != _Page.karhutlaCards) {
      return;
    }
    _readingState.fail();
    _readingCompletionTimer?.cancel();
    _readingCompletionTicks = 0;
    _readingTimer?.cancel();
    setState(() => _readingFailed = true);
  }

  void _setReadingPaused(bool paused) {
    if (_page != _Page.karhutlaCards || _readingPaused == paused) return;
    _readingPaused = paused;
    if (paused) {
      _readingCompletionTimer?.cancel();
      _readingState.pause();
      _readingClock.stop();
      if (!_readingSilent) _voice.pause();
    } else {
      _readingState.resume();
      if (_readingCompletionTicks > 0) {
        _runReadingCompletionDelay();
        return;
      }
      if (_readingFinishPending) {
        _readingFinishPending = false;
        _readingFinished(_readingSession);
        return;
      }
      if (_readingVoicePending) {
        _startReadingVoice();
        return;
      }
      if (_readingSilent) {
        _readingClock.start();
      } else {
        _voice.resume();
      }
    }
  }

  void _onSpeaking(bool value) {
    if (!mounted) return;
    if (_speaking != value) setState(() => _speaking = value);
    unawaited(_audio.setNarrationActive(value));
  }

  void _cancelVoice() {
    _closingVoicePending = false;
    _voiceLoadTimeout?.cancel();
    _voiceLoadTimeout = null;
    _greetingTimer?.cancel();
    _greetingTimer = null;
    _voice.stop();
  }

  void _startClosingVoice() {
    if (!_closingVoicePending || !mounted || _page != _Page.closing) return;
    _closingVoicePending = false;
    _voiceLoadTimeout?.cancel();
    _voiceLoadTimeout = null;
    _say('closing');
  }

  void _audioChanged() {
    final audible = _audio.audible && _appForeground;
    if (_speaking && audible) _voice.setVolume(_audio.level(AudioLayer.master));
    if (_voiceAudible == audible) return;
    _voiceAudible = audible;
    if (_page == _Page.karhutlaCards) {
      if (!audible &&
          _appForeground &&
          !_readingSilent &&
          _readingTiming != null) {
        _readingVoicePending = false;
        _readingVoiceTimeout?.cancel();
        _voice.stop();
        _readingPositions?.cancel();
        if (_audio.unavailable) {
          _readingError(_readingSession);
        } else {
          _startSilentReading();
        }
      }
      return;
    }
    if (!audible) {
      _cancelVoice();
    } else if (_page == _Page.welcome) {
      _scheduleGreeting();
    }
  }

  void _scheduleGreeting() {
    _greetingTimer?.cancel();
    _greetingTimer = Timer(widget.greetingInterval, () {
      _greetingTimer = null;
      if (mounted &&
          _page == _Page.welcome &&
          _audio.audible &&
          _appForeground &&
          (ModalRoute.of(context)?.isCurrent ?? true)) {
        _say('welcome', repeat: true);
      }
    });
  }

  void _say(String name, {bool repeat = false}) {
    if (!_audio.audible ||
        !_appForeground ||
        !(ModalRoute.of(context)?.isCurrent ?? true)) {
      return;
    }
    final language = switch (_locale) {
      AppLocale.indonesian => 'id',
      AppLocale.english => 'en',
      AppLocale.korean => 'ko',
    };
    _voice.speak(
      '$language/$name.mp3',
      _audio.level(AudioLayer.master),
      onFinished: repeat ? _scheduleGreeting : null,
    );
  }

  @override
  void initState() {
    super.initState();
    MascotAssetCache.warmup();
    WidgetsBinding.instance.addObserver(this);
    _audio.addListener(_audioChanged);
    if (widget.initialLocale != null) {
      _locale = widget.initialLocale!;
      AppCopy.locale = widget.initialLocale!;
    }
    if (widget.initialPage != null) {
      _page = _Page.values.firstWhere(
        (p) => p.name == widget.initialPage,
        orElse: () => _Page.welcome,
      );
    }
    if (widget.initialCardIndex != null) {
      _karhutlaCardIndex = widget.initialCardIndex!;
    }
    if (_page == _Page.karhutlaCards) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _page == _Page.karhutlaCards) unawaited(_beginReading());
      });
    }
    _syncFeedbackTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setReadingPaused(
      !_appForeground || ModalRoute.of(context)?.isCurrent == false,
    );
    if (ModalRoute.of(context)?.isCurrent == false &&
        _page != _Page.karhutlaCards) {
      _cancelVoice();
    } else if (_page == _Page.welcome &&
        _audio.audible &&
        _greetingTimer == null &&
        !_speaking) {
      _scheduleGreeting();
    }
    if (_mascotsPrepared) return;
    _mascotsPrepared = true;
    // Matching 3D posters cover loading, renderer failure and reduced motion.
    for (final state in MascotState.values) {
      unawaited(precacheImage(GameMascot.imageForState(state), context));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appForeground = state == AppLifecycleState.resumed;
    _setReadingPaused(
      !_appForeground || ModalRoute.of(context)?.isCurrent == false,
    );
    if (!_appForeground && _page != _Page.karhutlaCards) _cancelVoice();
    unawaited(_audio.setActive(state == AppLifecycleState.resumed));
    _audioChanged();
  }

  bool get _en => _locale == AppLocale.english;
  int get _trianglePoints => _triangle.length;
  int get _finalRaw => math.max(
    0,
    _finalFound.where((item) => item.impact).length -
        _finalFound.where((item) => !item.impact).length,
  );
  double get _finalBonus => _finalRaw / 4;

  @override
  void dispose() {
    _stopReading();
    _readingTransitionTimer?.cancel();
    _greetingTimer?.cancel();
    _voiceLoadTimeout?.cancel();
    _audio.removeListener(_audioChanged);
    unawaited(_voice.dispose());
    _timer?.cancel();
    _cancelFeedbackTimer();
    _finalClock.stop();
    _finalProgress.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _audio.dispose();
    super.dispose();
  }

  void _go(_Page page) {
    _stopReading();
    _cancelVoice();
    _preparationTicket++;
    _timer?.cancel();
    _cancelFeedbackTimer();
    _finalClock.stop();
    setState(() {
      // Revisiting an activity starts that activity again.
      if (page != _page) {
        switch (page) {
          case _Page.triangleBuild:
            _triangle.clear();
            _lastDropCorrect = null;
            _lastDroppedPiece = null;
          case _Page.karhutlaCards:
            if (_page == _Page.triangleExplanation) _karhutlaCardIndex = 0;
          case _Page.risk:
            _riskAnswer = null;
            _riskWrong = 0;
            _riskRevealed = false;
          case _Page.causeQuiz:
            _causeIndex = 0;
            _causePoints = 0;
            _causeChoice = null;
          case _Page.peatCharacteristics:
            _peatOpened.clear();
            _peatFlipped.clear();
          default:
            break;
        }
      }
      _page = page;
      _preparingFinal = false;
      _finishingFinal = false;
    });
    _syncFeedbackTimer();
    if (page == _Page.karhutlaCards) unawaited(_beginReading());
    if (page == _Page.closing && _audio.audible && _appForeground) {
      _closingVoicePending = true;
      setState(() => _speaking = true);
      // Static fallback or slow renderers must never suppress the narration.
      _voiceLoadTimeout = Timer(const Duration(seconds: 4), _startClosingVoice);
    }
    if (page == _Page.welcome && _audio.audible) _scheduleGreeting();
  }

  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
    _feedbackEpoch++;
  }

  void _syncFeedbackTimer() {
    _cancelFeedbackTimer();
    _readingSeconds = _page == _Page.closing ? 30 : 15;
    final timed = switch (_page) {
      _Page.triangleBuild => _triangle.length == 3,
      _Page.risk => _riskAnswer == _RiskOption.peatSwamp || _riskRevealed,
      _Page.causeQuiz => _causeChoice != null,
      _Page.finalReview || _Page.score || _Page.closing => true,
      _ => false,
    };
    final advance = timed ? _readingAdvance : null;
    if (advance == null) return;
    final epoch = _feedbackEpoch;
    _feedbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || epoch != _feedbackEpoch) {
        timer.cancel();
        return;
      }
      // A dialog/backgrounded app must not consume the visitor's reading time.
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      if (ModalRoute.of(context)?.isCurrent == false ||
          (lifecycle != null && lifecycle != AppLifecycleState.resumed)) {
        return;
      }
      if (_readingSeconds <= 1) {
        _cancelFeedbackTimer();
        advance();
      } else {
        setState(() => _readingSeconds--);
      }
    });
  }

  void _restart() {
    _stopReading();
    _cancelVoice();
    _preparationTicket++;
    _timer?.cancel();
    _cancelFeedbackTimer();
    _finalClock.stop();
    setState(() {
      _page = _Page.welcome;
      _finishingFinal = false;
      _riskAnswer = null;
      _riskWrong = 0;
      _riskRevealed = false;
      _triangle.clear();
      _lastDropCorrect = null;
      _lastDroppedPiece = null;
      _causeIndex = 0;
      _causePoints = 0;
      _causeChoice = null;
      _peatOpened.clear();
      _peatFlipped.clear();
      _karhutlaCardIndex = 0;
      _finalFound.clear();
      _seconds = finalChallengeSeconds;
      _finalProgress.value = 1;
      _preparingFinal = false;
    });
    if (_audio.audible) _scheduleGreeting();
  }

  void _dropPiece(_FirePiece piece) {
    if (!mounted || _page != _Page.triangleBuild || _triangle.length == 3) {
      return;
    }
    setState(() {
      final correct = piece.slot != null && !_triangle.values.contains(piece);
      _lastDropCorrect = correct;
      _lastDroppedPiece = piece;
      if (correct) {
        final slot = _FireSlot.values.firstWhere(
          (slot) => !_triangle.containsKey(slot),
        );
        _triangle[slot] = piece;
      }
    });
    unawaited(
      _audio.interact(
        _lastDropCorrect == true
            ? (_triangle.length == 3 ? GameSound.complete : GameSound.correct)
            : GameSound.retry,
      ),
    );
    _syncFeedbackTimer();
  }

  void _resetTriangle() {
    _cancelFeedbackTimer();
    setState(() {
      _triangle.clear();
      _lastDropCorrect = null;
      _lastDroppedPiece = null;
    });
  }

  void _continueAssembly() {
    if (_page != _Page.triangleBuild || _triangle.length != 3) return;
    _go(_Page.triangleExplanation);
  }

  void _chooseRisk(_RiskOption option) {
    if (_riskRevealed ||
        _riskAnswer == option ||
        _riskAnswer == _RiskOption.peatSwamp) {
      return;
    }
    final correct = option == _RiskOption.peatSwamp;
    unawaited(_audio.interact(correct ? GameSound.correct : GameSound.retry));
    setState(() {
      _riskAnswer = option;
      if (!correct) _riskWrong++;
      if (_riskWrong >= 2) _riskRevealed = true;
    });
    _syncFeedbackTimer();
  }

  void _continueRisk() {
    if (_page == _Page.risk &&
        (_riskAnswer == _RiskOption.peatSwamp || _riskRevealed)) {
      _go(_Page.causeQuiz);
    }
  }

  void _chooseCause(bool humanCause) {
    if (_causeChoice != null) return;
    final scenarios = _causeScenarios(_en);
    unawaited(
      _audio.interact(
        humanCause == scenarios[_causeIndex].human
            ? GameSound.correct
            : GameSound.retry,
      ),
    );
    setState(() {
      _causeChoice = humanCause;
      if (humanCause == scenarios[_causeIndex].human) _causePoints++;
    });
    _syncFeedbackTimer();
  }

  void _continueCause() {
    if (_page != _Page.causeQuiz || _causeChoice == null) return;
    _cancelFeedbackTimer();
    if (_causeIndex == _causeScenarios(_en).length - 1) {
      _go(_Page.peatCharacteristics);
    } else {
      setState(() {
        _causeIndex++;
        _causeChoice = null;
      });
    }
  }

  void _continueKarhutla() => _advanceReading();

  void _advanceReading({bool claimed = false}) {
    if (_page != _Page.karhutlaCards) return;
    if (_readingTransitioning) return;
    if (!claimed &&
        _readingCompletionTicks == 0 &&
        _readingTiming != null &&
        !_readingState.advanceOnce(_readingEpoch)) {
      return;
    }
    _readingTransitioning = true;
    _readingTransitionTimer?.cancel();
    _readingTransitionTimer = Timer(
      const Duration(milliseconds: 350),
      () => _readingTransitioning = false,
    );
    _stopReading();
    _cancelVoice();
    if (_karhutlaCardIndex < 2) {
      setState(() => _karhutlaCardIndex++);
      unawaited(_beginReading());
    } else {
      _go(_Page.risk);
    }
  }

  // Register a parent tap only after the activity is complete. The gesture
  // which answers/places the final item cannot also dismiss its new feedback.
  // Child controls win the gesture arena, keeping audio/back/replay usable.
  VoidCallback? get _readingAdvance => switch (_page) {
    _Page.triangleBuild when _triangle.length == 3 => _continueAssembly,
    _Page.triangleExplanation => () => _go(_Page.karhutlaCards),
    _Page.karhutlaCards => _continueKarhutla,
    _Page.risk when _riskAnswer == _RiskOption.peatSwamp || _riskRevealed =>
      _continueRisk,
    _Page.causeQuiz when _causeChoice != null => _continueCause,
    _Page.peatCharacteristics
        when _peatOpened.length == 3 && !_preparingFinal =>
      _openFinal,
    _Page.finalReview => () => _go(_Page.score),
    _Page.score => _openClosing,
    _Page.closing => _restart,
    _ => null,
  };

  void _flipPeatCard(int index) {
    if (_preparingFinal || _page != _Page.peatCharacteristics) return;
    unawaited(_audio.interact(GameSound.flip));
    setState(() {
      if (!_peatFlipped.add(index)) _peatFlipped.remove(index);
      _peatOpened.add(index);
    });
  }

  Future<void> _openFinal() async {
    if (_preparingFinal || _peatOpened.length != 3) return;
    final ticket = ++_preparationTicket;
    setState(() => _preparingFinal = true);
    await Future.wait(
      _ImpactToken.values.map(
        (token) => precacheImage(AssetImage(token.photo), context),
      ),
    );
    if (!mounted ||
        ticket != _preparationTicket ||
        _page != _Page.peatCharacteristics) {
      return;
    }
    _timer?.cancel();
    setState(() {
      _page = _Page.finalChallenge;
      _finishingFinal = false;
      _seconds = finalChallengeSeconds;
      _finalProgress.value = 1;
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
    if (!mounted || _page != _Page.finalChallenge || _finishingFinal) return;
    _timer?.cancel();
    _finalClock
      ..reset()
      ..start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _page != _Page.finalChallenge) {
        timer.cancel();
        return;
      }
      final remainingExact = math.max(
        0.0,
        finalChallengeSeconds -
            _finalClock.elapsed.inMicroseconds / Duration.microsecondsPerSecond,
      );
      // Update only the ring between integer ticks, using the scoring clock.
      _finalProgress.value = remainingExact / finalChallengeSeconds;
      final remaining = remainingExact.ceil();
      if (remaining != _seconds) setState(() => _seconds = remaining);
      if (remaining == 0) {
        _finishFinalChallenge(atDeadline: true);
      }
    });
  }

  void _finishFinalChallenge({bool atDeadline = false}) {
    if (!mounted || _page != _Page.finalChallenge || _finishingFinal) return;
    _timer?.cancel();
    _finalClock.stop();
    setState(() => _finishingFinal = true);
    unawaited(_audio.play(GameSound.finish));
    if (atDeadline) {
      // Preserve the final zero-count frame before the automatic review.
      _timer = Timer(const Duration(milliseconds: 420), () {
        if (mounted && _page == _Page.finalChallenge && _finishingFinal) {
          _go(_Page.finalReview);
        }
      });
    } else {
      _go(_Page.finalReview);
    }
  }

  void _openClosing() => _go(_Page.closing);

  void _playAgain() {
    _restart();
    _go(_Page.triangleBuild);
  }

  @override
  Widget build(BuildContext context) {
    AppCopy.locale = _locale;
    final page = switch (_page) {
      _Page.welcome => _WelcomePage(
        locale: _locale,
        onLocale: (locale) {
          _cancelVoice();
          setState(() {
            _locale = locale;
            AppCopy.locale = locale;
          });
          if (_audio.audible) _scheduleGreeting();
        },
        onStart: () {
          unawaited(_audio.interact(GameSound.tap));
          _go(_Page.triangleBuild);
        },
      ),
      _Page.risk => _RiskPage(
        english: _en,
        answer: _riskAnswer,
        wrongAttempts: _riskWrong,
        onAnswer: _chooseRisk,
        onContinue: _continueRisk,
        onBack: () => _go(_Page.karhutlaCards),
      ),
      _Page.triangleBuild => _TriangleBuild(
        english: _en,
        pieces: _triangle,
        lastDropCorrect: _lastDropCorrect,
        lastPiece: _lastDroppedPiece,
        onDrop: _dropPiece,
        onBack: _restart,
        onRestart: _resetTriangle,
        onContinue: _continueAssembly,
      ),
      _Page.triangleExplanation => _TriangleExplanation(
        english: _en,
        pieces: _triangle,
        onContinue: () => _go(_Page.karhutlaCards),
        onBack: () => _go(_Page.triangleBuild),
      ),
      _Page.karhutlaCards => _KarhutlaCards(
        english: _en,
        index: _karhutlaCardIndex,
        timing: _readingTiming,
        position: _readingState.position,
        failed: _readingFailed,
        started: _readingStarted,
        narrating: _speaking && !_readingSilent,
        onMascotReady: _startReadingVoice,
        onAdvance: _continueKarhutla,
        onComplete: () => _go(_Page.risk),
        onBack: () {
          if (_karhutlaCardIndex > 0) {
            _stopReading();
            _cancelVoice();
            setState(() => _karhutlaCardIndex--);
            unawaited(_beginReading());
          } else {
            _go(_Page.triangleExplanation);
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
      _Page.peatCharacteristics => _PeatCharacteristics(
        english: _en,
        opened: _peatOpened,
        flipped: _peatFlipped,
        preparing: _preparingFinal,
        onFlip: _flipPeatCard,
        onContinue: _openFinal,
        onBack: () => _go(_Page.causeQuiz),
      ),
      _Page.finalChallenge => _FinalChallenge(
        english: _en,
        seconds: _seconds,
        timerProgress: _finalProgress,
        found: _finalFound,
        onTap: (token) {
          if (_page == _Page.finalChallenge &&
              !_finishingFinal &&
              _seconds > 0 &&
              _finalClock.elapsed <
                  const Duration(seconds: finalChallengeSeconds)) {
            unawaited(_audio.interact(GameSound.select));
            setState(() {
              if (!_finalFound.remove(token)) _finalFound.add(token);
            });
          }
        },
        onFinish: _finishingFinal ? null : () => _finishFinalChallenge(),
        onBack: () {
          _timer?.cancel();
          _go(_Page.peatCharacteristics);
        },
      ),
      _Page.finalReview => _FinalChallenge(
        english: _en,
        seconds: 0,
        timerProgress: _finalProgress,
        found: _finalFound,
        reviewed: true,
        onTap: null,
        onContinue: () => _go(_Page.score),
        onBack: _restart,
      ),
      _Page.score => _ScorePage(
        english: _en,
        triangle: _trianglePoints,
        causes: _causePoints,
        finalRaw: _finalRaw,
        bonus: _finalBonus,
        readingSeconds: _readingSeconds,
        onContinue: _openClosing,
        onAgain: _playAgain,
        onHome: _restart,
      ),
      _Page.closing => _ClosingPage(
        english: _en,
        narrating: _speaking,
        onMascotReady: _startClosingVoice,
        readingSeconds: _readingSeconds,
        onAgain: _playAgain,
        onExplore: _restart,
      ),
    };
    final advance = _readingAdvance;
    void continueReading() {
      if (advance == null) return;
      unawaited(_audio.interact(GameSound.tap));
      advance();
    }

    return GameAudioScope(
      controller: _audio,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          unawaited(_audio.activate());
        },
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: advance == null
              ? null
              : AppCopy.translate(
                  _en
                      ? 'Touch the screen when you are ready to continue.'
                      : 'Sudah selesai membaca? Sentuh layar untuk lanjut.',
                ),
          onTap: advance == null ? null : continueReading,
          child: GestureDetector(
            key: const ValueKey('reading-continue-anywhere'),
            behavior: HitTestBehavior.opaque,
            // Keep a stable semantics container with separate reading nodes.
            // GestureDetector's implicit merging breaks dynamic web scroll nodes.
            excludeFromSemantics: true,
            onTap: advance == null ? null : continueReading,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                MascotPlaybackScope(
                  page: _page,
                  child: AnimatedSwitcher(
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
                    child: KeyedSubtree(
                      key: ValueKey(
                        _page == _Page.finalReview
                            ? _Page.finalChallenge
                            : _page,
                      ),
                      child: page,
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
}

enum _Page {
  welcome,
  risk,
  triangleBuild,
  triangleExplanation,
  karhutlaCards,
  causeQuiz,
  peatCharacteristics,
  finalChallenge,
  finalReview,
  score,
  closing,
}

enum _FireSlot { heat, fuel, oxygen }

enum _FirePiece { heat, fuel, oxygen, water, rain, stone }

extension _FireCopy on _FireSlot {
  String title(bool en) => switch (this) {
    _FireSlot.heat => en ? 'Heat' : 'Panas',
    _FireSlot.fuel => en ? 'Fuel' : 'Bahan bakar',
    _FireSlot.oxygen => en ? 'Oxygen' : 'Oksigen',
  };
  String get photo => switch (this) {
    _FireSlot.heat => 'assets/images/field/ignition-sparks.jpg',
    _FireSlot.fuel => 'assets/images/field/dry-wood-client.jpg',
    _FireSlot.oxygen => 'assets/images/field/oxygen-canopy.jpg',
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
    _FirePiece.heat => en ? 'Sparks' : 'Percikan api',
    _FirePiece.fuel => en ? 'Dry wood' : 'Kayu kering',
    _FirePiece.oxygen => en ? 'Oxygen from air' : 'Oksigen dari udara',
    _FirePiece.water => en ? 'Water' : 'Air',
    _FirePiece.rain => en ? 'Rain' : 'Hujan',
    _FirePiece.stone => en ? 'Stone' : 'Batu',
  };
  String wrongPlacement(bool en) => switch (this) {
    _FirePiece.water =>
      en
          ? 'Water is not one of the elements of the fire triangle.'
          : 'Air bukan salah satu unsur dalam Segitiga Api.',
    _FirePiece.rain =>
      en
          ? 'Rain is not one of the elements of the fire triangle.'
          : 'Hujan bukan salah satu unsur dalam Segitiga Api.',
    _FirePiece.stone =>
      en
          ? 'Stone is not an element of the fire triangle.'
          : 'Batu bukan unsur yang dicari dalam Segitiga Api.',
    _ =>
      en
          ? 'This photo is already in place. Try another photo.'
          : 'Foto ini sudah terpasang. Coba foto lain.',
  };
  String get photo => switch (this) {
    _FirePiece.heat => 'assets/images/field/ignition-sparks.jpg',
    _FirePiece.fuel => 'assets/images/field/dry-wood-client.jpg',
    _FirePiece.oxygen => 'assets/images/field/oxygen-canopy.jpg',
    _FirePiece.water => 'assets/images/field/water-surface.jpg',
    _FirePiece.rain => 'assets/images/field/rain-splash.jpg',
    _FirePiece.stone => 'assets/images/field/stone-pebbles.jpg',
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
        const _Photo(tone: Color(0x380C2B1F)),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, .18, .36, .58, .83, 1],
              colors: [
                Color(0x000C2B1F),
                Color(0x100C2B1F),
                Color(0x820C2B1F),
                Color(0x700C2B1F),
                Color(0x180C2B1F),
                Color(0x000C2B1F),
              ],
            ),
          ),
        ),
        TouchscreenArea(
          child: LayoutBuilder(
            builder: (context, bounds) {
              final compact = bounds.maxHeight < 680;
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _PartnerHeader(dark: true),
                    const SizedBox(height: 8),
                    _LanguagePicker(locale: locale, onChanged: onLocale),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const LocalizedText(
                              'KIFC EXHIBITION ROOM / MANGGALA AGNI',
                              style: TextStyle(
                                color: Color(0xDEFFFFFF),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LocalizedText(
                              key: const ValueKey('welcome-title'),
                              'Fire Prevention\nChallenge',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'ArchivoBlack',
                                fontSize: compact ? 34 : 38,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -.8,
                                height: 1.06,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 18 : 24),
                            _HostConversation(
                              key: const ValueKey('welcome-conversation'),
                              opening: true,
                              height: compact ? 230 : 275,
                              pose: MascotPose.welcome,
                              mascotOnRight: false,
                              text: locale == AppLocale.english
                                  ? 'Hello! Discover how fires start and what we can do to protect the forest.'
                                  : 'Halo! Yuk, kenali penyebab kebakaran dan cari tahu cara menjaga hutan dari api.',
                            ),
                            SizedBox(height: compact ? 16 : 20),
                            _WelcomeStartButton(
                              label: locale == AppLocale.english
                                  ? 'Start Challenge'
                                  : 'Mulai Tantangan',
                              onPressed: onStart,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _WelcomeStartButton extends StatefulWidget {
  const _WelcomeStartButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_WelcomeStartButton> createState() => _WelcomeStartButtonState();
}

class _WelcomeStartButtonState extends State<_WelcomeStartButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) => _setPressed(true),
    onPointerUp: (_) => _setPressed(false),
    onPointerCancel: (_) => _setPressed(false),
    child: AnimatedScale(
      key: const ValueKey('welcome-start-feedback'),
      scale: _pressed ? .98 : 1,
      duration: _motionDuration(context, const Duration(milliseconds: 100)),
      curve: Curves.easeOut,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x290C2B1F),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: _Primary(
          label: widget.label,
          icon: Icons.play_arrow_rounded,
          large: true,
          onPressed: widget.onPressed,
        ),
      ),
    ),
  );
}

/// A host and its message form one group on the opening and closing screens.
/// Keep the sprite intact; its chest logo must never be mirrored.
class _HostConversation extends StatelessWidget {
  const _HostConversation({
    super.key,
    required this.pose,
    required this.mascotOnRight,
    required this.text,
    this.opening = false,
    this.height,
    this.state,
    this.narrating = false,
    this.onMascotReady,
  });

  final MascotPose pose;
  final bool mascotOnRight;
  final String text;
  final bool opening;
  final double? height;
  final MascotState? state;
  final bool narrating;
  final VoidCallback? onMascotReady;

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? (_compactLayout(context) ? 230.0 : 275.0);
    final mascot = SizedBox(
      width: height * .62,
      child: GameMascot(
        pose: pose,
        state: state,
        narrating: narrating,
        onReady: onMascotReady,
        height: height,
        motionTrigger: (AppCopy.locale, text),
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!mascotOnRight) mascot,
        Expanded(
          child: _SpeechBubble(
            text: text,
            content: opening
                ? LocalizedText(
                    text,
                    keepKoreanWordsTogether: true,
                    style: const TextStyle(
                      color: KifcTheme.ink,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  )
                : null,
            tailOnRight: mascotOnRight,
            padding: EdgeInsets.all(opening ? 17 : 14),
            radius: opening ? 20 : 18,
            side: opening
                ? const BorderSide(color: Color(0xFFE2E6DA))
                : BorderSide.none,
            shadows: opening
                ? const [
                    BoxShadow(
                      color: Color(0x180C2B1F),
                      blurRadius: 16,
                      offset: Offset(0, 5),
                    ),
                  ]
                : null,
            style: TextStyle(
              color: KifcTheme.ink,
              fontSize: 14,
              height: opening ? 1.4 : 1.35,
            ),
          ),
        ),
        if (mascotOnRight) mascot,
      ],
    );
  }
}

/// Every speech pointer, fill, border and shadow shares the same finite reveal.
/// The active language is part of the trigger even when source text is reused.
class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({
    required this.text,
    this.tailOnRight = false,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
    this.side = const BorderSide(color: KifcTheme.line),
    this.shadows,
    this.messageKey,
    this.textKey,
    this.content,
    this.motionKey,
    this.tailWidth = 10,
    this.tailHalfHeight = 9,
    this.style = const TextStyle(
      color: KifcTheme.ink,
      fontSize: 14,
      height: 1.4,
    ),
  });
  final String text;
  final bool tailOnRight;
  final EdgeInsetsGeometry padding;
  final double radius, tailWidth, tailHalfHeight;
  final BorderSide side;
  final List<BoxShadow>? shadows;
  final Key? messageKey, textKey, motionKey;
  final TextStyle style;
  final Widget? content;

  @override
  Widget build(BuildContext context) => MotionReveal(
    key: motionKey,
    trigger: (AppCopy.locale, text),
    delay: const Duration(milliseconds: 55),
    child: Container(
      key: messageKey,
      padding: padding,
      decoration: ShapeDecoration(
        color: KifcTheme.paper,
        shape: _SpeechBubbleShape(
          tailOnRight: tailOnRight,
          radius: radius,
          side: side,
          tailWidth: tailWidth,
          tailHalfHeight: tailHalfHeight,
        ),
        shadows: shadows,
      ),
      child: content ?? LocalizedText(text, key: textKey, style: style),
    ),
  );
}

/// A continuous outline removes the border at the pointer junction. Its inset
/// preserves the existing reading width and works on both sides of the host.
class _SpeechBubbleShape extends ShapeBorder {
  const _SpeechBubbleShape({
    required this.tailOnRight,
    required this.radius,
    required this.side,
    this.tailWidth = 10,
    this.tailHalfHeight = 9,
  });

  final bool tailOnRight;
  final double radius, tailWidth, tailHalfHeight;
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(
        left: tailOnRight ? 0 : tailWidth,
        right: tailOnRight ? tailWidth : 0,
      ) +
      EdgeInsets.all(side.width);

  Path _outline(Rect rect) {
    final body = Rect.fromLTRB(
      rect.left + (tailOnRight ? 0 : tailWidth),
      rect.top,
      rect.right - (tailOnRight ? tailWidth : 0),
      rect.bottom,
    );
    final edge = tailOnRight ? body.right : body.left;
    final direction = tailOnRight ? 1.0 : -1.0;
    final y = body.center.dy;
    final join = edge - direction;
    final pointer = Path()
      ..moveTo(join, y - tailHalfHeight)
      ..quadraticBezierTo(
        edge + direction * 3,
        y - 3,
        tailOnRight ? rect.right : rect.left,
        y,
      )
      ..quadraticBezierTo(edge + direction * 3, y + 3, join, y + tailHalfHeight)
      ..close();
    return Path.combine(
      PathOperation.union,
      Path()..addRRect(BorderRadius.circular(radius).toRRect(body)),
      pointer,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _outline(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _outline(rect.deflate(side.width));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(_outline(rect.deflate(side.width / 2)), side.toPaint());
  }

  @override
  ShapeBorder scale(double t) => _SpeechBubbleShape(
    tailOnRight: tailOnRight,
    radius: radius * t,
    side: side.scale(t),
    tailWidth: tailWidth * t,
    tailHalfHeight: tailHalfHeight * t,
  );
}

class _RiskPage extends StatelessWidget {
  const _RiskPage({
    required this.english,
    required this.answer,
    required this.wrongAttempts,
    required this.onAnswer,
    required this.onBack,
    required this.onContinue,
  });
  final bool english;
  final _RiskOption? answer;
  final int wrongAttempts;
  final ValueChanged<_RiskOption> onAnswer;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  static const _RiskOption _correct = _RiskOption.peatSwamp;

  @override
  Widget build(BuildContext context) {
    // A tall phone can still have only 360 logical pixels of text width.
    // Keep full-size answers and feedback by using the compact question title.
    final compact =
        _compactLayout(context) || MediaQuery.sizeOf(context).width < 380;
    final solved = answer == _correct;
    final revealed = solved || wrongAttempts >= 2;
    final locked = revealed;
    final stage = _LightStage(
      chapter: 2,
      english: english,
      eyebrow: english
          ? 'CHAPTER 2 / PEAT SWAMP FOREST'
          : 'BABAK 2 / HUTAN RAWA GAMBUT',
      title: english
          ? 'In which type of forest can fire smolder beneath the ground surface, making it difficult to extinguish?'
          : 'Pada jenis hutan manakah kebakaran dapat membara di bawah permukaan tanah sehingga sulit dipadamkan?',
      titleFontSize: compact ? 17 : 22,
      edgeFeedback: answer != null,
      subtitle: english
          ? 'Choose the forest type that has a peat layer.'
          : 'Pilih jenis hutan yang memiliki lapisan gambut.',
      onBack: onBack,
      bodyScrollable: false,
      footerGap: compact ? 4 : 14,
      body: Column(
        children: <Widget>[
          _RiskCard(
            height: 72,
            option: _RiskOption.mangrove,
            english: english,
            selected: answer == _RiskOption.mangrove,
            correct: false,
            onTap: locked ? null : () => onAnswer(_RiskOption.mangrove),
          ),
          const SizedBox(height: 8),
          _RiskCard(
            option: _correct,
            height: 72,
            english: english,
            selected: revealed,
            correct: true,
            onTap: locked ? null : () => onAnswer(_correct),
          ),
          const SizedBox(height: 8),
          _RiskCard(
            option: _RiskOption.mineralSoil,
            height: 72,
            english: english,
            selected: answer == _RiskOption.mineralSoil,
            correct: false,
            onTap: locked ? null : () => onAnswer(_RiskOption.mineralSoil),
          ),
        ],
      ),
      footer: _footer(
        solved: solved,
        revealed: revealed,
        answered: answer != null,
      ),
    );
    return stage;
  }

  Widget _footer({
    required bool solved,
    required bool revealed,
    required bool answered,
  }) {
    if (!answered) {
      return LocalizedText(
        english ? 'Choose one answer.' : 'Pilih satu jawaban.',
        style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
      );
    }
    if (solved) {
      return _Feedback(
        ok: true,
        longMessage: true,
        text: english
            ? 'Correct! Fires in dried-out peat swamp forests are difficult to extinguish because fire can smolder beneath the ground surface. Embers are hard to detect and can rekindle flames even after the surface fire is out.'
            : 'Tepat! Kebakaran di hutan rawa gambut yang mengering sulit dipadamkan karena api dapat membara di bawah permukaan tanah. Bara sulit terdeteksi dan dapat memicu api kembali meskipun api di permukaan sudah padam.',
      );
    }
    if (!revealed) {
      return _Feedback(
        ok: false,
        longMessage: true,
        text: english
            ? 'Not quite. Think about the forest type with a thick organic soil layer. Fire can smolder inside that layer, making it difficult to extinguish.'
            : 'Belum tepat. Coba ingat jenis hutan yang memiliki lapisan tanah organik tebal. Api dapat membara di dalam lapisan tersebut sehingga sulit dipadamkan.',
      );
    }
    return _Feedback(
      ok: false,
      longMessage: true,
      text: english
          ? 'The correct answer is peat swamp forest. Fire can smolder beneath the ground in thick organic soil, making it hard to extinguish.'
          : 'Jawaban yang tepat adalah hutan rawa gambut. Api dapat membara di dalam lapisan tanah organik tebal di bawah permukaan sehingga sulit dipadamkan.',
    );
  }
}

class _MascotDialogue extends StatelessWidget {
  const _MascotDialogue({
    required this.text,
    this.timing,
    this.position = Duration.zero,
    this.failed = false,
    this.started = false,
    this.narrating = false,
    this.onMascotReady,
  });
  final String text;
  final ReadingTiming? timing;
  final Duration position;
  final bool failed, narrating;
  final bool started;
  final VoidCallback? onMascotReady;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: _compactLayout(context) ? 122 : 140,
        child: GameMascot(
          pose: MascotPose.presenting,
          state: narrating ? MascotState.talking : MascotState.presenting,
          narrating: narrating,
          onReady: onMascotReady,
          height: _compactLayout(context) ? 210 : 250,
          motionTrigger: (AppCopy.locale, text),
        ),
      ),
      Expanded(
        child: _SpeechBubble(text: text, content: _readingContent(context)),
      ),
    ],
  );

  Widget _readingContent(BuildContext context) {
    final full = timing?.text ?? AppCopy.translate(text);
    final showFull = failed || MediaQuery.disableAnimationsOf(context);
    final visible = showFull
        ? full.length
        : started && timing != null
        ? timing!.visibleText(position).length
        : 0;
    return Stack(
      children: [
        ProgressiveReadingText(
          key: ValueKey('reading-paragraph-${timing?.key ?? 'loading'}'),
          text: full,
          visibleCharacters: visible,
          style: const TextStyle(
            color: KifcTheme.ink,
            fontSize: 12.5,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _KarhutlaCards extends StatelessWidget {
  const _KarhutlaCards({
    required this.english,
    required this.index,
    required this.onAdvance,
    required this.onComplete,
    required this.onBack,
    this.timing,
    this.position = Duration.zero,
    this.failed = false,
    this.started = false,
    this.narrating = false,
    this.onMascotReady,
  });
  final bool english;
  final int index;
  final VoidCallback onAdvance;
  final VoidCallback onComplete;
  final VoidCallback onBack;
  final ReadingTiming? timing;
  final Duration position;
  final bool failed, narrating;
  final bool started;
  final VoidCallback? onMascotReady;

  @override
  Widget build(BuildContext context) {
    // Working narrative: replace content by stable ID when client copy arrives.
    // Each card keeps one idea, and its own lead-in line so the subtitles do
    // not repeat the same generic sentence.
    final cards = english
        ? [
            (
              'karhutla-definition',
              'What Is a Forest Fire?',
              'A forest fire is the burning of vegetation and organic matter in a forest area, with flames spreading freely and uncontrollably.',
              'You have seen how fire starts. What happens when it spreads?',
            ),
            (
              'karhutla-cause',
              'Why Do Forest Fires Happen?',
              'A forest fire can occur when sufficient heat, fuel, and oxygen meet under conditions that allow fire to ignite. Human activities can bring these three elements together, increasing the risk of fire.',
              'A forest fire can occur when the three elements of fire meet.',
            ),
            (
              'karhutla-prevention',
              'Why Must We Prevent Forest Fires?',
              'Forest fires damage the environment and cause ecological, economic, socio-cultural, and political losses. Such damage disrupts the forest’s ability to perform its functions properly.',
              'Most forest fires can be stopped before they grow.',
            ),
          ]
        : [
            (
              'karhutla-definition',
              'Tapi, Apa Itu Kebakaran Hutan?',
              'Kebakaran hutan adalah peristiwa terbakarnya vegetasi dan bahan organik di kawasan hutan, dengan api yang menyebar secara bebas dan tidak terkendali.',
              'Tadi kamu melihat api menyala. Bagaimana jika api itu menjalar?',
            ),
            (
              'karhutla-cause',
              'Mengapa Kebakaran Hutan Bisa Terjadi?',
              'Kebakaran hutan dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu dalam kondisi yang memungkinkan api menyala. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut sehingga meningkatkan risiko kebakaran.',
              'Kebakaran hutan dapat terjadi ketika tiga unsur api bertemu.',
            ),
            (
              'karhutla-prevention',
              'Mengapa Kebakaran Hutan Perlu Kita Cegah?',
              'Kebakaran hutan merusak lingkungan dan menimbulkan kerugian ekologis, ekonomi, sosial budaya, serta politik. Kerusakan tersebut mengganggu kemampuan hutan untuk menjalankan fungsinya dengan baik.',
              'Sebagian besar karhutla bisa dicegah sebelum membesar.',
            ),
          ];
    final card = cards[index];
    return _DarkStage(
      chapter: 2,
      english: english,
      eyebrow: english ? 'CHAPTER 2 / FOREST FIRE' : 'BABAK 2 / KARHUTLA',
      title: index == 0
          ? switch (AppCopy.locale) {
              AppLocale.indonesian => 'Tapi, Apa Itu\nKebakaran\u00a0Hutan?',
              AppLocale.english => 'What Is a Forest\u00a0Fire?',
              AppLocale.korean => card.$2,
            }
          : card.$2,
      subtitle: card.$4,
      groupFooter: true,
      onBack: onBack,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(key: ValueKey(card.$1)),
          _MascotDialogue(
            text: card.$3,
            timing: timing,
            position: position,
            failed: failed,
            started: started,
            narrating: narrating,
            onMascotReady: onMascotReady,
          ),
          if (failed) ...[
            const SizedBox(height: 8),
            LocalizedText(switch (AppCopy.locale) {
              AppLocale.indonesian =>
                'Audio belum tersedia. Silakan baca, lalu lanjutkan.',
              AppLocale.english =>
                'Audio is unavailable. Please read, then continue.',
              AppLocale.korean => '오디오를 사용할 수 없어요. 읽은 후 계속해 주세요.',
            }, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < cards.length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == index ? 24 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == index ? KifcTheme.amber : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              const SizedBox(width: 10),
              LocalizedText(
                '${index + 1}/3',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      footer: _Primary(
        label: index == 2
            ? (english ? 'Start Quiz' : 'Mulai Kuis')
            : (english ? 'Continue' : 'Lanjut'),
        dark: true,
        onPressed: index == 2 ? onComplete : onAdvance,
      ),
    );
  }
}

enum _RiskOption { mangrove, peatSwamp, mineralSoil }

extension _RiskOptionVisual on _RiskOption {
  String get photo => switch (this) {
    _RiskOption.mangrove => 'assets/images/field/mangrove-nusa-lembongan.jpg',
    _RiskOption.peatSwamp => 'assets/images/forest/kereng-bangkirai.jpg',
    _RiskOption.mineralSoil => 'assets/images/field/rainforest-kalimantan.jpg',
  };
}

extension _RiskOptionCopy on _RiskOption {
  String label(bool english) => switch (this) {
    _RiskOption.mangrove =>
      english ? 'A. Mangrove forest' : 'A. Hutan mangrove',
    _RiskOption.peatSwamp =>
      english ? 'B. Peat swamp forest' : 'B. Hutan rawa gambut',
    _RiskOption.mineralSoil =>
      english ? 'C. Forest on mineral soil' : 'C. Hutan pada tanah mineral',
  };
}

class _TriangleBuild extends StatelessWidget {
  const _TriangleBuild({
    required this.english,
    required this.pieces,
    required this.lastDropCorrect,
    required this.lastPiece,
    required this.onDrop,
    required this.onBack,
    required this.onRestart,
    required this.onContinue,
  });
  final bool english;
  final Map<_FireSlot, _FirePiece> pieces;
  final bool? lastDropCorrect;
  final _FirePiece? lastPiece;
  final ValueChanged<_FirePiece> onDrop;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) {
    final complete = pieces.length == 3;
    final compact = _compactLayout(context);
    final message = complete
        ? (english
              ? 'Correct! Fire can start when sufficient heat, fuel, and oxygen meet. These three elements form the fire triangle. Reducing any one of them can help control fire.'
              : 'Tepat! Api dapat menyala ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Ketiga unsur ini disebut Segitiga Api. Mengurangi salah satu unsur dapat membantu mengendalikan api.')
        : lastDropCorrect == false && lastPiece != null
        ? lastPiece!.wrongPlacement(english)
        : lastDropCorrect == true
        ? (english
              ? 'That fits. Find the remaining elements.'
              : 'Sudah cocok. Temukan unsur lainnya.')
        : (english
              ? 'Find all three elements to start the fire.'
              : 'Temukan ketiga unsur agar api menyala.');
    final stage = _LightStage(
      chapter: 1,
      english: english,
      eyebrow: english
          ? 'CHAPTER 1 / PUT IT TOGETHER'
          : 'BABAK 1 / SATUKAN TIGA UNSUR',
      title: english ? 'Choose three elements.' : 'Pilih tiga unsur api.',
      titleFontSize: compact ? 22 : 26,
      subtitle: english
          ? 'Drag the three correct photos into the forest.'
          : 'Seret tiga foto yang tepat ke area hutan.',
      onBack: onBack,
      onRestart: onRestart,
      groupFooter: false,
      expandFooter: complete,
      edgeFeedback: true,
      bodyScrollable: false,
      footerGap: compact ? 4 : 12,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FireScene(
            active: pieces.values.map((piece) => piece.slot!).toSet(),
            placements: pieces,
            english: english,
            onDrop: onDrop,
          ),
          if (!complete) ...[
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: _fireCardAspectRatio,
              children:
                  const [
                        _FirePiece.heat,
                        _FirePiece.water,
                        _FirePiece.fuel,
                        _FirePiece.rain,
                        _FirePiece.oxygen,
                        _FirePiece.stone,
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
        ],
      ),
      footer: _AssemblyFeedback(
        english: english,
        text: message,
        complete: complete,
        incorrect: lastDropCorrect == false,
      ),
    );
    return stage;
  }
}

class _AssemblyFeedback extends StatelessWidget {
  const _AssemblyFeedback({
    required this.text,
    required this.complete,
    required this.incorrect,
    required this.english,
  });
  final String text;
  final bool complete;
  final bool incorrect;
  final bool english;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: complete
        ? _AssemblyCompletionFeedback(text: text, english: english)
        : _MascotFeedback(
            text: text,
            ok: complete,
            longMessage: true,
            assembly: true,
            neutral: !complete && !incorrect,
            pose: complete
                ? MascotPose.success
                : incorrect
                ? MascotPose.hintSafety
                : MascotPose.presenting,
          ),
  );
}

class _AssemblyCompletionFeedback extends StatelessWidget {
  const _AssemblyCompletionFeedback({
    required this.text,
    this.pose = MascotPose.success,
    this.onContinue,
    this.english = false,
  });
  final String text;
  final MascotPose pose;
  final VoidCallback? onContinue;
  final bool english;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final width = _assemblyMascotWidth(context);
      final imageHeight = width * 4 / 3;
      final cropHeight = imageHeight * _feedbackMascotCrop;
      final completion = onContinue == null;
      return Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // The decorative host may overlap the card border; text stays readable.
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: MotionReveal(
              trigger: text,
              delay: const Duration(milliseconds: 55),
              child: Container(
                key: const ValueKey('feedback-message'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KifcTheme.paper,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: KifcTheme.answerCorrect.withValues(alpha: .45),
                  ),
                ),
                child: LocalizedText(
                  text,
                  style: const TextStyle(fontSize: 13, height: 1.25),
                ),
              ),
            ),
          ),
          Positioned(
            left: completion ? (bounds.maxWidth - width) / 2 : 0,
            bottom: 0,
            width: width,
            height: cropHeight,
            child: IgnorePointer(
              child: ClipRect(
                key: const ValueKey('feedback-mascot-crop'),
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  minWidth: width,
                  maxWidth: width,
                  minHeight: imageHeight,
                  maxHeight: imageHeight,
                  child: Transform.translate(
                    offset: Offset(
                      pose == MascotPose.success ? width * .08 : 0,
                      !completion && bounds.maxHeight < 240 ? 8 : 0,
                    ),
                    child: Transform.scale(
                      scale: _feedbackMascotScale,
                      alignment: const Alignment(0, -.5),
                      child: GameMascot(
                        pose: pose,
                        height: imageHeight,
                        motionTrigger: text,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!completion)
            Positioned(
              right: 0,
              top: TouchscreenArea.isCenteredOf(context) ? 4 : null,
              bottom: TouchscreenArea.isCenteredOf(context)
                  ? null
                  : math.max(16.0, cropHeight / 2 - 23),
              width: math.min(
                bounds.maxWidth * .60,
                math.max(0.0, bounds.maxWidth - width - 8),
              ),
              child: _Primary(
                key: const ValueKey('triangle-reading-continue'),
                singleLine: true,
                label: english ? 'Continue' : 'Lanjut',
                onPressed: onContinue!,
              ),
            ),
        ],
      );
    },
  );
}

class _TriangleExplanation extends StatelessWidget {
  const _TriangleExplanation({
    required this.english,
    required this.onContinue,
    required this.onBack,
    required this.pieces,
  });
  final bool english;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final Map<_FireSlot, _FirePiece> pieces;

  @override
  Widget build(BuildContext context) => _LightStage(
    chapter: 1,
    english: english,
    eyebrow: english ? 'CHAPTER 1 / FIRE TRIANGLE' : 'BABAK 1 / SEGITIGA API',
    title: english
        ? 'Fire Can Start When Three Elements Meet'
        : 'Api Dapat Muncul Saat Tiga Unsur Bertemu',
    titleFontSize: _compactLayout(context) ? 20 : 24,
    bodyScrollable: false,
    subtitle: english
        ? 'Fire can occur anywhere when sufficient heat, fuel, and oxygen meet.'
        : 'Kebakaran dapat terjadi di mana saja jika panas yang cukup, bahan bakar, dan oksigen bertemu.',
    onBack: onBack,
    edgeFeedback: true,
    expandFooter: true,
    footerGap: _compactLayout(context)
        ? 0
        : MediaQuery.sizeOf(context).height < 900
        ? 4
        : 12,
    body: _FireScene(
      active: _FireSlot.values.toSet(),
      placements: pieces.isEmpty ? null : pieces,
      english: english,
    ),
    footer: _AssemblyCompletionFeedback(
      english: english,
      pose: MascotPose.presenting,
      onContinue: onContinue,
      text: english
          ? 'Fire can occur when sufficient heat, fuel, and oxygen meet. Human activity can bring these three elements together. Prevention helps keep a fire from starting.'
          : 'Kebakaran dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut. Karena itu, pencegahan penting dilakukan agar kebakaran tidak terjadi.',
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
      edgeFeedback: answered,
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
          const SizedBox(height: 6),
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
              mascotRightInset: correct ? 64 : 24,
              text: english
                  ? (correct
                        ? 'Correct. ${scenario.reason}${lastScenario ? ' $summary' : ''}'
                        : 'The answer is ${scenario.human ? 'human activity.' : 'a natural factor.'} ${scenario.reason}${lastScenario ? ' $summary' : ''}')
                  : (correct
                        ? '${scenario.reason}${lastScenario ? ' $summary' : ''}'
                        : 'Yang ini dipicu ${scenario.human ? 'aktivitas manusia' : 'faktor alam'}. ${scenario.reason}${lastScenario ? ' $summary' : ''}'),
            )
          : LocalizedText(
              english
                  ? 'Choose the answer that fits the situation best.'
                  : 'Pilih salah satu jawaban untuk melihat penjelasannya.',
              style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
            ),
    );
  }
}

class _PeatCharacteristics extends StatelessWidget {
  const _PeatCharacteristics({
    required this.english,
    required this.opened,
    required this.flipped,
    required this.preparing,
    required this.onFlip,
    required this.onContinue,
    required this.onBack,
  });
  final bool english, preparing;
  final Set<int> opened, flipped;
  final ValueChanged<int> onFlip;
  final VoidCallback onContinue, onBack;

  @override
  Widget build(BuildContext context) {
    final complete = opened.length == 3;
    return _LightStage(
      chapter: 4,
      english: english,
      eyebrow: english
          ? 'CHAPTER 4 / PEAT FIRE CHARACTERISTICS'
          : 'BABAK 4 / CIRI KEBAKARAN GAMBUT',
      title: english
          ? 'What Are the Characteristics of Peatland Fires?'
          : 'Apa Saja Karakteristik Kebakaran di Ekosistem Gambut?',
      titleFontSize: _compactLayout(context) ? 21 : 24,
      subtitle: english
          ? 'Touch cards 1–3 to discover each characteristic.'
          : 'Sentuh kartu 1–3 untuk mengenali setiap cirinya.',
      onBack: onBack,
      bodyScrollable: false,
      body: Column(
        children: [
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            Expanded(
              child: PeatCharacteristicCard(
                key: ValueKey('peat-card-$index'),
                number: index + 1,
                information: (english
                    ? const [
                        'Fire can smolder beneath the ground surface.',
                        'These fires are difficult to extinguish.',
                        'Fire can reignite.',
                      ]
                    : const [
                        'Api dapat membara di bawah permukaan tanah.',
                        'Kebakaran sulit dipadamkan.',
                        'Api dapat menyala kembali.',
                      ])[index],
                revealed: flipped.contains(index),
                onTap: preparing ? null : () => onFlip(index),
              ),
            ),
          ],
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          SizedBox(
            height: _compactLayout(context) ? 126 : 142,
            child: _MascotFeedback(
              ok: false,
              neutral: true,
              assembly: true,
              centerBubbleOnMascot: true,
              pose: MascotPose.presenting,
              text: complete
                  ? (english
                        ? 'All three can happen in peatland fires. Ready to explore their impacts?'
                        : 'Ketiganya bisa terjadi pada kebakaran gambut. Yuk, kenali dampaknya juga.')
                  : (english
                        ? 'Take your time. You can turn each card over again.'
                        : 'Baca pelan-pelan, ya. Kamu bisa membalik kartunya lagi.'),
            ),
          ),
          _Primary(
            key: const ValueKey('peat-cards-continue'),
            label: preparing
                ? (english ? 'Preparing challenge…' : 'Menyiapkan tantangan…')
                : (english ? 'Explore the Impacts' : 'Kenali Dampaknya'),
            onPressed: complete && !preparing ? onContinue : null,
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
    required this.timerProgress,
    required this.found,
    required this.onTap,
    required this.onBack,
    this.reviewed = false,
    this.onContinue,
    this.onFinish,
  });
  final bool english;
  final int seconds;
  final ValueListenable<double> timerProgress;
  final Set<_ImpactToken> found;
  final ValueChanged<_ImpactToken>? onTap;
  final VoidCallback onBack;
  final bool reviewed;
  final VoidCallback? onContinue;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final compact = _compactLayout(context);
    final correct = found.where((token) => token.impact).length;
    final wrong = found.length - correct;
    final missed =
        _ImpactToken.values.where((token) => token.impact).length - correct;
    return _LightStage(
      chapter: 4,
      english: english,
      eyebrow: english
          ? 'CHAPTER 4 / FINAL CHALLENGE'
          : 'BABAK 4 / TANTANGAN AKHIR',
      title: english
          ? 'How Do Forest Fires Affect Peatland Ecosystems?'
          : 'Apa Saja Dampak Kebakaran Hutan pada Ekosistem Gambut?',
      titleFontSize: compact ? 21 : 24,
      subtitle: english
          ? 'Choose all the relevant impacts.'
          : 'Pilih semua dampak yang sesuai.',
      onBack: onBack,
      backLabel: reviewed ? (english ? 'Home' : 'Beranda') : null,
      trailing: reviewed
          ? SizedBox(
              width: 58,
              height: 58,
              child: IconButton(
                key: const ValueKey('impact-photo-credits'),
                tooltip: AppCopy.translate(
                  english ? 'Asset credits' : 'Kredit aset',
                ),
                onPressed: () {
                  final audio = GameAudioScope.of(context);
                  unawaited(audio.interact(GameSound.tap));
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: LocalizedText(
                        english ? 'Asset credits' : 'Kredit aset',
                      ),
                      content: const SingleChildScrollView(
                        child: SelectableText(
                          'Kabut asap / Smoke: NASA Earth Observatory, Jeff Schmaltz & Adam Voiland. Sumatra, 2015. NASA media guidelines.\nhttps://science.nasa.gov/earth/earth-observatory/smoke-over-sumatra-86762/\n\n'
                          'Gambut terbakar / Burning peat: Tan Yi Han, Selangor, 2013. CC BY-SA 3.0. Resized; display crop and color filter.\nhttps://commons.wikimedia.org/wiki/File:Peat_fire_in_Selangor,_Malaysia_on_5_June_2013.JPG\nhttps://creativecommons.org/licenses/by-sa/3.0/\n\n'
                          'Tanah amblas / Collapsed ground: US National Archives, NAID285717. Red Lake Agency, 1935. Public domain (US federal work).\nhttps://catalog.archives.gov/id/285717\n\n'
                          'Api / Fire: krisna azie, Unsplash. Kanopi / Canopy: Francesco Ungaro, Unsplash. Hutan / Forest: Kereng Bangkirai, project image credits.\n\n'
                          'Musik / Music: Safari — syncopika. CC BY 3.0. Adapted for looping and volume balanced.\nhttps://opengameart.org/content/safari\nhttps://creativecommons.org/licenses/by/3.0/',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            unawaited(audio.interact(GameSound.tap));
                            Navigator.pop(context);
                          },
                          child: LocalizedText(english ? 'Close' : 'Tutup'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
              ),
            )
          : _TimerChip(
              seconds: seconds,
              english: english,
              progress: timerProgress,
            ),
      bodyScrollable: false,
      body: LayoutBuilder(
        builder: (context, bounds) {
          // Reserve the host's space during play too, so the board stays put.
          final cardHeight = math.min(
            112.0,
            math.max(52.0, (bounds.maxHeight - (compact ? 140 : 160)) / 2),
          );
          return Column(
            children: [
              SizedBox(
                height: cardHeight * 2 + 8,
                child: GridView.count(
                  key: const ValueKey('final-selection-grid'),
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: ((bounds.maxWidth - 16) / 3) / cardHeight,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: _ImpactToken.values
                      .map(
                        (token) => _ImpactTokenCard(
                          token: token,
                          english: english,
                          found: found.contains(token),
                          revealed: reviewed,
                          onTap: !reviewed && seconds > 0
                              ? () => onTap?.call(token)
                              : null,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              LocalizedText(
                reviewed
                    ? (english
                          ? '$correct correct · $wrong incorrect · $missed missed'
                          : '$correct benar · $wrong salah · $missed terlewat')
                    : (english
                          ? '${found.length} images selected'
                          : '${found.length} gambar dipilih'),
                key: ValueKey(
                  reviewed ? 'final-review-summary' : 'final-selection-count',
                ),
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: reviewed
                    ? _FinalReviewDialogue(english: english, found: found)
                    : Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: compact ? 12 : 18),
                          child: _Primary(
                            key: const ValueKey('final-finish-early'),
                            label: english
                                ? 'Finish Selecting'
                                : 'Selesai Memilih',
                            onPressed: onFinish,
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      footer: reviewed
          ? _Primary(
              key: const ValueKey('final-review-continue'),
              label: english ? 'See Overall Result' : 'Lihat Hasil Akhir',
              onPressed: onContinue,
            )
          : SizedBox(
              height: 46,
              child: Center(child: _SafetyNote(english: english)),
            ),
    );
  }
}

class _FinalReviewDialogue extends StatelessWidget {
  const _FinalReviewDialogue({required this.english, required this.found});
  final bool english;
  final Set<_ImpactToken> found;

  String get _message {
    final correct = found.where((token) => token.impact).toList();
    final wrong = found.where((token) => !token.impact).toList();
    if (found.isEmpty) {
      return english
          ? 'No impacts were selected. The four impacts are haze, ecosystem damage, high carbon emissions, and subsidence.'
          : 'Belum ada dampak yang dipilih. Empat dampaknya adalah kabut asap, kerusakan ekosistem, emisi karbon tinggi, dan subsidens.';
    }
    if (correct.length == 4 && wrong.isEmpty) {
      return english
          ? 'You found all four impacts. Fire damages ecosystems and releases carbon stored in peat.'
          : 'Keempat dampak sudah kamu temukan. Kebakaran merusak ekosistem dan melepaskan karbon yang tersimpan dalam gambut.';
    }
    if (wrong.length == 2) {
      return english
          ? 'Fire worsens air quality and reduces peat carbon stores. Neither improvement is an impact of fire.'
          : 'Kebakaran memperburuk kualitas udara dan mengurangi cadangan karbon gambut. Kedua peningkatan itu bukan dampaknya.';
    }
    if (wrong.contains(_ImpactToken.cleanAir)) {
      return english
          ? 'Smoke worsens air quality. Cleaner air is not an impact of fire. Check the missed impacts too.'
          : 'Asap memperburuk kualitas udara. Udara yang lebih bersih bukan dampak kebakaran. Cermati juga dampak yang terlewat.';
    }
    if (wrong.contains(_ImpactToken.carbonStorage)) {
      return english
          ? 'Fire releases stored carbon, so peat carbon stores decrease. Check the missed impacts too.'
          : 'Kebakaran melepaskan karbon yang tersimpan, sehingga cadangan karbon gambut berkurang. Cermati juga dampak yang terlewat.';
    }
    final missed = _ImpactToken.values.firstWhere(
      (token) => token.impact && !found.contains(token),
    );
    return switch (missed) {
      _ImpactToken.haze =>
        english
            ? 'Smoke from peat fires creates haze and worsens air quality. This impact was missed.'
            : 'Asap kebakaran gambut menimbulkan kabut asap dan memperburuk kualitas udara. Dampak ini masih terlewat.',
      _ImpactToken.ecosystemDamage =>
        english
            ? 'Fire damages vegetation and habitats in peatland ecosystems. This impact was missed.'
            : 'Kebakaran merusak vegetasi dan habitat pada ekosistem gambut. Dampak ini masih terlewat.',
      _ImpactToken.carbonEmissions =>
        english
            ? 'Burning peat releases stored carbon into the atmosphere. This impact was missed.'
            : 'Gambut yang terbakar melepaskan karbon tersimpan ke atmosfer. Dampak ini masih terlewat.',
      _ =>
        english
            ? 'Loss of peat can lower the ground surface. This is called subsidence, another impact to recognize.'
            : 'Hilangnya lapisan gambut dapat menurunkan permukaan tanah. Inilah subsidens, salah satu dampak yang perlu dikenali.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final perfect = found.length == 4 && found.every((token) => token.impact);
    return LayoutBuilder(builder: (context, bounds) => _MascotFeedback(
      ok: perfect,
      assembly: true,
      centerBubbleOnMascot: true,
      pose: perfect ? MascotPose.success : MascotPose.hintSafety,
      text: _message,
      messageTextKey: const ValueKey('final-review-message'),
      cropKey: const ValueKey('final-review-mascot-crop'),
      bubbleHeightLimit: bounds.maxHeight,
      mascotBottom: -_stageFooterGap(context),
    ));
  }
}

enum _ImpactToken {
  haze,
  ecosystemDamage,
  carbonEmissions,
  subsidence,
  cleanAir,
  carbonStorage,
}

extension _ImpactTokenCopy on _ImpactToken {
  bool get impact => index < 4;
  String label(bool en) => switch (this) {
    _ImpactToken.haze => en ? 'Haze' : 'Kabut asap',
    _ImpactToken.ecosystemDamage =>
      en ? 'Ecosystem damage' : 'Kerusakan ekosistem',
    _ImpactToken.carbonEmissions =>
      en ? 'High carbon emissions' : 'Emisi karbon tinggi',
    _ImpactToken.subsidence =>
      en
          ? 'Lower ground surface (subsidence)'
          : 'Penurunan tinggi permukaan tanah atau subsidens',
    _ImpactToken.cleanAir =>
      en ? 'Improved air quality' : 'Peningkatan kualitas udara',
    _ImpactToken.carbonStorage =>
      en
          ? 'Increased carbon stored in peat soil'
          : 'Peningkatan cadangan karbon dalam tanah gambut',
  };
  String get photo => switch (this) {
    _ImpactToken.haze => 'assets/images/field/haze-sumatra-nasa.jpg',
    _ImpactToken.ecosystemDamage =>
      'assets/images/field/peat-fire-selangor.jpg',
    _ImpactToken.carbonEmissions => 'assets/images/field/fire-klaten.jpg',
    _ImpactToken.subsidence => 'assets/images/field/peat-subsidence-nara.jpg',
    _ImpactToken.cleanAir => 'assets/images/field/oxygen-canopy.jpg',
    _ImpactToken.carbonStorage => 'assets/images/forest/kereng-bangkirai.jpg',
  };
}

class _ScorePage extends StatelessWidget {
  const _ScorePage({
    required this.english,
    required this.triangle,
    required this.causes,
    required this.finalRaw,
    required this.bonus,
    required this.readingSeconds,
    required this.onContinue,
    required this.onAgain,
    required this.onHome,
  });
  final bool english;
  final int triangle, causes, finalRaw, readingSeconds;
  final double bonus;
  final VoidCallback onContinue, onAgain, onHome;
  double get total => triangle + causes + bonus;
  // Preserve the previous 8/9 and 6/9 attainment bands after removing a point.
  String get title => total / maxGamePoints >= 8 / 9
      ? (english ? 'Fire Prevention Hero' : 'Siap Cegah Karhutla')
      : total / maxGamePoints >= 6 / 9
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
        MotionReveal(
          delay: const Duration(milliseconds: 60),
          beginScale: .98,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: KifcTheme.success,
              borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                LocalizedText(
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
                  child: LocalizedText(
                    english
                        ? '/ $maxGamePoints points'
                        : '/ $maxGamePoints poin',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        MotionReveal(
          delay: const Duration(milliseconds: 110),
          child: _ScoreRow(
            label: english ? 'Elements placed' : 'Menyusun unsur',
            score: '$triangle/3',
          ),
        ),
        MotionReveal(
          delay: const Duration(milliseconds: 150),
          child: _ScoreRow(
            label: english ? 'Recognising causes' : 'Mengenali penyebab',
            score: '$causes/4',
          ),
        ),
        MotionReveal(
          delay: const Duration(milliseconds: 190),
          child: _ScoreRow(
            label: english
                ? 'Impact challenge bonus'
                : 'Bonus mengenali dampak',
            score: '${_points(bonus, english)}/1',
          ),
        ),
        LocalizedText(
          english
              ? '$finalRaw/4 challenge points → +${_points(bonus, english)} bonus'
              : '$finalRaw/4 poin di babak akhir = ${_points(bonus, english)} poin bonus',
          style: const TextStyle(fontSize: 11, color: KifcTheme.mutedInk),
        ),
        const SizedBox(height: 10),
        Container(
          key: const ValueKey('score-closing-banner'),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0x120C2B1F),
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
            border: Border.all(color: const Color(0x240C2B1F)),
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.shield_outlined,
                size: 18,
                color: KifcTheme.forest800,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LocalizedText(
                  english
                      ? 'Preventing Fires Is Better Than Fighting Them.'
                      : 'Mencegah Kebakaran Lebih Baik daripada Memadamkan.',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: KifcTheme.forest800,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
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
        _ContinueNotice(english: english, seconds: readingSeconds),
      ],
    ),
  );
}

class _ClosingPage extends StatelessWidget {
  const _ClosingPage({
    required this.english,
    required this.readingSeconds,
    required this.onAgain,
    required this.onExplore,
    required this.narrating,
    required this.onMascotReady,
  });
  final bool english;
  final bool narrating;
  final VoidCallback onMascotReady;
  final int readingSeconds;
  final VoidCallback onAgain, onExplore;
  @override
  Widget build(BuildContext context) {
    final compact = _compactLayout(context);
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
          TouchscreenArea(
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
                      LocalizedText(
                        english ? 'CHALLENGE COMPLETE' : 'TANTANGAN SELESAI',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .4,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const AudioControls(dark: true),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LocalizedText(
                          key: const ValueKey('closing-title'),
                          english
                              ? 'Protect Forests.\nProtect Lives.'
                              : 'Jaga Hutan,\nJaga Kehidupan.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 30 : 34,
                            fontWeight: FontWeight.w800,
                            height: 1.06,
                            letterSpacing: -.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _HostConversation(
                          key: const ValueKey('closing-conversation'),
                          pose: MascotPose.success,
                          state: MascotState.farewell,
                          narrating: narrating,
                          onMascotReady: onMascotReady,
                          mascotOnRight: true,
                          text: english
                              ? 'Thanks for playing! Keep fire away from dry vegetation. If you see a fire, report it to trained personnel.'
                              : 'Terima kasih sudah bermain! Jauhkan sumber api dari bahan kering. Jika melihat kebakaran, segera laporkan kepada petugas.',
                        ),
                        SizedBox(height: compact ? 10 : 12),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 12),
                        const LocalizedText(
                          'Korea–Indonesia Forest Cooperation Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 5),
                        LocalizedText(
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
                  SizedBox(height: compact ? 10 : 12),
                  SizedBox(
                    height: 46,
                    child: FilledButton(
                      onPressed: () {
                        unawaited(
                          GameAudioScope.of(context).interact(GameSound.tap),
                        );
                        onAgain();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: KifcTheme.paper,
                        foregroundColor: KifcTheme.forest950,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            KifcTheme.controlRadius,
                          ),
                        ),
                      ),
                      child: LocalizedText(
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
                  _ContinueNotice(
                    english: english,
                    seconds: readingSeconds,
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

class _ContinueNotice extends StatelessWidget {
  const _ContinueNotice({
    required this.english,
    required this.seconds,
    this.dark = false,
  });
  final bool english;
  final int seconds;
  final bool dark;
  @override
  Widget build(BuildContext context) => LocalizedText(
    english
        ? 'Touch the screen to continue, or wait $seconds seconds.'
        : 'Sentuh layar untuk lanjut, atau tunggu $seconds detik.',
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
    final compact = _compactLayout(context);
    return Scaffold(
      backgroundColor: KifcTheme.forest950,
      body: TerrainBackdrop(
        dark: true,
        child: TouchscreenArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _PartnerHeader(dark: true),
                SizedBox(height: compact ? 5 : 13),
                _TopBar(
                  chapter: chapter,
                  english: english,
                  dark: true,
                  onBack: onBack,
                ),
                SizedBox(height: compact ? 5 : 10),
                _Eyebrow(text: eyebrow, dark: true),
                LocalizedText(
                  title,
                  semanticsLabel: title.replaceAll(RegExp(r'\s+'), ' '),
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.08,
                    fontSize: compact ? 26 : 29,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                LocalizedText(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: compact ? 12 : 20),
                if (groupFooter)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [body, const SizedBox(height: 20), footer],
                      ),
                    ),
                  )
                else ...[
                  Expanded(child: body),
                  SizedBox(height: compact ? 10 : 16),
                  footer,
                ],
              ],
            ),
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
    this.edgeFeedback = false,
    this.expandFooter = false,
    this.titleFontSize,
    this.footerGap,
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
  final bool edgeFeedback;
  final bool expandFooter;
  final double? titleFontSize;
  final double? footerGap;
  @override
  Widget build(BuildContext context) {
    final compact = _compactLayout(context);
    return Scaffold(
      backgroundColor: KifcTheme.paper,
      body: TerrainBackdrop(
        child: TouchscreenArea(
          bottom: !edgeFeedback,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              chapter == 1 ? 18 : 24,
              14,
              chapter == 1 ? 18 : 24,
              edgeFeedback ? 0 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _PartnerHeader(),
                SizedBox(height: compact ? 5 : 11),
                _TopBar(
                  chapter: chapter,
                  english: english,
                  onBack: onBack,
                  backLabel: backLabel,
                  onRestart: onRestart,
                  trailing: trailing,
                ),
                SizedBox(height: compact ? 5 : 11),
                _Eyebrow(text: eyebrow),
                LocalizedText(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize ?? (compact ? 26 : 29),
                    height: 1.07,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 6),
                  LocalizedText(
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
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          body,
                          SizedBox(height: footerGap ?? 16),
                          footer,
                        ],
                      ),
                    ),
                  )
                else if (expandFooter) ...[
                  body,
                  SizedBox(height: footerGap ?? 12),
                  Expanded(child: footer),
                ] else ...[
                  Expanded(
                    child: bodyScrollable
                        ? SingleChildScrollView(child: body)
                        : body,
                  ),
                  SizedBox(height: footerGap ?? _stageFooterGap(context)),
                  footer,
                ],
              ],
            ),
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
          border: Border.all(color: Colors.white.withValues(alpha: .4)),
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
    tint: Colors.white.withValues(alpha: .2),
    padding: const EdgeInsets.all(8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: AppLocale.values
                .map(
                  (candidate) => Expanded(
                    child: InkWell(
                      onTap: () {
                        unawaited(
                          GameAudioScope.of(context).interact(GameSound.tap),
                        );
                        onChanged(candidate);
                      },
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: LocalizedText(
                              candidate.label,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: candidate == AppLocale.korean
                                    ? 'NotoSansKR'
                                    : null,
                                fontVariations: candidate == AppLocale.korean
                                    ? const [FontVariation('wght', 700)]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 6),
        const AudioControls(dark: true),
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
        const SizedBox(width: 24),
      const SizedBox(width: 6),
      AudioControls(dark: dark),
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
      LocalizedText(
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
    child: LocalizedText(
      AppCopy.translate(text).split('/').first.trim(),
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
  Widget build(BuildContext context) => PressFeedback(
    enabled: true,
    child: SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: () {
          unawaited(GameAudioScope.of(context).interact(GameSound.tap));
          onPressed();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: dark ? Colors.white : KifcTheme.ink,
          side: BorderSide(color: dark ? Colors.white70 : KifcTheme.forest800),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
        ),
        icon: Icon(icon, size: 16),
        label: LocalizedText(label, style: const TextStyle(fontSize: 12)),
      ),
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
    this.large = false,
    this.singleLine = false,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool dark;
  final bool large;
  final bool singleLine;
  @override
  Widget build(BuildContext context) => PressFeedback(
    // The large welcome CTA already owns its pressure animation.
    enabled: onPressed != null && !large,
    child: SizedBox(
      width: double.infinity,
      height: large ? 72 : 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null ? null : KifcTheme.primaryGradient,
          borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed == null
              ? null
              : () {
                  unawaited(GameAudioScope.of(context).interact(GameSound.tap));
                  onPressed!();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
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
          icon: icon == null
              ? const SizedBox.shrink()
              : Icon(icon, size: large ? 28 : null),
          label: singleLine
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LocalizedText(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              : LocalizedText(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: large ? 21 : null,
                  ),
                ),
        ),
      ),
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
  Widget build(BuildContext context) => PressFeedback(
    enabled: true,
    child: SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: () {
          unawaited(GameAudioScope.of(context).interact(GameSound.tap));
          onPressed();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: dark ? Colors.white : KifcTheme.ink,
          side: BorderSide(color: dark ? Colors.white54 : KifcTheme.forest800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
          ),
        ),
        child: LocalizedText(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
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
                child: LocalizedText(
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
              LocalizedText(
                english ? 'FIELD SITUATION $index' : 'SITUASI $index',
                style: const TextStyle(
                  color: KifcTheme.mutedInk,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 5),
              LocalizedText(
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

LinearGradient _answerGradient(bool correct) => correct
    ? const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[KifcTheme.answerCorrect, KifcTheme.forest800],
      )
    : const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          KifcTheme.answerIncorrect,
          KifcTheme.answerIncorrectDeep,
        ],
      );

class _AnswerMark extends StatelessWidget {
  const _AnswerMark({required this.correct});
  final bool correct;

  @override
  Widget build(BuildContext context) => MotionReveal(
    offset: Offset.zero,
    beginScale: .65,
    duration: const Duration(milliseconds: 220),
    child: Icon(
      correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
      color: Colors.white,
      size: 18,
    ),
  );
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.ok,
    required this.text,
    this.longMessage = false,
    this.mascotRightInset = 24,
  });
  final bool ok;
  final String text;
  final bool longMessage;
  final double mascotRightInset;
  @override
  Widget build(BuildContext context) =>
      _MascotFeedback(text: text, ok: ok, longMessage: longMessage,
        mascotRightInset: mascotRightInset);
}

class _MascotFeedback extends StatelessWidget {
  const _MascotFeedback({
    required this.text,
    required this.ok,
    this.longMessage = false,
    this.assembly = false,
    this.pose,
    this.neutral = false,
    this.centerBubbleOnMascot = false,
    this.mascotRightInset = 24,
    this.messageTextKey,
    this.bubbleHeightLimit,
    this.mascotBottom = 0,
    this.cropKey = const ValueKey('feedback-mascot-crop'),
  });
  final String text;
  final bool ok;
  final bool longMessage;
  final bool assembly;
  final MascotPose? pose;
  final bool neutral;
  final bool centerBubbleOnMascot;
  final double mascotRightInset;
  final Key? messageTextKey;
  final double? bubbleHeightLimit;
  final double mascotBottom;
  final Key cropKey;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final dense = longMessage && viewport.height < 900;
    // Lift only the reading bubble; the cropped mascot still meets the panel.
    final readingBottom = assembly
        ? 16.0
        : !longMessage
        ? 16.0
        : TouchscreenArea.isCenteredOf(context)
        ? 72.0
        : viewport.height < 680
        ? 20.0
        : 48.0;
    // Long quiz feedback shares a row with the mascot; preserve answer sizes.
    final mascotWidth = assembly
        ? _assemblyMascotWidth(context)
        : dense && ok
        ? (viewport.height < 680 ? 140.0 : 190.0)
        : viewport.width < 380
        ? 176.0
        : 230.0;
    final imageHeight = mascotWidth * 4 / 3;
    // Artwork includes transparent side margins. Keep cause-feedback reading
    // width stable when enlarging its decorative mascot.
    final bubbleInsetWidth = !assembly && !longMessage
        ? math.min(mascotWidth, viewport.width < 380 ? 160.0 : 194.0)
        : mascotWidth;
    final leftInset = assembly && pose == MascotPose.presenting ? 16.0 : 40.0;
    final bubble = Padding(
      padding: EdgeInsets.only(
        left: ok ? 0 : bubbleInsetWidth - leftInset,
        right: !ok ? 0 : bubbleInsetWidth - 24,
        top: centerBubbleOnMascot || dense ? 0 : 8,
        bottom: centerBubbleOnMascot ? 0 : readingBottom,
      ),
      child: _SpeechBubble(
        text: text,
        tailOnRight: ok,
        motionKey: const ValueKey('feedback-motion'),
        messageKey: const ValueKey('feedback-message'),
        textKey: messageTextKey,
        tailWidth: messageTextKey != null ? 8 : 10,
        tailHalfHeight: messageTextKey != null ? 8 : 9,
        padding: EdgeInsets.all(dense ? 8 : 10),
        side: BorderSide(
          color: neutral
              ? KifcTheme.line
              : (ok ? KifcTheme.answerCorrect : KifcTheme.answerIncorrect)
                    .withValues(alpha: .45),
        ),
        style: TextStyle(
          color: KifcTheme.ink,
          fontSize: dense ? 12 : 13,
          height: 1.25,
        ),
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: assembly
            ? (viewport.height < 680 ? 96 : 104)
            : TouchscreenArea.isCenteredOf(context)
            ? 230
            : 150,
      ),
      child: Stack(
        alignment: longMessage ? Alignment.bottomCenter : Alignment.topLeft,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            // Use the PNG's transparent side margin to sit close to the edge
            // while preserving the complete silhouette and both hands.
            left: ok ? null : -leftInset,
            right: ok ? -mascotRightInset : null,
            bottom: mascotBottom,
            width: mascotWidth,
            height: imageHeight * _feedbackMascotCrop,
            child: ClipRect(
              key: cropKey,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                minWidth: mascotWidth,
                maxWidth: mascotWidth,
                minHeight: imageHeight,
                maxHeight: imageHeight,
                child: Transform.scale(
                  scale: _feedbackMascotScale,
                  alignment: const Alignment(0, -.5),
                  child: GameMascot(
                    pose:
                        pose ??
                        (ok ? MascotPose.success : MascotPose.hintSafety),
                    height: imageHeight,
                    motionTrigger: (AppCopy.locale, text),
                  ),
                ),
              ),
            ),
          ),
          if (centerBubbleOnMascot)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: math.min(imageHeight * _feedbackMascotCrop,
                bubbleHeightLimit ?? double.infinity),
              child: Center(child: bubble),
            )
          else
            bubble,
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.error = false,
    this.height = 48,
  });
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool error;
  final double height;
  @override
  Widget build(BuildContext context) => PressFeedback(
    enabled: onTap != null,
    child: AnimatedContainer(
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
                  ? (error
                        ? KifcTheme.answerIncorrect
                        : KifcTheme.answerCorrect)
                  : KifcTheme.line,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
            ),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 26),
              Expanded(
                child: LocalizedText(
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
              SizedBox(
                width: 26,
                child: selected ? _AnswerMark(correct: !error) : null,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _FireScene extends StatelessWidget {
  const _FireScene({
    required this.active,
    required this.english,
    this.onDrop,
    this.placements,
  });
  final Set<_FireSlot> active;
  final Map<_FireSlot, _FirePiece>? placements;
  final bool english;
  static double heightOf(BuildContext context) =>
      _compactLayout(context) ? 216 : 248;
  final ValueChanged<_FirePiece>? onDrop;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
    child: SizedBox(
      height: heightOf(context),
      child: LayoutBuilder(
        builder: (context, bounds) {
          final height = bounds.maxHeight;
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
          return DragTarget<_FirePiece>(
            key: const ValueKey('forest-drop-target'),
            onWillAcceptWithDetails: (_) => onDrop != null && active.length < 3,
            onAcceptWithDetails: (details) => onDrop?.call(details.data),
            builder: (context, candidate, rejected) => Semantics(
              container: true,
              explicitChildNodes: true,
              label: onDrop == null
                  ? null
                  : AppCopy.translate(
                      english
                          ? 'Forest area for dropping fire elements'
                          : 'Area hutan untuk meletakkan unsur api',
                    ),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const ColoredBox(color: KifcTheme.forest800),
                  Positioned.fill(
                    child: const GamePhoto(
                      'assets/images/field/rainforest-kalimantan.jpg',
                      forestTone: true,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                  if (active.length == 3)
                    Positioned.fill(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: _motionDuration(
                          context,
                          const Duration(milliseconds: 450),
                        ),
                        builder: (context, opacity, child) =>
                            Opacity(opacity: opacity, child: child),
                        child: const ForestBurnVideo(key: ValueKey('fire')),
                      ),
                    ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00152D23), Color(0x88152D23)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    width: bounds.maxWidth - 24,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xE41A4534),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: LocalizedText(
                          '${active.length}/3 ${english ? 'elements' : 'unsur'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
                        filled:
                            placements?.containsKey(slot) ??
                            active.contains(slot),
                        placedPiece: placements?[slot],
                        burning: active.length == 3,
                      ),
                    ),
                  ),
                  if (candidate.isNotEmpty)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          key: const ValueKey('forest-drop-highlight'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              KifcTheme.controlRadius,
                            ),
                            border: Border.all(
                              color: KifcTheme.amber,
                              width: 3,
                            ),
                            color: KifcTheme.amber.withValues(alpha: .06),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _DropSlot extends StatelessWidget {
  const _DropSlot({
    required this.slot,
    required this.english,
    required this.filled,
    this.placedPiece,
    this.burning = false,
  });
  final bool burning;
  final _FireSlot slot;
  final _FirePiece? placedPiece;
  final bool english;
  final bool filled;

  @override
  Widget build(BuildContext context) => !filled
      ? const SizedBox.expand()
      : MotionReveal(
          offset: Offset.zero,
          beginScale: .94,
          duration: const Duration(milliseconds: 240),
          child: _PhotoFrame(
            radius: BorderRadius.circular(10),
            border: Border.all(color: KifcTheme.answerCorrect),
            child: Stack(
              fit: StackFit.expand,
              children: [
                GamePhoto(placedPiece?.photo ?? slot.photo, forestTone: true),
                ColoredBox(
                  color: burning
                      ? const Color(0x88451E10)
                      : const Color(0x850C2119),
                ),
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LocalizedText(
                      placedPiece?.slot?.title(english) ?? slot.title(english),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}

/// Clips the photo edge to edge and paints its outline above it. A decoration
/// border on Container would inset the image and expose pale corner wedges.
class _PhotoFrame extends StatelessWidget {
  const _PhotoFrame({required this.child, required this.border, this.radius});
  final Widget child;
  final BoxBorder border;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final radius =
        this.radius ?? BorderRadius.circular(KifcTheme.controlRadius);
    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: KifcTheme.forest800,
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
      ? _PieceCard(piece: piece, english: english, placed: true)
      : Draggable<_FirePiece>(
          data: piece,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: _AssemblyDragPreview(
            sourceContext: context,
            piece: piece,
            english: english,
          ),
          childWhenDragging: Opacity(
            opacity: .35,
            child: _PieceCard(piece: piece, english: english),
          ),
          child: _PieceCard(piece: piece, english: english),
        );
}

class _AssemblyDragPreview extends StatelessWidget {
  const _AssemblyDragPreview({
    required this.sourceContext,
    required this.piece,
    required this.english,
  });
  final BuildContext sourceContext;
  final _FirePiece piece;
  final bool english;
  @override
  Widget build(BuildContext context) {
    if (!sourceContext.mounted) return const SizedBox.shrink();
    final source = sourceContext.findRenderObject()! as RenderBox;
    final overlay = Overlay.of(sourceContext).context.findRenderObject()!;
    final scale = source.getTransformTo(overlay).getMaxScaleOnAxis();
    final width = source.size.width * scale;
    final height = source.size.height * scale;
    // Keep the photo above the finger while hit testing uses the finger itself.
    return Transform.translate(
      offset: Offset(-width / 2, -height - 12),
      child: SizedBox(
        width: width,
        height: height,
        child: FittedBox(
          child: SizedBox(
            width: source.size.width,
            height: source.size.height,
            child: Material(
              color: Colors.transparent,
              child: _PieceCard(piece: piece, english: english, elevated: true),
            ),
          ),
        ),
      ),
    );
  }
}

class _PieceCard extends StatelessWidget {
  const _PieceCard({
    required this.piece,
    required this.english,
    this.elevated = false,
    this.placed = false,
  });
  final _FirePiece piece;
  final bool english;
  final bool elevated;
  final bool placed;
  @override
  Widget build(BuildContext context) => Container(
    width: 106,
    height: 106 / _fireCardAspectRatio,
    decoration: BoxDecoration(
      color: KifcTheme.forest800,
      borderRadius: BorderRadius.circular(10),
      boxShadow: elevated
          ? <BoxShadow>[const BoxShadow(color: Colors.black26, blurRadius: 8)]
          : null,
    ),
    child: _PhotoFrame(
      radius: BorderRadius.circular(10),
      border: Border.all(
        color: placed ? KifcTheme.answerCorrect : KifcTheme.line,
        width: placed ? 2 : 1,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GamePhoto(piece.photo, forestTone: true),
          if (placed) const ColoredBox(color: Color(0x30142E22)),
          if (piece == _FirePiece.oxygen && !placed)
            Positioned(
              top: 5,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xE6F7F6EE),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'O₂',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: KifcTheme.ink,
                  ),
                ),
              ),
            ),
          if (placed)
            const Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
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
              child: LocalizedText(
                piece.label(english),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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

class _ImpactTokenCard extends StatelessWidget {
  const _ImpactTokenCard({
    required this.token,
    required this.english,
    required this.found,
    required this.onTap,
    this.revealed = false,
  });
  final _ImpactToken token;
  final bool english;
  final bool found;
  final bool revealed;
  final VoidCallback? onTap;
  bool get _missed => revealed && !found && token.impact;
  Color get _markerColor => !revealed || _missed
      ? KifcTheme.amber
      : token.impact
      ? KifcTheme.answerCorrect
      : KifcTheme.answerIncorrect;
  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: _motionDuration(context, const Duration(milliseconds: 180)),
    curve: Curves.easeOutBack,
    scale: found && !revealed ? 1.015 : 1,
    child: InkWell(
      key: ValueKey('impact-${token.name}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
      child: SizedBox(
        width: 104,
        height: 100,
        child: _PhotoFrame(
          border: Border.all(
            color: found || _missed ? _markerColor : KifcTheme.line,
            width: found || _missed ? 2 : 1,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GamePhoto(token.photo, forestTone: true),
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
              if (found || _missed)
                Positioned(
                  right: 6,
                  top: 6,
                  child: MotionReveal(
                    trigger: (found, revealed),
                    offset: Offset.zero,
                    beginScale: .7,
                    duration: const Duration(milliseconds: 220),
                    child: Semantics(
                      label: AppCopy.translate(
                        !revealed
                            ? (english ? 'Selected' : 'Dipilih')
                            : _missed
                            ? (english ? 'Missed impact' : 'Dampak terlewat')
                            : token.impact
                            ? (english
                                  ? 'Correct impact'
                                  : 'Benar, ini dampak kebakaran')
                            : (english
                                  ? 'Not a fire impact'
                                  : 'Bukan dampak kebakaran'),
                      ),
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          color: !revealed ? KifcTheme.forest950 : _markerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          !revealed
                              ? Icons.radio_button_checked
                              : _missed
                              ? Icons.remove_rounded
                              : token.impact
                              ? Icons.check_rounded
                              : Icons.close_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 8, 5, 10),
                  child: LocalizedText(
                    token.label(english),
                    textAlign: TextAlign.center,
                    maxLines: 5,
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
  const _TimerChip({
    required this.seconds,
    required this.english,
    required this.progress,
  });
  final int seconds;
  final bool english;
  final ValueListenable<double> progress;
  Color get _color => seconds <= finalChallengeSeconds * .3
      ? KifcTheme.answerIncorrect
      : seconds <= finalChallengeSeconds * .5
      ? KifcTheme.amber
      : KifcTheme.answerCorrect;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 58,
    height: 58,
    child: _LiquidGlass(
      borderRadius: BorderRadius.circular(999),
      tint: Colors.white.withValues(alpha: .45),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, fraction, _) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 1, end: fraction),
                duration: fraction == 0
                    ? Duration.zero
                    : _motionDuration(
                        context,
                        const Duration(milliseconds: 100),
                      ),
                curve: Curves.linear,
                builder: (context, value, _) => CircularProgressIndicator(
                  key: const ValueKey('final-countdown-progress'),
                  value: value,
                  strokeWidth: 3.5,
                  backgroundColor: _color.withValues(alpha: .13),
                  color: _color,
                  semanticsLabel: AppCopy.translate(
                    english ? 'Time remaining' : 'Sisa waktu',
                  ),
                  semanticsValue: AppCopy.translate(
                    english ? '$seconds seconds' : '$seconds detik',
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: LocalizedText(
                    '$seconds',
                    key: ValueKey(seconds),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: .9,
                    ),
                  ),
                ),
                LocalizedText(
                  english ? 'sec' : 'detik',
                  style: const TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ],
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
        LocalizedText(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        LocalizedText(
          score,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
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
        child: LocalizedText(
          english
              ? 'Do not approach a real fire. Report it and follow trained personnel.'
              : 'Jika melihat kebakaran, jaga jarak. Laporkan kepada petugas dan ikuti arahannya.',
          style: const TextStyle(fontSize: 12, color: KifcTheme.forest800),
        ),
      ),
    ],
  );
}
