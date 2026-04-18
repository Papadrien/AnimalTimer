import '../models/animal_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class AnimalRepository {
  static const List<AnimalModel> animals = [
    AnimalModel(
      id: 'dog',
      name: 'Dog',
      emoji: '\u{1F436}',
      imageAsset: 'assets/images/dog.png',
      ambientAudioPath: 'audio/ambient_default.wav',
      endSoundPath: 'audio/end_default.wav',
      setupGradient: AppGradients.dogSetup,
      timerGradient: AppGradients.dogTimer,
      primaryColor: AppColors.dogPrimary,
      secondaryColor: AppColors.dogSecondary,
    ),
    AnimalModel(
      id: 'cat',
      name: 'Cat',
      emoji: '\u{1F431}',
      imageAsset: 'assets/images/cat.png',
      ambientAudioPath: 'audio/ambient_default.wav',
      endSoundPath: 'audio/end_default.wav',
      setupGradient: AppGradients.catSetup,
      timerGradient: AppGradients.catTimer,
      primaryColor: AppColors.catPrimary,
      secondaryColor: AppColors.catSecondary,
    ),
    AnimalModel(
      id: 'crocodile',
      name: 'Crocodile',
      emoji: '\u{1F40A}',
      imageAsset: 'assets/images/crocodile.png',
      ambientAudioPath: 'audio/ambient_default.wav',
      endSoundPath: 'audio/end_default.wav',
      setupGradient: AppGradients.crocodileSetup,
      timerGradient: AppGradients.crocodileTimer,
      primaryColor: AppColors.crocodilePrimary,
      secondaryColor: AppColors.crocodileSecondary,
    ),
    AnimalModel(
      id: 'pony',
      name: 'Pony',
      emoji: '\u{1F434}',
      imageAsset: 'assets/images/pony.png',
      ambientAudioPath: 'audio/ambient_default.wav',
      endSoundPath: 'audio/end_default.wav',
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
      ambientAudioPath: 'audio/ambient_default.wav',
      endSoundPath: 'audio/end_default.wav',
      setupGradient: AppGradients.chickenSetup,
      timerGradient: AppGradients.chickenTimer,
      primaryColor: AppColors.chickenPrimary,
      secondaryColor: AppColors.chickenSecondary,
    ),
  ];

  AnimalModel getById(String id) {
    return animals.firstWhere((a) => a.id == id, orElse: () => animals.first);
  }
  List<AnimalModel> getAll() => animals;
}
