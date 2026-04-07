import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'sketchy_painter.dart';

/// Carte avec apparence "dessinée à la main" sur papier.
class SketchyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? fillColor;
  final double radius;
  final int seed;

  const SketchyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.fillColor,
    this.radius = 24,
    this.seed = 42,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SketchyRectPainter(
        strokeColor: AppColors.pencilDark,
        fillColor: fillColor ?? AppColors.paperLight.withOpacity(0.7),
        strokeWidth: 2.5,
        radius: radius,
        seed: seed,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
