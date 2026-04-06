// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/timer/presentation/screens/home_screen.dart';

class AnimalTimerApp extends ConsumerWidget {
  const AnimalTimerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AnimalTimer',
      debugShowCheckedModeBanner: false,

      // ── Thème ──────────────────────────────────────────────────────────────
      theme: AppTheme.light,
      themeMode: ThemeMode.light, // Toujours clair (app enfant)

      // ── Écran d'accueil ────────────────────────────────────────────────────
      home: const HomeScreen(),

      // ── Transitions globales ───────────────────────────────────────────────
      builder: (context, child) {
        // Force le texte à ne pas scaler selon les préférences système
        // Important pour les enfants : taille de texte toujours maîtrisée
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.15),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
