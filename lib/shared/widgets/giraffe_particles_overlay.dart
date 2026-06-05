import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay girafe : branche qui se balance en haut + feuilles qui tombent
/// avec fade-in depuis la branche et sortent en bas de l'écran.
class GiraffeParticlesOverlay extends StatefulWidget {
  const GiraffeParticlesOverlay({super.key});

  @override
  State<GiraffeParticlesOverlay> createState() =>
      _GiraffeParticlesOverlayState();
}

class _GiraffeParticlesOverlayState extends State<GiraffeParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_LeafParticle> _leaves;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = Random(77);
    _leaves = List.generate(18, (i) => _LeafParticle.random(rng, i, 18));
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
          painter: _GiraffePainter(
            leaves: _leaves,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─── Couleurs feuilles tropicales ───
const _leafColors = [
  Color(0xFF66BB6A),
  Color(0xFF4CAF50),
  Color(0xFF388E3C),
  Color(0xFF81C784),
  Color(0xFFA5D6A7),
  Color(0xFF2E7D32),
  Color(0xFFAED581),
];

class _LeafParticle {
  final double x;        // position X de départ normalisée [0..1]
  final double size;     // taille de base
  final double phase;    // offset boucle [0..1]
  final double driftX;   // dérive horizontale
  final double speed;    // vitesse relative (1.0 = normale)
  final Color color;
  final double rotation; // rotation initiale

  const _LeafParticle({
    required this.x,
    required this.size,
    required this.phase,
    required this.driftX,
    required this.speed,
    required this.color,
    required this.rotation,
  });

  factory _LeafParticle.random(Random rng, int index, int total) {
    return _LeafParticle(
      x: rng.nextDouble(),
      size: 6.0 + rng.nextDouble() * 8.0,
      phase: index / total.toDouble(),
      driftX: (rng.nextDouble() - 0.5) * 0.08,
      speed: 0.7 + rng.nextDouble() * 0.6,
      color: _leafColors[rng.nextInt(_leafColors.length)],
      rotation: rng.nextDouble() * pi * 2,
    );
  }
}

class _GiraffePainter extends CustomPainter {
  final List<_LeafParticle> leaves;
  final double progress;

  const _GiraffePainter({required this.leaves, required this.progress});

  // Branche : part du bord gauche (légèrement hors écran) vers le milieu
  static const double _branchY = 0.07;   // hauteur relative de la branche
  static const double _branchSwayAmp = 0.012; // amplitude de balancement (fraction h)

  @override
  void paint(Canvas canvas, Size size) {
    _drawBranch(canvas, size);
    for (final l in leaves) {
      _drawLeaf(canvas, size, l);
    }
  }

  void _drawBranch(Canvas canvas, Size size) {
    // La branche se balance doucement en vertical
    final sway = sin(progress * pi * 2) * _branchSwayAmp * size.height;
    final baseY = _branchY * size.height;

    // Branche principale : de x=-0.05 (hors écran gauche) à x=0.75
    final p0 = Offset(-0.05 * size.width, baseY + sway * 0.3);
    final p3 = Offset(0.78 * size.width, baseY + sway);

    // Points de contrôle pour une légère courbe organique
    final cp1 = Offset(0.20 * size.width, baseY - 18 + sway * 0.5);
    final cp2 = Offset(0.55 * size.width, baseY + 12 + sway * 0.8);

    final branchPaint = Paint()
      ..color = const Color(0xFF5D4037).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p3.dx, p3.dy);
    canvas.drawPath(path, branchPaint);

    // Petites branches secondaires
    _drawSubBranch(canvas, size, 0.25, baseY + sway * 0.5, -0.06, 0.04, 5.0);
    _drawSubBranch(canvas, size, 0.50, baseY + sway * 0.7, -0.05, 0.05, 4.0);
    _drawSubBranch(canvas, size, 0.68, baseY + sway * 0.9, -0.04, 0.03, 3.5);

    // Feuilles fixes sur la branche (décoratives)
    _drawBranchLeaves(canvas, size, baseY, sway);
  }

  void _drawSubBranch(Canvas canvas, Size size, double xFrac, double y,
      double dxFrac, double dyFrac, double strokeW) {
    final x = xFrac * size.width;
    final paint = Paint()
      ..color = const Color(0xFF6D4C41).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(x, y),
      Offset(x + dxFrac * size.width, y - dyFrac * size.height),
      paint,
    );
  }

  void _drawBranchLeaves(Canvas canvas, Size size, double baseY, double sway) {
    const leafPositions = [0.18, 0.30, 0.42, 0.56, 0.70];
    const leafColors2 = [
      Color(0xFF66BB6A),
      Color(0xFF4CAF50),
      Color(0xFF81C784),
      Color(0xFF388E3C),
      Color(0xFFA5D6A7),
    ];
    for (int i = 0; i < leafPositions.length; i++) {
      final x = leafPositions[i] * size.width;
      final y = baseY + sway * leafPositions[i] - 8;
      final angle = (i % 2 == 0 ? -0.4 : 0.4) + sin(progress * pi * 2 + i) * 0.08;
      _paintLeaf(canvas, Offset(x, y), leafColors2[i], 9.0, angle, 0.82);
    }
  }

  void _drawLeaf(Canvas canvas, Size size, _LeafParticle l) {
    // t local [0,1] cyclique avec phase décalée
    final t = (progress * l.speed + l.phase) % 1.0;

    // Fade-in depuis la branche : apparaît en haut, tombe vers le bas
    // La feuille part de juste sous la branche (y ≈ branchY + fadeZone)
    // et tombe jusqu'en bas de l'écran (y > 1.0)
    final fallY = _branchY + t * (1.05 - _branchY); // de branchY à 1.05
    final y = fallY * size.height;

    // Fade in sur les premiers 10% du trajet, opaque ensuite
    final fadeIn = (t / 0.10).clamp(0.0, 1.0);
    final alpha = (fadeIn * 0.85).clamp(0.0, 1.0);
    if (alpha <= 0.01) return;

    final x = (l.x + sin(t * pi * 1.5) * l.driftX) * size.width;
    final rotation = l.rotation + t * pi * 1.2;

    _paintLeaf(canvas, Offset(x, y), l.color, l.size, rotation, alpha);
  }

  void _paintLeaf(Canvas canvas, Offset center, Color color, double size,
      double angle, double alpha) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    // Forme feuille ovale
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: size * 0.65, height: size * 1.6),
      paint,
    );

    // Nervure centrale
    canvas.drawLine(
      Offset(0, -size * 0.7),
      Offset(0, size * 0.7),
      Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GiraffePainter old) => old.progress != progress;
}
