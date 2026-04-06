// lib/features/timer/data/timer_repository.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/models.dart';
import '../../../core/constants/app_constants.dart';

class TimerRepository {
  // ── Récents ──────────────────────────────────────────────────────────────

  Future<List<TimerConfig>> getRecentTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(AppConstants.keyRecentTimers) ?? [];
    return raw
        .map((s) => TimerConfig.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRecentTimer(TimerConfig config) async {
    final prefs  = await SharedPreferences.getInstance();
    var recents  = await getRecentTimers();

    // Dédoublonnage : même durée + même animal
    recents.removeWhere(
      (r) => r.duration == config.duration && r.animalId == config.animalId,
    );

    // Insérer en tête + limiter
    recents.insert(0, TimerConfig(
      duration: config.duration,
      animalId: config.animalId,
      lastUsed: DateTime.now(),
    ));
    if (recents.length > AppConstants.maxRecentTimers) {
      recents = recents.sublist(0, AppConstants.maxRecentTimers);
    }

    await prefs.setStringList(
      AppConstants.keyRecentTimers,
      recents.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }

  // ── Animals (JSON config extensible) ─────────────────────────────────────

  Future<List<AnimalModel>> loadAnimals() async {
    try {
      final raw  = await rootBundle.loadString(AppConstants.animalsConfigPath);
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => AnimalModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Fallback hardcodé si le JSON est absent
      return _defaultAnimals;
    }
  }

  static const _defaultAnimals = [
    AnimalModel(
      id:         'duck',
      name:       'Canard',
      emoji:      '🦆',
      lottiePath: 'assets/animations/duck_idle.json',
      imagePath:  'assets/images/duck.png',
      audioPath:  'assets/audio/duck_ambient.mp3',
    ),
    AnimalModel(
      id:         'dog',
      name:       'Chien',
      emoji:      '🐶',
      lottiePath: 'assets/animations/dog_idle.json',
      imagePath:  'assets/images/dog.png',
      audioPath:  'assets/audio/dog_ambient.mp3',
    ),
  ];
}
