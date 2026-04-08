import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/animal_model.dart';

/// Displays an animal SVG with a gentle breathing + sway animation.
class AnimalDisplay extends StatefulWidget {
  final AnimalModel animal;
  final double size;
  final bool animate;

  const AnimalDisplay({
    super.key,
    required this.animal,
    this.size = 120,
    this.animate = true,
  });

  @override
  State<AnimalDisplay> createState() => _AnimalDisplayState();
}

class _AnimalDisplayState extends State<AnimalDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _breathe;
  late Animation<double> _sway;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _breathe = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _sway = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (widget.animate) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimalDisplay old) {
    super.didUpdateWidget(old);
    if (widget.animate && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.animate && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svgWidget = SvgPicture.asset(
      widget.animal.svgAsset,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => Center(
        child: Text(widget.animal.emoji,
            style: TextStyle(fontSize: widget.size * 0.4)),
      ),
    );

    if (!widget.animate) return svgWidget;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.scale(
        scale: _breathe.value,
        child: Transform.rotate(
          angle: _sway.value,
          child: svgWidget,
        ),
      ),
    );
  }
}
