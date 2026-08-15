import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';

/// Bulle d'aide "coach mark" invitant l'utilisateur à toucher le bouton de
/// changement d'animal. N'est affichée qu'au tout premier lancement de
/// l'appli (géré par [StorageService.hasSeenAnimalSwitchTooltip]).
///
/// Se positionne au-dessus du badge, avec une petite flèche qui pointe vers
/// lui, et une animation d'apparition douce (fade + léger rebond).
class AnimalSwitchHintBubble extends StatefulWidget {
  const AnimalSwitchHintBubble({super.key});

  @override
  State<AnimalSwitchHintBubble> createState() =>
      _AnimalSwitchHintBubbleState();
}

class _AnimalSwitchHintBubbleState extends State<AnimalSwitchHintBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.4, curve: Curves.easeOut),
    );
    // Petit délai avant apparition pour laisser l'écran se stabiliser.
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        alignment: Alignment.bottomRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.paperLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.pencilDark, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              context.l10n.animalSwitchHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
