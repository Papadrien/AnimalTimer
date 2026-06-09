import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay girafe : feuilles tombantes uniquement.
class GiraffeParticlesOverlay extends StatefulWidget {
  const GiraffeParticlesOverlay({super.key});

  @override
  State<GiraffeParticlesOverlay> createState() =>
      _GiraffeParticlesOverlayState();
}

class _GiraffeParticlesOverlayState extends State<GiraffeParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FallingLeaf> _fallingLeaves;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = Random(77);
    _fallingLeaves = List.generate(18, (i) => _FallingLeaf.random(rng, i, 18));
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
          painter: _GiraffePainter(
            fallingLeaves: _fallingLeaves,
            progress:      _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─── Couleurs ───
const _leafColors = [
  Color(0xFF66BB6A),
  Color(0xFF4CAF50),
  Color(0xFF388E3C),
  Color(0xFF81C784),
  Color(0xFFA5D6A7),
  Color(0xFF2E7D32),
  Color(0xFFAED581),
  Color(0xFF558B2F),
];

// ─── Feuille tombante ───
class _FallingLeaf {
  final double x;
  final double size;
  final double phase;
  final double driftX;
  final double spinRate;
  final double initAngle;
  final Color  color;

  const _FallingLeaf({
    required this.x, required this.size, required this.phase,
    required this.driftX, required this.spinRate,
    required this.initAngle, required this.color,
  });

  factory _FallingLeaf.random(Random rng, int index, int total) {
    return _FallingLeaf(
      x:         rng.nextDouble(),
      size:      6.0 + rng.nextDouble() * 8.0,
      phase:     index / total.toDouble(),
      driftX:    (rng.nextDouble() - 0.5) * 0.08,
      spinRate:  (rng.nextDouble() - 0.5) * 1.2,
      initAngle: rng.nextDouble() * pi * 2,
      color:     _leafColors[rng.nextInt(_leafColors.length)],
    );
  }
}

// ─── Painter ───
class _GiraffePainter extends CustomPainter {
  final List<_FallingLeaf> fallingLeaves;
  final double progress;

  const _GiraffePainter({
    required this.fallingLeaves,
    required this.progress,
  });

  static const double _startY = 0.03;

  @override
  void paint(Canvas canvas, Size size) {
    for (final l in fallingLeaves) {
      _drawFallingLeaf(canvas, size, l);
    }
  }

  void _drawFallingLeaf(Canvas canvas, Size size, _FallingLeaf l) {
    final t = (progress + l.phase) % 1.0;

    final rawAlpha     = sin(t * pi) * 0.60;
    final fadeInLinear = (t / 0.25).clamp(0.0, 1.0);
    final fadeIn       = fadeInLinear * fadeInLinear;
    final alpha        = (rawAlpha * fadeIn).clamp(0.0, 0.60);
    if (alpha <= 0.01) return;

    final fall = t * t;
    final y    = (_startY + fall * (1.05 - _startY)) * size.height;
    final x    = (l.x + sin(t * pi * 2) * l.driftX) * size.width;
    final rot  = l.initAngle + t * l.spinRate * pi * 2 + sin(t * pi * 3) * 0.20;

    _paintLeaf(canvas, Offset(x, y), l.color, l.size, rot, alpha);
  }

  void _paintLeaf(Canvas canvas, Offset center, Color color, double size,
      double angle, double alpha) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size * 0.65, height: size * 1.6),
      Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill,
    );
    canvas.drawLine(
      Offset(0, -size * 0.7), Offset(0, size * 0.7),
      Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GiraffePainter old) => old.progress != progress;
}
