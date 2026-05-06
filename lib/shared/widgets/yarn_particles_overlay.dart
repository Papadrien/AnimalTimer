import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay pelotes de laine — chat.
/// Chaque pelote a son propre cycle de vie (naissance → montée → disparition)
/// identique au fonctionnement des feuilles et des bulles.
class YarnParticlesOverlay extends StatefulWidget {
  const YarnParticlesOverlay({super.key});

  @override
  State<YarnParticlesOverlay> createState() => _YarnParticlesOverlayState();
}

class _YarnParticlesOverlayState extends State<YarnParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_YarnParticle> _particles;
  final Random _rng = Random(7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _particles = List.generate(14, (i) => _YarnParticle.random(_rng, i, 14));
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
          painter: _YarnPainter(particles: _particles, progress: _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

const _yarnColors = [
  Color(0xFFE53935),
  Color(0xFFEF5350),
  Color(0xFFC62828),
  Color(0xFFFF5252),
  Color(0xFFB71C1C),
  Color(0xFFFF1744),
];

class _YarnParticle {
  final double x;
  final double startY;   // Y de départ (bas)
  final double riseY;    // amplitude de montée (fraction écran)
  final double radius;
  final double phase;    // offset uniforme dans [0,1]
  final double driftX;   // dérive horizontale douce
  final double speed;
  final double rotation;
  final Color color;
  final int loops;

  const _YarnParticle({
    required this.x, required this.startY, required this.riseY,
    required this.radius, required this.phase, required this.driftX,
    required this.speed, required this.rotation, required this.color,
    required this.loops,
  });

  factory _YarnParticle.random(Random rng, int index, int total) {
    return _YarnParticle(
      x: 0.05 + rng.nextDouble() * 0.90,
      startY: 0.65 + rng.nextDouble() * 0.25,
      riseY: 0.12 + rng.nextDouble() * 0.15,
      radius: 10.0 + rng.nextDouble() * 12.0,
      // Phases régulièrement espacées → pas de saut à la boucle
      phase: index / total.toDouble(),
      driftX: (rng.nextDouble() - 0.5) * 0.04,
      speed: 0.4 + rng.nextDouble() * 0.4,
      rotation: rng.nextDouble() * pi * 2,
      color: _yarnColors[rng.nextInt(_yarnColors.length)],
      loops: 3 + rng.nextInt(4),
    );
  }
}

class _YarnPainter extends CustomPainter {
  final List<_YarnParticle> particles;
  final double progress;

  const _YarnPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // t local [0,1] : chaque pelote a son propre décalage de phase
      final t = (progress * p.speed + p.phase) % 1.0;

      // sin(t*pi) : 0 en t=0 et t=1, max en t=0.5 → fondu naturel naissance/mort
      final alpha = (sin(t * pi) * 0.55).clamp(0.0, 1.0);
      if (alpha <= 0.01) continue;

      // Montée en easeOut comme les feuilles
      final rise = 1.0 - (1.0 - t) * (1.0 - t);
      final y = (p.startY - rise * p.riseY) * size.height;
      final x = (p.x + sin(t * pi) * p.driftX) * size.width;
      final r = p.radius * (0.9 + 0.1 * sin(t * pi * 4));
      final rot = p.rotation + t * pi * 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      _drawYarnBall(canvas, r, p.color, p.loops, alpha);
      canvas.restore();
    }
  }

  void _drawYarnBall(Canvas canvas, double r, Color color, int loops, double alpha) {
    canvas.drawCircle(
      Offset.zero, r,
      Paint()..color = color.withValues(alpha: alpha * 0.75)..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset.zero, r,
      Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final threadPaint = Paint()
      ..color = Colors.white.withValues(alpha: alpha * 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (int l = 0; l < loops; l++) {
      final angleOffset = (l / loops) * pi;
      final path = Path();
      bool first = true;
      for (int i = 0; i <= 40; i++) {
        final a = (i / 40) * pi * 2;
        final ex = cos(a + angleOffset) * r;
        final ey = sin(a + angleOffset) * r * 0.35;
        if (first) { path.moveTo(ex, ey); first = false; }
        else { path.lineTo(ex, ey); }
      }
      canvas.drawPath(path, threadPaint);
    }

    final tail = Path();
    tail.moveTo(r * 0.6, -r * 0.3);
    tail.quadraticBezierTo(r * 1.3, -r * 0.6, r * 1.1, -r * 1.1);
    canvas.drawPath(
      tail,
      Paint()
        ..color = color.withValues(alpha: alpha * 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(-r * 0.3, -r * 0.3), r * 0.22,
      Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.25)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_YarnPainter old) => old.progress != progress;
}
