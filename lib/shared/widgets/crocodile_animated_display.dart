import 'package:flutter/material.dart';

/// Affichage animé du crocodile avec 2 layers (body, head).
/// Seule la tête tourne de gauche à droite dans une boucle de 2 secondes.
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///
/// Timing (boucle 2s, fractions du controller 0→1) :
///   0.0 → 0.4  : repos position A
///   0.4 → 0.5  : rotation vers position B
///   0.5 → 0.9  : repos position B
///   0.9 → 1.0  : rotation vers position A
class CrocodileAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const CrocodileAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<CrocodileAnimatedDisplay> createState() =>
      _CrocodileAnimatedDisplayState();
}

class _CrocodileAnimatedDisplayState extends State<CrocodileAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Head rotation angle (radians) — ~8 degrees
  static const double _headAngle = 0.14;

  // Head pivot: junction neck/body (280, 255) / 512
  static const double _headPivotX = 0.547;
  static const double _headPivotY = 0.498;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _startAnimation();
  }

  void _startAnimation() {
    if (!widget.animate) return;
    if (widget.playOnce) {
      _ctrl.forward(from: 0.0);
    } else {
      _ctrl.repeat();
    }
  }

  @override
  void didUpdateWidget(CrocodileAnimatedDisplay old) {
    super.didUpdateWidget(old);
    if (widget.animate && !old.animate) {
      _startAnimation();
    } else if (!widget.animate && old.animate) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _computeAngle(double t, double maxAngle) {
    if (t <= 0.4) {
      return maxAngle;
    } else if (t <= 0.5) {
      final progress = (t - 0.4) / 0.1;
      final eased = _easeInOut(progress);
      return maxAngle - 2 * maxAngle * eased;
    } else if (t <= 0.9) {
      return -maxAngle;
    } else {
      final progress = (t - 0.9) / 0.1;
      final eased = _easeInOut(progress);
      return -maxAngle + 2 * maxAngle * eased;
    }
  }

  double _easeInOut(double t) {
    return t < 0.5
        ? 2 * t * t
        : 1 - (-2 * t + 2) * (-2 * t + 2) / 2;
  }

  /// Comme _computeAngle mais commence et finit à 0 (position neutre).
  /// Utilisé pour playOnce afin d'avoir une transition douce au début et à la fin.
  double _computeAngleOnce(double t, double maxAngle) {
    if (t <= 0.15) {
      // Ease from 0 to +maxAngle
      final progress = t / 0.15;
      return maxAngle * _easeInOut(progress);
    } else if (t <= 0.35) {
      return maxAngle;
    } else if (t <= 0.65) {
      // Ease from +maxAngle to -maxAngle
      final progress = (t - 0.35) / 0.30;
      return maxAngle - 2 * maxAngle * _easeInOut(progress);
    } else if (t <= 0.85) {
      return -maxAngle;
    } else {
      // Ease from -maxAngle back to 0
      final progress = (t - 0.85) / 0.15;
      return -maxAngle * (1 - _easeInOut(progress));
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;

        final double headAngle;
        if (!_ctrl.isAnimating && !(_ctrl.status == AnimationStatus.forward)) {
          headAngle = 0.0;
        } else if (widget.playOnce) {
          headAngle = _computeAngleOnce(t, _headAngle);
        } else {
          headAngle = _computeAngle(t, _headAngle);
        }

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Layer 1: Body (static)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/crocodile/crocodile_body.png',
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              ),
              // Layer 2: Head (rotation)
              Positioned.fill(
                child: Transform(
                  alignment: const FractionalOffset(_headPivotX, _headPivotY),
                  transform: Matrix4.rotationZ(headAngle),
                  child: Image.asset(
                    'assets/images/crocodile/crocodile_head.png',
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
