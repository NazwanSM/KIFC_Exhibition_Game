import 'dart:async';
import 'package:flutter/material.dart';
import '../localization/app_locale.dart';
import 'game_audio.dart';

Future<void> showAudioCredits(
  BuildContext context,
  GameAudioController audio,
  bool english,
) {
  unawaited(audio.interact(GameSound.tap));
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: LocalizedText(english ? 'Audio credits' : 'Kredit audio'),
      content: SingleChildScrollView(
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Safari — syncopika\nCC BY 3.0\nhttps://opengameart.org/content/safari\nhttps://creativecommons.org/licenses/by/3.0/',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 8),
              LocalizedText(
                english
                    ? 'Full composition adapted for looping and volume balanced.'
                    : 'Komposisi penuh disesuaikan untuk loop dan volumenya diseimbangkan.',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 16),
              const Text(
                'Forest ambience: Réveil des oiseaux — Joseph Sardin (CC0)\nhttps://commons.wikimedia.org/wiki/File:Réveil_des_oiseaux.ogg\n\nInterface Sounds — Kenney (CC0)\nhttps://opengameart.org/content/interface-sounds',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ],
          ),
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
}
