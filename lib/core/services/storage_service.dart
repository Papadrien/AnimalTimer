import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/timer_preset.dart';
import '../../data/models/app_settings.dart';

class StorageService {
  static const _presetsKey = 'timer_presets';
  static const _settingsKey = 'app_settings';
  static const _lastAnimalKey = 'last_animal_id';
  final SharedPreferences _prefs;
  StorageService(this._prefs);

  List<TimerPreset> getPresets() {
    final raw = _prefs.getStringList(_presetsKey) ?? [];
    return raw.map((e) => TimerPreset.fromJson(jsonDecode(e))).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> savePreset(TimerPreset preset) async {
    final presets = getPresets();
    presets.insert(0, preset);
    if (presets.length > 10) presets.removeLast();
    await _prefs.setStringList(_presetsKey,
      presets.map((e) => jsonEncode(e.toJson())).toList());
  }

  AppSettings getSettings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return const AppSettings();
    return AppSettings.fromJson(jsonDecode(raw));
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  String getLastAnimalId() => _prefs.getString(_lastAnimalKey) ?? 'duck';
  Future<void> saveLastAnimalId(String id) async {
    await _prefs.setString(_lastAnimalKey, id);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main with ProviderScope');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(sharedPrefsProvider));
});
