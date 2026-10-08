import 'package:flutter/material.dart';

import 'core/theme/kifc_theme.dart';
import 'features/welcome/welcome_screen.dart';

class KifcApp extends StatelessWidget {
  const KifcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Prevention Challenge',
      theme: KifcTheme.light(),
      home: const WelcomeScreen(),
    );
  }
}
