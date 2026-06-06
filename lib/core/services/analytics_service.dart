import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Wrapper autour de Firebase Analytics.
/// Toutes les méthodes sont silencieuses en cas d'erreur pour éviter
/// tout crash si Firebase ne s'initialise pas correctement.
///
/// La collecte est automatiquement désactivée en mode debug (kDebugMode)
/// pour ne pas polluer les données de production.
class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  /// Doit être appelé après Firebase.initializeApp().
  /// Désactive la collecte en debug, l'active en release.
  static Future<void> init(FirebaseAnalytics analytics) async {
    _analytics = analytics;
    _initialized = true;
    try {
      await analytics.setAnalyticsCollectionEnabled(!kDebugMode);
    } catch (_) {}
  }

  static FirebaseAnalytics? get instance => _initialized ? _analytics : null;

  static Future<void> logEvent(String name,
      {Map<String, Object>? parameters}) async {
    if (!_initialized || _analytics == null) return;
    try {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } catch (_) {}
  }

  static Future<void> logTimerStarted({
    required String animalId,
    required int durationSeconds,
  }) async {
    await logEvent('timer_started', parameters: {
      'animal_id': animalId,
      'duration_seconds': durationSeconds,
    });
  }

  static Future<void> logTimerCompleted({
    required String animalId,
    required int durationSeconds,
  }) async {
    await logEvent('timer_completed', parameters: {
      'animal_id': animalId,
      'duration_seconds': durationSeconds,
    });
  }

  static Future<void> setScreen(String screenName) async {
    if (!_initialized || _analytics == null) return;
    try {
      await _analytics!.logScreenView(screenName: screenName);
    } catch (_) {}
  }
}
