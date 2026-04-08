import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Peint un contour "dessiné à la main" autour d'un rectangle arrondi.
/// Le trait tremble légèrement pour donner un effet crayon.
class SketchyRectPainter extends CustomPainter {
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final double radius;
  final int seed;

  SketchyRectPainter({
    this.strokeColor = AppColors.pencilDark,
    this.fillColor,
    this.strokeWidth = 2.5,
    this.radius = 24,
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    final jitter = strokeWidth * 0.8;

    // Remplissage qui "déborde" légèrement
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;

      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -jitter * 0.5 + rng.nextDouble() * jitter,
          -jitter * 0.3 + rng.nextDouble() * jitter * 0.6,
          size.width + jitter * 0.3,
          size.height + jitter * 0.3,
        ),
        Radius.circular(radius + rng.nextDouble() * 4),
      );
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Contour "à la main"
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = radius;
    final steps = 40;

    // Dessiner un rectangle arrondi avec du jitter
    List<Offset> points = [];

    // Top edge
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = r + t * (w - 2 * r);
      final y = 0.0;
      points.add(Offset(
        x + (rng.nextDouble() - 0.5) * jitter,
        y + (rng.nextDouble() - 0.5) * jitter * 0.5,
      ));
    }
    // Top-right corner
    for (int i = 0; i <= 8; i++) {
      final angle = -pi / 2 + (pi / 2) * i / 8;
      points.add(Offset(
        w - r + r * cos(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
        r + r * sin(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
      ));
    }
    // Right edge
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final y = r + t * (h - 2 * r);
      points.add(Offset(
        w + (rng.nextDouble() - 0.5) * jitter * 0.5,
        y + (rng.nextDouble() - 0.5) * jitter,
      ));
    }
    // Bottom-right corner
    for (int i = 0; i <= 8; i++) {
      final angle = 0.0 + (pi / 2) * i / 8;
      points.add(Offset(
        w - r + r * cos(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
        h - r + r * sin(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
      ));
    }
    // Bottom edge
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = w - r - t * (w - 2 * r);
      points.add(Offset(
        x + (rng.nextDouble() - 0.5) * jitter,
        h + (rng.nextDouble() - 0.5) * jitter * 0.5,
      ));
    }
    // Bottom-left corner
    for (int i = 0; i <= 8; i++) {
      final angle = pi / 2 + (pi / 2) * i / 8;
      points.add(Offset(
        r + r * cos(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
        h - r + r * sin(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
      ));
    }
    // Left edge
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final y = h - r - t * (h - 2 * r);
      points.add(Offset(
        0 + (rng.nextDouble() - 0.5) * jitter * 0.5,
        y + (rng.nextDouble() - 0.5) * jitter,
      ));
    }
    // Top-left corner
    for (int i = 0; i <= 8; i++) {
      final angle = pi + (pi / 2) * i / 8;
      points.add(Offset(
        r + r * cos(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
        r + r * sin(angle) + (rng.nextDouble() - 0.5) * jitter * 0.5,
      ));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
    }

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(SketchyRectPainter old) =>
      old.fillColor != fillColor || old.strokeColor != strokeColor;
}

/// Peint un cercle "dessiné à la main"
class SketchyCirclePainter extends CustomPainter {
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final int seed;

  SketchyCirclePainter({
    this.strokeColor = AppColors.pencilDark,
    this.fillColor,
    this.strokeWidth = 2.5,
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth;
    final jitter = strokeWidth * 0.7;

    // Remplissage qui déborde
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(
          center.dx + (rng.nextDouble() - 0.5) * jitter,
          center.dy + (rng.nextDouble() - 0.5) * jitter,
        ),
        radius + jitter * 0.4,
        fillPaint,
      );
    }

    // Contour tremblant
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final steps = 60;
    for (int i = 0; i <= steps; i++) {
      final angle = 2 * pi * i / steps;
      final r = radius + (rng.nextDouble() - 0.5) * jitter;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(SketchyCirclePainter old) =>
      old.fillColor != fillColor || old.strokeColor != strokeColor;
}
