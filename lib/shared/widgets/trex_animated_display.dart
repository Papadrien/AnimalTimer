import 'package:flutter/material.dart';

/// Affichage animé du T-Rex avec 5 layers (body statique + 4 membres).
/// Contrairement aux animaux "type chat" (tête + queue), le T-Rex anime
/// ses 4 membres pour simuler une démarche : les membres opposés en
/// diagonale bougent ensemble (comme une marche naturelle).
///
/// Synchronisation :
///   - bras gauche (désormais devant le buste) + jambe droite (désormais
///     derrière le buste)
///   - bras droit (désormais derrière le buste) + jambe gauche (la grosse
///     cuisse ronde, désormais devant le buste)
/// Ces deux paires sont en opposition de phase l'une par rapport à l'autre,
/// comme des membres diagonaux qui avancent en alternance.
///
/// Les rotations se font autour d'un point d'ancrage :
///   - jambes : centre du haut de la cuisse
///   - bras : centre de l'épaule
///
/// [playOnce] : si true, joue exactement 1 cycle puis s'arrête.
///              si false, boucle indéfiniment.
///
/// Timing (boucle 2s, fractions du controller 0→1), identique au modèle
/// "chat" pour rester cohérent avec les autres animaux :
///   0.0 → 0.4  : repos position A
///   0.4 → 0.5  : rotation vers position B
///   0.5 → 0.9  : repos position B
///   0.9 → 1.0  : rotation vers position A
class TrexAnimatedDisplay extends StatefulWidget {
  final double size;
  final bool animate;
  final bool playOnce;

  const TrexAnimatedDisplay({
    super.key,
    this.size = 180,
    this.animate = true,
    this.playOnce = false,
  });

  @override
  State<TrexAnimatedDisplay> createState() => _TrexAnimatedDisplayState();
}

class _TrexAnimatedDisplayState extends State<TrexAnimatedDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Rotation angles (radians)
  static const double _armAngle = 0.14; // ~8 degrés
  static const double _legAngle = 0.16; // ~9 degrés

  // Points d'ancrage, en fractions du canvas carré 1024x1024
  // (images pré-alignées, complétées par un padding transparent haut/bas
  // pour passer du format source 1536x1024 au format carré utilisé par
  // les autres animaux). Mesurés par extraction pixel-level à la jonction
  // visible de chaque membre avec le corps.

  // Bras droit (désormais derrière le buste) : centre de l'épaule.
  static const double _rightArmPivotX = 0.339;
  static const double _rightArmPivotY = 0.554;

  // Bras gauche (désormais devant le buste) : centre de l'épaule.
  static const double _leftArmPivotX = 0.445;
  static const double _leftArmPivotY = 0.513;

  // Jambe droite (désormais derrière) : centre du haut de la cuisse.
  static const double _rightLegPivotX = 0.404;
  static const double _rightLegPivotY = 0.616;

  // Jambe gauche (la grosse cuisse ronde, désormais devant) : centre du
  // haut de la cuisse.
  static const double _leftLegPivotX = 0.588;
  static const double _leftLegPivotY = 0.593;

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
  void didUpdateWidget(TrexAnimatedDisplay old) {
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

  double _easeInOut(double t) {
    return t < 0.5
        ? 2 * t * t
        : 1 - (-2 * t + 2) * (-2 * t + 2) / 2;
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

        // pairAngle : bras gauche + jambe droite (paire A)
        // pairAngleInverse : bras droit + jambe gauche (paire B, en
        // opposition de phase avec la paire A — démarche en diagonale)
        final double pairAngle;
        final double pairAngleInverse;
        if (!widget.animate) {
          pairAngle = 0.0;
          pairAngleInverse = 0.0;
        } else if (widget.playOnce) {
          pairAngle = _computeAngleOnce(t, 1.0);
          pairAngleInverse = -pairAngle;
        } else {
          pairAngle = _computeAngle(t, 1.0);
          pairAngleInverse = -pairAngle;
        }

        final leftArmAngle = pairAngle * _armAngle;
        final rightLegAngle = pairAngle * _legAngle;
        final rightArmAngle = pairAngleInverse * _armAngle;
        final leftLegAngle = pairAngleInverse * _legAngle;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Layer 1 : Jambe droite (désormais derrière le corps)
              _buildRotatedLayer(
                'assets/images/trex/trex_right_leg.png',
                size,
                rightLegAngle,
                _rightLegPivotX,
                _rightLegPivotY,
              ),
              // Layer 2 : Bras droit (désormais derrière le corps)
              _buildRotatedLayer(
                'assets/images/trex/trex_right_arm.png',
                size,
                rightArmAngle,
                _rightArmPivotX,
                _rightArmPivotY,
              ),
              // Layer 3 : Corps (statique — tête, buste, queue)
              _buildLayer('assets/images/trex/trex_body.png', size),
              // Layer 4 : Bras gauche (désormais devant le corps)
              _buildRotatedLayer(
                'assets/images/trex/trex_left_arm.png',
                size,
                leftArmAngle,
                _leftArmPivotX,
                _leftArmPivotY,
              ),
              // Layer 5 : Jambe gauche (désormais devant le corps)
              _buildRotatedLayer(
                'assets/images/trex/trex_left_leg.png',
                size,
                leftLegAngle,
                _leftLegPivotX,
                _leftLegPivotY,
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
