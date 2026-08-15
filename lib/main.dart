import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/analytics_service.dart';
import 'core/services/storage_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await AnalyticsService.init(FirebaseAnalytics.instance);
  } catch (_) {}

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations(_preferredOrientations());

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AnimalTimerApp(),
    ),
  );
}

/// Détermine les orientations autorisées selon le type d'appareil.
///
/// Sur téléphone, l'appli reste verrouillée en portrait (design pensé pour
/// les enfants, boutons larges en bas d'écran). Sur tablette, on autorise
/// aussi le paysage, orientation naturelle sur ce format d'écran.
///
/// La détection se base sur la taille physique de l'écran (plus petit côté
/// en pixels logiques) : un seuil de 600dp est le repère standard Android
/// pour distinguer téléphone et tablette, et couvre aussi les iPad (dont le
/// plus petit côté dépasse toujours 600dp, contrairement aux iPhone).
List<DeviceOrientation> _preferredOrientations() {
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalSize = view.physicalSize / view.devicePixelRatio;
  final isTablet = logicalSize.shortestSide >= 600;

  if (isTablet) {
    return const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ];
  }
  return const [DeviceOrientation.portraitUp];
}
