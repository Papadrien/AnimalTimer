import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/timer_preset.dart';
import '../../../data/models/animal_model.dart';
import '../../../data/repositories/animal_repository.dart';
import '../../../core/services/storage_service.dart';

class SetupState {
  final int hours;
  final int minutes;
  final int seconds;
  final AnimalModel selectedAnimal;
  final List<TimerPreset> recentPresets;

  const SetupState({
    this.hours = 0,
    this.minutes = 2,
    this.seconds = 10,
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

  SetupNotifier(this._animalRepo, this._storage)
      : super(SetupState(selectedAnimal: _animalRepo.getAll().first)) {
    // Charger les recents et le dernier animal au démarrage
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final presets = _storage.getPresets();
    final lastAnimalId = _storage.getLastAnimalId();
    final animal = _animalRepo.getById(lastAnimalId);
    state = state.copyWith(
      recentPresets: presets,
      selectedAnimal: animal,
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

  void loadPreset(TimerPreset preset) {
    final animal = _animalRepo.getById(preset.animalId);
    state = state.copyWith(
      hours: preset.duration.inHours,
      minutes: preset.duration.inMinutes.remainder(60),
      seconds: preset.duration.inSeconds.remainder(60),
      selectedAnimal: animal,
    );
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

final animalRepoProvider = Provider((ref) => AnimalRepository());

final setupProvider = StateNotifierProvider<SetupNotifier, SetupState>((ref) {
  return SetupNotifier(
    ref.read(animalRepoProvider),
    ref.read(storageServiceProvider),
  );
});
