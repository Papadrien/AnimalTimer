import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/gamification_service.dart';
import '../../../../data/models/animal_model.dart';
import '../../../../data/repositories/animal_repository.dart';
import 'animal_picker_card.dart';

class AnimalPickerGrid extends ConsumerWidget {
  final String selectedAnimalId;
  final ValueChanged<AnimalModel> onLockedAnimalTap;
  final ValueChanged<AnimalModel> onUnlockedAnimalTap;

  const AnimalPickerGrid({
    super.key,
    required this.selectedAnimalId,
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
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
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
