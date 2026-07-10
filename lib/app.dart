import 'package:flutter/material.dart';
import 'package:animal_timer/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

/// Observateur de routes global, utilisé notamment par SetupScreen pour
/// détecter chaque retour à l'écran d'accueil (ex: après un minuteur).
final routeObserver = RouteObserver<PageRoute>();

class AnimalTimerApp extends StatelessWidget {
  const AnimalTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimalTimer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [routeObserver],
      home: const SplashScreen(),
    );
  }
}
