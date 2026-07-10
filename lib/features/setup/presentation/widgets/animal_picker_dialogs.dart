import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../data/models/animal_model.dart';

void showPurchaseConfirmationDialog({
  required BuildContext context,
  required String price,
  required VoidCallback onBuyPressed,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        context.l10n.purchaseDialogTitle,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          color: AppColors.pencilDark,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.purchaseDialogBody,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.pencilDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.purchaseDialogOneTime,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.pencilFaint.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(ctx).pop();
          },
          child: Text(
            context.l10n.cancel,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              color: AppColors.pencilLight,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(ctx).pop();
            onBuyPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            context.l10n.purchaseDialogBuy(price),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

void showRewardedUnlockDialog({
  required BuildContext context,
  required AnimalModel animal,
  required VoidCallback onWatchAdPressed,
}) {
  final animalName = localizedAnimalName(context, animal.id);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        context.l10n.rewardedAdTitle,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          color: AppColors.pencilDark,
        ),
      ),
      content: Text(
        context.l10n.watchAdToUnlock(animalName),
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.pencilDark,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(ctx).pop();
          },
          child: Text(
            context.l10n.cancel,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              color: AppColors.pencilLight,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(ctx).pop();
            onWatchAdPressed();
          },
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: Text(
            context.l10n.watchAd,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  );
}
