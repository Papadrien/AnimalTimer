import 'package:flutter/material.dart';

/// Affichage animé de la tortue avec 3 layers (body, tail, head).
/// La tête tourne de gauche à droite avec le pivot en bas de la tête,
/// et la queue tourne de haut en bas avec le pivot à gauche de la queue.
/// Synchronisées dans une boucle de 2 secondes (même timing que le chat).
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///              si false, boucle indéfiniment.
class TurtleAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const TurtleAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<TurtleAnimatedDisplay> createState() => _TurtleAnimatedDisplayState();
}

class _TurtleAnimatedDisplayState extends State<TurtleAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Rotation angles (radians) — légèrement réduits pour la tortue (plus lente)
  static const double _headAngle = 0.10; // ~6 degrés
  static const double _tailAngle = 0.14; // ~8 degrés

  // Pivot tête : point rouge (nez) sur turtle_head_2.png (~x:210, y:530 sur 1080x1080)
  static const double _headPivotX = 0.330;
  static const double _headPivotY = 0.530;

  // Pivot queue : gauche de la queue (jonction avec le corps ~x:845, y:625)
  static const double _tailPivotX = 0.782;
  static const double _tailPivotY = 0.579;

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
  void didUpdateWidget(TurtleAnimatedDisplay old) {
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
              _buildRotatedLayer(
                'assets/images/turtle/turtle_tail.png',
                size,
                tailAngle,
                _tailPivotX,
                _tailPivotY,
              ),
              // Layer 2 : Corps (statique)
              _buildLayer('assets/images/turtle/turtle_body.png', size),
              // Layer 3 : Tête (devant le corps)
              _buildRotatedLayer(
                'assets/images/turtle/turtle_head.png',
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
