import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/animal_repository.dart';
import 'storage_service.dart';

final animalRepoProvider = Provider((ref) => AnimalRepository());

/// Service de gestion du déblocage des animaux.
/// Crocodile et Chat sont débloqués par défaut.
/// Les autres (Chien, Poney, Poule) nécessitent le visionnage d'une pub.
class GamificationService {
  final StorageService _storage;
  GamificationService(this._storage);

  /// Vérifie si un animal est débloqué.
  bool isUnlocked(String animalId) {
    return _storage.isAnimalUnlocked(animalId);
  }

  /// Retourne les IDs des animaux verrouillés.
  List<String> getLockedAnimalIds() {
    final unlocked = _storage.getUnlockedAnimalIds();
    return AnimalRepository.animals
        .map((a) => a.id)
        .where((id) => !unlocked.contains(id))
        .toList();
  }

  /// Retourne true s'il reste des animaux verrouillés.
  bool hasLockedAnimals() => getLockedAnimalIds().isNotEmpty;

  /// Débloque un animal (après visionnage de pub).
  Future<void> unlockAnimal(String animalId) async {
    await _storage.unlockAnimal(animalId);
  }
}

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return GamificationService(storage);
});
