import 'package:flutter/material.dart';

/// Affichage animé du poney avec 3 layers (body, tail, head).
/// La tête oscille de gauche à droite, la queue oscille de haut en bas
/// autour de son point d'attache (base gauche de la queue).
/// Les deux sont synchronisés avec le même timing.
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///              si false, boucle indéfiniment.
///
/// Timing (boucle 2s, fractions du controller 0->1) :
///   0.0 -> 0.4  : repos position A (tête à droite, queue en haut)
///   0.4 -> 0.5  : rotation vers position B (tête à gauche, queue en bas)
///   0.5 -> 0.9  : repos position B
///   0.9 -> 1.0  : rotation vers position A
class PonyAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const PonyAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<PonyAnimatedDisplay> createState() => _PonyAnimatedDisplayState();
}

class _PonyAnimatedDisplayState extends State<PonyAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Rotation angles (radians)
  static const double _headAngle = 0.10; // ~6 degrees left/right
  static const double _tailAngle = 0.18; // ~10 degrees up/down

  // Head pivot: bottom-center of head, where neck meets body
  static const double _headPivotX = 0.38;
  static const double _headPivotY = 0.55;

  // Tail pivot: base of the tail (left side), where it attaches to the body
  static const double _tailPivotX = 0.699;
  static const double _tailPivotY = 0.680;

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
  void didUpdateWidget(PonyAnimatedDisplay old) {
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

  /// Calcule l'angle de rotation en fonction du temps t (0->1).
  /// Position A = angle positif, Position B = angle négatif.
  /// Repos entre les rotations.
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
  /// Utilisé pour playOnce.
  double _computeAngleOnce(double t, double maxAngle) {
    if (t <= 0.15) {
      final progress = t / 0.15;
      return maxAngle * _easeInOut(progress);
    } else if (t <= 0.35) {
      return maxAngle;
    } else if (t <= 0.65) {
      final progress = (t - 0.35) / 0.30;
      return maxAngle - 2 * maxAngle * _easeInOut(progress);
    } else if (t <= 0.85) {
      return -maxAngle;
    } else {
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
        final double tailAngle;
        if (!_ctrl.isAnimating && !(_ctrl.status == AnimationStatus.forward)) {
          headAngle = 0.0;
          tailAngle = 0.0;
        } else if (widget.playOnce) {
          headAngle = _computeAngleOnce(t, _headAngle);
          tailAngle = _computeAngleOnce(t, _tailAngle);
        } else {
          headAngle = _computeAngle(t, _headAngle);
          tailAngle = _computeAngle(t, _tailAngle);
        }

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Layer 1 : Queue (derrière le corps)
              // Rotation haut/bas autour de la base (gauche)
              _buildRotatedLayer(
                'assets/images/pony/pony_tail.png',
                size,
                tailAngle,
                _tailPivotX,
                _tailPivotY,
              ),
              // Layer 2 : Corps (statique)
              _buildLayer('assets/images/pony/pony_body.png', size),
              // Layer 3 : Tête (devant le corps)
              _buildRotatedLayer(
                'assets/images/pony/pony_head.png',
                size,
                headAngle,
                _headPivotX,
                _headPivotY,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLayer(String asset, double size) {
    return Positioned.fill(
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildRotatedLayer(
    String asset,
    double size,
    double angle,
    double pivotX,
    double pivotY,
  ) {
    return Positioned.fill(
      child: Transform(
        alignment: FractionalOffset(pivotX, pivotY),
        transform: Matrix4.rotationZ(angle),
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
