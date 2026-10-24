import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/kifc_theme.dart';
import 'game_photo.dart';

/// Only the visible face participates in reading/accessibility. Opening a card
/// is exploration, so it has no answer colors, correctness marks or points.
class PeatCharacteristicCard extends StatelessWidget {
  const PeatCharacteristicCard({
    super.key,
    required this.number,
    required this.information,
    required this.revealed,
    required this.onTap,
  });
  final int number;
  final String information;
  final bool revealed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final english = AppCopy.locale == AppLocale.english;
    return Semantics(
      button: true,
      label:
          '${AppCopy.translate(english ? 'Card' : 'Kartu')} $number. ${revealed ? AppCopy.translate(information) : AppCopy.translate(english ? 'Touch to open' : 'Sentuh untuk membuka')}',
      onTap: onTap,
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: revealed ? math.pi : 0),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 420),
          curve: Curves.easeInOutCubic,
          builder: (context, angle, _) {
            final back = angle >= math.pi / 2;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, .0012)
                ..rotateY(angle),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(back ? math.pi : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(KifcTheme.controlRadius),
                  child: Material(
                    color: back ? KifcTheme.paper : KifcTheme.forest800,
                    child: InkWell(
                      onTap: onTap,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: back ? KifcTheme.line : KifcTheme.forest800,
                          ),
                          borderRadius: BorderRadius.circular(
                            KifcTheme.controlRadius,
                          ),
                        ),
                        child: back
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '$number',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: KifcTheme.mossGreen,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: LocalizedText(
                                        information,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.25,
                                          color: KifcTheme.ink,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  GamePhoto(
                                    'assets/images/forest/kereng-bangkirai.jpg',
                                    alignment: Alignment(
                                      (number - 2) * .65,
                                      .4,
                                    ),
                                    forestTone: true,
                                  ),
                                  const ColoredBox(color: Color(0xA30C2B1F)),
                                  Center(
                                    child: Text(
                                      '$number',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
