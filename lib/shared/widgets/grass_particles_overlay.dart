import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay "gazon + feuilles" — chien ET cheval (même widget partagé).
/// Boucle 12 s, sans saccade (début = fin d'état).
class GrassParticlesOverlay extends StatefulWidget {
  const GrassParticlesOverlay({super.key});

  @override
  State<GrassParticlesOverlay> createState() => _GrassParticlesOverlayState();
}

class _GrassParticlesOverlayState extends State<GrassParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_GrassBlade> _blades;
  late List<_LeafParticle> _leaves;
  final Random _rng = Random(13);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _blades = List.generate(65, (_) => _GrassBlade.random(_rng));
    _leaves = List.generate(18, (i) => _LeafParticle.random(_rng, i, 18));
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
          painter: _GrassPainter(
            blades: _blades,
            leaves: _leaves,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

const _grassColors = [
  Color(0xFF4CAF50),
  Color(0xFF66BB6A),
  Color(0xFF2E7D32),
  Color(0xFF81C784),
  Color(0xFF388E3C),
  Color(0xFF1B5E20),
  Color(0xFFA5D6A7),
];

class _GrassBlade {
  final double x;
  final double height;
  final double width;
  final double phase;
  final double sway;
  final Color color;
  final double curve;

  const _GrassBlade({
    required this.x, required this.height, required this.width,
    required this.phase, required this.sway, required this.color,
    required this.curve,
  });

  factory _GrassBlade.random(Random rng) {
    return _GrassBlade(
      x: rng.nextDouble(),
      height: 0.05 + rng.nextDouble() * 0.15,
      width: 1.2 + rng.nextDouble() * 2.5,
      phase: rng.nextDouble(),
      sway: 0.006 + rng.nextDouble() * 0.014,
      color: _grassColors[rng.nextInt(_grassColors.length)],
      curve: 0.3 + rng.nextDouble() * 0.5,
    );
  }
}

class _LeafParticle {
  final double x;
  final double startY;  // Y de départ (bas)
  final double riseY;   // amplitude de montée (fraction écran)
  final double size;
  final double phase;   // offset uniforme dans [0,1]
  final double driftX;  // dérive horizontale douce
  final Color color;

  const _LeafParticle({
    required this.x, required this.startY, required this.riseY,
    required this.size, required this.phase, required this.driftX,
    required this.color,
  });

  factory _LeafParticle.random(Random rng, int index, int total) {
    return _LeafParticle(
      x: rng.nextDouble(),
      startY: 0.70 + rng.nextDouble() * 0.20,
      riseY: 0.10 + rng.nextDouble() * 0.12,
      size: 5.0 + rng.nextDouble() * 7.0,
      // Phases régulièrement espacées => à t=0 et t=1 l'état est identique
      phase: index / total.toDouble(),
      driftX: (rng.nextDouble() - 0.5) * 0.03,
      color: _grassColors[rng.nextInt(_grassColors.length)],
    );
  }
}

class _GrassPainter extends CustomPainter {
  final List<_GrassBlade> blades;
  final List<_LeafParticle> leaves;
  final double progress;

  const _GrassPainter({
    required this.blades, required this.leaves, required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in blades) { _drawBlade(canvas, size, b); }
    for (final l in leaves) { _drawLeaf(canvas, size, l); }
  }

  void _drawBlade(Canvas canvas, Size size, _GrassBlade b) {
    final t = (progress + b.phase) % 1.0;
    final swayOffset = sin(t * pi * 2) * b.sway * size.width;
    final baseX = b.x * size.width;
    final baseY = size.height;
    final bladeH = b.height * size.height;
    final tipX = baseX + swayOffset;
    final tipY = baseY - bladeH;
    final ctrlX = baseX + swayOffset * b.curve + (swayOffset * 0.5);
    final ctrlY = baseY - bladeH * 0.6;

    final paint = Paint()
      ..color = b.color.withValues(alpha: 0.52)   // translucides
      ..style = PaintingStyle.stroke
      ..strokeWidth = b.width
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(baseX, baseY);
    path.quadraticBezierTo(ctrlX, ctrlY, tipX, tipY);
    canvas.drawPath(path, paint);
  }

  void _drawLeaf(Canvas canvas, Size size, _LeafParticle l) {
    // t local dans [0,1] : chaque feuille a son propre décalage de phase
    final t = (progress + l.phase) % 1.0;

    // Alpha continu via sin — aucune discontinuité entre boucles
    // sin(t*pi) est 0 en t=0 et t=1, max en t=0.5 → fondu naturel
    final alpha = (sin(t * pi) * 0.80).clamp(0.0, 1.0);
    if (alpha <= 0.01) return;

    // Progression de montée = t directement (0→1 sur tout le cycle)
    final rise = 1.0 - (1.0 - t) * (1.0 - t); // easeOut
    final y = (l.startY - rise * l.riseY) * size.height;
    final x = (l.x + sin(t * pi) * l.driftX) * size.width;
    final rotation = t * pi * 0.6;

    final paint = Paint()
      ..color = l.color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: l.size, height: l.size * 2.0),
      paint,
    );

    canvas.drawPath(
      Path()..moveTo(0, -l.size)..lineTo(0, l.size),
      Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GrassPainter old) => old.progress != progress;
}
