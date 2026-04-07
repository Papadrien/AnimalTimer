import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../../core/theme/app_gradients.dart';

class AnimalRepository {
  static const List<AnimalModel> animals = [
    AnimalModel(
      id: 'duck',
      name: 'Canard',
      emoji: '\u{1F986}',
      lottiePath: 'assets/lottie/duck_walking.json',
      idleLottiePath: 'assets/lottie/duck_idle.json',
      ambientAudioPath: 'audio/ambient_water.wav',
      endSoundPath: 'audio/end_duck.wav',
      setupGradient: AppGradients.duckSetup,
      timerGradient: AppGradients.duckTimer,
      primaryColor: Color(0xFFFFC838),
      secondaryColor: Color(0xFFFFB74D),
    ),
    AnimalModel(
      id: 'dog',
      name: 'Chien',
      emoji: '\u{1F436}',
      lottiePath: 'assets/lottie/dog_walking.json',
      idleLottiePath: 'assets/lottie/dog_idle.json',
      ambientAudioPath: 'audio/ambient_joyful.wav',
      endSoundPath: 'audio/end_dog.wav',
      setupGradient: AppGradients.dogSetup,
      timerGradient: AppGradients.dogTimer,
      primaryColor: Color(0xFF7B8DCC),
      secondaryColor: Color(0xFF93B5E1),
    ),
  ];

  AnimalModel getById(String id) {
    return animals.firstWhere((a) => a.id == id, orElse: () => animals.first);
  }

  List<AnimalModel> getAll() => animals;
}
