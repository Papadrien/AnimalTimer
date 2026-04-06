// lib/features/timer/presentation/providers/settings_provider.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

// ── Modèle ───────────────────────────────────────────────────────────────────

class AppSettings {
  const AppSettings({
    this.showTime          = true,
    this.showAnimal        = true,
    this.tickTockEnabled   = false,
    this.animalSoundEnabled = true,
    this.volume            = AppConstants.defaultVolume,
  });

  final bool   showTime;
  final bool   showAnimal;
  final bool   tickTockEnabled;
  final bool   animalSoundEnabled;
  final double volume;

  AppSettings copyWith({
    bool?   showTime,
    bool?   showAnimal,
    bool?   tickTockEnabled,
    bool?   animalSoundEnabled,
    double? volume,
  }) =>
      AppSettings(
        showTime:           showTime           ?? this.showTime,
        showAnimal:         showAnimal         ?? this.showAnimal,
        tickTockEnabled:    tickTockEnabled    ?? this.tickTockEnabled,
        animalSoundEnabled: animalSoundEnabled ?? this.animalSoundEnabled,
        volume:             volume             ?? this.volume,
      );

  Map<String, dynamic> toJson() => {
        'showTime':           showTime,
        'showAnimal':         showAnimal,
        'tickTockEnabled':    tickTockEnabled,
        'animalSoundEnabled': animalSoundEnabled,
        'volume':             volume,
      };

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        showTime:           j['showTime']           as bool?   ?? true,
        showAnimal:         j['showAnimal']         as bool?   ?? true,
        tickTockEnabled:    j['tickTockEnabled']    as bool?   ?? false,
        animalSoundEnabled: j['animalSoundEnabled'] as bool?   ?? true,
        volume:             (j['volume']            as num?)?.toDouble()
                                                             ?? AppConstants.defaultVolume,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(AppConstants.keySettings);
    if (raw != null) {
      state = AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySettings, jsonEncode(state.toJson()));
  }

  void setShowTime(bool v)           { state = state.copyWith(showTime: v);           _save(); }
  void setShowAnimal(bool v)         { state = state.copyWith(showAnimal: v);         _save(); }
  void setTickTock(bool v)           { state = state.copyWith(tickTockEnabled: v);    _save(); }
  void setAnimalSound(bool v)        { state = state.copyWith(animalSoundEnabled: v); _save(); }
  void setVolume(double v)           { state = state.copyWith(volume: v);             _save(); }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
  (_) => SettingsNotifier(),
);
