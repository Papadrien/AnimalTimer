import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/gamification_service.dart';
import '../../../../data/models/animal_model.dart';
import '../../../../data/repositories/animal_repository.dart';
import 'animal_picker_card.dart';
import 'random_animal_picker_card.dart';

class AnimalPickerGrid extends ConsumerWidget {
  final String selectedAnimalId;
  final VoidCallback onRandomTap;
  final ValueChanged<AnimalModel> onLockedAnimalTap;
  final ValueChanged<AnimalModel> onUnlockedAnimalTap;

  const AnimalPickerGrid({
    super.key,
    required this.selectedAnimalId,
    required this.onRandomTap,
    required this.onLockedAnimalTap,
    required this.onUnlockedAnimalTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const animals = AnimalRepository.animals;
    final gamif = ref.watch(gamificationServiceProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      // +1 pour la card "Animal aléatoire" en première position
      itemCount: animals.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return RandomAnimalPickerCard(
            onTap: () {
              HapticFeedback.selectionClick();
              onRandomTap();
            },
          );
        }

        final animal = animals[index - 1];
        final isLocked = !gamif.isUnlocked(animal.id);

        return AnimalPickerCard(
          animal: animal,
          isSelected: animal.id == selectedAnimalId,
          isLocked: isLocked,
          daysRemaining: gamif.getDaysRemaining(animal.id),
          onTap: () {
            HapticFeedback.selectionClick();
            if (isLocked) {
              onLockedAnimalTap(animal);
            } else {
              onUnlockedAnimalTap(animal);
            }
          },
        );
      },
    );
  }
}
