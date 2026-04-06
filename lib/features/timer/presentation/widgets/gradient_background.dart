// lib/features/timer/presentation/widgets/gradient_background.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Fond dégradé animé qui transite doucement quand l'animal change.
class GradientBackground extends StatefulWidget {
  const GradientBackground({
    super.key,
    required this.child,
    required this.animalId,
  });

  final Widget child;
  final String animalId;

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  LinearGradient _from = _bgGradient('duck');
  LinearGradient _to   = _bgGradient('duck');

  static LinearGradient _bgGradient(String id) {
    // Version désaturée / claire du dégradé animal pour le fond
    final g = id.animalGradient;
    return LinearGradient(
      begin: Alignment.topLeft,
      end:   Alignment.bottomRight,
      colors: [
        g.colors.first.withOpacity(0.18),
        g.colors.last.withOpacity(0.28),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _from = _bgGradient(widget.animalId);
    _to   = _from;
  }

  @override
  void didUpdateWidget(GradientBackground old) {
    super.didUpdateWidget(old);
    if (old.animalId != widget.animalId) {
      _from = _bgGradient(old.animalId);
      _to   = _bgGradient(widget.animalId);
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        final gradient = LinearGradient.lerp(_from, _to, _anim.value)!;
        return Container(
          decoration: BoxDecoration(gradient: gradient),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
