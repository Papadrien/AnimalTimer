import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de particules "poussière et vent" pour le cheval.
class DustParticlesOverlay extends StatefulWidget {
  const DustParticlesOverlay({super.key});

  @override
  State<DustParticlesOverlay> createState() => _DustParticlesOverlayState();
}

class _DustParticlesOverlayState extends State<DustParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_DustParticle> _particles;
  final Random _rng = Random(21);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _particles = List.generate(35, (i) => _DustParticle.random(_rng, i));
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
          painter: _DustPainter(particles: _particles, progress: _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _DustParticle {
  final double startX;
  final double y;
  final double speed;
  final double size;
  final double opacity;
  final double phase;
  final double waveAmp;
  final double waveFreq;
  final Color color;

  const _DustParticle({
    required this.startX,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
    required this.waveAmp,
    required this.waveFreq,
    required this.color,
  });

  factory _DustParticle.random(Random rng, int index) {
    const colors = [
      Color(0xFFD4A96A),
      Color(0xFFC8956C),
      Color(0xFFE8C99A),
      Color(0xFFBFA07A),
      Color(0xFFD2B48C),
    ];
    return _DustParticle(
      startX: -0.05 - rng.nextDouble() * 0.10,
      y: 0.4 + rng.nextDouble() * 0.58,
      speed: 0.15 + rng.nextDouble() * 0.25,
      size: 3.0 + rng.nextDouble() * 9.0,
      opacity: 0.12 + rng.nextDouble() * 0.30,
      phase: index / 35.0,
      waveAmp: 0.01 + rng.nextDouble() * 0.025,
      waveFreq: 1.0 + rng.nextDouble() * 2.0,
      color: colors[rng.nextInt(colors.length)],
    );
  }
}

class _DustPainter extends CustomPainter {
  final List<_DustParticle> particles;
  final double progress;

  const _DustPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress * p.speed + p.phase) % 1.0);

      final x = (p.startX + t * 1.15) * size.width;
      final y = (p.y + sin(t * pi * 2 * p.waveFreq) * p.waveAmp) * size.height;

      // Fondu : 20% fade in, 20% fade out
      final fade = _fadeAlpha(t, fadeIn: 0.20, fadeOut: 0.20);
      final alpha = (fade * p.opacity).clamp(0.0, 1.0);
      if (alpha <= 0) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: p.size * 2.2,
        height: p.size,
      );
      canvas.drawOval(rect, paint);

      if (p.size > 7) {
        _drawWindStreak(canvas, Offset(x, y), p.size, alpha, p.color);
      }
    }
  }

  double _fadeAlpha(double t, {required double fadeIn, required double fadeOut}) {
    if (t < fadeIn) return t / fadeIn;
    if (t > 1.0 - fadeOut) return (1.0 - t) / fadeOut;
    return 1.0;
  }

  void _drawWindStreak(Canvas canvas, Offset center, double sz, double alpha, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 2; i++) {
      final offsetY = (i == 0 ? -sz * 0.6 : sz * 0.5);
      final len = sz * (0.8 + i * 0.4);
      canvas.drawLine(
        Offset(center.dx - len, center.dy + offsetY),
        Offset(center.dx + len * 0.3, center.dy + offsetY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DustPainter old) => old.progress != progress;
}
