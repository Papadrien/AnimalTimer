import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/animal_model.dart';
import 'animal_picker_grid.dart';
import 'animal_picker_unlock_controls.dart';

class AnimalPickerContent extends StatelessWidget {
  final double bottomPadding;
  final String selectedAnimalId;
  final bool showUnlockAllButton;
  final bool showDebugUnlockButton;
  final VoidCallback onUnlockAllPressed;
  final VoidCallback onRandomAnimalPressed;
  final ValueChanged<AnimalModel> onLockedAnimalPressed;
  final ValueChanged<AnimalModel> onUnlockedAnimalPressed;
  final VoidCallback onDebugUnlockAllPressed;

  const AnimalPickerContent({
    super.key,
    required this.bottomPadding,
    required this.selectedAnimalId,
    required this.showUnlockAllButton,
    required this.showDebugUnlockButton,
    required this.onUnlockAllPressed,
    required this.onRandomAnimalPressed,
    required this.onLockedAnimalPressed,
    required this.onUnlockedAnimalPressed,
    required this.onDebugUnlockAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: bottomPadding + 20,
      ),
      child: Column(
        children: [
          if (showUnlockAllButton) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: UnlockAllAnimalsButton(onPressed: onUnlockAllPressed),
            ),
          ],
          AnimalPickerGrid(
            selectedAnimalId: selectedAnimalId,
            onRandomTap: onRandomAnimalPressed,
            onLockedAnimalTap: onLockedAnimalPressed,
            onUnlockedAnimalTap: onUnlockedAnimalPressed,
          ),
          if (kDebugMode && showDebugUnlockButton) ...[
            const SizedBox(height: 8),
            DebugUnlockAllAnimalsButton(onPressed: onDebugUnlockAllPressed),
          ],
        ],
      ),
    );
  }
}
