import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay paille — poule.
/// Chaque brin a son propre cycle de vie (naissance → flottement → disparition)
/// identique au fonctionnement des feuilles et des bulles.
class StrawParticlesOverlay extends StatefulWidget {
  const StrawParticlesOverlay({super.key});

  @override
  State<StrawParticlesOverlay> createState() => _StrawParticlesOverlayState();
}

class _StrawParticlesOverlayState extends State<StrawParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_StrawPiece> _pieces;
  final Random _rng = Random(99);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _pieces = List.generate(80, (i) => _StrawPiece.random(_rng, i, 80));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _StrawPainter(pieces: _pieces, progress: _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

const _strawColors = [
  Color(0xFFD4A017),
  Color(0xFFE8C84A),
  Color(0xFFBF9B30),
  Color(0xFFF0D060),
  Color(0xFFC8A84B),
];

class _StrawPiece {
  final double x;
  final double startY;    // Y de départ
  final double riseY;     // amplitude de montée (fraction écran)
  final double length;
  final double thickness;
  final double angle;
  final double phase;     // offset uniforme dans [0,1]
  final double floatAmp;
  final double driftX;
  final double speed;
  final Color color;

  const _StrawPiece({
    required this.x, required this.startY, required this.riseY,
    required this.length, required this.thickness, required this.angle,
    required this.phase, required this.floatAmp, required this.driftX,
    required this.speed, required this.color,
  });

  factory _StrawPiece.random(Random rng, int index, int total) {
    return _StrawPiece(
      x: rng.nextDouble(),
      startY: 0.60 + rng.nextDouble() * 0.30,
      riseY: 0.08 + rng.nextDouble() * 0.12,
      length: 12.0 + rng.nextDouble() * 23.0,
      thickness: 1.5 + rng.nextDouble() * 1.5,
      angle: (rng.nextDouble() - 0.5) * pi * 0.40,
      // Phases régulièrement espacées → pas de saut à la boucle
      phase: index / total.toDouble(),
      floatAmp: 0.005 + rng.nextDouble() * 0.015,
      driftX: (rng.nextDouble() - 0.5) * 0.03,
      speed: 0.3 + rng.nextDouble() * 0.4,
      color: _strawColors[rng.nextInt(_strawColors.length)],
    );
  }
}

class _StrawPainter extends CustomPainter {
  final List<_StrawPiece> pieces;
  final double progress;

  const _StrawPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      // t local [0,1] : chaque brin a son propre décalage de phase
      final t = (progress * p.speed + p.phase) % 1.0;

      // sin(t*pi) : 0 en t=0 et t=1, max en t=0.5 → fondu naturel naissance/mort
      final alpha = (sin(t * pi) * 0.85).clamp(0.0, 1.0);
      if (alpha <= 0.01) continue;

      // Montée en easeOut comme les feuilles
      final rise = 1.0 - (1.0 - t) * (1.0 - t);
      final y = (p.startY - rise * p.riseY + sin(t * pi * 2) * p.floatAmp) * size.height;
      final x = (p.x + sin(t * pi) * p.driftX) * size.width;
      final currentAngle = p.angle + sin(t * pi * 2 * 0.7) * 0.15;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(currentAngle);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.length, height: p.thickness),
          Radius.circular(p.thickness / 2),
        ),
        Paint()
          ..color = p.color.withValues(alpha: alpha)
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round,
      );

      canvas.drawLine(
        Offset(-p.length / 2 + 2, 0),
        Offset(p.length / 2 - 2, 0),
        Paint()
          ..color = p.color.withValues(alpha: alpha * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_StrawPainter old) => old.progress != progress;
}
