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
  static const _adUnlockedKey = 'ad_unlocked_animals';
  static const _premiumKey = 'premium_unlocked';

  /// Animaux débloqués par défaut (gratuits).
  static const defaultUnlocked = {'crocodile', 'cat'};

  /// Retourne la map des animaux débloqués par pub {animalId: expirationTimestamp}.
  Map<String, int> _getAdUnlockedMap() {
    final raw = _prefs.getString(_adUnlockedKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  /// Sauvegarde la map des animaux débloqués par pub.
  Future<void> _saveAdUnlockedMap(Map<String, int> map) async {
    await _prefs.setString(_adUnlockedKey, jsonEncode(map));
  }

  /// Débloque un animal par pub pour [days] jours.
  Future<void> unlockAnimalByAd(String animalId, {int days = 15}) async {
    final map = _getAdUnlockedMap();
    final expiration = DateTime.now().add(Duration(days: days));
    map[animalId] = expiration.millisecondsSinceEpoch;
    await _saveAdUnlockedMap(map);
  }

  /// Vérifie si un animal débloqué par pub est encore valide.
  bool isAdUnlockValid(String animalId) {
    final map = _getAdUnlockedMap();
    final expiration = map[animalId];
    if (expiration == null) return false;
    return DateTime.now().millisecondsSinceEpoch < expiration;
  }

  /// Retourne le nombre de jours restants pour un animal débloqué par pub.
  /// Retourne 0 si expiré ou jamais débloqué.
  int getDaysRemaining(String animalId) {
    final map = _getAdUnlockedMap();
    final expiration = map[animalId];
    if (expiration == null) return 0;
    final remaining = expiration - DateTime.now().millisecondsSinceEpoch;
    if (remaining <= 0) return 0;
    return (remaining / (1000 * 60 * 60 * 24)).ceil();
  }

  /// Vérifie si un animal est débloqué (par défaut, pub ou premium).
  bool isAnimalUnlocked(String animalId) {
    if (defaultUnlocked.contains(animalId)) return true;
    return isAdUnlockValid(animalId);
  }

  // --- Premium (achat in-app) ---

  /// Vérifie si l'utilisateur a acheté le pack premium.
  bool getPremiumUnlocked() => _prefs.getBool(_premiumKey) ?? false;

  /// Sauvegarde le statut premium.
  Future<void> savePremiumUnlocked(bool value) async {
    await _prefs.setBool(_premiumKey, value);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main with ProviderScope');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(sharedPrefsProvider));
});
