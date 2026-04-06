// lib/features/timer/presentation/widgets/recent_timers_section.dart

import 'package:flutter/material.dart';
import '../../domain/models/models.dart';
import '../../../../core/theme/app_colors.dart';
import 'glass_card.dart';

class RecentTimersSection extends StatelessWidget {
  const RecentTimersSection({
    super.key,
    required this.recents,
    required this.onSelect,
  });

  final List<TimerConfig>         recents;
  final ValueChanged<TimerConfig> onSelect;

  @override
  Widget build(BuildContext context) {
    if (recents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'RÉCENTS',
            style: TextStyle(
              fontSize:     11,
              fontWeight:   FontWeight.w700,
              letterSpacing: 1.8,
              color:        AppColors.textLight,
              fontFamily:   'Nunito',
            ),
          ),
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount:       recents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _Chip(
              config: recents[i],
              onTap:  () => onSelect(recents[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.config, required this.onTap});
  final TimerConfig  config;
  final VoidCallback onTap;

  static String _emoji(String? id) {
    switch (id) {
      case 'duck': return '🦆';
      case 'dog':  return '🐶';
      default:     return '⏱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding:      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: 18,
        shadow:       false,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_emoji(config.animalId), style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              config.formattedDuration,
              style: const TextStyle(
                fontSize:   16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito',
                color:      AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
