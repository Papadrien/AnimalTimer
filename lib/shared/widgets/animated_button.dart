import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'sketchy_painter.dart';

/// Bouton rond avec contour "dessiné à la main" et couleur crayon.
class AnimatedButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double size;
  final Color? fillColor;
  final int seed;

  const AnimatedButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.size = 100,
    this.fillColor,
    this.seed = 42,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _onTapDown(TapDownDetails _) { _ctrl.forward(); HapticFeedback.lightImpact(); }
  void _onTapUp(TapUpDetails _) { _ctrl.reverse(); widget.onPressed(); }
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: CustomPaint(
          painter: SketchyCirclePainter(
            strokeColor: AppColors.pencilDark,
            fillColor: widget.fillColor ?? AppColors.buttonFill,
            strokeWidth: 2.5,
            seed: widget.seed,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.label, style: AppTextStyles.buttonLabel),
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(widget.icon, color: AppColors.crayonOrange, size: 28),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
