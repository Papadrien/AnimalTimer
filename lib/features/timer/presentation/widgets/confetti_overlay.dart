import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});
  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Confetti> _pieces;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _pieces = List.generate(80, (_) => _Confetti(_rng));
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 8))
      ..forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        // Fade out sur les derniers 15% de l'animation
        final fadeOut = (_ctrl.value > 0.85
            ? 1.0 - ((_ctrl.value - 0.85) / 0.15)
            : 1.0).clamp(0.0, 1.0);
        return Opacity(
          opacity: fadeOut,
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ConfettiPainter(_pieces, _ctrl.value),
          ),
        );
      },
    );
  }
}

class _Confetti {
  final double x;
  final double delay;
  final double duration;
  final double size;
  final double driftAmp;
  final double driftFreq;
  final double wobbleFreq;
  final double wobbleAmp;
  final double rotSpeed;
  final Color color;
  final int shape;

  _Confetti(Random rng)
      : x = rng.nextDouble(),
        delay = rng.nextDouble() * 0.35,
        duration = 0.45 + rng.nextDouble() * 0.4,
        size = 6 + rng.nextDouble() * 10,
        driftAmp = 0.03 + rng.nextDouble() * 0.08,
        driftFreq = 2 + rng.nextDouble() * 4,
        wobbleFreq = 3 + rng.nextDouble() * 5,
        wobbleAmp = 0.01 + rng.nextDouble() * 0.03,
        rotSpeed = 2 + rng.nextDouble() * 6,
        shape = rng.nextInt(3),
        color = [
          const Color(0xFFFF6B6B),
          const Color(0xFFFFD43B),
          const Color(0xFF74C0FC),
          const Color(0xFF69DB7C),
          const Color(0xFFB197FC),
          const Color(0xFFF783AC),
          const Color(0xFFFF922B),
        ][rng.nextInt(7)];
}

class _ConfettiPainter extends CustomPainter {
  final List<_Confetti> pieces;
  final double t;
  _ConfettiPainter(this.pieces, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in pieces) {
      if (t < c.delay) continue;
      final local = ((t - c.delay) / c.duration).clamp(0.0, 1.0);
      if (local >= 1.0) continue;

      // Ease-in curve: starts slow, accelerates like real gravity
      final gravity = local * local * 0.4 + local * 0.6;

      final y = -c.size + gravity * (size.height + c.size * 2);

      // Organic horizontal sway: two overlapping sine waves
      final sway1 = sin(local * c.driftFreq * pi * 2) * c.driftAmp;
      final sway2 = sin(local * c.wobbleFreq * pi * 2) * c.wobbleAmp;
      final x = (c.x + sway1 + sway2) * size.width;

      final paint = Paint()..color = c.color.withValues(alpha: 0.9);
      final rot = t * c.rotSpeed * pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);

      if (c.shape == 0) {
        canvas.drawRect(Rect.fromCenter(center: Offset.zero,
          width: c.size, height: c.size * 0.6), paint);
      } else if (c.shape == 1) {
        canvas.drawCircle(Offset.zero, c.size * 0.4, paint);
      } else {
        final path = Path()
          ..moveTo(0, -c.size * 0.5)
          ..lineTo(c.size * 0.4, c.size * 0.3)
          ..lineTo(-c.size * 0.4, c.size * 0.3)
          ..close();
        canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => true;
}
