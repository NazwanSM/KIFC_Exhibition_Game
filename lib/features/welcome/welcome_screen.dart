import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/kifc_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  AppLocale _locale = AppLocale.english;
  _Screen _screen = _Screen.welcome;
  final Map<_Element, _Choice> _matched = <_Element, _Choice>{};
  _Choice? _selected;
  _Feedback feedback = _Feedback.neutral;

  bool get english => _locale == AppLocale.english;

  void _resetGame() => setState(() {
    _matched.clear();
    _selected = null;
    feedback = _Feedback.neutral;
    _screen = _Screen.game;
  });

  void _select(_Choice choice) => setState(() {
    _selected = choice;
    feedback = _Feedback.neutral;
  });

  void _match(_Element element) {
    final choice = _selected;
    if (choice == null || _matched.containsKey(element)) return;
    setState(() {
      _selected = null;
      if (choice.element == element) {
        _matched[element] = choice;
        feedback = _matched.length == 3
            ? _Feedback.complete
            : _Feedback.correct;
      } else {
        feedback = _Feedback.tryAgain;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screen == _Screen.welcome) {
      return _Welcome(
        locale: _locale,
        onLocale: (locale) => setState(() => _locale = locale),
        onStart: () => setState(() => _screen = _Screen.learn),
      );
    }
    if (_screen == _Screen.learn) {
      return _Learn(
        english: english,
        onBack: () => setState(() => _screen = _Screen.welcome),
        onStart: _resetGame,
      );
    }
    if (_matched.length == 3) {
      return _Complete(
        english: english,
        onAgain: _resetGame,
        onWelcome: () => setState(() => _screen = _Screen.welcome),
      );
    }
    return _Game(
      english: english,
      matched: _matched,
      selected: _selected,
      feedback: feedback,
      onBack: () => setState(() => _screen = _Screen.learn),
      onRestart: _resetGame,
      onSelect: _select,
      onMatch: _match,
    );
  }
}

enum _Screen { welcome, learn, game }

enum _Feedback { neutral, correct, tryAgain, complete }

enum _Element { heat, fuel, oxygen }

extension _ElementCopy on _Element {
  String title(bool english) => switch (this) {
    _Element.heat => english ? 'Heat' : 'Panas',
    _Element.fuel => english ? 'Fuel' : 'Bahan bakar',
    _Element.oxygen => english ? 'Oxygen' : 'Oksigen',
  };

  String description(bool english) => switch (this) {
    _Element.heat =>
      english ? 'Energy to start a fire.' : 'Energi untuk memulai api.',
    _Element.fuel =>
      english ? 'Material that can burn.' : 'Material yang dapat terbakar.',
    _Element.oxygen =>
      english
          ? 'Oxygen in air supports fire.'
          : 'Oksigen di udara mendukung api.',
  };

  IconData get icon => switch (this) {
    _Element.heat => Icons.local_fire_department_outlined,
    _Element.fuel => Icons.forest_outlined,
    _Element.oxygen => Icons.air,
  };
}

class _Choice {
  const _Choice(this.en, this.id, this.element);
  final String en;
  final String id;
  final _Element? element;
  String label(bool english) => english ? en : id;
}

const _choices = <_Choice>[
  _Choice('Solar heat', 'Panas matahari', _Element.heat),
  _Choice('Dry wood', 'Kayu kering', _Element.fuel),
  _Choice('Dry grass', 'Rumput kering', null),
  _Choice('Wind', 'Angin', _Element.oxygen),
  _Choice('Rainwater', 'Air hujan', null),
  _Choice('Wet soil', 'Tanah basah', null),
  _Choice('Cold air', 'Udara dingin', null),
];

class _Welcome extends StatelessWidget {
  const _Welcome({
    required this.locale,
    required this.onLocale,
    required this.onStart,
  });
  final AppLocale locale;
  final ValueChanged<AppLocale> onLocale;
  final VoidCallback onStart;

  bool get english => locale == AppLocale.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KifcTheme.forest950,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const _ForestImage(),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xB30C2B1F), Color(0xEF092419)],
                stops: <double>[0.12, 0.76],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _PartnerMarks(dark: true),
                  const SizedBox(height: 18),
                  _LanguageSwitch(locale: locale, onChanged: onLocale),
                  const Spacer(flex: 3),
                  const Icon(
                    Icons.landscape_outlined,
                    color: Colors.white70,
                    size: 38,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    english
                        ? 'Indonesian peat swamp forest\nMorning light, still water, dense vegetation'
                        : 'Hutan rawa gambut Indonesia\nCahaya pagi, air tenang, vegetasi rapat',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                  const Spacer(flex: 4),
                  Row(
                    children: <Widget>[
                      Container(width: 20, height: 2, color: KifcTheme.amber),
                      const SizedBox(width: 8),
                      Text(
                        english
                            ? 'EXPLORE FORESTS & PEATLANDS'
                            : 'JELAJAHI HUTAN & GAMBUT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    english
                        ? 'Fire Prevention\nChallenge'
                        : 'Tantangan\nPencegahan Karhutla',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 39,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    english
                        ? 'Arrange the three elements of fire, then discover how to protect forest and land from fire.'
                        : 'Susun tiga unsur api, lalu temukan cara melindungi hutan dan lahan dari kebakaran.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.28,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _PrimaryButton(
                    dark: true,
                    icon: Icons.touch_app_outlined,
                    label: english ? 'Start Challenge' : 'Mulai Tantangan',
                    onPressed: onStart,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    english ? 'Tap to begin' : 'Ketuk untuk memulai',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
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

class _Learn extends StatelessWidget {
  const _Learn({
    required this.english,
    required this.onBack,
    required this.onStart,
  });
  final bool english;
  final VoidCallback onBack;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => _LightPage(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _PartnerMarks(),
            const SizedBox(height: 16),
            _OutlineAction(
              icon: Icons.arrow_back,
              label: english ? 'Back' : 'Kembali',
              onPressed: onBack,
            ),
            const SizedBox(height: 16),
            Text(
              english
                  ? 'Three elements. One\nchallenge.'
                  : 'Tiga unsur. Satu\ntantangan.',
              style: const TextStyle(
                fontSize: 31,
                height: 1.05,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              english
                  ? 'Discover what keeps fire burning. Choose, match, then learn how to prevent it.'
                  : 'Kenali unsur yang membuat api menyala. Pilih, cocokkan, lalu pelajari pencegahannya.',
              style: const TextStyle(
                color: KifcTheme.mutedInk,
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            const _PhotoPanel(
              title: 'Water and vegetation in a peat forest',
              height: 118,
            ),
            const SizedBox(height: 10),
            _Instruction(
              number: '01',
              icon: Icons.touch_app_outlined,
              text: english ? 'Choose one object.' : 'Pilih satu objek.',
            ),
            const SizedBox(height: 8),
            _Instruction(
              number: '02',
              icon: Icons.open_with,
              text: english
                  ? 'Tap the matching element.'
                  : 'Ketuk unsur yang sesuai.',
            ),
            const SizedBox(height: 8),
            _Instruction(
              number: '03',
              icon: Icons.local_fire_department_outlined,
              text: english
                  ? 'Complete the Fire Triangle.'
                  : 'Lengkapi Segitiga Api.',
            ),
            const Spacer(),
            Text(
              english
                  ? 'No sound needed. All instructions appear on screen.'
                  : 'Tanpa suara. Semua instruksi tampil di layar.',
              style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
            ),
            const SizedBox(height: 8),
            _PrimaryButton(
              icon: Icons.touch_app_outlined,
              label: english ? 'Start' : 'Mulai',
              onPressed: onStart,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Game extends StatelessWidget {
  const _Game({
    required this.english,
    required this.matched,
    required this.selected,
    required this.feedback,
    required this.onBack,
    required this.onRestart,
    required this.onSelect,
    required this.onMatch,
  });
  final bool english;
  final Map<_Element, _Choice> matched;
  final _Choice? selected;
  final _Feedback feedback;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  final ValueChanged<_Choice> onSelect;
  final ValueChanged<_Element> onMatch;

  @override
  Widget build(BuildContext context) {
    final (String hint, Color color, IconData icon) = switch (feedback) {
      _Feedback.correct => (
        english
            ? 'Correct. Heat helps the combustion process.'
            : 'Benar. Panas membantu proses pembakaran.',
        KifcTheme.success,
        Icons.check_circle_outline,
      ),
      _Feedback.tryAgain => (
        english
            ? 'Try again. Rainwater helps keep fuel wet.'
            : 'Coba lagi. Air hujan membantu menjaga bahan bakar tetap basah.',
        KifcTheme.warning,
        Icons.warning_amber_outlined,
      ),
      _ => (
        selected == null
            ? (english
                  ? 'Tap an object, then a slot. You can also drag.'
                  : 'Ketuk objek, lalu kolom yang sesuai.')
            : (english
                  ? 'Tap the matching element.'
                  : 'Ketuk unsur yang sesuai.'),
        KifcTheme.warmPanel,
        Icons.info_outline,
      ),
    };
    return _LightPage(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _PartnerMarks(),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  _OutlineAction(
                    icon: Icons.arrow_back,
                    label: english ? 'Back' : 'Kembali',
                    onPressed: onBack,
                  ),
                  const Spacer(),
                  _Progress(value: matched.length),
                  const Spacer(),
                  _OutlineAction(
                    icon: Icons.restart_alt,
                    label: english ? 'Restart' : 'Ulangi',
                    onPressed: onRestart,
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Text(
                english ? 'Build the Fire Triangle' : 'Bangun Segitiga Api',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                english
                    ? 'Choose objects that keep a fire burning.'
                    : 'Pilih objek yang membuat api tetap menyala.',
                style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 14),
              ),
              const SizedBox(height: 13),
              Row(
                children: _Element.values
                    .map(
                      (element) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: element == _Element.oxygen ? 0 : 7,
                          ),
                          child: _Slot(
                            element: element,
                            english: english,
                            choice: matched[element],
                            targeted: selected?.element == element,
                            onTap: () => onMatch(element),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 9),
              _Hint(text: hint, color: color, icon: icon),
              const SizedBox(height: 13),
              Row(
                children: <Widget>[
                  Text(
                    english ? 'Choose an object' : 'Pilih objek',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    english ? 'ENGLISH' : 'INDONESIA',
                    style: const TextStyle(
                      fontSize: 8,
                      color: KifcTheme.mutedInk,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _choices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: .72,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 7,
                ),
                itemBuilder: (context, index) {
                  final choice = _choices[index];
                  final used = matched.values.contains(choice);
                  return _ChoiceTile(
                    choice: choice,
                    english: english,
                    selected: choice == selected,
                    used: used,
                    onTap: used ? null : () => onSelect(choice),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Divider(color: KifcTheme.line),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.info_outline,
                    size: 17,
                    color: KifcTheme.forest800,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      english
                          ? 'Wind brings air that contains oxygen.'
                          : 'Angin membawa udara yang mengandung oksigen.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: KifcTheme.forest800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Complete extends StatelessWidget {
  const _Complete({
    required this.english,
    required this.onAgain,
    required this.onWelcome,
  });
  final bool english;
  final VoidCallback onAgain;
  final VoidCallback onWelcome;

  @override
  Widget build(BuildContext context) => _LightPage(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 9, 22, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _PartnerMarks(),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: KifcTheme.forest800,
                  size: 25,
                ),
                const SizedBox(width: 7),
                Text(
                  english ? 'Correct' : 'Benar',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                const _Progress(value: 3),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              english ? 'Fire Triangle Complete' : 'Segitiga Api Lengkap',
              style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w700,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              english
                  ? 'Fire needs heat, fuel, and oxygen. Reducing any one of them helps prevent fire.'
                  : 'Api membutuhkan panas, bahan bakar, dan oksigen. Mengurangi salah satunya membantu mencegah kebakaran.',
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
            const SizedBox(height: 18),
            const _PhotoPanel(
              title: 'Controlled-fire demonstration',
              height: 128,
            ),
            const SizedBox(height: 12),
            Row(
              children: _Element.values
                  .map(
                    (element) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: element == _Element.oxygen ? 0 : 7,
                        ),
                        child: _Slot(
                          element: element,
                          english: english,
                          choice: _choices.firstWhere(
                            (choice) => choice.element == element,
                          ),
                          targeted: false,
                          onTap: () {},
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 13),
            _Hint(
              color: KifcTheme.success,
              icon: Icons.check_circle_outline,
              text: english
                  ? 'Keep peatlands wet\nIn peatlands, prevention starts with maintaining moisture and avoiding ignition sources.'
                  : 'Jaga gambut tetap basah\nDi lahan gambut, pencegahan dimulai dari menjaga kelembapan dan menghindari sumber api.',
            ),
            const Spacer(),
            _PrimaryButton(
              icon: Icons.replay,
              label: english ? 'Play Again' : 'Main Lagi',
              onPressed: onAgain,
            ),
            const SizedBox(height: 8),
            _SecondaryButton(
              icon: Icons.arrow_back,
              label: english ? 'Back to Welcome' : 'Kembali ke Beranda',
              onPressed: onWelcome,
            ),
          ],
        ),
      ),
    ),
  );
}

class _LightPage extends StatelessWidget {
  const _LightPage({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Scaffold(backgroundColor: KifcTheme.paper, body: child);
}

class _ForestImage extends StatelessWidget {
  const _ForestImage();
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/forest/kereng-bangkirai.jpg',
    fit: BoxFit.cover,
  );
}

class _PhotoPanel extends StatelessWidget {
  const _PhotoPanel({required this.title, required this.height});
  final String title;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const _ForestImage(),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0x22091D15), Color(0xD80C2B1F)],
              ),
            ),
          ),
          Positioned(
            left: 13,
            right: 13,
            bottom: 12,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PartnerMarks extends StatelessWidget {
  const _PartnerMarks({this.dark = false});
  final bool dark;
  static const _logos = <String>[
    'assets/images/logos/01-kementerian-kehutanan.png',
    'assets/images/logos/02-korea-forest-service.png',
    'assets/images/logos/03-kifc.png',
    'assets/images/logos/04-manggala-agni.jpeg',
  ];
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 29,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _logos
          .map(
            (asset) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white.withValues(alpha: .92)
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

class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch({required this.locale, required this.onChanged});
  final AppLocale locale;
  final ValueChanged<AppLocale> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: const Color(0xC8103327),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: AppLocale.values
          .map(
            (candidate) => Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => onChanged(candidate),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: locale == candidate
                        ? KifcTheme.paper
                        : Colors.transparent,
                    border: locale == candidate
                        ? Border.all(color: KifcTheme.amber, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    candidate.label,
                    style: TextStyle(
                      color: locale == candidate ? KifcTheme.ink : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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

class _Instruction extends StatelessWidget {
  const _Instruction({
    required this.number,
    required this.icon,
    required this.text,
  });
  final String number;
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    height: 64,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: <Widget>[
        Text(
          number,
          style: const TextStyle(color: KifcTheme.mutedInk, fontSize: 12),
        ),
        const SizedBox(width: 13),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: KifcTheme.paper,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, color: KifcTheme.forest800, size: 20),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ],
    ),
  );
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 34,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: KifcTheme.ink,
        side: const BorderSide(color: KifcTheme.forest800),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class _Progress extends StatelessWidget {
  const _Progress({required this.value});
  final int value;
  @override
  Widget build(BuildContext context) => Container(
    height: 32,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...List<Widget>.generate(
          3,
          (index) => Container(
            width: 10,
            height: 3,
            margin: const EdgeInsets.only(right: 4),
            color: index < value ? KifcTheme.forest800 : KifcTheme.warmPanel,
          ),
        ),
        Text(
          '$value/3',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.element,
    required this.english,
    required this.choice,
    required this.targeted,
    required this.onTap,
  });
  final _Element element;
  final bool english;
  final _Choice? choice;
  final bool targeted;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final matched = choice != null;
    return Material(
      color: matched ? KifcTheme.success : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 128,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: targeted
                  ? KifcTheme.amber
                  : matched
                  ? KifcTheme.forest800
                  : KifcTheme.line,
              width: targeted ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(element.icon, size: 16, color: KifcTheme.forest800),
                  const SizedBox(width: 4),
                  Text(
                    '${element.index + 1}'.padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 9,
                      color: KifcTheme.mutedInk,
                    ),
                  ),
                  if (matched) ...<Widget>[
                    const Spacer(),
                    const Icon(
                      Icons.check_circle_outline,
                      size: 15,
                      color: KifcTheme.forest800,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              Text(
                element.title(english),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              if (matched) ...<Widget>[
                const SizedBox(height: 4),
                Container(
                  height: 22,
                  width: double.infinity,
                  color: KifcTheme.warmPanel,
                ),
                const SizedBox(height: 5),
                Text(
                  choice!.label(english),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else
                Text(
                  element.description(english),
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: KifcTheme.mutedInk,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text, required this.color, required this.icon});
  final String text;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: KifcTheme.forest800),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.choice,
    required this.english,
    required this.selected,
    required this.used,
    required this.onTap,
  });
  final _Choice choice;
  final bool english;
  final bool selected;
  final bool used;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: used ? KifcTheme.success : Colors.white,
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected
                ? KifcTheme.amber
                : used
                ? KifcTheme.forest800
                : KifcTheme.line,
            width: selected ? 2 : 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 33,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: KifcTheme.warmPanel,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Center(
                    child: Text(
                      'PHOTO',
                      style: TextStyle(
                        fontSize: 7,
                        color: KifcTheme.mutedInk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (used)
                  const Positioned(
                    right: 2,
                    top: 2,
                    child: Icon(
                      Icons.check_circle,
                      size: 15,
                      color: KifcTheme.forest800,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              choice.label(english),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.dark = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool dark;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: dark ? const Color(0xC80C2B1F) : KifcTheme.forest800,
        side: const BorderSide(color: KifcTheme.amber, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: KifcTheme.ink,
        side: const BorderSide(color: KifcTheme.forest800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}
