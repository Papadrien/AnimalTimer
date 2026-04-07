import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/timer_preset.dart';
import '../../../data/models/animal_model.dart';
import '../../../data/repositories/animal_repository.dart';

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

  SetupNotifier(this._animalRepo)
      : super(SetupState(selectedAnimal: _animalRepo.getAll().first));

  void setHours(int h) => state = state.copyWith(hours: h.clamp(0, 23));
  void setMinutes(int m) => state = state.copyWith(minutes: m.clamp(0, 59));
  void setSeconds(int s) => state = state.copyWith(seconds: s.clamp(0, 59));

  void nextAnimal() {
    final animals = _animalRepo.getAll();
    final idx = animals.indexWhere((a) => a.id == state.selectedAnimal.id);
    state = state.copyWith(selectedAnimal: animals[(idx + 1) % animals.length]);
  }

  void selectAnimal(String id) {
    state = state.copyWith(selectedAnimal: _animalRepo.getById(id));
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

  void setRecentPresets(List<TimerPreset> presets) {
    state = state.copyWith(recentPresets: presets);
  }
}

final animalRepoProvider = Provider((ref) => AnimalRepository());

final setupProvider = StateNotifierProvider<SetupNotifier, SetupState>((ref) {
  return SetupNotifier(ref.read(animalRepoProvider));
});
