import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../providers/setup_provider.dart';
import 'animal_picker_sheet.dart';

/// Grand animal centré avec un badge "changer" en bas à droite.
/// Tap = ouvre la bottom sheet de sélection d'animal.
/// Pour le chat : animation multi-layer jouée une seule fois (2s).
class AnimalSelector extends ConsumerWidget {
  const AnimalSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animal = ref.watch(setupProvider).selectedAnimal;
    final isDark = animal.isDarkTheme;

    // En thème sombre (requin), le badge adopte le même style que le bouton
    // paramètres : fond translucide blanc + bordure/icône blanches.
    final badgeBg = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : animal.secondaryColor.withValues(alpha: 0.85);
    final badgeBorderColor = isDark ? AppColors.textOnColor : AppColors.pencilDark;
    final badgeIconColor = isDark ? AppColors.textOnColor : AppColors.pencilDark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _showAnimalPicker(context, ref);
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
                  playOnce: true,
                ),
              ),
            ),
            // Change badge — bottom right, circular with swap icon
            Positioned(
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badgeBg,
                  border: Border.all(
                    color: badgeBorderColor,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.swap_horiz,
                  color: badgeIconColor, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnimalPicker(BuildContext context, WidgetRef ref) {
    final currentId = ref.read(setupProvider).selectedAnimal.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (_) => AnimalPickerSheet(
        selectedAnimalId: currentId,
        onAnimalSelected: (id) {
          ref.read(setupProvider.notifier).selectAnimal(id);
        },
      ),
    );
  }
}
