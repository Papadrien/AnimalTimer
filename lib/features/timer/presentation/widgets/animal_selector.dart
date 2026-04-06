// lib/features/timer/presentation/widgets/animal_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/models.dart';
import '../../../../core/theme/app_colors.dart';
import 'glass_card.dart';

class AnimalSelector extends StatefulWidget {
  const AnimalSelector({
    super.key,
    required this.animals,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<AnimalModel> animals;
  final int               selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  State<AnimalSelector> createState() => _AnimalSelectorState();
}

class _AnimalSelectorState extends State<AnimalSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double>   _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450),
    );
    _bounce = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() { _bounceCtrl.dispose(); super.dispose(); }

  void _go(int newIdx) {
    HapticFeedback.selectionClick();
    _bounceCtrl.forward(from: 0);
    widget.onChanged(newIdx);
  }

  void _prev() => _go((widget.selectedIndex - 1 + widget.animals.length) % widget.animals.length);
  void _next() => _go((widget.selectedIndex + 1) % widget.animals.length);

  @override
  Widget build(BuildContext context) {
    final animal = widget.animals[widget.selectedIndex];
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Arrow(icon: Icons.chevron_left_rounded,  onTap: _prev),

          GestureDetector(
            onHorizontalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v < -250) _next();
              if (v >  250) _prev();
            },
            child: AnimatedBuilder(
              animation: _bounce,
              builder: (_, child) =>
                  Transform.scale(scale: _bounce.value, child: child),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(animal.emoji, style: const TextStyle(fontSize: 58)),
                  const SizedBox(height: 6),
                  Text(
                    animal.name,
                    style: const TextStyle(
                      fontSize:   16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                      color:      AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _Arrow(icon: Icons.chevron_right_rounded, onTap: _next),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onTap});
  final IconData      icon;
  final VoidCallback  onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color:  AppColors.glassWhiteLight,
            shape:  BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, color: AppColors.textMedium, size: 26),
        ),
      );
}
