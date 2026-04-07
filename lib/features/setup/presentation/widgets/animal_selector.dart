import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../../../shared/widgets/sketchy_painter.dart';
import '../../providers/setup_provider.dart';

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
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: SizedBox(
              key: ValueKey(animal.id),
              width: 170,
              height: 170,
              child: CustomPaint(
                painter: SketchyCirclePainter(
                  strokeColor: AppColors.pencilDark,
                  fillColor: animal.primaryColor.withOpacity(0.35),
                  strokeWidth: 2.5,
                  seed: animal.id.hashCode,
                ),
                child: Center(
                  child: AnimalDisplay(
                    animal: animal,
                    size: 120,
                    animate: true,
                  ),
                ),
              ),
            ),
          ),
          // Swap button — petit cercle crayon
          CustomPaint(
            painter: SketchyCirclePainter(
              strokeColor: AppColors.pencilDark,
              fillColor: animal.secondaryColor.withOpacity(0.5),
              strokeWidth: 2.0,
              seed: 999,
            ),
            child: const SizedBox(
              width: 42, height: 42,
              child: Icon(Icons.sync, color: AppColors.pencilDark, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
