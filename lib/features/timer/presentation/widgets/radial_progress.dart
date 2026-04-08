import 'dart:math';
import 'package:flutter/material.dart';

/// Barre de progression circulaire — arc épais vert sur fond sombre
/// avec deux anneaux (temps restant = arc vert, temps écoulé = arc gris).
/// Conforme à la maquette.
class RadialProgress extends StatelessWidget {
  final double progress; // 1.0 = full, 0.0 = empty
  final Color primaryColor;
  final Color secondaryColor;
  final double size;

  const RadialProgress({
    super.key,
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CircularProgressPainter(
        progress: progress,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _CircularProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    final strokeW = 18.0;

    // ── Background track (grey) ──
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // ── Inner subtle circle ──
    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - strokeW / 2 - 8, innerPaint);
    canvas.drawCircle(center, radius + strokeW / 2 + 8, innerPaint);

    // ── Tick marks around the circle (like a clock) ──
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      final angle = 2 * pi * i / 60 - pi / 2;
      final isLarge = i % 5 == 0;
      final outerR = radius + strokeW / 2 + 6;
      final innerR = radius + strokeW / 2 + (isLarge ? -2 : 2);
      final outer = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      final inner = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint
        ..strokeWidth = isLarge ? 2.0 : 1.0);
    }

    // ── Progress arc (green, elapsed = colored portion) ──
    if (progress > 0.001) {
      final sweepAngle = progress * 2 * pi;
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -pi / 2,
          endAngle: -pi / 2 + sweepAngle,
          colors: [secondaryColor, primaryColor, secondaryColor],
          stops: const [0.0, 0.5, 1.0],
          transform: const GradientRotation(-pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );

      // ── Glow dot at the end of progress arc ──
      final endAngle = -pi / 2 + sweepAngle;
      final dotCenter = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );
      final glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(dotCenter, strokeW / 2 + 4, glowPaint);
      final dotPaint = Paint()..color = primaryColor;
      canvas.drawCircle(dotCenter, strokeW / 2 - 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) => old.progress != progress;
}
