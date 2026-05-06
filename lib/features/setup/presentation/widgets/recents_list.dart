import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/repositories/animal_repository.dart';
import '../../../timer/presentation/screens/timer_screen.dart';
import '../../providers/setup_provider.dart';

/// Cards "Derniers minuteurs".
///
/// [isDark] : quand `true` (ex. requin), le titre passe en blanc,
/// comme le titre "Animal Timer" dans SetupScreen.
class RecentsSection extends ConsumerWidget {
  final bool isDark;
  const RecentsSection({super.key, this.isDark = false});

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
    final titleColor = isDark ? AppColors.textOnColor : AppTextStyles.sectionTitle.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.recentTimers,
          style: AppTextStyles.sectionTitle.copyWith(color: titleColor),
        ),
        const SizedBox(height: 12),
        ...presets.take(3).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final preset = entry.value;
          final animal = animalRepo.getById(preset.animalId);

          // Fond pastel : toujours la même couleur, quel que soit le thème
          final cardColor = _cardColors[i % _cardColors.length].withValues(alpha: 0.7);
          // Bordure extérieure : toujours pencilDark (thème clair)
          const effectiveOuterBorder = AppColors.pencilDark;

          void launchPreset() {
            HapticFeedback.mediumImpact();
            ref.read(setupProvider.notifier).loadPreset(preset);
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => const TimerScreen(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
                  child: child,
                ),
              ),
              transitionDuration: const Duration(milliseconds: 400),
            ));
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: effectiveOuterBorder, width: 2.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.6),
                      border: Border.all(color: AppColors.pencilDark, width: 2),
                    ),
                    child: Center(
                      child: Image.asset(
                        animal.imageAsset,
                        width: 32, height: 32,
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
                        Text(preset.formattedDuration, style: AppTextStyles.recentDuration),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: launchPreset,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGreen.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.pencilDark, width: 2),
                      ),
                      child: const Icon(Icons.play_arrow, color: AppColors.accentGreen, size: 20),
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
