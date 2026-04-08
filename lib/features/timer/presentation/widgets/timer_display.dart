import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Affichage du temps restant en vert (02m 05s) conforme maquette.
class TimerDisplay extends StatelessWidget {
  final Duration remaining;
  const TimerDisplay({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (hours > 0) ...[
          Text(hours.toString().padLeft(2, '0'),
              style: AppTextStyles.timerCountdown),
          Text('h ', style: AppTextStyles.timerUnit),
        ],
        Text(minutes, style: AppTextStyles.timerCountdown),
        Text('m ', style: AppTextStyles.timerUnit),
        Text(seconds, style: AppTextStyles.timerCountdown),
        Text('s', style: AppTextStyles.timerUnit),
      ],
    );
  }
}
