import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de particules "feuilles de salade et poussière" pour la tortue.
/// Boucle 8 s, sans saccade (positions déterministes via phase fixe).
class TurtleParticlesOverlay extends StatefulWidget {
  const TurtleParticlesOverlay({super.key});

  @override
  State<TurtleParticlesOverlay> createState() =>
      _TurtleParticlesOverlayState();
}

class _TurtleParticlesOverlayState extends State<TurtleParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Leaf> _leaves;
  late List<_DirtPuff> _dirtPuffs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    final rng = Random(42);
    _leaves = List.generate(18, (i) => _Leaf.random(rng, i, 18));
    _dirtPuffs = List.generate(22, (i) => _DirtPuff.random(rng, i, 22));
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
          painter: _TurtlePainter(
            leaves: _leaves,
            dirtPuffs: _dirtPuffs,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─────────────── Leaf (feuille de salade) ───────────────

class _Leaf {
  final double x;        // position X fixe [0..1]
  final double y;        // position Y fixe [0..1] — bas de l'écran
  final double size;     // taille [px]
  final double phase;    // offset animation [0..1]
  final double jumpAmp;  // amplitude saut vertical [0..1]
  final double jumpFreq; // fréquence du saut
  final double rotation; // rotation initiale [radians]
  final Color color;

  const _Leaf({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.jumpAmp,
    required this.jumpFreq,
    required this.rotation,
    required this.color,
  });

  factory _Leaf.random(Random rng, int index, int total) {
    const colors = [
      Color(0xFF5CB85C), // vert salade vif
      Color(0xFF4CAF50), // vert moyen
      Color(0xFF8BC34A), // vert lime
      Color(0xFF6DBF67), // vert clair
      Color(0xFF388E3C), // vert foncé
      Color(0xFF7CB342), // vert olive clair
    ];
    return _Leaf(
      x: rng.nextDouble(),
      y: 0.72 + rng.nextDouble() * 0.22,
      size: 5.0 + rng.nextDouble() * 7.0,
      phase: index / total,
      jumpAmp: 0.008 + rng.nextDouble() * 0.018,
      jumpFreq: 0.5 + rng.nextDouble() * 1.0,
      rotation: rng.nextDouble() * pi * 2,
      color: colors[rng.nextInt(colors.length)],
    );
  }
}

// ─────────────── DirtPuff (nuage de poussière) ───────────────

class _DirtPuff {
  final double startX;
  final double baseY;
  final double speed;
  final double size;
  final double opacity;
  final double phase;
  final double riseAmp;
  final Color color;

  const _DirtPuff({
    required this.startX,
    required this.baseY,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
    required this.riseAmp,
    required this.color,
  });

  factory _DirtPuff.random(Random rng, int index, int total) {
    const colors = [
      Color(0xFFAB7C45),
      Color(0xFF8B5E30),
      Color(0xFFC49A60),
      Color(0xFF7A4F28),
      Color(0xFFD4A870),
    ];
    return _DirtPuff(
      startX: index / total.toDouble(),
      baseY: 0.68 + rng.nextDouble() * 0.20,
      speed: 0.08 + rng.nextDouble() * 0.12,
      size: 5.0 + rng.nextDouble() * 10.0,
      opacity: 0.15 + rng.nextDouble() * 0.30,
      phase: index / total,
      riseAmp: 0.02 + rng.nextDouble() * 0.05,
      color: colors[rng.nextInt(colors.length)],
    );
  }
}

// ─────────────── Painter ───────────────

class _TurtlePainter extends CustomPainter {
  final List<_Leaf> leaves;
  final List<_DirtPuff> dirtPuffs;
  final double progress;

  const _TurtlePainter({
    required this.leaves,
    required this.dirtPuffs,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawDirtPuffs(canvas, size);
    _drawLeaves(canvas, size);
  }

  void _drawDirtPuffs(Canvas canvas, Size size) {
    for (final p in dirtPuffs) {
      final t = ((progress * p.speed + p.phase) % 1.0);
      final x = (p.startX + t / p.speed * p.speed) * size.width;
      final riseOffset = -sin(t * pi * 2) * p.riseAmp * size.height;
      final y = p.baseY * size.height + riseOffset;

      final fade = _fadeAlpha(t, fadeIn: 0.15, fadeOut: 0.20);
      final alpha = (fade * p.opacity).clamp(0.0, 1.0);
      if (alpha <= 0.01) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: p.size * 2.4,
          height: p.size,
        ),
        paint,
      );

      if (p.size > 8) {
        final trailPaint = Paint()
          ..color = p.color.withValues(alpha: alpha * 0.35)
          ..style = PaintingStyle.fill;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x - p.size * 1.5, y + p.size * 0.3),
            width: p.size * 1.6,
            height: p.size * 0.6,
          ),
          trailPaint,
        );
      }
    }
  }

  void _drawLeaves(Canvas canvas, Size size) {
    for (final leaf in leaves) {
      final jumpOffset =
          -sin((progress * leaf.jumpFreq + leaf.phase) * pi * 2).abs() *
              leaf.jumpAmp *
              size.height;

      final cx = leaf.x * size.width;
      final cy = leaf.y * size.height + jumpOffset;

      // Rotation légère qui oscille
      final angle = leaf.rotation + sin((progress * leaf.jumpFreq + leaf.phase) * pi * 2) * 0.3;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);

      // Ombre
      final shadowPaint = Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, leaf.size * 0.5),
          width: leaf.size * 1.8,
          height: leaf.size * 0.4,
        ),
        shadowPaint,
      );

      // Corps de la feuille (ovale)
      final leafPaint = Paint()
        ..color = leaf.color
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: leaf.size * 1.8,
          height: leaf.size * 1.1,
        ),
        leafPaint,
      );

      // Nervure centrale
      final veinPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..strokeWidth = leaf.size * 0.12
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(-leaf.size * 0.7, 0),
        Offset(leaf.size * 0.7, 0),
        veinPaint,
      );

      // Reflet
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.20)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(-leaf.size * 0.2, -leaf.size * 0.2),
          width: leaf.size * 0.5,
          height: leaf.size * 0.25,
        ),
        highlightPaint,
      );

      canvas.restore();
    }
  }

  double _fadeAlpha(
    double t, {
    required double fadeIn,
    required double fadeOut,
  }) {
    if (t < fadeIn) return t / fadeIn;
    if (t > 1.0 - fadeOut) return (1.0 - t) / fadeOut;
    return 1.0;
  }

  @override
  bool shouldRepaint(_TurtlePainter old) => old.progress != progress;
}
