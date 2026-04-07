import 'dart:math';
import 'package:flutter/material.dart';

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
      painter: _RadialPainter(
        progress: progress,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _RadialPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    canvas.drawCircle(center, radius,
      Paint()..color = primaryColor.withOpacity(0.2)..style = PaintingStyle.fill);

    // Inner ring
    canvas.drawCircle(center, radius * 0.78,
      Paint()..color = primaryColor.withOpacity(0.35)..style = PaintingStyle.fill);

    // Center glow
    canvas.drawCircle(center, radius * 0.55,
      Paint()..color = primaryColor.withOpacity(0.5)..style = PaintingStyle.fill);

    // Elapsed arc (the dark wedge that grows as time passes)
    if (progress < 1.0) {
      final sweepAngle = (1.0 - progress) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, sweepAngle, true,
        Paint()..color = secondaryColor.withOpacity(0.4)..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_RadialPainter old) => old.progress != progress;
}
