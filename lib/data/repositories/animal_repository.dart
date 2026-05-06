import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/animal_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class AnimalRepository {
  static const List<AnimalModel> animals = [
    AnimalModel(
      id: 'crocodile',
      name: 'Crocodile',
      emoji: '\u{1F40A}',
      imageAsset: 'assets/images/crocodile.png',
      ambientAudioPath: 'audio/ambient_crocodile.mp3',
      endSoundPath: 'audio/end_crocodile.mp3',
      setupGradient: AppGradients.crocodileSetup,
      timerGradient: AppGradients.crocodileTimer,
      primaryColor: AppColors.crocodilePrimary,
      secondaryColor: AppColors.crocodileSecondary,
    ),
    AnimalModel(
      id: 'cat',
      name: 'Cat',
      emoji: '\u{1F431}',
      imageAsset: 'assets/images/cat.png',
      ambientAudioPath: 'audio/ambient_cat.mp3',
      endSoundPath: 'audio/end_cat.mp3',
      setupGradient: AppGradients.catSetup,
      timerGradient: AppGradients.catTimer,
      primaryColor: AppColors.catPrimary,
      secondaryColor: AppColors.catSecondary,
    ),
    AnimalModel(
      id: 'dog',
      name: 'Dog',
      emoji: '\u{1F436}',
      imageAsset: 'assets/images/dog.png',
      ambientAudioPath: 'audio/ambient_dog.mp3',
      endSoundPath: 'audio/end_dog.mp3',
      setupGradient: AppGradients.dogSetup,
      timerGradient: AppGradients.dogTimer,
      primaryColor: AppColors.dogPrimary,
      secondaryColor: AppColors.dogSecondary,
    ),
    AnimalModel(
      id: 'pony',
      name: 'Pony',
      emoji: '\u{1F434}',
      imageAsset: 'assets/images/pony.png',
      ambientAudioPath: 'audio/ambient_pony.mp3',
      endSoundPath: 'audio/end_pony.mp3',
      setupGradient: AppGradients.ponySetup,
      timerGradient: AppGradients.ponyTimer,
      primaryColor: AppColors.ponyPrimary,
      secondaryColor: AppColors.ponySecondary,
    ),
    AnimalModel(
      id: 'chicken',
      name: 'Chicken',
      emoji: '\u{1F414}',
      imageAsset: 'assets/images/chicken.png',
      ambientAudioPath: 'audio/ambient_chicken.mp3',
      endSoundPath: 'audio/end_chicken.mp3',
      setupGradient: AppGradients.chickenSetup,
      timerGradient: AppGradients.chickenTimer,
      primaryColor: AppColors.chickenPrimary,
      secondaryColor: AppColors.chickenSecondary,
    ),
    AnimalModel(
      id: 'shark',
      name: 'Shark',
      emoji: '\u{1F988}',
      imageAsset: 'assets/images/shark.png',
      ambientAudioPath: 'audio/ambient_shark_128.mp3',
      endSoundPath: 'audio/end_crocodile.mp3',
      setupGradient: AppGradients.sharkSetup,
      timerGradient: AppGradients.sharkTimer,
      primaryColor: AppColors.sharkPrimary,
      secondaryColor: AppColors.sharkSecondary,
      isDarkTheme: true,
    ),
    AnimalModel(
      id: 'unicorn',
      name: 'Unicorn',
      emoji: '\u{1F984}',
      imageAsset: 'assets/images/unicorn.png',
      ambientAudioPath: 'audio/ambient_unicorn_128.mp3',
      endSoundPath: 'audio/end_unicorn.mp3',
      setupGradient: AppGradients.unicornSetup,
      timerGradient: AppGradients.unicornTimer,
      primaryColor: AppColors.unicornPrimary,
      secondaryColor: AppColors.unicornSecondary,
    ),
  ];

  AnimalModel getById(String id) {
    return animals.firstWhere((a) => a.id == id, orElse: () => animals.first);
  }
  List<AnimalModel> getAll() => animals;
}

final animalRepoProvider = Provider((ref) => AnimalRepository());
