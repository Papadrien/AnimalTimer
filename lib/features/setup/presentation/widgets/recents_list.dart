import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/sketchy_card.dart';
import '../../../../shared/widgets/sketchy_painter.dart';
import '../../../../data/repositories/animal_repository.dart';
import '../../providers/setup_provider.dart';

class RecentsSection extends ConsumerWidget {
  const RecentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(setupProvider).recentPresets;
    if (presets.isEmpty) return const SizedBox.shrink();

    final animalRepo = AnimalRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECENTS', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        ...presets.asMap().entries.map((entry) {
          final i = entry.key;
          final preset = entry.value;
          final animal = animalRepo.getById(preset.animalId);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => ref.read(setupProvider.notifier).loadPreset(preset),
              child: SketchyCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                radius: 24,
                seed: 200 + i,
                child: Row(
                  children: [
                    // Animal thumbnail dans cercle crayon
                    SizedBox(
                      width: 56, height: 56,
                      child: CustomPaint(
                        painter: SketchyCirclePainter(
                          fillColor: animal.primaryColor.withOpacity(0.3),
                          strokeWidth: 2.0,
                          seed: 300 + i,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            animal.svgAsset, width: 38, height: 38,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(preset.name, style: AppTextStyles.recentName),
                          Text(preset.formattedDuration, style: AppTextStyles.recentDuration),
                        ],
                      ),
                    ),
                    Icon(Icons.edit, color: AppColors.pencilLight, size: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
