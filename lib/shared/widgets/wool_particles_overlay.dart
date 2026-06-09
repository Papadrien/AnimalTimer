import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay boules de laine blanc cassé — mouton.
/// Même animation que les pelotes de laine du chat (YarnParticlesOverlay)
/// mais avec des couleurs blanc cassé / crème et un look floconneux.
class WoolParticlesOverlay extends StatefulWidget {
  const WoolParticlesOverlay({super.key});

  @override
  State<WoolParticlesOverlay> createState() => _WoolParticlesOverlayState();
}

class _WoolParticlesOverlayState extends State<WoolParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_WoolParticle> _particles;
  final Random _rng = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _particles = List.generate(14, (i) => _WoolParticle.random(_rng, i, 14));
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
          painter: _WoolPainter(particles: _particles, progress: _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// Palette blanc cassé / crème pour la laine
const _woolColors = [
  Color(0xFFFAF7F2), // blanc cassé chaud
  Color(0xFFF5F0E8), // crème
  Color(0xFFEDE8DF), // beige clair
  Color(0xFFF8F4EE), // blanc ivoire
  Color(0xFFEFE9DE), // sable très clair
  Color(0xFFF2EDE4), // lin clair
];

class _WoolParticle {
  final double x;
  final double startY;
  final double riseY;
  final double radius;
  final double phase;
  final double driftX;
  final double speed;
  final double rotation;
  final Color color;
  final int bumps; // nombre de bosses du contour floconneux

  const _WoolParticle({
    required this.x,
    required this.startY,
    required this.riseY,
    required this.radius,
    required this.phase,
    required this.driftX,
    required this.speed,
    required this.rotation,
    required this.color,
    required this.bumps,
  });

  factory _WoolParticle.random(Random rng, int index, int total) {
    return _WoolParticle(
      x: 0.05 + rng.nextDouble() * 0.90,
      startY: 0.65 + rng.nextDouble() * 0.25,
      riseY: 0.12 + rng.nextDouble() * 0.15,
      radius: 10.0 + rng.nextDouble() * 14.0,
      phase: index / total.toDouble(),
      driftX: (rng.nextDouble() - 0.5) * 0.04,
      speed: 0.4 + rng.nextDouble() * 0.4,
      rotation: rng.nextDouble() * pi * 2,
      color: _woolColors[rng.nextInt(_woolColors.length)],
      bumps: 6 + rng.nextInt(4),
    );
  }
}

class _WoolPainter extends CustomPainter {
  final List<_WoolParticle> particles;
  final double progress;

  const _WoolPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final alpha = (sin(t * pi) * 0.60).clamp(0.0, 1.0);
      if (alpha <= 0.01) continue;

      final rise = 1.0 - (1.0 - t) * (1.0 - t);
      final y = (p.startY - rise * p.riseY) * size.height;
      final x = (p.x + sin(t * pi) * p.driftX) * size.width;
      final r = p.radius * (0.9 + 0.1 * sin(t * pi * 4));
      final rot = p.rotation + t * pi * 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      _drawWoolBall(canvas, r, p.color, p.bumps, alpha);
      canvas.restore();
    }
  }

  void _drawWoolBall(Canvas canvas, double r, Color color, int bumps, double alpha) {
    // Fond de la boule
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = color.withValues(alpha: alpha * 0.85)
        ..style = PaintingStyle.fill,
    );

    // Contour floconneux avec bosses
    final fluffPath = _buildFluffyPath(r, bumps);
    canvas.drawPath(
      fluffPath,
      Paint()
        ..color = color.withValues(alpha: alpha * 0.95)
        ..style = PaintingStyle.fill,
    );

    // Contour légèrement grisé pour donner du relief
    canvas.drawPath(
      fluffPath,
      Paint()
        ..color = const Color(0xFFCCC8C0).withValues(alpha: alpha * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Petits cercles flous sur la surface (texture laine)
    final texturePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: alpha * 0.30)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * pi * 2;
      final tx = cos(angle) * r * 0.45;
      final ty = sin(angle) * r * 0.45;
      canvas.drawCircle(Offset(tx, ty), r * 0.20, texturePaint);
    }

    // Reflet lumineux
    canvas.drawCircle(
      Offset(-r * 0.28, -r * 0.28),
      r * 0.20,
      Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.40)
        ..style = PaintingStyle.fill,
    );
  }

  /// Construit un chemin circulaire avec des bosses douces (aspect floconneux).
  Path _buildFluffyPath(double r, int bumps) {
    final path = Path();
    final bumpHeight = r * 0.28;
    final innerR = r * 0.82;
    const steps = 120;

    for (int i = 0; i <= steps; i++) {
      final angle = (i / steps) * pi * 2;
      // Ondulation sinusoïdale pour les bosses
      final wave = sin(angle * bumps) * bumpHeight;
      final radius = innerR + wave;
      final px = cos(angle) * radius;
      final py = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_WoolPainter old) => old.progress != progress;
}
