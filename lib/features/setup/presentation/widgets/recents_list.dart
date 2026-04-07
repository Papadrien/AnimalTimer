import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glassmorphic_card.dart';
import '../../providers/setup_provider.dart';

class RecentsSection extends ConsumerWidget {
  const RecentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(setupProvider).recentPresets;
    if (presets.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECENTS', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        ...presets.map((preset) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => ref.read(setupProvider.notifier).loadPreset(preset),
            child: GlassmorphicCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderRadius: 24, blur: 15,
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.yellowBright, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('\u{1F986}', style: TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(preset.name, style: AppTextStyles.recentName),
                    Text(preset.formattedDuration, style: AppTextStyles.recentDuration),
                  ],
                )),
                Icon(Icons.edit, color: AppColors.orangeSoft, size: 20),
              ]),
            ),
          ),
        )),
      ],
    );
  }
}
