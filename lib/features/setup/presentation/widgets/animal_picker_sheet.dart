import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/animal_model.dart';
import '../../../../data/repositories/animal_repository.dart';

/// Bottom sheet affichant les animaux disponibles dans une grille.
class AnimalPickerSheet extends ConsumerWidget {
  final String selectedAnimalId;
  final ValueChanged<String> onAnimalSelected;

  const AnimalPickerSheet({
    super.key,
    required this.selectedAnimalId,
    required this.onAnimalSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animals = AnimalRepository.animals;
    final bottomPad = MediaQuery.of(context).padding.bottom;

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
                final isSelected = animal.id == selectedAnimalId;
                return _AnimalCard(
                  animal: animal,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onAnimalSelected(animal.id);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte individuelle d'un animal dans la grille.
class _AnimalCard extends StatelessWidget {
  final AnimalModel animal;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimalCard({
    required this.animal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: animal.primaryColor.withValues(alpha: 0.35),
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
                child: Image.asset(
                  animal.imageAsset,
                  fit: BoxFit.contain,
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
                  color: AppColors.pencilDark,
                ),
              ),
            ),
            // Check badge if selected
            if (isSelected)
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
