import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton coloré avec forme pill, icône seule (pas de texte),
/// adapté pour les enfants (gros et lisible).
/// Les boutons avec texture utilisent l'image directement (pas de dégradé).
class ImageButton extends StatefulWidget {
  /// Clés de couleur de fond
  static const String greenBg  = 'green';
  static const String orangeBg = 'orange';
  static const String redBg    = 'red';

  final String text; // Conservé pour accessibilité/semantics mais non affiché
  final String backgroundAsset; // Clé de couleur
  final VoidCallback onPressed;
  final IconData? icon;
  final double height;
  final double? width;
  final double borderWidth;

  const ImageButton({
    super.key,
    required this.text,
    required this.backgroundAsset,
    required this.onPressed,
    this.icon,
    this.height = 80,
    this.width,
    this.borderWidth = 3.5,
  });

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _ctrl.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onPressed();
  }

  void _onTapCancel() => _ctrl.reverse();

  /// Retourne la couleur de fond principale selon la clé
  Color _bgColor() {
    switch (widget.backgroundAsset) {
      case 'green':
        return const Color(0xFF4CAF50);
      case 'orange':
        return const Color(0xFFFF9800);
      case 'red':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  /// Retourne la couleur de fond plus claire pour le dégradé
  Color _bgColorLight() {
    switch (widget.backgroundAsset) {
      case 'green':
        return const Color(0xFF66BB6A);
      case 'orange':
        return const Color(0xFFFFA726);
      case 'red':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF66BB6A);
    }
  }

  /// Retourne le chemin de la texture (null si aucune)
  String? _textureAsset() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pillRadius = widget.height / 2;
    final iconSize = widget.height * 0.70;
    final texture = _textureAsset();
    final hasTexture = texture != null;

    return Semantics(
      label: widget.text,
      button: true,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scale,
          child: SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Fond — texture pleine OU dégradé de couleur
                if (hasTexture)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(pillRadius),
                      child: Image.asset(
                        texture,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(pillRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [_bgColorLight(), _bgColor()],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _bgColor().withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Layer 2: Contour pill foncé
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(pillRadius),
                      border: Border.all(
                        color: const Color(0xFF2B2B2B),
                        width: widget.borderWidth,
                      ),
                    ),
                  ),
                ),
                // Layer 3: Icône seule, centrée, grosse, noire si texture
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: const Color(0xFF2B2B2B),
                    size: iconSize,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
