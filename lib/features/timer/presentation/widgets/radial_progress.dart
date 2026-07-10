import 'dart:math';
import 'package:flutter/material.dart';

/// Barre de progression circulaire — arc épais coloré sur fond sombre
/// avec deux anneaux (temps restant = arc coloré, temps écoulé = arc gris).
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

  static const _yellowPrimary = Color(0xFFFFD43B);
  static const _yellowSecondary = Color(0xFFFFE066);
  static const _redPrimary = Color(0xFFE53935);
  static const _redSecondary = Color(0xFFFF6B6B);

  _CircularProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const strokeW = 27.0; // +50% (was 18.0)
    final colors = _progressColors(progress);

    // ── Background track (grey) — transparence réduite de 50% ──
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // ── Inner subtle circles — transparence réduite de 50% ──
    final innerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - strokeW / 2 - 8, innerPaint);
    canvas.drawCircle(center, radius + strokeW / 2 + 8, innerPaint);

    // ── Graduations retirées ──

    // ── Progress arc (remaining = colored portion) ──
    if (progress > 0.001) {
      final sweepAngle = progress * 2 * pi;
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -pi / 2,
          endAngle: -pi / 2 + sweepAngle,
          colors: [colors.secondary, colors.primary, colors.secondary],
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
        ..color = colors.primary.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(dotCenter, strokeW / 2 + 4, glowPaint);
      final dotPaint = Paint()..color = colors.primary;
      canvas.drawCircle(dotCenter, strokeW / 2 - 2, dotPaint);
    }
  }

  _ProgressColors _progressColors(double value) {
    final remaining = value.clamp(0.0, 1.0);

    if (remaining <= 0.10) {
      return const _ProgressColors(_redPrimary, _redSecondary);
    }

    if (remaining < 0.12) {
      final t = (0.12 - remaining) / 0.02;
      return _ProgressColors(
        Color.lerp(_yellowPrimary, _redPrimary, t)!,
        Color.lerp(_yellowSecondary, _redSecondary, t)!,
      );
    }

    if (remaining <= 0.33) {
      return const _ProgressColors(_yellowPrimary, _yellowSecondary);
    }

    if (remaining < 0.35) {
      final t = (0.35 - remaining) / 0.02;
      return _ProgressColors(
        Color.lerp(primaryColor, _yellowPrimary, t)!,
        Color.lerp(secondaryColor, _yellowSecondary, t)!,
      );
    }

    return _ProgressColors(primaryColor, secondaryColor);
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) =>
      old.progress != progress ||
      old.primaryColor != primaryColor ||
      old.secondaryColor != secondaryColor;
}

class _ProgressColors {
  final Color primary;
  final Color secondary;

  const _ProgressColors(this.primary, this.secondary);
}
