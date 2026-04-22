import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/animal_model.dart';
import '../../../../data/repositories/animal_repository.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/services/gamification_service.dart';
import '../../../../core/services/purchase_service.dart';
import '../../../../shared/widgets/image_button.dart';

/// Bottom sheet affichant les animaux disponibles dans une grille.
/// Les animaux verrouillés affichent une icône ▶ et nécessitent
/// le visionnage d'une pub Rewarded pour être débloqués.
/// Un bouton "Tout débloquer" permet l'achat in-app (0.99€).
class AnimalPickerSheet extends ConsumerStatefulWidget {
  final String selectedAnimalId;
  final ValueChanged<String> onAnimalSelected;

  const AnimalPickerSheet({
    super.key,
    required this.selectedAnimalId,
    required this.onAnimalSelected,
  });

  @override
  ConsumerState<AnimalPickerSheet> createState() => _AnimalPickerSheetState();
}

class _AnimalPickerSheetState extends ConsumerState<AnimalPickerSheet> {
  @override
  void initState() {
    super.initState();
    final gamif = ref.read(gamificationServiceProvider);
    if (gamif.hasLockedAnimals()) {
      // Pré-charger une pub
      ref.read(adServiceProvider).loadAd();
      // Initialiser le service d'achat
      ref.read(purchaseServiceProvider).initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    const animals = AnimalRepository.animals;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final gamif = ref.watch(gamificationServiceProvider);
    final hasLocked = gamif.hasLockedAnimals();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.pencilFaint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            context.l10n.chooseAnimal,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.pencilDark,
            ),
          ),
          const SizedBox(height: 20),
          // Grid of animals
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                final isSelected = animal.id == widget.selectedAnimalId;
                final isLocked = !gamif.isUnlocked(animal.id);
                final daysRemaining = gamif.getDaysRemaining(animal.id);
                return _AnimalCard(
                  animal: animal,
                  isSelected: isSelected,
                  isLocked: isLocked,
                  daysRemaining: daysRemaining,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    if (isLocked) {
                      _showUnlockDialog(context, animal);
                    } else {
                      widget.onAnimalSelected(animal.id);
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ),
          // Bouton "Tout débloquer" — visible seulement s'il reste des verrouillés
          if (hasLocked) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ImageButton(
                text: context.l10n.unlockAllButton,
                showLabel: true,
                backgroundAsset: ImageButton.blueBg,
                onPressed: _showPurchaseConfirmation,
                height: 64,
              ),
            ),
          ],
          // ⚠️ DEBUG ONLY — Simuler l'achat sans passer par le store
          if (kDebugMode && hasLocked) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(gamificationServiceProvider).unlockAllAnimals();
                    if (mounted) {
                      setState(() {});
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('DEBUG: Tous les animaux débloqués !'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '🐛 [DEBUG] Simuler achat',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: bottomPad + 20),
        ],
      ),
    );
  }

  /// Lance l'achat in-app "Tout débloquer".
  /// Affiche un dialogue d'information avant l'achat.
  void _showPurchaseConfirmation() {
    HapticFeedback.mediumImpact();
    final price = ref.read(purchaseServiceProvider).localizedPrice;
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
              _handlePurchase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
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

  Future<void> _handlePurchase() async {
    HapticFeedback.mediumImpact();
    final purchaseService = ref.read(purchaseServiceProvider);

    if (!purchaseService.isProductAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.storeNotAvailable),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Enregistrer le callback pour quand l'achat est validé
    purchaseService.onPurchaseCompleted = () {
      if (mounted) {
        setState(() {}); // Rafraîchir la grille
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.unlockAllSuccess),
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    };

    final launched = await purchaseService.purchaseUnlockAll();
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.purchaseError),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Affiche un dialogue proposant de regarder une pub pour débloquer l'animal.
  void _showUnlockDialog(BuildContext context, AnimalModel animal) {
    final animalName = localizedAnimalName(context, animal.id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.unlockAnimalTitle(animalName),
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
              _watchAdAndUnlock(animal);
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
                borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  /// Lance la pub Rewarded puis débloque l'animal.
  Future<void> _watchAdAndUnlock(AnimalModel animal) async {
    final adService = ref.read(adServiceProvider);
    final gamif = ref.read(gamificationServiceProvider);

    if (!adService.isAdReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adLoading),
          duration: const Duration(seconds: 2),
        ),
      );
      await adService.loadAd();
      await Future.delayed(const Duration(seconds: 3));
      if (!adService.isAdReady || !mounted) return;
    }

    await adService.showRewardedAd(
      onReward: () async {
        await gamif.unlockAnimal(animal.id);
        if (mounted) {
          widget.onAnimalSelected(animal.id);
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.animalUnlocked(
                  localizedAnimalName(context, animal.id))),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.accentGreen,
              ),
            );
          }
        }
      },
    );
  }
}

/// Carte individuelle d'un animal dans la grille.
class _AnimalCard extends StatelessWidget {
  final AnimalModel animal;
  final bool isSelected;
  final bool isLocked;
  final int? daysRemaining;
  final VoidCallback onTap;

  const _AnimalCard({
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
            color: isSelected
                ? AppColors.accentGreen
                : AppColors.pencilDark,
            width: isSelected ? 3.5 : 2.5,
          ),
        ),
        child: Stack(
          children: [
            // Animal image centered
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
            // Animal name at bottom center
            Positioned(
              left: 0, right: 0, bottom: 10,
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
            // Lock / Play badge if locked
            if (isLocked)
              Center(
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pencilDark.withValues(alpha: 0.7),
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            // Check badge if selected
            if (isSelected && !isLocked)
              Positioned(
                right: 8, bottom: 8,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentGreen,
                    border: Border.all(
                      color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            // Days remaining badge (ad-unlocked animals)
            if (daysRemaining != null && !isLocked)
              Positioned(
                right: 6, top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined,
                        color: Colors.white, size: 12),
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
              ),
          ],
        ),
      ),
    );
  }
}
