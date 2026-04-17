import 'package:flutter/material.dart';

/// Affichage animé du chat avec 3 layers (body, tail, head).
/// La tête tourne de gauche à droite et la queue de haut en bas,
/// synchronisées dans une boucle de 2 secondes.
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///              si false, boucle indéfiniment.
///
/// Timing (boucle 2s, fractions du controller 0→1) :
///   0.0 → 0.4  : repos position A (tête centrée, queue haute)
///   0.4 → 0.5  : rotation vers position B (tête à gauche, queue en bas)
///   0.5 → 0.9  : repos position B
///   0.9 → 1.0  : rotation vers position A
class CatAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const CatAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<CatAnimatedDisplay> createState() => _CatAnimatedDisplayState();
}

class _CatAnimatedDisplayState extends State<CatAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Rotation angles (radians)
  static const double _headAngle = 0.12; // ~7 degrees
  static const double _tailAngle = 0.18; // ~10 degrees

  // Pivot points as fractions of the 512x512 image
  // Head pivot: bottom-center of head (222, 270) / 512
  static const double _headPivotX = 0.434;
  static const double _headPivotY = 0.527;

  // Tail pivot: top-left of tail, junction with body (368, 338) / 512
  static const double _tailPivotX = 0.719;
  static const double _tailPivotY = 0.660;

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
  void didUpdateWidget(CatAnimatedDisplay old) {
    super.didUpdateWidget(old);
    if (widget.animate && !old.animate) {
      // Réactiver l'animation (ex: changement d'animal vers le chat)
      _startAnimation();
    } else if (!widget.animate && old.animate) {
      _ctrl.stop();
    }
    // Si la key change (via AnimatedSwitcher), initState gère tout
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Calcule l'angle de rotation en fonction du temps t (0→1).
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

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;

        // Si animation terminée (playOnce) ou pas animé → angles à 0
        final bool isAnimating = _ctrl.isAnimating || t > 0.0;
        final headAngle = isAnimating ? _computeAngle(t, _headAngle) : 0.0;
        final tailAngle = isAnimating ? _computeAngle(t, -_tailAngle) : 0.0;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Layer 1 : Queue (derrière le corps)
              _buildRotatedLayer(
                'assets/images/cat/cat_tail.png',
                size,
                tailAngle,
                _tailPivotX,
                _tailPivotY,
              ),
              // Layer 2 : Corps (statique)
              _buildLayer('assets/images/cat/cat_body.png', size),
              // Layer 3 : Tête (devant le corps)
              _buildRotatedLayer(
                'assets/images/cat/cat_head.png',
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
