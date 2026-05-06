import 'package:flutter/material.dart';

/// Affichage animé de la licorne avec 3 layers (body, tail, head).
/// Basé sur PonyAnimatedDisplay.
/// La tête oscille gauche/droite (pivot bas de la tête).
/// La queue oscille haut/bas (pivot gauche de la queue).
/// La couleur de teinte est #FF61E7.
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///              si false, boucle indéfiniment.
class UnicornAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const UnicornAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<UnicornAnimatedDisplay> createState() => _UnicornAnimatedDisplayState();
}

class _UnicornAnimatedDisplayState extends State<UnicornAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const double _headAngle = 0.10; // ~6°
  static const double _tailAngle = 0.18; // ~10°

  // Pivot tête : point d'attache au cou (déduit de l'annotation image 1024×1024 : x=490, y=365)
  static const double _headPivotX = 0.479;
  static const double _headPivotY = 0.357;

  // Pivot queue : point d'attache à la base (déduit de l'annotation unicorn_tail_2.png 1024×1024 : x=677, y=571)
  static const double _tailPivotX = 0.661;
  static const double _tailPivotY = 0.558;

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
  void didUpdateWidget(UnicornAnimatedDisplay old) {
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

  double _easeInOut(double t) =>
      t < 0.5 ? 2 * t * t : 1 - (-2 * t + 2) * (-2 * t + 2) / 2;

  double _computeAngleOnce(double t, double maxAngle) {
    if (t <= 0.15) {
      return maxAngle * _easeInOut(t / 0.15);
    } else if (t <= 0.35) {
      return maxAngle;
    } else if (t <= 0.65) {
      return maxAngle - 2 * maxAngle * _easeInOut((t - 0.35) / 0.30);
    } else if (t <= 0.85) {
      return -maxAngle;
    } else {
      return -maxAngle * (1 - _easeInOut((t - 0.85) / 0.15));
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
        if (!_ctrl.isAnimating &&
            !(_ctrl.status == AnimationStatus.forward)) {
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
              _buildRotatedLayer(
                'assets/images/unicorn/unicorn_tail.png',
                size,
                tailAngle,
                _tailPivotX,
                _tailPivotY,
              ),
              // Layer 2 : Corps (statique)
              _buildLayer('assets/images/unicorn/unicorn_body.png', size),
              // Layer 3 : Tête (devant le corps)
              _buildRotatedLayer(
                'assets/images/unicorn/unicorn_head.png',
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
