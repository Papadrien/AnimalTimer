import 'dart:math';
import 'package:flutter/material.dart';

/// Overlay girafe : branche solide qui se balance en haut + 50 feuilles dessus
/// + feuilles qui tombent avec fade-in.
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
    _branchLeaves  = List.generate(50, (i) => _BranchLeaf.random(rng, i));
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
  final double phase;
  final double driftX;
  final double speed;
  final Color color;
  final double rotation;

  const _FallingLeaf({
    required this.x, required this.size, required this.phase,
    required this.driftX, required this.speed, required this.color,
    required this.rotation,
  });

  factory _FallingLeaf.random(Random rng, int index, int total) {
    return _FallingLeaf(
      x:        rng.nextDouble(),
      size:     6.0 + rng.nextDouble() * 8.0,
      phase:    index / total.toDouble(),
      driftX:   (rng.nextDouble() - 0.5) * 0.08,
      speed:    0.7 + rng.nextDouble() * 0.6,
      color:    _leafColors[rng.nextInt(_leafColors.length)],
      rotation: rng.nextDouble() * pi * 2,
    );
  }
}

// ─── Feuille fixe sur la branche ───
class _BranchLeaf {
  final double tBranch;   // position sur la branche [0..1]
  final double offsetY;   // décalage Y relatif à la branche (px)
  final double size;
  final double angle;     // angle de base
  final double swayPhase; // phase de balancement
  final double swayAmp;   // amplitude de balancement (radians)
  final Color color;
  final bool above;       // au-dessus ou en dessous de la branche

  const _BranchLeaf({
    required this.tBranch, required this.offsetY, required this.size,
    required this.angle, required this.swayPhase, required this.swayAmp,
    required this.color, required this.above,
  });

  factory _BranchLeaf.random(Random rng, int index) {
    return _BranchLeaf(
      tBranch:   rng.nextDouble(),
      offsetY:   2.0 + rng.nextDouble() * 6.0,
      size:      7.0 + rng.nextDouble() * 11.0,
      angle:     (rng.nextDouble() - 0.5) * pi * 0.9,
      swayPhase: rng.nextDouble() * pi * 2,
      swayAmp:   0.04 + rng.nextDouble() * 0.06,
      color:     _leafColors[rng.nextInt(_leafColors.length)],
      above:     rng.nextBool(),
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

  @override
  void paint(Canvas canvas, Size size) {
    final sway = sin(progress * pi * 2) * _branchSway * size.height;
    final baseY = _branchY * size.height;

    // ── Feuilles SOUS la branche (dessinées avant la branche) ──
    for (final l in branchLeaves) {
      if (!l.above) _drawBranchLeaf(canvas, size, l, sway);
    }

    // ── Branche principale (solide, opaque) ──
    _drawSolidBranch(canvas, size, baseY, sway);

    // ── Feuilles AU-DESSUS de la branche ──
    for (final l in branchLeaves) {
      if (l.above) _drawBranchLeaf(canvas, size, l, sway);
    }

    // ── Feuilles tombantes ──
    for (final l in fallingLeaves) {
      _drawFallingLeaf(canvas, size, l);
    }
  }

  void _drawSolidBranch(Canvas canvas, Size size, double baseY, double sway) {
    final p0  = Offset(-0.05 * size.width, baseY + sway * 0.3);
    final cp1 = Offset(0.20  * size.width, baseY - 18 + sway * 0.5);
    final cp2 = Offset(0.55  * size.width, baseY + 12 + sway * 0.8);
    final p3  = Offset(0.78  * size.width, baseY + sway);

    // Branche principale — une seule passe, couleur pleine, opaque
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

    // Reflet/texture bois — fine ligne claire sur le dessus, pleine
    final highlightPaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, highlightPaint);

    // ── Branches secondaires (solides) ──
    _drawSubBranch(canvas, size, 0.18, baseY + sway * 0.3, -0.055, 0.045, 6.0);
    _drawSubBranch(canvas, size, 0.32, baseY + sway * 0.5, +0.040, 0.038, 5.5);
    _drawSubBranch(canvas, size, 0.47, baseY + sway * 0.7, -0.050, 0.050, 5.0);
    _drawSubBranch(canvas, size, 0.60, baseY + sway * 0.8, +0.035, 0.042, 4.5);
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

  void _drawBranchLeaf(Canvas canvas, Size size, _BranchLeaf l, double sway) {
    final pt = _branchPoint(l.tBranch, size, sway);
    final sign = l.above ? -1.0 : 1.0;
    final pos = Offset(pt.dx, pt.dy + sign * l.offsetY);
    final angle = l.angle + sin(progress * pi * 2 + l.swayPhase) * l.swayAmp;
    _paintLeaf(canvas, pos, l.color, l.size, angle, 0.90);
  }

  void _drawFallingLeaf(Canvas canvas, Size size, _FallingLeaf l) {
    final t = (progress * l.speed + l.phase) % 1.0;
    final fallY = _branchY + t * (1.05 - _branchY);
    final y = fallY * size.height;
    final fadeIn = (t / 0.10).clamp(0.0, 1.0);
    final alpha = (fadeIn * 0.85).clamp(0.0, 1.0);
    if (alpha <= 0.01) return;
    final x = (l.x + sin(t * pi * 1.5) * l.driftX) * size.width;
    final rotation = l.rotation + t * pi * 1.2;
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
