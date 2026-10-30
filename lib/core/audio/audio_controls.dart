import 'dart:async';
import 'package:flutter/material.dart';
import '../localization/app_locale.dart';
import '../theme/kifc_theme.dart';
import 'game_audio.dart';
import 'audio_credits.dart';
import '../../features/game/widgets/touchscreen_area.dart';

class GameAudioScope extends InheritedNotifier<GameAudioController> {
  const GameAudioScope({
    super.key,
    required GameAudioController controller,
    required super.child,
  }) : super(notifier: controller);
  static GameAudioController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GameAudioScope>()!.notifier!;
}

class AudioControls extends StatelessWidget {
  const AudioControls({super.key, this.dark = false});
  final bool dark;
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<AppLocale>(
    valueListenable: AppCopy.localeListenable,
    builder: (context, locale, _) {
      final audio = GameAudioScope.of(context);
      final en = locale == AppLocale.english;
      final off = audio.muted || audio.level(AudioLayer.master) == 0;
      return SizedBox(
        width: 44,
        height: 44,
        child: IconButton(
          key: const ValueKey('audio-settings'),
          tooltip: AppCopy.translate(
            en ? 'Sound settings' : 'Pengaturan suara',
          ),
          style: IconButton.styleFrom(
            backgroundColor: dark ? const Color(0xB31B3D2F) : KifcTheme.paper,
            foregroundColor: dark ? Colors.white : KifcTheme.forest800,
            side: BorderSide(color: dark ? Colors.white54 : KifcTheme.line),
          ),
          icon: Icon(
            audio.unavailable
                ? Icons.volume_off_outlined
                : off
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            size: 22,
          ),
          onPressed: () {
            unawaited(audio.interact(GameSound.tap));
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (_) => TouchscreenArea(
                child: _AudioSettings(audio: audio, english: en),
              ),
            );
          },
        ),
      );
    },
  );
}

class _AudioSettings extends StatelessWidget {
  const _AudioSettings({required this.audio, required this.english});
  final GameAudioController audio;
  final bool english;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: audio,
    builder: (context, _) => Dialog(
      backgroundColor: KifcTheme.paper,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: LocalizedText(
                      english ? 'Sound' : 'Suara',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('audio-close'),
                    tooltip: AppCopy.translate(english ? 'Close' : 'Tutup'),
                    onPressed: () {
                      unawaited(audio.interact(GameSound.tap));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LocalizedText(
                english
                    ? 'Set a comfortable listening level.'
                    : 'Atur suara agar nyaman didengar.',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: KifcTheme.mutedInk,
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                key: const ValueKey('audio-mute'),
                contentPadding: EdgeInsets.zero,
                title: LocalizedText(
                  english ? 'Sound on' : 'Suara aktif',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: !audio.muted,
                onChanged: (value) {
                  unawaited(
                    audio.setMuted(!value).then((_) async {
                      if (value) await audio.interact(GameSound.tap);
                    }),
                  );
                },
              ),
              for (final layer in AudioLayer.values) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LocalizedText(
                        switch (layer) {
                          AudioLayer.master =>
                            english ? 'Overall volume' : 'Volume utama',
                          AudioLayer.music => english ? 'Music' : 'Musik',
                          AudioLayer.nature =>
                            english ? 'Forest sounds' : 'Suasana hutan',
                          AudioLayer.effects =>
                            english ? 'Interaction effects' : 'Efek interaksi',
                        },
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${(audio.level(layer) * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: KifcTheme.mutedInk,
                      ),
                    ),
                  ],
                ),
                Slider(
                  key: ValueKey('audio-${layer.name}'),
                  value: audio.level(layer),
                  divisions: 20,
                  label: '${(audio.level(layer) * 100).round()}%',
                  onChanged: (value) => unawaited(audio.setLevel(layer, value)),
                  onChangeEnd: (_) =>
                      unawaited(audio.interact(GameSound.select)),
                ),
              ],
              if (audio.unavailable) ...[
                const SizedBox(height: 8),
                LocalizedText(
                  english
                      ? 'Sound could not start. Tap to try again.'
                      : 'Suara belum bisa diputar. Sentuh untuk mencoba lagi.',
                  style: const TextStyle(fontSize: 13, height: 1.35),
                ),
                TextButton(
                  key: const ValueKey('audio-retry'),
                  onPressed: () => unawaited(
                    audio.retry().then((_) => audio.play(GameSound.tap)),
                  ),
                  child: LocalizedText(
                    english ? 'Try sound again' : 'Coba suara lagi',
                  ),
                ),
              ],
              TextButton.icon(
                key: const ValueKey('audio-credits'),
                onPressed: () => showAudioCredits(context, audio, english),
                icon: const Icon(Icons.library_music_outlined),
                label: LocalizedText(
                  english ? 'Audio credits' : 'Kredit audio',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
