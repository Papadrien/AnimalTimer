import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/storage_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/purchase_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();

  // Initialiser AdMob (COPPA pour app enfants)
  final adService = AdService();
  await adService.initialize();

  // ProviderContainer créé en amont pour pouvoir initialiser le PurchaseService
  // dès le démarrage. Cela garantit que le purchaseStream écoute les mises à
  // jour d'achat (y compris celles qui arrivent en arrière-plan), que le prix
  // localisé est déjà prêt à l'ouverture du picker, et que les achats pending
  // ou restored sont traités dès que possible.
  final container = ProviderContainer(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ],
  );

  // Fire-and-forget : on ne bloque pas le boot. initialize() est idempotent,
  // donc les écrans qui l'appellent à nouveau par sécurité ne déclenchent pas
  // de double init.
  unawaited(
    container.read(purchaseServiceProvider).initialize(),
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AnimalTimerApp(),
    ),
  );
}
