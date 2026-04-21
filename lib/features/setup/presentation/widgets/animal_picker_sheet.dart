import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/animal_model.dart';
import '../../../../data/repositories/animal_repository.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/services/gamification_service.dart';

/// Bottom sheet affichant les animaux disponibles dans une grille.
/// Les animaux verrouillés affichent une icône ▶ et nécessitent
/// le visionnage d'une pub Rewarded pour être débloqués.
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
    // Pré-charger une pub uniquement s'il y a des animaux verrouillés
    final gamif = ref.read(gamificationServiceProvider);
    if (gamif.hasLockedAnimals()) {
      ref.read(adServiceProvider).loadAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    const animals = AnimalRepository.animals;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final gamif = ref.watch(gamificationServiceProvider);

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
            padding: EdgeInsets.only(
              left: 24, right: 24, bottom: bottomPad + 20),
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
                return _AnimalCard(
                  animal: animal,
                  isSelected: isSelected,
                  isLocked: isLocked,
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
        ],
      ),
    );
  }

  /// Affiche un dialogue proposant de regarder une pub pour débloquer l'animal.
  void _showUnlockDialog(BuildContext context, AnimalModel animal) {
    final animalName = localizedAnimalName(context, animal.id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.pencilDark),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                animalName,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  color: AppColors.pencilDark,
                ),
              ),
            ),
          ],
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
            onPressed: () => Navigator.of(ctx).pop(),
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
      // Pub pas encore chargée — afficher un spinner et attendre
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adLoading),
          duration: const Duration(seconds: 2),
        ),
      );
      // Relancer le chargement
      await adService.loadAd();
      // Attendre un peu puis réessayer
      await Future.delayed(const Duration(seconds: 3));
      if (!adService.isAdReady || !mounted) return;
    }

    await adService.showRewardedAd(
      onReward: () async {
        await gamif.unlockAnimal(animal.id);
        if (mounted) {
          setState(() {}); // Rafraîchir la grille
          // Sélectionner l'animal débloqué
          widget.onAnimalSelected(animal.id);
          if (mounted) {
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
  final VoidCallback onTap;

  const _AnimalCard({
    required this.animal,
    required this.isSelected,
    required this.isLocked,
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
            // Animal image centered (grisé si verrouillé)
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
              Positioned(
                right: 8, top: 8,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pencilDark.withValues(alpha: 0.7),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 18,
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
          ],
        ),
      ),
    );
  }
}
