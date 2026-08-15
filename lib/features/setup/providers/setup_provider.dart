import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/timer_preset.dart';
import '../../../data/models/animal_model.dart';
import '../../../data/repositories/animal_repository.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/gamification_service.dart';

class SetupState {
  final int hours;
  final int minutes;
  final int seconds;
  final AnimalModel selectedAnimal;
  final List<TimerPreset> recentPresets;

  const SetupState({
    this.hours = 0,
    this.minutes = 3,
    this.seconds = 0,
    required this.selectedAnimal,
    this.recentPresets = const [],
  });

  Duration get duration => Duration(hours: hours, minutes: minutes, seconds: seconds);
  bool get isValid => duration.inSeconds > 0;

  SetupState copyWith({int? hours, int? minutes, int? seconds,
      AnimalModel? selectedAnimal, List<TimerPreset>? recentPresets}) {
    return SetupState(
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      selectedAnimal: selectedAnimal ?? this.selectedAnimal,
      recentPresets: recentPresets ?? this.recentPresets,
    );
  }
}

class SetupNotifier extends StateNotifier<SetupState> {
  final AnimalRepository _animalRepo;
  final StorageService _storage;
  final GamificationService _gamification;

  /// Animal de secours toujours débloqué, utilisé quand l'animal
  /// sélectionné n'est plus disponible (ex. déblocage par pub expiré).
  static const _fallbackAnimalId = 'crocodile';

  SetupNotifier(this._animalRepo, this._storage, this._gamification)
      : super(_initialState(_animalRepo, _storage)) {
    // Au démarrage, si le dernier animal utilisé n'est plus débloqué
    // (déblocage temporaire par pub expiré entre-temps), on retombe sur
    // le crocodile plutôt que de garder un animal verrouillé sélectionné.
    validateSelectedAnimal();
  }

  /// Construit l'état initial directement (sans setState après le build).
  static SetupState _initialState(
      AnimalRepository repo, StorageService storage) {
    final presets = storage.getPresets();
    final lastAnimalId = storage.getLastAnimalId();
    final animal = repo.getById(lastAnimalId);
    return SetupState(
      selectedAnimal: animal,
      recentPresets: presets,
    );
  }

  void setHours(int h) => state = state.copyWith(hours: h.clamp(0, 23));
  void setMinutes(int m) => state = state.copyWith(minutes: m.clamp(0, 59));
  void setSeconds(int s) => state = state.copyWith(seconds: s.clamp(0, 59));

  void nextAnimal() {
    final animals = _animalRepo.getAll();
    final idx = animals.indexWhere((a) => a.id == state.selectedAnimal.id);
    final next = animals[(idx + 1) % animals.length];
    state = state.copyWith(selectedAnimal: next);
    _storage.saveLastAnimalId(next.id);
  }

  void selectAnimal(String id) {
    final animal = _animalRepo.getById(id);
    state = state.copyWith(selectedAnimal: animal);
    _storage.saveLastAnimalId(id);
  }

  /// Vérifie que l'animal actuellement sélectionné est toujours débloqué.
  /// Si le temps accordé par le visionnage d'une pub a expiré (et que
  /// l'animal n'est ni gratuit, ni débloqué en premium), on revient
  /// automatiquement sur le crocodile.
  ///
  /// À appeler : au démarrage de l'appli, au retour au premier plan, et
  /// juste avant de lancer un minuteur — pour ne jamais démarrer avec un
  /// animal qui n'est plus disponible.
  void validateSelectedAnimal() {
    if (_gamification.isUnlocked(state.selectedAnimal.id)) return;
    final fallback = _animalRepo.getById(_fallbackAnimalId);
    state = state.copyWith(selectedAnimal: fallback);
    _storage.saveLastAnimalId(fallback.id);
  }

  /// Sélectionne un animal aléatoire parmi ceux débloqués par l'utilisateur.
  /// Déclenché par la card "Aléatoire" dans la bottom sheet de sélection.
  /// Si un seul animal (ou aucun) est débloqué, ne change rien.
  void selectRandomUnlockedAnimal() {
    final unlocked = _animalRepo
        .getAll()
        .where((a) => _gamification.isUnlocked(a.id))
        .toList();
    if (unlocked.length <= 1) return;
    final candidates = unlocked
        .where((a) => a.id != state.selectedAnimal.id)
        .toList();
    final pool = candidates.isNotEmpty ? candidates : unlocked;
    final animal = pool[Random().nextInt(pool.length)];
    state = state.copyWith(selectedAnimal: animal);
    _storage.saveLastAnimalId(animal.id);
  }

  void loadPreset(TimerPreset preset) {
    final presetAnimal = _animalRepo.getById(preset.animalId);
    // Si l'animal du preset n'est plus débloqué (pub expirée depuis), on
    // retombe sur le crocodile plutôt que de resélectionner un animal
    // verrouillé.
    final isLocked = !_gamification.isUnlocked(presetAnimal.id);
    final animal =
        isLocked ? _animalRepo.getById(_fallbackAnimalId) : presetAnimal;
    state = state.copyWith(
      hours: preset.duration.inHours,
      minutes: preset.duration.inMinutes.remainder(60),
      seconds: preset.duration.inSeconds.remainder(60),
      selectedAnimal: animal,
    );
    if (isLocked) _storage.saveLastAnimalId(animal.id);
  }

  /// Sauvegarder le timer actuel comme "recent" quand on lance le timer
  Future<void> saveCurrentAsRecent() async {
    final count = state.recentPresets.length + 1;
    final preset = TimerPreset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Timer $count',
      duration: state.duration,
      animalId: state.selectedAnimal.id,
      createdAt: DateTime.now(),
    );
    await _storage.savePreset(preset);
    // Recharger depuis le storage (pour avoir l'ordre et la limite de 10)
    final updated = _storage.getPresets();
    state = state.copyWith(recentPresets: updated);
  }
}

final setupProvider = StateNotifierProvider<SetupNotifier, SetupState>((ref) {
  return SetupNotifier(
    ref.read(animalRepoProvider),
    ref.read(storageServiceProvider),
    ref.read(gamificationServiceProvider),
  );
});
