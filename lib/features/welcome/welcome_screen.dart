import 'package:flutter/material.dart';

import '../../core/theme/kifc_theme.dart';

/// Development shell only. It verifies portrait layout and bundled partner
/// marks while the Figma-approved screen design is being prepared.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _logos = <String>[
    'assets/images/logos/01-kementerian-kehutanan.png',
    'assets/images/logos/02-korea-forest-service.png',
    'assets/images/logos/03-kifc.png',
    'assets/images/logos/04-manggala-agni.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 58,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _logos
                      .map(
                        (asset) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset(asset, fit: BoxFit.contain),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.forest_outlined,
                color: KifcTheme.amber,
                size: 56,
              ),
              const SizedBox(height: 20),
              Text(
                'Fire Prevention Challenge',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 14),
              const Text(
                'Fondasi aplikasi Android offline siap. UI permainan akan dibangun dari desain Figma yang disetujui.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const Text(
                'Target: Android touchscreen • Portrait • Offline',
                textAlign: TextAlign.center,
                style: TextStyle(color: KifcTheme.amber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
