// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dégradés principaux ──────────────────────────────────────────────────
  static const gradientGreenYellow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8BC34A), Color(0xFFFDD835)],
  );

  static const gradientYellowOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDD835), Color(0xFFFF8F00)],
  );

  static const gradientFull = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF8BC34A), Color(0xFFFDD835), Color(0xFFFF8F00)],
  );

  // ── Fonds ────────────────────────────────────────────────────────────────
  static const backgroundWarm    = Color(0xFFFFF8F0);
  static const backgroundSurface = Color(0xFFFFF3E0);

  // ── Couleurs par animal ──────────────────────────────────────────────────
  static const duckPrimary   = Color(0xFFFDD835);
  static const duckSecondary = Color(0xFFFF8F00);
  static const dogPrimary    = Color(0xFF8BC34A);
  static const dogSecondary  = Color(0xFFFDD835);

  // ── Glassmorphism ────────────────────────────────────────────────────────
  static const glassWhite      = Color(0xCCFFFFFF); // 80 %
  static const glassWhiteLight = Color(0x99FFFFFF); // 60 %
  static const glassBorder     = Color(0x66FFFFFF); // 40 %

  // ── Textes ───────────────────────────────────────────────────────────────
  static const textDark       = Color(0xFF3E2723);
  static const textMedium     = Color(0xFF6D4C41);
  static const textLight      = Color(0xFF8D6E63);
  static const textOnGradient = Colors.white;

  // ── Divers ───────────────────────────────────────────────────────────────
  static const success      = Color(0xFF66BB6A);
  static const shadow       = Color(0x1A000000);
  static const shadowMedium = Color(0x33000000);
}

// ── Extension : thème dynamique par animal ───────────────────────────────────
extension AnimalGradient on String {
  LinearGradient get animalGradient {
    switch (this) {
      case 'duck':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDD835), Color(0xFFFF8F00)],
        );
      case 'dog':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8BC34A), Color(0xFFFDD835)],
        );
      default:
        return AppColors.gradientFull;
    }
  }

  Color get animalPrimaryColor {
    switch (this) {
      case 'duck': return AppColors.duckPrimary;
      case 'dog':  return AppColors.dogPrimary;
      default:     return AppColors.duckPrimary;
    }
  }

  Color get animalSecondaryColor {
    switch (this) {
      case 'duck': return AppColors.duckSecondary;
      case 'dog':  return AppColors.dogSecondary;
      default:     return AppColors.duckSecondary;
    }
  }
}
