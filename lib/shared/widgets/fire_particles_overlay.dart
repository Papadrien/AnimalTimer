import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de particules "flammes" montant du bas vers le haut de l'écran,
/// sur le même principe que les bulles du crocodile (WaterParticlesOverlay).
class FireParticlesOverlay extends StatefulWidget {
  const FireParticlesOverlay({super.key});

  @override
  State<FireParticlesOverlay> createState() => _FireParticlesOverlayState();
}

class _FireParticlesOverlayState extends State<FireParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FireParticle> _particles;
  final Random _rng = Random(17);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _particles = List.generate(26, (i) => _FireParticle.random(_rng, i, 26));
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
          painter: _FireParticlesPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _FireParticle {
  final double x;
  final double speed;
  final double size;
  final double opacity;
  final double phase;
  final double drift;
  final double flickerSpeed;
  final int colorIndex;

  const _FireParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
    required this.drift,
    required this.flickerSpeed,
    required this.colorIndex,
  });

  factory _FireParticle.random(Random rng, int index, int total) {
    return _FireParticle(
      x: rng.nextDouble(),
      speed: 0.55 + rng.nextDouble() * 0.55,
      size: 5.0 + rng.nextDouble() * 9.0,
      opacity: 0.45 + rng.nextDouble() * 0.4,
      phase: index / total + rng.nextDouble() * 0.02,
      drift: 0.015 + rng.nextDouble() * 0.03,
      flickerSpeed: 3.0 + rng.nextDouble() * 3.0,
      colorIndex: rng.nextInt(3),
    );
  }
}

class _FireParticlesPainter extends CustomPainter {
  final List<_FireParticle> particles;
  final double progress;

  const _FireParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress + p.phase) % 1.0;

      // Trajectoire verticale : monte du bas (1.1) vers le haut (-0.1),
      // toujours hors écran à l'apparition et à la disparition.
      final normY = 1.1 - t * 1.2;
      final y = normY * size.height;

      final x = (p.x + sin(t * pi * 2 + p.phase * pi * 2) * p.drift) *
          size.width;

      final fade = _fadeAlpha(t, fadeIn: 0.15, fadeOut: 0.15);
      final flicker = 0.75 + 0.25 * sin(t * pi * p.flickerSpeed);
      final alpha = (p.opacity * flicker * fade).clamp(0.0, 0.65);
      if (alpha <= 0.01) continue;

      // La flamme rétrécit légèrement en montant, comme si elle s'éteignait.
      final flameSize = p.size * (1.0 - 0.3 * t);

      _drawFlame(canvas, Offset(x, y), flameSize, alpha, p.colorIndex);
    }
  }

  double _fadeAlpha(double t, {required double fadeIn, required double fadeOut}) {
    if (t < fadeIn) return t / fadeIn;
    if (t > 1.0 - fadeOut) return (1.0 - t) / fadeOut;
    return 1.0;
  }

  void _drawFlame(Canvas canvas, Offset center, double size, double alpha, int colorIndex) {
    const outerColors = [
      Color(0xFFFF7A1A), // orange vif
      Color(0xFFFF9640), // orange clair
      Color(0xFFFFB300), // ambre
    ];
    const innerColor = Color(0xFFFFE066); // jaune coeur de flamme

    final path = Path();
    // Silhouette de flamme : pointe en haut, base arrondie en bas.
    path.moveTo(center.dx, center.dy - size * 1.3);
    path.cubicTo(
      center.dx + size * 0.75, center.dy - size * 0.5,
      center.dx + size * 0.65, center.dy + size * 0.35,
      center.dx, center.dy + size * 0.9,
    );
    path.cubicTo(
      center.dx - size * 0.65, center.dy + size * 0.35,
      center.dx - size * 0.75, center.dy - size * 0.5,
      center.dx, center.dy - size * 1.3,
    );
    path.close();

    // Halo doux
    final halo = Paint()
      ..color = outerColors[colorIndex].withValues(alpha: alpha * 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(center, size * 1.3, halo);

    // Corps de la flamme
    final fill = Paint()
      ..color = outerColors[colorIndex].withValues(alpha: alpha)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fill);

    // Coeur jaune plus clair
    final innerPath = Path();
    innerPath.moveTo(center.dx, center.dy - size * 0.75);
    innerPath.cubicTo(
      center.dx + size * 0.35, center.dy - size * 0.1,
      center.dx + size * 0.3, center.dy + size * 0.45,
      center.dx, center.dy + size * 0.75,
    );
    innerPath.cubicTo(
      center.dx - size * 0.3, center.dy + size * 0.45,
      center.dx - size * 0.35, center.dy - size * 0.1,
      center.dx, center.dy - size * 0.75,
    );
    innerPath.close();

    final innerFill = Paint()
      ..color = innerColor.withValues(alpha: alpha * 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, innerFill);
  }

  @override
  bool shouldRepaint(_FireParticlesPainter old) => old.progress != progress;
}
