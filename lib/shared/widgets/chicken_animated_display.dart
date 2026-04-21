import 'package:flutter/material.dart';

/// Affichage animé de la poule avec 3 layers (body, tail, head).
/// La tête tourne de gauche à droite, la queue translate de gauche à droite
/// (comme si elle remuait), synchronisées dans une boucle de 2 secondes.
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///
/// Timing (boucle 2s, fractions du controller 0→1) :
///   0.0 → 0.4  : repos position A
///   0.4 → 0.5  : transition vers position B
///   0.5 → 0.9  : repos position B
///   0.9 → 1.0  : transition vers position A
class ChickenAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const ChickenAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<ChickenAnimatedDisplay> createState() =>
      _ChickenAnimatedDisplayState();
}

class _ChickenAnimatedDisplayState extends State<ChickenAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Head rotation angle (radians) — ~7 degrees
  static const double _headAngle = 0.12;

  // Tail horizontal translation amplitude (fraction of widget size)
  // ~5px on a 180px widget → 0.028
  static const double _tailShiftFraction = 0.028;

  // Head pivot: bottom-center of head (246, 271) / 512
  static const double _headPivotX = 0.480;
  static const double _headPivotY = 0.529;

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
  void didUpdateWidget(ChickenAnimatedDisplay old) {
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

  /// Interpole entre +max et -max avec repos aux extrêmes.
  double _computeValue(double t, double maxVal) {
    if (t <= 0.4) {
      return maxVal;
    } else if (t <= 0.5) {
      final progress = (t - 0.4) / 0.1;
      final eased = _easeInOut(progress);
      return maxVal - 2 * maxVal * eased;
    } else if (t <= 0.9) {
      return -maxVal;
    } else {
      final progress = (t - 0.9) / 0.1;
      final eased = _easeInOut(progress);
      return -maxVal + 2 * maxVal * eased;
    }
  }

  double _easeInOut(double t) {
    return t < 0.5
        ? 2 * t * t
        : 1 - (-2 * t + 2) * (-2 * t + 2) / 2;
  }

  /// Comme _computeValue mais commence et finit à 0 (position neutre).
  /// Utilisé pour playOnce afin d'avoir une transition douce au début et à la fin.
  double _computeValueOnce(double t, double maxVal) {
    if (t <= 0.15) {
      final progress = t / 0.15;
      return maxVal * _easeInOut(progress);
    } else if (t <= 0.35) {
      return maxVal;
    } else if (t <= 0.65) {
      final progress = (t - 0.35) / 0.30;
      return maxVal - 2 * maxVal * _easeInOut(progress);
    } else if (t <= 0.85) {
      return -maxVal;
    } else {
      final progress = (t - 0.85) / 0.15;
      return -maxVal * (1 - _easeInOut(progress));
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
        final double tailShift;
        if (!_ctrl.isAnimating && !(_ctrl.status == AnimationStatus.forward)) {
          headAngle = 0.0;
          tailShift = 0.0;
        } else if (widget.playOnce) {
          headAngle = _computeValueOnce(t, _headAngle);
          tailShift = _computeValueOnce(t, -_tailShiftFraction) * size;
        } else {
          headAngle = _computeValue(t, _headAngle);
          tailShift = _computeValue(t, -_tailShiftFraction) * size;
        }

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Layer 1: Tail (behind body) — horizontal translation
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(tailShift, 0),
                  child: Image.asset(
                    'assets/images/chicken/chicken_tail.png',
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Layer 2: Body (static)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/chicken/chicken_body.png',
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              ),
              // Layer 3: Head (in front) — rotation
              Positioned.fill(
                child: Transform(
                  alignment: const FractionalOffset(_headPivotX, _headPivotY),
                  transform: Matrix4.rotationZ(headAngle),
                  child: Image.asset(
                    'assets/images/chicken/chicken_head.png',
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
