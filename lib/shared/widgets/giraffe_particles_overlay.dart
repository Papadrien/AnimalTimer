import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay girafe :
/// • Branche principale + branches secondaires qui se balancent
/// • Feuilles fixées sur TOUTES les branches (principale + secondaires)
/// • Feuilles tombantes sans saccade : phases uniformément espacées +
///   alpha sin(t·π) avec easeIn, même technique que la tortue.
class GiraffeParticlesOverlay extends StatefulWidget {
  const GiraffeParticlesOverlay({super.key});

  @override
  State<GiraffeParticlesOverlay> createState() =>
      _GiraffeParticlesOverlayState();
}

class _GiraffeParticlesOverlayState extends State<GiraffeParticlesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FallingLeaf> _fallingLeaves;
  late List<_BranchLeaf> _branchLeaves;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = Random(77);
    // 18 feuilles tombantes, phases uniformément espacées → boucle sans saccade
    _fallingLeaves = List.generate(18, (i) => _FallingLeaf.random(rng, i, 18));
    // Feuilles fixes : ~35 sur la branche principale, ~3–4 par branche secondaire
    _branchLeaves = _buildAllBranchLeaves(rng);
  }

  /// Génère les feuilles pour la branche principale ET les 5 branches secondaires.
  List<_BranchLeaf> _buildAllBranchLeaves(Random rng) {
    final leaves = <_BranchLeaf>[];

    // Branche principale : 35 feuilles (tBranch [0..1] → branche principale)
    for (int i = 0; i < 35; i++) {
      leaves.add(_BranchLeaf.onMain(rng));
    }

    // Branches secondaires : positions xFrac définies dans _GiraffePainter
    // sub0: xFrac=0.18, sub1: xFrac=0.32, sub2: xFrac=0.47, sub3: xFrac=0.60, sub4: xFrac=0.72
    const subBranchXFracs = [0.18, 0.32, 0.47, 0.60, 0.72];
    const subBranchDxFracs = [-0.055, 0.040, -0.050, 0.035, -0.040];
    const subBranchDyFracs = [0.045, 0.038, 0.050, 0.042, 0.035];

    for (int s = 0; s < subBranchXFracs.length; s++) {
      // 3 à 4 feuilles par branche secondaire
      final count = 3 + rng.nextInt(2);
      for (int i = 0; i < count; i++) {
        leaves.add(_BranchLeaf.onSub(
          rng,
          subIndex: s,
          xFrac: subBranchXFracs[s],
          dxFrac: subBranchDxFracs[s],
          dyFrac: subBranchDyFracs[s],
        ));
      }
    }

    return leaves;
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
            fallingLeaves: _fallingLeaves,
            branchLeaves: _branchLeaves,
            progress: _controller.value,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ─── Couleurs ───
const _leafColors = [
  Color(0xFF66BB6A),
  Color(0xFF4CAF50),
  Color(0xFF388E3C),
  Color(0xFF81C784),
  Color(0xFFA5D6A7),
  Color(0xFF2E7D32),
  Color(0xFFAED581),
  Color(0xFF558B2F),
];

// ─── Feuille tombante ───
class _FallingLeaf {
  final double x;
  final double size;
  final double phase;    // uniformément espacée → boucle sans discontinuité
  final double driftX;
  final double spinRate;
  final double initAngle;
  final Color color;

  const _FallingLeaf({
    required this.x,
    required this.size,
    required this.phase,
    required this.driftX,
    required this.spinRate,
    required this.initAngle,
    required this.color,
  });

  factory _FallingLeaf.random(Random rng, int index, int total) {
    return _FallingLeaf(
      x:         rng.nextDouble(),
      size:      6.0 + rng.nextDouble() * 8.0,
      // Phases uniformément réparties : même recette que la tortue
      phase:     index / total.toDouble(),
      driftX:    (rng.nextDouble() - 0.5) * 0.08,
      spinRate:  (rng.nextDouble() - 0.5) * 1.2,
      initAngle: rng.nextDouble() * pi * 2,
      color:     _leafColors[rng.nextInt(_leafColors.length)],
    );
  }
}

// ─── Feuille fixe sur une branche ───
enum _BranchType { main, sub }

class _BranchLeaf {
  final _BranchType branchType;
  final double tBranch;   // position sur la branche principale [0..1]
  final double offsetY;   // décalage Y relatif à la branche
  final double size;
  final double angle;
  final double swayPhase;
  final double swayAmp;
  final Color color;
  final bool above;

  // Pour les branches secondaires :
  final int subIndex;       // 0–4
  final double subXFrac;
  final double subDxFrac;
  final double subDyFrac;
  final double tSub;        // position le long de la branche secondaire [0..1]

  const _BranchLeaf({
    required this.branchType,
    required this.tBranch,
    required this.offsetY,
    required this.size,
    required this.angle,
    required this.swayPhase,
    required this.swayAmp,
    required this.color,
    required this.above,
    this.subIndex = 0,
    this.subXFrac = 0,
    this.subDxFrac = 0,
    this.subDyFrac = 0,
    this.tSub = 0,
  });

  factory _BranchLeaf.onMain(Random rng) {
    return _BranchLeaf(
      branchType: _BranchType.main,
      tBranch:    rng.nextDouble(),
      offsetY:    2.0 + rng.nextDouble() * 6.0,
      size:       7.0 + rng.nextDouble() * 11.0,
      angle:      (rng.nextDouble() - 0.5) * pi * 0.9,
      swayPhase:  rng.nextDouble() * pi * 2,
      swayAmp:    0.04 + rng.nextDouble() * 0.06,
      color:      _leafColors[rng.nextInt(_leafColors.length)],
      above:      rng.nextBool(),
    );
  }

  factory _BranchLeaf.onSub(
    Random rng, {
    required int subIndex,
    required double xFrac,
    required double dxFrac,
    required double dyFrac,
  }) {
    return _BranchLeaf(
      branchType: _BranchType.sub,
      tBranch:    0,
      offsetY:    1.5 + rng.nextDouble() * 4.0,
      size:       5.0 + rng.nextDouble() * 8.0,
      angle:      (rng.nextDouble() - 0.5) * pi * 0.8,
      swayPhase:  rng.nextDouble() * pi * 2,
      swayAmp:    0.04 + rng.nextDouble() * 0.07,
      color:      _leafColors[rng.nextInt(_leafColors.length)],
      above:      rng.nextBool(),
      subIndex:   subIndex,
      subXFrac:   xFrac,
      subDxFrac:  dxFrac,
      subDyFrac:  dyFrac,
      tSub:       rng.nextDouble(),
    );
  }
}

class _GiraffePainter extends CustomPainter {
  final List<_FallingLeaf> fallingLeaves;
  final List<_BranchLeaf>  branchLeaves;
  final double progress;

  const _GiraffePainter({
    required this.fallingLeaves,
    required this.branchLeaves,
    required this.progress,
  });

  static const double _branchY    = 0.07;
  static const double _branchSway = 0.012;

  // Calcule un point sur la courbe cubique principale
  Offset _branchPoint(double t, Size size, double sway) {
    final baseY = _branchY * size.height;
    final p0  = Offset(-0.05 * size.width, baseY + sway * 0.3);
    final cp1 = Offset(0.20  * size.width, baseY - 18 + sway * 0.5);
    final cp2 = Offset(0.55  * size.width, baseY + 12 + sway * 0.8);
    final p3  = Offset(0.78  * size.width, baseY + sway);
    final u = 1 - t;
    return Offset(
      u*u*u*p0.dx + 3*u*u*t*cp1.dx + 3*u*t*t*cp2.dx + t*t*t*p3.dx,
      u*u*u*p0.dy + 3*u*u*t*cp1.dy + 3*u*t*t*cp2.dy + t*t*t*p3.dy,
    );
  }

  /// Point le long d'une branche secondaire interpolé entre base et pointe.
  Offset _subBranchPoint(
      double t, Size size, double baseY, double swayFrac,
      double xFrac, double dxFrac, double dyFrac) {
    final sway = sin(progress * pi * 2) * _branchSway * size.height;
    final base  = Offset(xFrac * size.width, baseY + sway * swayFrac);
    final tip   = Offset(
      (xFrac + dxFrac) * size.width,
      baseY + sway * swayFrac - dyFrac * size.height,
    );
    return Offset(
      base.dx + t * (tip.dx - base.dx),
      base.dy + t * (tip.dy - base.dy),
    );
  }

  // Fraction de sway par index de branche secondaire
  static const _subSwayFracs = [0.3, 0.5, 0.7, 0.8, 0.9];
  static const _subDxFracs   = [-0.055, 0.040, -0.050, 0.035, -0.040];
  static const _subDyFracs   = [0.045, 0.038, 0.050, 0.042, 0.035];
  static const _subXFracs    = [0.18, 0.32, 0.47, 0.60, 0.72];

  @override
  void paint(Canvas canvas, Size size) {
    final sway  = sin(progress * pi * 2) * _branchSway * size.height;
    final baseY = _branchY * size.height;

    // ── Feuilles SOUS la branche (avant la branche) ──
    for (final l in branchLeaves) {
      if (!l.above) _drawBranchLeaf(canvas, size, l, sway, baseY);
    }

    // ── Branche principale + secondaires ──
    _drawSolidBranch(canvas, size, baseY, sway);

    // ── Feuilles AU-DESSUS de la branche ──
    for (final l in branchLeaves) {
      if (l.above) _drawBranchLeaf(canvas, size, l, sway, baseY);
    }

    // ── Feuilles tombantes (sans saccade) ──
    for (final l in fallingLeaves) {
      _drawFallingLeaf(canvas, size, l);
    }
  }

  void _drawSolidBranch(Canvas canvas, Size size, double baseY, double sway) {
    final p0  = Offset(-0.05 * size.width, baseY + sway * 0.3);
    final cp1 = Offset(0.20  * size.width, baseY - 18 + sway * 0.5);
    final cp2 = Offset(0.55  * size.width, baseY + 12 + sway * 0.8);
    final p3  = Offset(0.78  * size.width, baseY + sway);

    final branchPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p3.dx, p3.dy);
    canvas.drawPath(path, branchPaint);

    final highlightPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, highlightPaint);

    // Branches secondaires
    _drawSubBranch(canvas, size, 0.18, baseY + sway * 0.3, -0.055, 0.045, 6.0);
    _drawSubBranch(canvas, size, 0.32, baseY + sway * 0.5,  0.040, 0.038, 5.5);
    _drawSubBranch(canvas, size, 0.47, baseY + sway * 0.7, -0.050, 0.050, 5.0);
    _drawSubBranch(canvas, size, 0.60, baseY + sway * 0.8,  0.035, 0.042, 4.5);
    _drawSubBranch(canvas, size, 0.72, baseY + sway * 0.9, -0.040, 0.035, 4.0);
  }

  void _drawSubBranch(Canvas canvas, Size size, double xFrac, double y,
      double dxFrac, double dyFrac, double strokeW) {
    final x = xFrac * size.width;
    final paint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(x, y),
      Offset(x + dxFrac * size.width, y - dyFrac * size.height),
      paint,
    );
  }

  void _drawBranchLeaf(
      Canvas canvas, Size size, _BranchLeaf l, double sway, double baseY) {
    final Offset pt;
    if (l.branchType == _BranchType.main) {
      pt = _branchPoint(l.tBranch, size, sway);
    } else {
      pt = _subBranchPoint(
        l.tSub, size, baseY,
        _subSwayFracs[l.subIndex],
        _subXFracs[l.subIndex],
        _subDxFracs[l.subIndex],
        _subDyFracs[l.subIndex],
      );
    }
    final sign = l.above ? -1.0 : 1.0;
    final pos  = Offset(pt.dx, pt.dy + sign * l.offsetY);
    final angle = l.angle + sin(progress * pi * 2 + l.swayPhase) * l.swayAmp;
    _paintLeaf(canvas, pos, l.color, l.size, angle, 0.90);
  }

  /// Chute sans saccade — calquée sur la tortue :
  /// • phase uniformément espacée → pas de "trou" entre boucles
  /// • alpha = sin(t·π) × easeIn → fondu entrée/sortie parfait
  void _drawFallingLeaf(Canvas canvas, Size size, _FallingLeaf l) {
    final t = (progress + l.phase) % 1.0;

    // Alpha sin(t·π) : 0 en début et fin, pic au milieu → boucle lisse
    final rawAlpha = sin(t * pi) * 0.85;
    // Fade-in progressif sur 25% du cycle (easeIn quadratique)
    final fadeInLinear = (t / 0.25).clamp(0.0, 1.0);
    final fadeIn = fadeInLinear * fadeInLinear;
    final alpha  = (rawAlpha * fadeIn).clamp(0.0, 1.0);
    if (alpha <= 0.01) return;

    // Chute avec légère accélération (easeIn)
    final fall = t * t;
    final y = (_branchY + fall * (1.05 - _branchY)) * size.height;

    // Dérive sinusoïdale latérale
    final x = (l.x + sin(t * pi * 2) * l.driftX) * size.width;

    // Rotation progressive
    final rotation = l.initAngle + t * l.spinRate * pi * 2
        + sin(t * pi * 3) * 0.20;

    _paintLeaf(canvas, Offset(x, y), l.color, l.size, rotation, alpha);
  }

  void _paintLeaf(Canvas canvas, Offset center, Color color, double size,
      double angle, double alpha) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size * 0.65, height: size * 1.6),
      Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill,
    );
    canvas.drawLine(
      Offset(0, -size * 0.7), Offset(0, size * 0.7),
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
