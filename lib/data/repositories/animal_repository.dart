import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class AnimalRepository {
  static const List<AnimalModel> animals = [
    AnimalModel(
      id: 'duck',
      name: 'Canard',
      emoji: '\u{1F986}',
      svgAsset: 'assets/images/duck.svg',
      ambientAudioPath: 'audio/ambient_duck.mp3',
      endSoundPath: 'audio/end_duck.wav',
      setupGradient: AppGradients.duckSetup,
      timerGradient: AppGradients.duckTimer,
      primaryColor: AppColors.duckPrimary,
      secondaryColor: AppColors.duckSecondary,
    ),
    AnimalModel(
      id: 'dog',
      name: 'Chien',
      emoji: '\u{1F436}',
      svgAsset: 'assets/images/dog.svg',
      ambientAudioPath: 'audio/ambient_joyful.wav',
      endSoundPath: 'audio/end_dog.wav',
      setupGradient: AppGradients.dogSetup,
      timerGradient: AppGradients.dogTimer,
      primaryColor: AppColors.dogPrimary,
      secondaryColor: AppColors.dogSecondary,
    ),
  ];

  AnimalModel getById(String id) {
    return animals.firstWhere((a) => a.id == id, orElse: () => animals.first);
  }
  List<AnimalModel> getAll() => animals;
}
