import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay T-Rex : frondes de fougère tombantes, sur le même principe que
/// les feuilles du diplodocus, mais avec une silhouette de fougère
/// (tige + folioles) et une palette vert sombre adaptée au thème foncé
/// du T-Rex.
class TrexParticlesOverlay extends StatefulWidget {
  const TrexParticlesOverlay({super.key});

  @override
  State<TrexParticlesOverlay> createState() => _TrexParticlesOverlayState();
}

class _TrexParticlesOverlayState extends State<TrexParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FallingFrond> _fallingFronds;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = Random(96);
    _fallingFronds = List.generate(16, (i) => _FallingFrond.random(rng, i, 16));
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
        builder: (_, __) => CustomPaint(
          painter: _TrexPainter(
            fallingFronds: _fallingFronds,
            progress:      _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─── Couleurs (vert sombre, cohérent avec le thème foncé du T-Rex) ───
const _frondColors = [
  Color(0xFF1B4D2E),
  Color(0xFF264D2A),
  Color(0xFF2E5934),
  Color(0xFF1F3D24),
  Color(0xFF355E3B),
  Color(0xFF14361B),
];

// ─── Fronde tombante ───
class _FallingFrond {
  final double x;
  final double size;
  final double phase;
  final double driftX;
  final double spinRate;
  final double initAngle;
  final Color  color;

  const _FallingFrond({
    required this.x, required this.size, required this.phase,
    required this.driftX, required this.spinRate,
    required this.initAngle, required this.color,
  });

  factory _FallingFrond.random(Random rng, int index, int total) {
    return _FallingFrond(
      x:         rng.nextDouble(),
      size:      7.0 + rng.nextDouble() * 9.0,
      phase:     index / total.toDouble(),
      driftX:    (rng.nextDouble() - 0.5) * 0.08,
      spinRate:  (rng.nextDouble() - 0.5) * 1.0,
      initAngle: rng.nextDouble() * pi * 2,
      color:     _frondColors[rng.nextInt(_frondColors.length)],
    );
  }
}

// ─── Painter ───
class _TrexPainter extends CustomPainter {
  final List<_FallingFrond> fallingFronds;
  final double progress;

  const _TrexPainter({
    required this.fallingFronds,
    required this.progress,
  });

  static const double _startY = 0.03;

  @override
  void paint(Canvas canvas, Size size) {
    for (final f in fallingFronds) {
      _drawFallingFrond(canvas, size, f);
    }
  }

  void _drawFallingFrond(Canvas canvas, Size size, _FallingFrond f) {
    final t = (progress + f.phase) % 1.0;

    final rawAlpha     = sin(t * pi) * 0.60;
    final fadeInLinear = (t / 0.25).clamp(0.0, 1.0);
    final fadeIn       = fadeInLinear * fadeInLinear;
    final alpha        = (rawAlpha * fadeIn).clamp(0.0, 0.60);
    if (alpha <= 0.01) return;

    final fall = t * t;
    final y    = (_startY + fall * (1.05 - _startY)) * size.height;
    final x    = (f.x + sin(t * pi * 2) * f.driftX) * size.width;
    final rot  = f.initAngle + t * f.spinRate * pi * 2 + sin(t * pi * 3) * 0.20;

    _paintFrond(canvas, Offset(x, y), f.color, f.size, rot, alpha);
  }

  /// Fronde de fougère : une tige centrale avec des folioles alternées de
  /// part et d'autre, contrairement à la simple feuille ovale.
  void _paintFrond(Canvas canvas, Offset center, Color color, double size,
      double angle, double alpha) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final stemPaint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.09
      ..strokeCap = StrokeCap.round;

    // Tige centrale.
    canvas.drawLine(
      Offset(0, -size * 1.1), Offset(0, size * 1.1), stemPaint,
    );

    // Folioles : petites feuilles alternées le long de la tige.
    final leafletPaint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    const leafletCount = 4;
    for (int i = 0; i < leafletCount; i++) {
      final t = (i + 1) / (leafletCount + 1);
      final ly = -size * 1.1 + t * size * 2.2;
      final side = i.isEven ? 1.0 : -1.0;
      final leafletLength = size * (0.55 - t * 0.15);

      canvas.save();
      canvas.translate(0, ly);
      canvas.rotate(side * 0.55);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(leafletLength * 0.5, 0),
          width: leafletLength,
          height: size * 0.28,
        ),
        leafletPaint,
      );
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_TrexPainter old) => old.progress != progress;
}
