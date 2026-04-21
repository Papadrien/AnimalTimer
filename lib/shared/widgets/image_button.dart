import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton coloré avec forme pill, icône seule (pas de texte),
/// adapté pour les enfants (gros et lisible).
/// [bounce] active un effet rebond élastique au relâchement.
class ImageButton extends StatefulWidget {
  static const String greenBg  = 'green';
  static const String orangeBg = 'orange';
  static const String redBg    = 'red';
  static const String blueBg   = 'blue';

  final String text;
  final String backgroundAsset;
  final VoidCallback onPressed;
  final IconData? icon;
  final double height;
  final double? width;
  final double borderWidth;
  final bool bounce;

  const ImageButton({
    super.key,
    required this.text,
    required this.backgroundAsset,
    required this.onPressed,
    this.icon,
    this.height = 80,
    this.width,
    this.borderWidth = 3.5,
    this.bounce = false,
  });

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  // Bounce : état interne pour gérer la séquence
  double _bounceScale = 1.0;
  bool _isBouncing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 60));
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
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

  void _onTapUp(TapUpDetails _) async {
    if (widget.bounce) {
      await _doBounce();
    } else {
      _ctrl.reverse();
    }
    widget.onPressed();
  }

  void _onTapCancel() => _ctrl.reverse();

  /// Animation bounce : overshoot (1.06) puis settle (1.0)
  Future<void> _doBounce() async {
    _isBouncing = true;

    // Phase 1 : retour rapide depuis shrink (0.92 → 1.0)
    await _ctrl.reverse();

    // Phase 2 : overshoot (1.0 → 1.06)
    const overshootDuration = Duration(milliseconds: 75);
    const settleDuration = Duration(milliseconds: 60);

    final start = DateTime.now();
    while (true) {
      final elapsed = DateTime.now().difference(start).inMilliseconds;
      if (elapsed >= overshootDuration.inMilliseconds) break;
      final t = elapsed / overshootDuration.inMilliseconds;
      final curve = Curves.easeOut.transform(t);
      if (mounted) {
        setState(() => _bounceScale = 1.0 + 0.06 * curve);
      }
      await Future.delayed(const Duration(milliseconds: 8));
    }

    // Phase 3 : settle (1.06 → 1.0)
    final start2 = DateTime.now();
    while (true) {
      final elapsed = DateTime.now().difference(start2).inMilliseconds;
      if (elapsed >= settleDuration.inMilliseconds) break;
      final t = elapsed / settleDuration.inMilliseconds;
      final curve = Curves.easeInOut.transform(t);
      if (mounted) {
        setState(() => _bounceScale = 1.06 - 0.06 * curve);
      }
      await Future.delayed(const Duration(milliseconds: 8));
    }

    if (mounted) {
      setState(() {
        _bounceScale = 1.0;
        _isBouncing = false;
      });
    }
  }

  Color _bgColor() {
    switch (widget.backgroundAsset) {
      case 'green':  return const Color(0xFF4CAF50);
      case 'orange': return const Color(0xFFFF9800);
      case 'red':    return const Color(0xFFE53935);
      case 'blue':   return const Color(0xFF42A5F5);
      default:       return const Color(0xFF4CAF50);
    }
  }

  Color _bgColorLight() {
    switch (widget.backgroundAsset) {
      case 'green':  return const Color(0xFF66BB6A);
      case 'orange': return const Color(0xFFFFA726);
      case 'red':    return const Color(0xFFEF5350);
      case 'blue':   return const Color(0xFF64B5F6);
      default:       return const Color(0xFF66BB6A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pillRadius = widget.height / 2;
    final iconSize = widget.height * 0.70;

    return Semantics(
      label: widget.text,
      button: true,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scale,
          child: Transform.scale(
            scale: _isBouncing ? _bounceScale : 1.0,
            child: SizedBox(
              width: widget.width ?? double.infinity,
              height: widget.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Layer 1: Fond dégradé
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
                  // Layer 3: Icône centrée
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
      ),
    );
  }
}
