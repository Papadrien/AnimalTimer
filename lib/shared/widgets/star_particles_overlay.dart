import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de particules "étoiles" tombant doucement, pour la licorne.
/// Étoiles à 4, 5 ou 6 branches. Chute continue avec léger drift horizontal.
/// Fade in/out fluide pour éviter toute saccade, même si la particule
/// apparaît ou disparaît à l'intérieur de l'écran.
class StarParticlesOverlay extends StatefulWidget {
  const StarParticlesOverlay({super.key});

  @override
  State<StarParticlesOverlay> createState() => _StarParticlesOverlayState();
}

class _StarParticlesOverlayState extends State<StarParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_StarParticle> _particles;
  final Random _rng = Random(73);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _particles = List.generate(32, (i) => _StarParticle.random(_rng, i, 32));
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
          painter: _StarParticlesPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _StarParticle {
  final double x;          // position horizontale normalisée [0..1]
  final double speed;      // vitesse de chute (fraction de hauteur par cycle)
  final double size;       // rayon extérieur en pixels
  final double opacity;    // opacité max
  final double phase;      // décalage temporel [0..1)
  final double drift;      // amplitude du balancement horizontal
  final double rotation;   // rotation de base (rad)
  final double spinSpeed;  // vitesse de rotation (tours par cycle)
  final int points;        // 4, 5 ou 6 branches
  final int rainbowIndex; // index dans la palette arc-en-ciel (0..6)

  const _StarParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
    required this.drift,
    required this.rotation,
    required this.spinSpeed,
    required this.points,
    required this.rainbowIndex,
  });

  factory _StarParticle.random(Random rng, int index, int total) {
    // Choix des branches parmi 4, 5, 6 (équiréparti)
    final pts = [4, 5, 6][rng.nextInt(3)];
    return _StarParticle(
      x: rng.nextDouble(),
      speed: 0.55 + rng.nextDouble() * 0.55, // descente douce
      size: 4.0 + rng.nextDouble() * 7.0,
      opacity: 0.45 + rng.nextDouble() * 0.45,
      // Phase décalée pour étaler les apparitions dans le temps
      phase: index / total + rng.nextDouble() * 0.02,
      drift: 0.01 + rng.nextDouble() * 0.025,
      rotation: rng.nextDouble() * 2 * pi,
      spinSpeed: (rng.nextBool() ? 1 : -1) * (0.2 + rng.nextDouble() * 0.6),
      points: pts,
      // Couleur arc-en-ciel fixe par étoile, cyclée sur les 7 couleurs
      rainbowIndex: index % 7,
    );
  }
}

class _StarParticlesPainter extends CustomPainter {
  final List<_StarParticle> particles;
  final double progress;

  const _StarParticlesPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress + p.phase) % 1.0;

      // Trajectoire verticale : de -0.1 (au-dessus de l'écran) à 1.1 (en-dessous)
      // Parcourt 1.2 * hauteur au total, ainsi l'apparition et la disparition
      // se font systématiquement HORS écran -> pas de pop-in visible.
      final normY = -0.1 + t * 1.2;
      final y = normY * size.height;

      final x = (p.x + sin(t * pi * 2 + p.phase * pi * 2) * p.drift) *
          size.width;

      // Fade doux sur 15% d'entrée et 15% de sortie dans le cycle.
      // Même si la particule était encore à l'écran, cela évite toute
      // coupure brutale à la boucle.
      final fade = _fadeAlpha(t, fadeIn: 0.15, fadeOut: 0.15);
      final alpha = (p.opacity * fade).clamp(0.0, 1.0);
      if (alpha <= 0.01) continue;

      final angle = p.rotation + t * p.spinSpeed * 2 * pi;
      final color = _starColor(p.rainbowIndex);

      _drawStar(
        canvas,
        Offset(x, y),
        p.size,
        angle,
        p.points,
        color,
        alpha,
      );
    }
  }

  double _fadeAlpha(double t, {required double fadeIn, required double fadeOut}) {
    if (t < fadeIn) return t / fadeIn;
    if (t > 1.0 - fadeOut) return (1.0 - t) / fadeOut;
    return 1.0;
  }

  // 7 couleurs arc-en-ciel pastel, une par étoile (fixe à l'apparition).
  Color _starColor(int rainbowIndex) {
    const palette = <Color>[
      Color(0xFFFF6B6B), // rouge
      Color(0xFFFFAA55), // orange
      Color(0xFFFFE566), // jaune
      Color(0xFF6BDD6B), // vert
      Color(0xFF55BBFF), // bleu ciel
      Color(0xFF5566FF), // indigo
      Color(0xFFCC77FF), // violet
    ];
    return palette[rainbowIndex % palette.length];
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double outerRadius,
    double angle,
    int points,
    Color color,
    double alpha,
  ) {
    final innerRadius = outerRadius * _innerRatio(points);
    final path = Path();
    final step = pi / points;
    for (int i = 0; i < points * 2; i++) {
      final r = (i.isEven) ? outerRadius : innerRadius;
      final a = angle - pi / 2 + i * step;
      final px = center.dx + cos(a) * r;
      final py = center.dy + sin(a) * r;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();

    // Halo doux
    final halo = Paint()
      ..color = color.withValues(alpha: alpha * 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, outerRadius * 1.4, halo);

    // Corps de l'étoile
    final fill = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fill);

    // Liseré blanc subtil pour la lisibilité
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: alpha * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, stroke);
  }

  // Ratio inner/outer pour que les étoiles gardent une belle silhouette
  // quel que soit le nombre de branches.
  double _innerRatio(int points) {
    switch (points) {
      case 4:
        return 0.38;
      case 5:
        return 0.45;
      case 6:
        return 0.52;
      default:
        return 0.45;
    }
  }

  @override
  bool shouldRepaint(_StarParticlesPainter old) => old.progress != progress;
}
