import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de particules "eau" animées (bulles uniquement).
class WaterParticlesOverlay extends StatefulWidget {
  const WaterParticlesOverlay({super.key});

  @override
  State<WaterParticlesOverlay> createState() => _WaterParticlesOverlayState();
}

class _WaterParticlesOverlayState extends State<WaterParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_WaterParticle> _particles;
  final Random _rng = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _particles = List.generate(28, (i) => _WaterParticle.random(_rng, i));
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
          painter: _WaterParticlesPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _WaterParticle {
  final double x;
  final double startY;
  final double speed;
  final double size;
  final double opacity;
  final double phase;
  final double drift;

  const _WaterParticle({
    required this.x,
    required this.startY,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
    required this.drift,
  });

  factory _WaterParticle.random(Random rng, int index) {
    return _WaterParticle(
      x: rng.nextDouble(),
      startY: 0.2 + rng.nextDouble() * 0.8,
      speed: 0.06 + rng.nextDouble() * 0.18,
      size: 3.0 + rng.nextDouble() * 8.0,
      opacity: 0.10 + rng.nextDouble() * 0.30,
      phase: index / 28.0,
      drift: 0.01 + rng.nextDouble() * 0.03,
    );
  }
}

class _WaterParticlesPainter extends CustomPainter {
  final List<_WaterParticle> particles;
  final double progress;

  const _WaterParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress + p.phase) % 1.0);
      final rawY = p.startY - t * p.speed * 8.0;
      final normY = rawY < -0.05 ? rawY + 1.1 : rawY;
      final y = normY * size.height;
      final x = (p.x + sin(t * pi * 2 + p.phase * pi * 2) * p.drift) * size.width;

      // Fondu doux : 15% fade in / 15% fade out
      final fade = _fadeAlpha(t, fadeIn: 0.15, fadeOut: 0.15);
      final alpha = (p.opacity * (0.7 + 0.3 * sin(t * pi * 4)) * fade).clamp(0.0, 1.0);
      if (alpha <= 0) continue;

      _drawBubble(canvas, Offset(x, y), p.size, alpha);
    }
  }

  double _fadeAlpha(double t, {required double fadeIn, required double fadeOut}) {
    if (t < fadeIn) return t / fadeIn;
    if (t > 1.0 - fadeOut) return (1.0 - t) / fadeOut;
    return 1.0;
  }

  void _drawBubble(Canvas canvas, Offset center, double radius, double alpha) {
    final paint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: alpha * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    final border = Paint()
      ..color = const Color(0xFF81D4FA).withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius, border);

    final highlight = Paint()
      ..color = Colors.white.withValues(alpha: alpha * 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.25,
      highlight,
    );
  }

  @override
  bool shouldRepaint(_WaterParticlesPainter old) => old.progress != progress;
}
