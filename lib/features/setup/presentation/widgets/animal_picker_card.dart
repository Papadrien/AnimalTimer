import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../data/models/animal_model.dart';

class AnimalPickerCard extends StatelessWidget {
  final AnimalModel animal;
  final bool isSelected;
  final bool isLocked;
  final int? daysRemaining;
  final VoidCallback onTap;

  const AnimalPickerCard({
    super.key,
    required this.animal,
    required this.isSelected,
    required this.isLocked,
    this.daysRemaining,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: animal.primaryColor.withValues(alpha: isLocked ? 0.15 : 0.35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accentGreen : AppColors.pencilDark,
            width: isSelected ? 3.5 : 2.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Opacity(
                  opacity: isLocked ? 0.4 : 1.0,
                  child: Image.asset(
                    animal.imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Text(
                localizedAnimalName(context, animal.id),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isLocked
                      ? AppColors.pencilDark.withValues(alpha: 0.4)
                      : AppColors.pencilDark,
                ),
              ),
            ),
            if (isLocked) const _LockedAnimalBadge(),
            if (isSelected && !isLocked) const _SelectedAnimalBadge(),
            if (daysRemaining != null && !isLocked)
              _DaysRemainingBadge(daysRemaining: daysRemaining!),
          ],
        ),
      ),
    );
  }
}

class _LockedAnimalBadge extends StatelessWidget {
  const _LockedAnimalBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              localizedAdBadgeLabel(context),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedAnimalBadge extends StatelessWidget {
  const _SelectedAnimalBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      bottom: 8,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentGreen,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}

class _DaysRemainingBadge extends StatelessWidget {
  final int daysRemaining;

  const _DaysRemainingBadge({
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 6,
      top: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accentOrange,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 12,
            ),
            const SizedBox(width: 2),
            Text(
              '${daysRemaining}j',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
