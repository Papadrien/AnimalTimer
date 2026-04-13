import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton avec fond PNG Procreate (forme "pull" dessinée à la main).
/// Le PNG est étiré comme fond, le texte est superposé au centre.
class ImageButton extends StatefulWidget {
  /// Chemins vers les 3 backgrounds de boutons
  static const String greenBg  = 'assets/images/buttons/btn_green.png';
  static const String orangeBg = 'assets/images/buttons/btn_orange.png';
  static const String redBg    = 'assets/images/buttons/btn_red.png';

  final String text;
  final String backgroundAsset;
  final VoidCallback onPressed;
  final IconData? icon;
  final double height;
  final double? width;

  const ImageButton({
    super.key,
    required this.text,
    required this.backgroundAsset,
    required this.onPressed,
    this.icon,
    this.height = 64,
    this.width,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              // PNG background stretched to fill
              Positioned.fill(
                child: Image.asset(
                  widget.backgroundAsset,
                  fit: BoxFit.fill,
                ),
              ),
              // Text + optional icon overlay
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon,
                        color: const Color(0xFF2B2B2B), size: 24),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2B2B2B),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
