// lib/features/timer/presentation/widgets/animal_widget.dart

import 'package:flutter/material.dart';
import '../../domain/models/models.dart';
import '../../../../core/constants/app_constants.dart';

/// Affiche l'animal avec une animation "respiration" douce en boucle.
/// En production : remplacer le Text emoji par Lottie.asset(animal.lottiePath)
class AnimalWidget extends StatefulWidget {
  const AnimalWidget({
    super.key,
    required this.animal,
    this.size            = 100,
    this.enableBreathing = true,
  });

  final AnimalModel animal;
  final double      size;
  final bool        enableBreathing;

  @override
  State<AnimalWidget> createState() => _AnimalWidgetState();
}

class _AnimalWidgetState extends State<AnimalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: Duration(milliseconds: AppConstants.breathingDurationMs),
    );
    _scale = Tween<double>(
      begin: AppConstants.breathingScaleMin,
      end:   AppConstants.breathingScaleMax,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    if (widget.enableBreathing) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimalWidget old) {
    super.didUpdateWidget(old);
    if (widget.enableBreathing && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.enableBreathing && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: SizedBox(
        width: widget.size, height: widget.size,
        child: Center(
          // 🔁 Remplacer par :
          // Lottie.asset(widget.animal.lottiePath,
          //   width: widget.size, height: widget.size, fit: BoxFit.contain)
          child: Text(
            widget.animal.emoji,
            style: TextStyle(fontSize: widget.size * 0.72),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
