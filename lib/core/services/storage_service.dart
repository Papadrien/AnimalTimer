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
  static const _adUnlockAllExpirationKey = 'ad_unlock_all_expiration';
  static const _premiumKey = 'premium_unlocked';

  /// Animaux débloqués par défaut (gratuits).
  static const defaultUnlocked = {'crocodile', 'cat'};

  /// Débloque tous les animaux par pub pour [hours] heures.
  Future<void> unlockAllByAd({int hours = 12}) async {
    final expiration = DateTime.now().add(Duration(hours: hours));
    await _prefs.setInt(
      _adUnlockAllExpirationKey,
      expiration.millisecondsSinceEpoch,
    );
  }

  /// Vérifie si le déblocage global par pub est encore valide.
  bool isAdUnlockAllValid() {
    final expiration = _prefs.getInt(_adUnlockAllExpirationKey);
    if (expiration == null) return false;
    return DateTime.now().millisecondsSinceEpoch < expiration;
  }

  /// Retourne le nombre d'heures restantes pour le déblocage global par pub.
  /// Retourne 0 si expiré ou jamais débloqué.
  int getHoursRemaining() {
    final expiration = _prefs.getInt(_adUnlockAllExpirationKey);
    if (expiration == null) return 0;
    final remaining = expiration - DateTime.now().millisecondsSinceEpoch;
    if (remaining <= 0) return 0;
    return (remaining / (1000 * 60 * 60)).ceil();
  }

  /// Vérifie si un animal est débloqué (par défaut, pub ou premium).
  bool isAnimalUnlocked(String animalId) {
    if (defaultUnlocked.contains(animalId)) return true;
    return isAdUnlockAllValid();
  }

  // --- Premium (achat in-app) ---

  /// Vérifie si l'utilisateur a acheté le pack premium.
  bool getPremiumUnlocked() => _prefs.getBool(_premiumKey) ?? false;

  /// Sauvegarde le statut premium.
  Future<void> savePremiumUnlocked(bool value) async {
    await _prefs.setBool(_premiumKey, value);
  }

  // --- Onboarding : bulle d'aide sur le bouton de changement d'animal ---
  static const _animalSwitchHintSeenKey = 'has_seen_animal_switch_tooltip';

  /// Vérifie si la bulle d'aide sur le changement d'animal a déjà été vue.
  bool hasSeenAnimalSwitchTooltip() =>
      _prefs.getBool(_animalSwitchHintSeenKey) ?? false;

  /// Marque la bulle d'aide sur le changement d'animal comme vue, pour ne
  /// plus jamais l'afficher.
  Future<void> markAnimalSwitchTooltipSeen() async {
    await _prefs.setBool(_animalSwitchHintSeenKey, true);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main with ProviderScope');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(sharedPrefsProvider));
});
