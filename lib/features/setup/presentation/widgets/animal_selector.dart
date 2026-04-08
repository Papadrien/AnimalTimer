import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../providers/setup_provider.dart';

/// Grand animal centré avec un badge "swap" (horloge + flèche) en bas à droite,
/// conforme à la maquette.
class AnimalSelector extends ConsumerWidget {
  const AnimalSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animal = ref.watch(setupProvider).selectedAnimal;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(setupProvider.notifier).nextAnimal();
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main animal display
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: AnimalDisplay(
                  key: ValueKey(animal.id),
                  animal: animal,
                  size: 180,
                  animate: true,
                ),
              ),
            ),
            // Swap badge — bottom right, circular with clock icon
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: animal.secondaryColor.withOpacity(0.85),
                  border: Border.all(
                    color: AppColors.pencilDark.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.history, color: AppColors.pencilDark, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
