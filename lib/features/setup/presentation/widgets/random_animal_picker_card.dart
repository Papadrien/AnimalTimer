import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';

/// Card spéciale "Animal aléatoire" affichée en première position dans la
/// grille de sélection des animaux. Même gabarit visuel que
/// [AnimalPickerCard] (mêmes bordures, mêmes proportions) mais avec un style
/// dédié (icône dé + dégradé multicolore) pour bien la distinguer des cards
/// d'animaux.
///
/// Au tap : choisit immédiatement un animal débloqué au hasard et ferme la
/// bottom sheet (logique gérée par l'appelant via [onTap]).
class RandomAnimalPickerCard extends StatelessWidget {
  final VoidCallback onTap;

  const RandomAnimalPickerCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.crayonPurple.withValues(alpha: 0.35),
              AppColors.crayonPink.withValues(alpha: 0.35),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.pencilDark,
            width: 2.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.6),
                    border: Border.all(
                      color: AppColors.pencilDark,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.casino_rounded,
                    color: AppColors.pencilDark,
                    size: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Text(
                context.l10n.randomAnimalMode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pencilDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
