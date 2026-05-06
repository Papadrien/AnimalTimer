import 'package:flutter/material.dart';
import '../../data/models/animal_model.dart';
import 'cat_animated_display.dart';
import 'chicken_animated_display.dart';
import 'crocodile_animated_display.dart';
import 'dog_animated_display.dart';
import 'pony_animated_display.dart';
import 'shark_animated_display.dart';
import 'unicorn_animated_display.dart';

/// Displays an animal image (PNG) with animation.
///
/// For cat, chicken, crocodile and pony, two modes :
/// - [useStaticImage] = false (default) → multi-layer animation
/// - [useStaticImage] = true → single image (for finish screen bounce, timer breathing)
///
/// [playOnce] : if true and multi-layer mode, plays exactly 1 cycle (2s) then stops.
///              Used on the setup screen.
class AnimalDisplay extends StatefulWidget {
  final AnimalModel animal;
  final double size;
  final bool animate;
  final bool useStaticImage;
  final bool playOnce;

  const AnimalDisplay({
    super.key,
    required this.animal,
    this.size = 120,
    this.animate = true,
    this.useStaticImage = false,
    this.playOnce = false,
  });

  @override
  State<AnimalDisplay> createState() => _AnimalDisplayState();
}

class _AnimalDisplayState extends State<AnimalDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _breathe;
  late Animation<double> _sway;

  /// IDs of animals that have custom multi-layer animations.
  static const _animatedIds = {'cat', 'chicken', 'crocodile', 'dog', 'pony', 'shark', 'unicorn'};

  /// Returns true if this animal has a custom multi-layer animation.
  bool get _hasCustomAnimation =>
      _animatedIds.contains(widget.animal.id) && !widget.useStaticImage;

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
    if (widget.animate && !_hasCustomAnimation) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimalDisplay old) {
    super.didUpdateWidget(old);
    if (_hasCustomAnimation) {
      if (_ctrl.isAnimating) _ctrl.stop();
    } else if (widget.animate && !_ctrl.isAnimating) {
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
    final id = widget.animal.id;

    // Cat multi-layer animation
    if (id == 'cat' && !widget.useStaticImage) {
      return CatAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }

    // Chicken multi-layer animation
    if (id == 'chicken' && !widget.useStaticImage) {
      return ChickenAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }

    // Crocodile multi-layer animation
    if (id == 'crocodile' && !widget.useStaticImage) {
      return CrocodileAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }


    // Dog multi-layer animation
    if (id == 'dog' && !widget.useStaticImage) {
      return DogAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }

    // Pony multi-layer animation
    if (id == 'pony' && !widget.useStaticImage) {
      return PonyAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }

    // Shark multi-layer animation
    if (id == 'shark' && !widget.useStaticImage) {
      return SharkAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }

    // Unicorn multi-layer animation
    if (id == 'unicorn' && !widget.useStaticImage) {
      return UnicornAnimatedDisplay(
        size: widget.size,
        animate: widget.animate,
        playOnce: widget.playOnce,
      );
    }

    // Default: single image (all other animals + when useStaticImage=true)
    final imageWidget = Image.asset(
      widget.animal.imageAsset,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Center(
        child: Text(widget.animal.emoji,
            style: TextStyle(fontSize: widget.size * 0.4)),
      ),
    );

    if (!widget.animate) return imageWidget;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.scale(
        scale: _breathe.value,
        child: Transform.rotate(
          angle: _sway.value,
          child: imageWidget,
        ),
      ),
    );
  }
}
