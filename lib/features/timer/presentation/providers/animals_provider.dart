// lib/features/timer/presentation/providers/animals_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/timer_repository.dart';
import '../../domain/models/models.dart';

final _repositoryProvider = Provider((_) => TimerRepository());

/// Liste des animaux chargée depuis assets/config/animals.json.
/// Ajouter un animal = éditer le JSON, aucun code à modifier.
final animalsProvider = FutureProvider<List<AnimalModel>>((ref) async {
  return ref.read(_repositoryProvider).loadAnimals();
});

/// Index de l'animal actuellement sélectionné sur l'écran d'accueil.
final selectedAnimalIndexProvider = StateProvider<int>((_) => 0);

/// Repository exposé aux autres providers.
final timerRepositoryProvider = Provider((_) => TimerRepository());
