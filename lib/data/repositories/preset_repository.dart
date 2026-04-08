import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/storage_service.dart';
import '../models/timer_preset.dart';

class PresetRepository {
  final StorageService _storage;
  PresetRepository(this._storage);

  List<TimerPreset> getRecents() => _storage.getPresets();

  Future<void> addPreset({
    required String name,
    required Duration duration,
    required String animalId,
  }) async {
    final preset = TimerPreset(
      id: const Uuid().v4(),
      name: name,
      duration: duration,
      animalId: animalId,
      createdAt: DateTime.now(),
    );
    await _storage.savePreset(preset);
  }
}

final presetRepositoryProvider = Provider<PresetRepository>((ref) {
  return PresetRepository(ref.watch(storageServiceProvider));
});
