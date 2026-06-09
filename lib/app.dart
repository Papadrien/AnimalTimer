import 'package:flutter/material.dart';
import 'package:animal_timer/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

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
      home: const SplashScreen(),
    );
  }
}
