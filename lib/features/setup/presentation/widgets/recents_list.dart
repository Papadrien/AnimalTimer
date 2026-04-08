import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/repositories/animal_repository.dart';
import '../../../timer/presentation/screens/timer_screen.dart';
import '../../providers/setup_provider.dart';

/// Section "DERNIERS MINUTEURS" — tap = lance le timer directement.
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
        Text('DERNIERS MINUTEURS', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        ...presets.take(3).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final preset = entry.value;
          final animal = animalRepo.getById(preset.animalId);
          final cardColor = _cardColors[i % _cardColors.length];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                // Load preset into setup state
                ref.read(setupProvider.notifier).loadPreset(preset);
                // Navigate directly to timer screen
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const TimerScreen(),
                  transitionsBuilder: (_, anim, __, child) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                      child: child)),
                  transitionDuration: const Duration(milliseconds: 400),
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.pencilDark.withOpacity(0.12),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          animal.svgAsset, width: 32, height: 32,
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
                    // Play icon to indicate it launches timer
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGreen.withOpacity(0.15),
                      ),
                      child: const Icon(Icons.play_arrow,
                        color: AppColors.accentGreen, size: 20),
                    ),
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
