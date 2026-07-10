import 'package:flutter/material.dart';

/// Affichage animé du dragon avec 4 layers (aile droite, corps, aile gauche, tête).
/// La tête oscille de gauche à droite. Les deux ailes battent en rythme
/// (montée/descente) de façon synchronisée entre elles ET avec la tête :
/// quand la tête tourne à gauche, les ailes descendent ; quand la tête
/// tourne à droite, les ailes remontent.
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///              si false, boucle indéfiniment.
///
/// Timing (boucle 2s, fractions du controller 0->1) :
///   0.0 -> 0.4  : repos position A (tête à droite, ailes en haut)
///   0.4 -> 0.5  : rotation vers position B (tête à gauche, ailes en bas)
///   0.5 -> 0.9  : repos position B
///   0.9 -> 1.0  : rotation vers position A
class DragonAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const DragonAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<DragonAnimatedDisplay> createState() => _DragonAnimatedDisplayState();
}

class _DragonAnimatedDisplayState extends State<DragonAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Rotation angles (radians)
  static const double _headAngle = 0.10; // ~6 degrees left/right
  static const double _wingAngle = 0.22; // ~12.6 degrees up/down

  // Head pivot: jonction cou/corps, bas de la tête légèrement décalé
  // vers le corps (droite de l'asset tête).
  static const double _headPivotX = 0.42;
  static const double _headPivotY = 0.49;

  // Aile droite (petite aile, côté loin, partiellement cachée) :
  // point d'ancrage calculé depuis le repère fourni sur
  // Dragon_aile_droite_2.png (nouveau design d'aile).
  static const double _rightWingPivotX = 0.338;
  static const double _rightWingPivotY = 0.445;

  // Aile gauche (grande aile visible) :
  // point d'ancrage calculé depuis le repère fourni sur
  // Dragon_aile_gauche_2.png (nouveau design d'aile).
  static const double _leftWingPivotX = 0.496;
  static const double _leftWingPivotY = 0.425;

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
  void didUpdateWidget(DragonAnimatedDisplay old) {
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
        final double wingAngle;
        if (!_ctrl.isAnimating && !(_ctrl.status == AnimationStatus.forward)) {
          headAngle = 0.0;
          wingAngle = 0.0;
        } else if (widget.playOnce) {
          headAngle = _computeAngleOnce(t, _headAngle);
          wingAngle = _computeAngleOnce(t, _wingAngle);
        } else {
          headAngle = _computeAngle(t, _headAngle);
          wingAngle = _computeAngle(t, _wingAngle);
        }

        // wingAngle positif = position A (ailes en haut, tête à droite).
        // Les deux ailes ont des points d'ancrage opposés (bas-centre vs
        // bas-gauche) : pour qu'elles montent/descendent ensemble à
        // l'écran, l'aile gauche utilise le signe inversé.
        final rightWingRotation = wingAngle;
        final leftWingRotation = -wingAngle;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Layer 1 : Aile droite (petite, côté loin, derrière le corps)
              _buildRotatedLayer(
                'assets/images/dragon/dragon_aile_droite.png',
                size,
                rightWingRotation,
                _rightWingPivotX,
                _rightWingPivotY,
              ),
              // Layer 2 : Corps (statique)
              _buildLayer('assets/images/dragon/dragon_body.png', size),
              // Layer 3 : Aile gauche (grande, visible au-dessus du corps)
              _buildRotatedLayer(
                'assets/images/dragon/dragon_aile_gauche.png',
                size,
                leftWingRotation,
                _leftWingPivotX,
                _leftWingPivotY,
              ),
              // Layer 4 : Tête (devant tout, rotation gauche/droite)
              _buildRotatedLayer(
                'assets/images/dragon/dragon_head.png',
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
