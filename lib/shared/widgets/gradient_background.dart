import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Fond avec gradient + texture de grain papier optionnelle.
/// showTexture=false pour le timer screen (fond sombre).
class GradientBackground extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;
  final bool showTexture;

  const GradientBackground({
    super.key,
    required this.gradient,
    required this.child,
    this.showTexture = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: showTexture
          ? CustomPaint(
              painter: _PaperTexturePainter(),
              child: SafeArea(bottom: false, child: child),
            )
          : SafeArea(bottom: false, child: child),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(123);
    final paint = Paint()
      ..color = AppColors.pencilFaint.withOpacity(0.05)
      ..style = PaintingStyle.fill;
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
