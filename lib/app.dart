import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/theme/kifc_theme.dart';
import 'core/widgets/web_portrait_shell.dart';
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
      builder: (context, child) {
        if (!kIsWeb || child == null) return child ?? const SizedBox.shrink();
        return WebPortraitShell(child: child);
      },
    );
  }
}
