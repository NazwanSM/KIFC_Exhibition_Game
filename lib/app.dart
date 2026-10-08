import 'package:flutter/material.dart';

import 'core/theme/kifc_theme.dart';
import 'features/game/exhibition_game.dart';

class KifcApp extends StatelessWidget {
  const KifcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Prevention Challenge',
      theme: KifcTheme.light(),
      themeAnimationDuration: Duration.zero,
      home: const ExhibitionGame(),
    );
  }
}
