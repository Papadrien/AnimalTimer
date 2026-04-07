import 'package:flutter/material.dart';
import '../../../../data/models/animal_model.dart';
import '../../../../shared/widgets/animal_display.dart';

class AnimalAnimation extends StatelessWidget {
  final AnimalModel animal;
  final bool isRunning;
  final double size;

  const AnimalAnimation({
    super.key,
    required this.animal,
    required this.isRunning,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: AnimalDisplay(
        key: ValueKey('${animal.id}_$isRunning'),
        animal: animal,
        size: size,
        animate: isRunning,
      ),
    );
  }
}
