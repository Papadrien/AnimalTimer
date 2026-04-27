import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/repositories/animal_repository.dart';
import '../../../timer/presentation/screens/timer_screen.dart';
import '../../providers/setup_provider.dart';

/// Section "DERNIERS MINUTEURS" — seul le bouton lecture lance le timer.
class RecentsSection extends ConsumerWidget {
  const RecentsSection({super.key});

  static const List<Color> _cardColors = [
    AppColors.recentBlue,
    AppColors.recentOrange,
    AppColors.recentGreen,
    AppColors.recentPink,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(setupProvider).recentPresets;
    if (presets.isEmpty) return const SizedBox.shrink();

    final animalRepo = AnimalRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.recentTimers, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        ...presets.take(3).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final preset = entry.value;
          final animal = animalRepo.getById(preset.animalId);
          final cardColor = _cardColors[i % _cardColors.length];

          void launchPreset() {
            HapticFeedback.mediumImpact();
            ref.read(setupProvider.notifier).loadPreset(preset);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const TimerScreen(),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: child,
                  ),
                ),
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.pencilDark,
                  width: 2.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.6),
                      border: Border.all(
                        color: AppColors.pencilDark,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        animal.imageAsset,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(preset.name, style: AppTextStyles.recentName),
                        const SizedBox(height: 2),
                        Text(
                          preset.formattedDuration,
                          style: AppTextStyles.recentDuration,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: launchPreset,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGreen.withValues(alpha: 0.15),
                        border: Border.all(
                          color: AppColors.pencilDark,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppColors.accentGreen,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
