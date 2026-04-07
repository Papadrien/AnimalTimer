import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../providers/setup_provider.dart';

class AnimalSelector extends ConsumerWidget {
  const AnimalSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animal = ref.watch(setupProvider).selectedAnimal;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(setupProvider.notifier).nextAnimal();
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim, child: FadeTransition(opacity: anim, child: child)),
            child: Container(
              key: ValueKey(animal.id),
              width: 140, height: 140,
              decoration: BoxDecoration(
                color: animal.primaryColor, shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: animal.primaryColor.withOpacity(0.4),
                  blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: ClipOval(
                child: Lottie.asset(animal.idleLottiePath, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(animal.emoji, style: const TextStyle(fontSize: 60)))),
              ),
            ),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: animal.secondaryColor, shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2)),
            child: const Icon(Icons.sync, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
