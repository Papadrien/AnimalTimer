import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay T-Rex : braises rugissantes montant du bas vers le haut,
/// sur le même principe que les flammes du dragon (FireParticlesOverlay :
/// montée, scintillement, fondu en entrée/sortie), mais rendues comme de
/// petites étincelles rondes avec halo flou plutôt que des silhouettes
/// de flamme — un souffle plus sobre, comme s'il volait d'un rugissement.
class TrexParticlesOverlay extends StatefulWidget {
  const TrexParticlesOverlay({super.key});

  @override
  State<TrexParticlesOverlay> createState() => _TrexParticlesOverlayState();
}

class _TrexParticlesOverlayState extends State<TrexParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Ember> _embers;
  final Random _rng = Random(53);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _embers = List.generate(26, (i) => _Ember.random(_rng, i, 26));
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
          painter: _EmberParticlesPainter(
            embers: _embers,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _Ember {
  final double x;
  final double speed;
  final double size;
  final double opacity;
  final double phase;
  final double drift;
  final double flickerSpeed;
  final int colorIndex;

  const _Ember({
    required this.x,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
    required this.drift,
    required this.flickerSpeed,
    required this.colorIndex,
  });

  factory _Ember.random(Random rng, int index, int total) {
    return _Ember(
      x: rng.nextDouble(),
      speed: 0.55 + rng.nextDouble() * 0.55,
      size: 2.5 + rng.nextDouble() * 3.0,
      opacity: 0.45 + rng.nextDouble() * 0.4,
      phase: index / total + rng.nextDouble() * 0.02,
      drift: 0.015 + rng.nextDouble() * 0.03,
      flickerSpeed: 3.0 + rng.nextDouble() * 3.0,
      colorIndex: rng.nextInt(3),
    );
  }
}

class _EmberParticlesPainter extends CustomPainter {
  final List<_Ember> embers;
  final double progress;

  const _EmberParticlesPainter({required this.embers, required this.progress});

  static const _emberColors = [
    Color(0xFFFF5A1F), // orange-rouge braise
    Color(0xFFFF7A1A), // orange vif
    Color(0xFFFFB300), // ambre
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final e in embers) {
      final t = (progress + e.phase) % 1.0;

      // Trajectoire verticale : monte du bas (1.1) vers le haut (-0.1),
      // toujours hors écran à l'apparition et à la disparition.
      final normY = 1.1 - t * 1.2;
      final y = normY * size.height;

      final x = (e.x + sin(t * pi * 2 + e.phase * pi * 2) * e.drift) *
          size.width;

      final fade = _fadeAlpha(t, fadeIn: 0.15, fadeOut: 0.15);
      final flicker = 0.75 + 0.25 * sin(t * pi * e.flickerSpeed);
      final alpha = (e.opacity * flicker * fade).clamp(0.0, 0.65);
      if (alpha <= 0.01) continue;

      // La braise rapetisse légèrement en montant, comme si elle s'éteignait.
      final emberSize = e.size * (1.0 - 0.3 * t);

      _drawEmber(canvas, Offset(x, y), emberSize, alpha, e.colorIndex);
    }
  }

  double _fadeAlpha(double t, {required double fadeIn, required double fadeOut}) {
    if (t < fadeIn) return t / fadeIn;
    if (t > 1.0 - fadeOut) return (1.0 - t) / fadeOut;
    return 1.0;
  }

  /// Point lumineux rond avec halo flou, plutôt qu'une silhouette de flamme.
  void _drawEmber(Canvas canvas, Offset center, double size, double alpha, int colorIndex) {
    final color = _emberColors[colorIndex];
    const innerColor = Color(0xFFFFE066); // coeur jaune, comme la flamme du dragon

    // Halo doux, plus large que la particule elle-même.
    final halo = Paint()
      ..color = color.withValues(alpha: alpha * 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, size * 2.2, halo);

    // Corps de la braise.
    final fill = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size, fill);

    // Coeur clair au centre, pour l'effet de point lumineux.
    final innerFill = Paint()
      ..color = innerColor.withValues(alpha: alpha * 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size * 0.45, innerFill);
  }

  @override
  bool shouldRepaint(_EmberParticlesPainter old) => old.progress != progress;
}
