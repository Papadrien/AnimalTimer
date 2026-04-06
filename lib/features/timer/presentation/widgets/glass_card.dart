// lib/features/timer/presentation/widgets/glass_card.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Carte glassmorphism réutilisable dans toute l'app.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding      = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.blur         = 12,
    this.opacity      = 0.75,
    this.border       = true,
    this.shadow       = true,
  });

  final Widget             child;
  final EdgeInsetsGeometry padding;
  final double             borderRadius;
  final double             blur;
  final double             opacity;
  final bool               border;
  final bool               shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color:       AppColors.shadow,
                  blurRadius:  20,
                  offset:      const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color:      AppColors.shadowMedium,
                  blurRadius: 4,
                  offset:     const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color:        AppColors.glassWhite.withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border
                  ? Border.all(color: AppColors.glassBorder, width: 1.5)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
