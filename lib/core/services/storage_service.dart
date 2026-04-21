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

  String getLastAnimalId() => _prefs.getString(_lastAnimalKey) ?? 'crocodile';
  Future<void> saveLastAnimalId(String id) async {
    await _prefs.setString(_lastAnimalKey, id);
  }

  // --- Déblocage des animaux ---
  static const _unlockedAnimalsKey = 'unlocked_animal_ids';

  /// Animaux débloqués par défaut (gratuits).
  static const defaultUnlocked = {'crocodile', 'cat'};

  /// Retourne la liste des IDs d'animaux débloqués.
  Set<String> getUnlockedAnimalIds() {
    final raw = _prefs.getStringList(_unlockedAnimalsKey);
    if (raw == null) return Set.from(defaultUnlocked);
    return Set.from(defaultUnlocked)..addAll(raw);
  }

  /// Débloque un animal par son ID.
  Future<void> unlockAnimal(String animalId) async {
    final unlocked = getUnlockedAnimalIds();
    unlocked.add(animalId);
    await _prefs.setStringList(_unlockedAnimalsKey, unlocked.toList());
  }

  /// Vérifie si un animal est débloqué.
  bool isAnimalUnlocked(String animalId) {
    return getUnlockedAnimalIds().contains(animalId);
  }

}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main with ProviderScope');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(sharedPrefsProvider));
});
