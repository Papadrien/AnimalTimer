import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay girafe :
/// • 6 branches secondaires (5 vers le haut + 1 vers le bas) + 1 tertiaire par secondaire
/// • Feuilles abondantes sur secondaires et tertiaires
/// • Feuilles tombantes sans saccade (même technique que la tortue)
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
    _fallingLeaves = List.generate(18, (i) => _FallingLeaf.random(rng, i, 18));
    _branchLeaves  = _buildAllBranchLeaves(rng);
  }

  List<_BranchLeaf> _buildAllBranchLeaves(Random rng) {
    final leaves = <_BranchLeaf>[];

    // ── 6 branches secondaires ──
    // Les 5 premières montent, la 6e descend (branche inférieure)
    for (int s = 0; s < _SubBranches.count; s++) {
      // Secondaire : 10–12 feuilles
      final countSec = 10 + rng.nextInt(3);
      for (int i = 0; i < countSec; i++) {
        leaves.add(_BranchLeaf.onSub(rng, subIndex: s));
      }
      // Tertiaire rattachée à cette secondaire : 7–9 feuilles
      final countTer = 7 + rng.nextInt(3);
      for (int i = 0; i < countTer; i++) {
        leaves.add(_BranchLeaf.onTertiary(rng, parentSubIndex: s));
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
            branchLeaves:  _branchLeaves,
            progress:      _controller.value,
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

// ─── Définition statique des 6 branches secondaires ───
// Chaque secondaire : (xFrac, dxFrac, dyFrac, swayFrac, strokeW)
// dyFrac > 0 → monte  |  dyFrac < 0 → descend (branche inférieure)
class _SubBranches {
  static const int count = 6;

  // xFrac : position X de départ sur la branche principale [0..1]
  static const xFracs    = [0.18,  0.32,  0.47,  0.60,  0.72,  0.40 ];
  // dxFrac : déplacement X de la pointe
  static const dxFracs   = [-0.055, 0.040, -0.050, 0.035, -0.040,  0.045];
  // dyFrac : déplacement Y de la pointe (positif = monte, négatif = descend)
  static const dyFracs   = [ 0.045, 0.038,  0.050, 0.042,  0.035, -0.055];
  // swayFrac : fraction du sway principal appliquée à la base
  static const swayFracs = [ 0.3,   0.5,    0.7,   0.8,    0.9,   0.55 ];
  // strokeW : épaisseur de trait
  static const strokeWs  = [ 6.0,   5.5,    5.0,   4.5,    4.0,   5.0  ];

  // Tertiaires : chaque secondaire a une tertiaire partant de t=0.6 sur la secondaire
  // dxFrac et dyFrac de la tertiaire (perpendiculaire à la secondaire)
  static const terDxFracs = [ 0.030, -0.025,  0.028, -0.022,  0.025, -0.030];
  static const terDyFracs = [ 0.030,  0.025,  0.032,  0.028,  0.022,  0.025];
  static const terStrokeWs = [3.5,    3.0,    3.0,    2.8,    2.5,    3.0  ];
}

// ─── Feuille tombante ───
class _FallingLeaf {
  final double x;
  final double size;
  final double phase;
  final double driftX;
  final double spinRate;
  final double initAngle;
  final Color  color;

  const _FallingLeaf({
    required this.x, required this.size, required this.phase,
    required this.driftX, required this.spinRate,
    required this.initAngle, required this.color,
  });

  factory _FallingLeaf.random(Random rng, int index, int total) {
    return _FallingLeaf(
      x:         rng.nextDouble(),
      size:      6.0 + rng.nextDouble() * 8.0,
      phase:     index / total.toDouble(),
      driftX:    (rng.nextDouble() - 0.5) * 0.08,
      spinRate:  (rng.nextDouble() - 0.5) * 1.2,
      initAngle: rng.nextDouble() * pi * 2,
      color:     _leafColors[rng.nextInt(_leafColors.length)],
    );
  }
}

// ─── Types de branche ───
enum _BranchType { main, sub, tertiary }

// ─── Feuille fixe ───
class _BranchLeaf {
  final _BranchType branchType;
  final double offsetY;
  final double size;
  final double angle;
  final double swayPhase;
  final double swayAmp;
  final Color  color;
  final bool   above;

  // sub / tertiary
  final int    subIndex;       // index branche secondaire (0–5)
  final double tSub;           // position [0..1] sur la secondaire

  // tertiary uniquement
  final double tTer;           // position [0..1] sur la tertiaire

  const _BranchLeaf({
    required this.branchType,
    required this.offsetY, required this.size,
    required this.angle, required this.swayPhase,
    required this.swayAmp, required this.color, required this.above,
    this.subIndex = 0,
    this.tSub    = 0,
    this.tTer    = 0,
  });

  factory _BranchLeaf.onSub(Random rng, {required int subIndex}) => _BranchLeaf(
    branchType: _BranchType.sub,
    subIndex:  subIndex,
    tSub:      rng.nextDouble(),
    offsetY:   3.0 + rng.nextDouble() * 12.0,
    size:      5.0 + rng.nextDouble() * 10.0,
    angle:     (rng.nextDouble() - 0.5) * pi * 0.9,
    swayPhase: rng.nextDouble() * pi * 2,
    swayAmp:   0.04 + rng.nextDouble() * 0.07,
    color:     _leafColors[rng.nextInt(_leafColors.length)],
    above:     rng.nextBool(),
  );

  factory _BranchLeaf.onTertiary(Random rng, {required int parentSubIndex}) => _BranchLeaf(
    branchType: _BranchType.tertiary,
    subIndex:  parentSubIndex,
    tSub:      0.6,
    tTer:      rng.nextDouble(),
    offsetY:   2.5 + rng.nextDouble() * 10.0,
    size:      4.0 + rng.nextDouble() * 8.0,
    angle:     (rng.nextDouble() - 0.5) * pi * 0.8,
    swayPhase: rng.nextDouble() * pi * 2,
    swayAmp:   0.05 + rng.nextDouble() * 0.08,
    color:     _leafColors[rng.nextInt(_leafColors.length)],
    above:     rng.nextBool(),
  );
}

// ─── Painter ───
class _GiraffePainter extends CustomPainter {
  final List<_FallingLeaf> fallingLeaves;
  final List<_BranchLeaf>  branchLeaves;
  final double progress;

  const _GiraffePainter({
    required this.fallingLeaves,
    required this.branchLeaves,
    required this.progress,
  });

  static const double _mainBranchY = 0.03;
  static const double _branchSway  = 0.012;

  // ── Base et pointe d'une branche secondaire ──
  ({Offset base, Offset tip}) _subEndpoints(int s, Size size, double baseY, double sway) {
    final xFrac   = _SubBranches.xFracs[s];
    final swayFrac = _SubBranches.swayFracs[s];
    final base = Offset(xFrac * size.width, baseY + sway * swayFrac);
    final tip  = Offset(
      (xFrac + _SubBranches.dxFracs[s]) * size.width,
      baseY + sway * swayFrac - _SubBranches.dyFracs[s] * size.height,
    );
    return (base: base, tip: tip);
  }

  Offset _subPoint(int s, double t, Size size, double baseY, double sway) {
    final ep = _subEndpoints(s, size, baseY, sway);
    return Offset(
      ep.base.dx + t * (ep.tip.dx - ep.base.dx),
      ep.base.dy + t * (ep.tip.dy - ep.base.dy),
    );
  }

  // ── Point sur une tertiaire (part de tSub=0.6 sur la secondaire) ──
  Offset _terPoint(int s, double tSub, double tTer, Size size, double baseY, double sway) {
    final origin = _subPoint(s, tSub, size, baseY, sway);
    final tip = Offset(
      origin.dx + _SubBranches.terDxFracs[s] * size.width,
      origin.dy - _SubBranches.terDyFracs[s] * size.height,
    );
    return Offset(
      origin.dx + tTer * (tip.dx - origin.dx),
      origin.dy + tTer * (tip.dy - origin.dy),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final sway  = sin(progress * pi * 2) * _branchSway * size.height;
    final baseY = _mainBranchY * size.height;

    // Feuilles SOUS les branches
    for (final l in branchLeaves) {
      if (!l.above) _drawBranchLeaf(canvas, size, l, sway, baseY);
    }

    // Branches
    _drawAllBranches(canvas, size, baseY, sway);

    // Feuilles AU-DESSUS des branches
    for (final l in branchLeaves) {
      if (l.above) _drawBranchLeaf(canvas, size, l, sway, baseY);
    }

    // Feuilles tombantes
    for (final l in fallingLeaves) {
      _drawFallingLeaf(canvas, size, l);
    }
  }

  void _drawAllBranches(Canvas canvas, Size size, double baseY, double sway) {
    // Secondaires + tertiaires
    for (int s = 0; s < _SubBranches.count; s++) {
      final ep = _subEndpoints(s, size, baseY, sway);

      // Secondaire
      canvas.drawLine(ep.base, ep.tip, Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _SubBranches.strokeWs[s]
        ..strokeCap = StrokeCap.round);

      // Tertiaire
      final terOrigin = _subPoint(s, 0.6, size, baseY, sway);
      final terTip = Offset(
        terOrigin.dx + _SubBranches.terDxFracs[s] * size.width,
        terOrigin.dy - _SubBranches.terDyFracs[s] * size.height,
      );
      canvas.drawLine(terOrigin, terTip, Paint()
        ..color = const Color(0xFF6D4C41)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _SubBranches.terStrokeWs[s]
        ..strokeCap = StrokeCap.round);
    }
  }

  void _drawBranchLeaf(
      Canvas canvas, Size size, _BranchLeaf l, double sway, double baseY) {
    final Offset pt = switch (l.branchType) {
      _BranchType.sub       => _subPoint(l.subIndex, l.tSub, size, baseY, sway),
      _BranchType.tertiary  => _terPoint(l.subIndex, l.tSub, l.tTer, size, baseY, sway),
      _BranchType.main      => throw StateError('Unexpected main branch leaf'),
    };
    final sign  = l.above ? -1.0 : 1.0;
    final pos   = Offset(pt.dx, pt.dy + sign * l.offsetY);
    final angle = l.angle + sin(progress * pi * 2 + l.swayPhase) * l.swayAmp;
    _paintLeaf(canvas, pos, l.color, l.size, angle, 0.90);
  }

  void _drawFallingLeaf(Canvas canvas, Size size, _FallingLeaf l) {
    final t = (progress + l.phase) % 1.0;

    final rawAlpha      = sin(t * pi) * 0.85;
    final fadeInLinear  = (t / 0.25).clamp(0.0, 1.0);
    final fadeIn        = fadeInLinear * fadeInLinear;
    final alpha         = (rawAlpha * fadeIn).clamp(0.0, 1.0);
    if (alpha <= 0.01) return;

    final fall = t * t;
    final y    = (_mainBranchY + fall * (1.05 - _mainBranchY)) * size.height;
    final x    = (l.x + sin(t * pi * 2) * l.driftX) * size.width;
    final rot  = l.initAngle + t * l.spinRate * pi * 2 + sin(t * pi * 3) * 0.20;

    _paintLeaf(canvas, Offset(x, y), l.color, l.size, rot, alpha);
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
