import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Fond "feuille de papier" avec gradient doux + texture de petits points
/// (comme du grain de papier).
class GradientBackground extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;

  const GradientBackground({super.key, required this.gradient, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: CustomPaint(
        painter: _PaperTexturePainter(),
        child: SafeArea(
          bottom: false,
          child: child,
        ),
      ),
    );
  }
}

/// Ajoute un léger grain de papier (petits points aléatoires)
class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(123);
    final paint = Paint()
      ..color = AppColors.pencilFaint.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // ~200 petits points de grain
    for (int i = 0; i < 200; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.5 + rng.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_PaperTexturePainter old) => false;
}
