// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // ── Timer ────────────────────────────────────────────────────────────────
  static const tickIntervalMs  = 100;   // Précision du timer (ms)
  static const finishDelayS    = 3;     // Secondes avant retour auto à l'accueil
  static const maxRecentTimers = 5;     // Nombre de timers récents sauvegardés

  // ── Audio ────────────────────────────────────────────────────────────────
  static const defaultVolume   = 0.7;
  static const tickVolume      = 0.25;  // Volume relatif du tick-tock

  // ── Storage keys ─────────────────────────────────────────────────────────
  static const keyRecentTimers       = 'recent_timers';
  static const keySettings           = 'app_settings';
  static const keyLastAnimalId       = 'last_animal_id';

  // ── Assets ───────────────────────────────────────────────────────────────
  static const animalsConfigPath     = 'assets/config/animals.json';
  static const audioTickTock         = 'assets/audio/tick_tock.mp3';
  static const audioTimerEnd         = 'assets/audio/timer_end.mp3';

  // ── UI ───────────────────────────────────────────────────────────────────
  static const borderRadiusCard      = 24.0;
  static const borderRadiusButton    = 16.0;
  static const progressRingStroke    = 20.0;
  static const startButtonSize       = 120.0;
  static const breathingScaleMin     = 0.96;
  static const breathingScaleMax     = 1.04;
  static const breathingDurationMs   = 2800;
}
