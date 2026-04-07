import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Cercle de progression "dessiné à la main" style coloriage.
/// Le remplissage "crayon" se vide progressivement.
class RadialProgress extends StatelessWidget {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  const RadialProgress({
    super.key,
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: _SketchyRadialPainter(
        progress: progress,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
    );
  }
}

class _SketchyRadialPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final _rng = Random(77);

  _SketchyRadialPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final jitter = 2.5;

    // ── Fond : cercle rempli au crayon (couleur pâle) ──
    final bgPaint = Paint()
      ..color = primaryColor.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    // Cercle légèrement irrégulier
    final bgPath = _wobblyCirclePath(center, radius + 3, jitter * 0.5, 50);
    canvas.drawPath(bgPath, bgPaint);

    // ── Anneau intérieur pâle ──
    final innerPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(_wobblyCirclePath(center, radius * 0.75, jitter * 0.4, 40), innerPaint);

    // ── Remplissage crayon de la progression ──
    if (progress > 0.0) {
      final fillPaint = Paint()
        ..color = primaryColor.withOpacity(0.35)
        ..style = PaintingStyle.fill;

      final sweepAngle = progress * 2 * pi;
      final fillPath = Path();
      fillPath.moveTo(center.dx, center.dy);
      // Arc rempli
      final startAngle = -pi / 2;
      fillPath.arcTo(
        Rect.fromCircle(center: center, radius: radius * 0.92),
        startAngle,
        sweepAngle,
        false,
      );
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }

    // ── Contour extérieur "main levée" ──
    final strokePaint = Paint()
      ..color = AppColors.pencilDark.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_wobblyCirclePath(center, radius, jitter, 60), strokePaint);

    // ── Contour intérieur plus léger ──
    final innerStrokePaint = Paint()
      ..color = AppColors.pencilFaint.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_wobblyCirclePath(center, radius * 0.72, jitter * 0.6, 45), innerStrokePaint);
  }

  Path _wobblyCirclePath(Offset center, double radius, double jitter, int steps) {
    final path = Path();
    final rng = Random(77); // Seed fixe pour stabilité
    for (int i = 0; i <= steps; i++) {
      final angle = 2 * pi * i / steps;
      final r = radius + (rng.nextDouble() - 0.5) * jitter * 2;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_SketchyRadialPainter old) => old.progress != progress;
}
