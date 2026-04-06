// lib/features/timer/presentation/widgets/progress_ring_painter.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter — anneau de progression radial avec dégradé + glow.
class ProgressRingPainter extends CustomPainter {
  const ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
    this.backgroundColor = const Color(0x22000000),
    this.glowEnabled     = true,
  });

  final double   progress;        // 1.0 = plein, 0.0 = vide
  final double   strokeWidth;
  final Gradient gradient;
  final Color    backgroundColor;
  final bool     glowEnabled;

  @override
  void paint(Canvas canvas, Size size) {
    final center     = Offset(size.width / 2, size.height / 2);
    final radius     = (size.shortestSide / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2;           // Départ en haut
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    final rect       = Rect.fromCircle(center: center, radius: radius);

    // ── 1. Piste de fond ──────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color      = backgroundColor
        ..style      = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap  = StrokeCap.round,
    );

    if (progress <= 0) return;

    // ── 2. Glow (lueur douce derrière l'anneau) ───────────────────────────
    if (glowEnabled) {
      canvas.drawArc(
        rect, startAngle, sweepAngle, false,
        Paint()
          ..shader     = gradient.createShader(rect)
          ..style      = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 2.6
          ..strokeCap  = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    // ── 3. Anneau principal ───────────────────────────────────────────────
    canvas.drawArc(
      rect, startAngle, sweepAngle, false,
      Paint()
        ..shader      = gradient.createShader(rect)
        ..style       = PaintingStyle.stroke
        ..strokeWidth  = strokeWidth
        ..strokeCap   = StrokeCap.round,
    );

    // ── 4. Point brillant à l'extrémité ───────────────────────────────────
    if (progress > 0.01 && progress < 0.99) {
      final endAngle = startAngle + sweepAngle;
      final dot      = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      // Halo
      canvas.drawCircle(
        dot,
        strokeWidth / 1.5,
        Paint()
          ..color      = Colors.white.withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      // Point blanc
      canvas.drawCircle(
        dot,
        strokeWidth / 2.6,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(ProgressRingPainter old) =>
      old.progress != progress ||
      old.gradient != gradient  ||
      old.strokeWidth != strokeWidth;
}

// ─────────────────────────────────────────────────────────────────────────────

/// Widget clé en main : anneau + contenu centré.
class ProgressRingWidget extends StatelessWidget {
  const ProgressRingWidget({
    super.key,
    required this.progress,
    required this.gradient,
    required this.child,
    this.size        = 280,
    this.strokeWidth = 20,
  });

  final double   progress;
  final Gradient gradient;
  final Widget   child;
  final double   size;
  final double   strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: ProgressRingPainter(
              progress:    progress,
              strokeWidth: strokeWidth,
              gradient:    gradient,
            ),
          ),
          SizedBox(
            width:  size - strokeWidth * 4,
            height: size - strokeWidth * 4,
            child: child,
          ),
        ],
      ),
    );
  }
}
