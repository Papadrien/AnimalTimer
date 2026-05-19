import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay de feuilles de laitue tombantes pour la tortue.
/// Boucle infinie sans saccade : phases régulièrement espacées + fade sin(t·π).
class TurtleParticlesOverlay extends StatefulWidget {
  const TurtleParticlesOverlay({super.key});

  @override
  State<TurtleParticlesOverlay> createState() =>
      _TurtleParticlesOverlayState();
}

class _TurtleParticlesOverlayState extends State<TurtleParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_LettuceLeaf> _leaves;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = Random(42);
    // 10 feuilles (divisé par 2), phases régulièrement espacées → boucle sans discontinuité
    _leaves = List.generate(10, (i) => _LettuceLeaf.random(rng, i, 10));
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
          painter: _LettucePainter(
            leaves: _leaves,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─────────────── Modèle feuille de laitue ───────────────

class _LettuceLeaf {
  final double x;        // position X de départ [0..1]
  final double size;     // taille de base [px]
  final double phase;    // offset de boucle [0..1]
  final double driftX;   // dérive horizontale (fraction écran)
  final double spinRate; // tours pendant la chute
  final double initAngle;// angle initial
  final Color color;
  final Color veinColor;
  final int lobeCount;   // nb de lobes sur le bord (3–5)

  const _LettuceLeaf({
    required this.x,
    required this.size,
    required this.phase,
    required this.driftX,
    required this.spinRate,
    required this.initAngle,
    required this.color,
    required this.veinColor,
    required this.lobeCount,
  });

  factory _LettuceLeaf.random(Random rng, int index, int total) {
    // Nuances de vert laitue : vert tendre à vert foncé frisé
    const baseColors = [
      Color(0xFF6DB33F), // vert vif laitue
      Color(0xFF8CC63F), // vert lime tendre
      Color(0xFF4E9A2D), // vert feuille foncé
      Color(0xFFA8D45A), // vert pâle
      Color(0xFF5FAD3E), // vert moyen
      Color(0xFF3D8B2F), // vert sombre
    ];
    const veinColors = [
      Color(0xFF4A8A20),
      Color(0xFF5E9E30),
      Color(0xFF3A7A1A),
      Color(0xFF7AB040),
      Color(0xFF4A9025),
      Color(0xFF2E6E1A),
    ];

    final colorIdx = rng.nextInt(baseColors.length);
    return _LettuceLeaf(
      x: rng.nextDouble(),
      size: 14.0 + rng.nextDouble() * 14.0,
      // Phases uniformément réparties → jamais de trou entre boucles
      phase: index / total.toDouble(),
      driftX: (rng.nextDouble() - 0.5) * 0.15,
      spinRate: (rng.nextDouble() - 0.5) * 1.2, // lent, naturel
      initAngle: rng.nextDouble() * pi * 2,
      color: baseColors[colorIdx],
      veinColor: veinColors[colorIdx],
      lobeCount: 3 + rng.nextInt(3), // 3, 4 ou 5 lobes
    );
  }
}

// ─────────────── Painter ───────────────

class _LettucePainter extends CustomPainter {
  final List<_LettuceLeaf> leaves;
  final double progress;

  const _LettucePainter({
    required this.leaves,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final leaf in leaves) {
      _drawLettuceLeaf(canvas, size, leaf);
    }
  }

  void _drawLettuceLeaf(Canvas canvas, Size size, _LettuceLeaf leaf) {
    // t local [0..1] par feuille, cycle continu
    final t = (progress + leaf.phase) % 1.0;

    // Alpha : sin(t·π) → 0 en début et fin de cycle, 1 au milieu
    // Garantit une boucle parfaitement lisse sans flash
    // Fade in : on booste l'alpha en début de cycle (t < 0.15) pour un effet d'apparition fondue
    final rawAlpha = (sin(t * pi) * 0.704).clamp(0.0, 1.0); // opacité -20% (0.88 * 0.8)
    final fadeIn = (t / 0.15).clamp(0.0, 1.0); // fade in sur les 15% premiers du cycle
    final alpha = rawAlpha * fadeIn;
    if (alpha <= 0.01) return;

    // Chute de haut en bas (easeIn : accélère en tombant)
    final fall = t * t;
    final y = (-0.05 + fall * 1.10) * size.height;

    // Dérive latérale sinusoïdale (effet vol plané)
    final x = (leaf.x + sin(t * pi * 2) * leaf.driftX) * size.width;

    // Rotation progressive + balancement
    final angle = leaf.initAngle + t * leaf.spinRate * pi * 2
        + sin(t * pi * 3) * 0.25;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle);

    _drawLettucePath(canvas, leaf, alpha);

    canvas.restore();
  }

  /// Dessine une feuille de laitue lobée + nervures.
  void _drawLettucePath(Canvas canvas, _LettuceLeaf leaf, double alpha) {
    final s = leaf.size;
    final paint = Paint()
      ..color = leaf.color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    // ── Forme de base : feuille en goutte lobée ──
    // Construite en traçant un contour avec des lobes ondulés sur le dessus.
    final path = _buildLettucePath(s, leaf.lobeCount);

    // Légère ombre portée
    final shadowPaint = Paint()
      ..color = const Color(0x22000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, shadowPaint);

    // Corps de la feuille
    canvas.drawPath(path, paint);

    // Bord légèrement plus foncé (effet laitue frisée)
    final borderPaint = Paint()
      ..color = leaf.veinColor.withValues(alpha: alpha * 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.06
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, borderPaint);

    // ── Nervure centrale ──
    final veinPaint = Paint()
      ..color = leaf.veinColor.withValues(alpha: alpha * 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.09
      ..strokeCap = StrokeCap.round;
    final veinPath = Path()
      ..moveTo(0, s * 0.55)
      ..quadraticBezierTo(0, 0, 0, -s * 0.45);
    canvas.drawPath(veinPath, veinPaint);

    // ── Nervures secondaires (3 paires) ──
    final secVein = Paint()
      ..color = leaf.veinColor.withValues(alpha: alpha * 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.045
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final vy = (i - 1) * s * 0.22;
      final vx = s * (0.28 + i * 0.04);
      canvas.drawLine(Offset(0, vy), Offset(vx, vy - s * 0.12), secVein);
      canvas.drawLine(Offset(0, vy), Offset(-vx, vy - s * 0.12), secVein);
    }

    // ── Reflet (brillance laitue fraîche) ──
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: alpha * 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-s * 0.15, -s * 0.15),
        width: s * 0.4,
        height: s * 0.22,
      ),
      highlightPaint,
    );
  }

  /// Construit le Path d'une feuille de laitue avec [lobeCount] lobes.
  /// Forme : ovale allongé avec des ondulations sur le périmètre supérieur.
  Path _buildLettucePath(double s, int lobeCount) {
    final path = Path();
    // La feuille est centrée sur (0,0), pointe vers le bas.
    // On trace en coordonnées polaires modifiées pour créer des lobes.
    const steps = 80;
    bool first = true;

    for (int i = 0; i <= steps; i++) {
      // Angle : 0 = bas (queue), π = haut (bord lobé)
      // On trace tout le contour
      final angle = (i / steps) * pi * 2;

      // Rayon de base : ovale allongé verticalement
      final baseR = s *
          (0.55 * cos(angle) * cos(angle) + 0.95 * sin(angle) * sin(angle))
              .clamp(0.3, 1.0);

      // Modulation lobes : seulement sur la moitié supérieure (angle ≈ π/2 à 3π/2)
      // sin(angle)>0 → partie haute
      final lobeDepth = sin(angle).clamp(0.0, 1.0);
      final lobe = 1.0 + lobeDepth * 0.28 * sin(lobeCount * angle + pi * 0.5);

      final r = baseR * lobe;
      final px = r * cos(angle - pi / 2); // -π/2 pour orienter pointe vers bas
      final py = r * sin(angle - pi / 2);

      if (first) {
        path.moveTo(px, py);
        first = false;
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_LettucePainter old) => old.progress != progress;
}
