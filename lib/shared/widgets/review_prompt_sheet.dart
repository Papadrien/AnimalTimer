import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/localization_helper.dart';
import 'image_button.dart';

/// Bottom sheet demandant un avis Play Store, affichée une seule fois,
/// au retour sur l'écran d'accueil après le 3e minuteur terminé.
class ReviewPromptSheet extends StatelessWidget {
  const ReviewPromptSheet({super.key});

  static const _storeUrl =
      'https://play.google.com/store/apps/details?id=fr.junade.animaltimer';

  static Future<void> show(BuildContext context) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReviewPromptSheet(),
    );
  }

  Future<void> _rate(BuildContext context) async {
    final uri = Uri.parse(_storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.sheetBg,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pencilFaint.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.star_rounded,
                color: Color(0xFFFFB800), size: 56),
            const SizedBox(height: 12),
            Text(
              context.l10n.reviewPromptTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.pencilDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.reviewPromptMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.pencilLight,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            ImageButton(
              text: context.l10n.reviewPromptRate,
              backgroundAsset: ImageButton.orangeBg,
              showLabel: true,
              height: 64,
              bounce: true,
              onPressed: () => _rate(context),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.l10n.reviewPromptLater,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pencilFaint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
