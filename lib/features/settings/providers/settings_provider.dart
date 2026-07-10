import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/app_settings.dart';
import '../../../core/services/storage_service.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final StorageService _storage;

  SettingsNotifier(this._storage) : super(const AppSettings()) {
    state = _storage.getSettings();
  }

  void toggleShowNumbers() {
    state = state.copyWith(showNumbers: !state.showNumbers);
    _storage.saveSettings(state);
  }

  void toggleAmbientSound() {
    state = state.copyWith(ambientSoundEnabled: !state.ambientSoundEnabled);
    _storage.saveSettings(state);
  }

  void toggleEndSound() {
    state = state.copyWith(endSoundEnabled: !state.endSoundEnabled);
    _storage.saveSettings(state);
  }

  void setVolume(double v) {
    state = state.copyWith(volume: v);
    _storage.saveSettings(state);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(ref.read(storageServiceProvider)),
);
