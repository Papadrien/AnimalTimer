import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/animal_repository.dart';
import 'storage_service.dart';

/// Service de gestion du déblocage des animaux.
/// Crocodile et Chat sont débloqués par défaut.
/// Les autres nécessitent le visionnage d'une pub (déblocage global de 12h)
/// OU l'achat premium (déblocage permanent).
class GamificationService {
  final StorageService _storage;
  GamificationService(this._storage);

  // --- Premium (achat in-app) ---

  /// Vérifie si l'utilisateur a acheté le pack premium.
  bool isPremiumUnlocked() => _storage.getPremiumUnlocked();

  /// Débloque tous les animaux via l'achat premium.
  Future<void> unlockAllAnimals() async {
    await _storage.savePremiumUnlocked(true);
  }

  // --- Déblocage individuel ---

  /// Vérifie si un animal est débloqué (par défaut, par pub avec expiration, ou par premium).
  bool isUnlocked(String animalId) {
    if (isPremiumUnlocked()) return true; // Premium → tout débloqué
    return _storage.isAnimalUnlocked(animalId);
  }

  /// Retourne les IDs des animaux verrouillés.
  List<String> getLockedAnimalIds() {
    if (isPremiumUnlocked()) return []; // Premium → rien de verrouillé
    return AnimalRepository.animals
        .map((a) => a.id)
        .where((id) => !_storage.isAnimalUnlocked(id))
        .toList();
  }

  /// Retourne true s'il reste des animaux verrouillés.
  bool hasLockedAnimals() => getLockedAnimalIds().isNotEmpty;

  /// Débloque tous les animaux pour 12h (après visionnage de pub).
  Future<void> unlockAllAnimalsByAd() async {
    await _storage.unlockAllByAd(hours: 12);
  }

  /// Retourne le nombre d'heures restantes avant que cet animal ne se
  /// reverrouille (déblocage global par pub).
  /// Retourne null si gratuit, premium, ou pas débloqué par pub.
  int? getHoursRemaining(String animalId) {
    if (isPremiumUnlocked()) return null; // Premium → permanent
    if (StorageService.defaultUnlocked.contains(animalId)) return null; // Gratuit
    final hours = _storage.getHoursRemaining();
    return hours > 0 ? hours : null;
  }
}

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return GamificationService(storage);
});
