import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../data/models/animal_model.dart';

class AnimalAnimation extends StatelessWidget {
  final AnimalModel animal;
  final bool isRunning;

  const AnimalAnimation({super.key, required this.animal, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        key: ValueKey('${animal.id}_$isRunning'),
        width: 120, height: 120,
        child: Lottie.asset(
          isRunning ? animal.lottiePath : animal.idleLottiePath,
          animate: true, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
            Center(child: Text(animal.emoji, style: const TextStyle(fontSize: 60))),
        ),
      ),
    );
  }
}
