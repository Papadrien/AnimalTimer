import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de particules "cailloux et terre soulevée" pour la tortue.
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
  late List<_Pebble> _pebbles;
  late List<_DirtPuff> _dirtPuffs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    final rng = Random(42);
    _pebbles = List.generate(18, (i) => _Pebble.random(rng, i, 18));
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
            pebbles: _pebbles,
            dirtPuffs: _dirtPuffs,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─────────────── Pebble (caillou) ───────────────

class _Pebble {
  final double x;        // position X fixe [0..1]
  final double y;        // position Y fixe [0..1] — bas de l'écran
  final double size;     // rayon [px]
  final double phase;    // offset animation [0..1]
  final double jumpAmp;  // amplitude saut vertical [0..1]
  final double jumpFreq; // fréquence du saut
  final Color color;

  const _Pebble({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.jumpAmp,
    required this.jumpFreq,
    required this.color,
  });

  factory _Pebble.random(Random rng, int index, int total) {
    const colors = [
      Color(0xFF8B6B45),
      Color(0xFF6B4F30),
      Color(0xFFA07850),
      Color(0xFF5C3D1E),
      Color(0xFF9C7A55),
      Color(0xFF7A5C38),
    ];
    return _Pebble(
      x: rng.nextDouble(),
      y: 0.72 + rng.nextDouble() * 0.22,
      size: 3.5 + rng.nextDouble() * 5.0,
      // phase espacée uniformément pour éviter la synchronisation visible
      phase: index / total,
      jumpAmp: 0.008 + rng.nextDouble() * 0.018,
      jumpFreq: 0.5 + rng.nextDouble() * 1.0,
      color: colors[rng.nextInt(colors.length)],
    );
  }
}

// ─────────────── DirtPuff (nuage de terre) ───────────────

class _DirtPuff {
  final double startX; // X de départ [0..1]
  final double baseY;  // Y de base [0..1]
  final double speed;  // vitesse défilement [fraction/cycle]
  final double size;
  final double opacity;
  final double phase;
  final double riseAmp; // amplitude montée [0..1]
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
      // Répartition uniforme sur X pour éviter saccade au début du cycle
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
  final List<_Pebble> pebbles;
  final List<_DirtPuff> dirtPuffs;
  final double progress;

  const _TurtlePainter({
    required this.pebbles,
    required this.dirtPuffs,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawDirtPuffs(canvas, size);
    _drawPebbles(canvas, size);
  }

  void _drawDirtPuffs(Canvas canvas, Size size) {
    for (final p in dirtPuffs) {
      // t local : défilement continu sans saut (modulo 1.0)
      final t = ((progress * p.speed + p.phase) % 1.0);

      final x = (p.startX + t / p.speed * p.speed) * size.width;
      // montée douce puis redescente avec sin
      final riseOffset = -sin(t * pi * 2) * p.riseAmp * size.height;
      final y = p.baseY * size.height + riseOffset;

      // Fade in 15%, plateau, fade out 20%
      final fade = _fadeAlpha(t, fadeIn: 0.15, fadeOut: 0.20);
      final alpha = (fade * p.opacity).clamp(0.0, 1.0);
      if (alpha <= 0.01) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      // Nuage ovale aplati
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: p.size * 2.4,
          height: p.size,
        ),
        paint,
      );

      // Petite trace de poussière derrière
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

  void _drawPebbles(Canvas canvas, Size size) {
    for (final p in pebbles) {
      // Oscillation verticale douce (saut)
      final jumpOffset =
          -sin((progress * p.jumpFreq + p.phase) * pi * 2).abs() *
              p.jumpAmp *
              size.height;

      final cx = p.x * size.width;
      final cy = p.y * size.height + jumpOffset;

      // Ombre
      final shadowPaint = Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, p.y * size.height + p.size * 0.3),
          width: p.size * 1.8,
          height: p.size * 0.5,
        ),
        shadowPaint,
      );

      // Corps principal du caillou
      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: p.size * 1.6,
          height: p.size * 1.2,
        ),
        paint,
      );

      // Reflet (highlight)
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - p.size * 0.25, cy - p.size * 0.28),
          width: p.size * 0.5,
          height: p.size * 0.3,
        ),
        highlightPaint,
      );
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
