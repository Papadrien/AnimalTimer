import 'package:flutter/material.dart';

/// Palette AnimalTimer — Design maquette V2
/// Setup: fond crème chaud avec cartes colorées
/// Timer: fond sombre charbon avec accents verts vifs
class AppColors {
  AppColors._();

  // ── Fond papier (Setup) ──
  static const Color paper         = Color(0xFFFFF8EE);
  static const Color paperLight    = Color(0xFFFFFDF7);
  static const Color paperDark     = Color(0xFFF5ECD7);

  // ── Fond sombre (Timer) ──
  static const Color timerBg       = Color(0xFF2D3436);
  static const Color timerBgLight  = Color(0xFF3D4446);
  static const Color timerBgDark   = Color(0xFF1E2526);

  // ── Couleurs d'accent (Timer buttons) ──
  static const Color accentGreen      = Color(0xFF4CAF50);
  static const Color accentGreenLight = Color(0xFF66BB6A);
  static const Color accentGreenDark  = Color(0xFF2E7D32);
  static const Color accentRed        = Color(0xFFE53935);
  static const Color accentRedLight   = Color(0xFFEF5350);
  static const Color accentOrange     = Color(0xFFFF9800);
  static const Color accentOrangeLight= Color(0xFFFFA726);

  // ── Crayons de couleur (Setup) ──
  static const Color crayonYellow  = Color(0xFFFFD43B);
  static const Color crayonOrange  = Color(0xFFFF922B);
  static const Color crayonRed     = Color(0xFFFF6B6B);
  static const Color crayonGreen   = Color(0xFF69DB7C);
  static const Color crayonBlue    = Color(0xFF74C0FC);
  static const Color crayonPurple  = Color(0xFFB197FC);
  static const Color crayonPink    = Color(0xFFF783AC);
  static const Color crayonBrown   = Color(0xFFC2956A);

  // ── Contours "crayon" ──
  static const Color pencilDark    = Color(0xFF2B2B2B);
  static const Color pencilLight   = Color(0xFF5C5C5C);
  static const Color pencilFaint   = Color(0xFFAAAAAA);

  // ── Texte ──
  static const Color textDark      = Color(0xFF2B2B2B);
  static const Color textMuted     = Color(0xFF888888);
  static const Color textOnColor   = Color(0xFFFFFFFF);
  static const Color textOnDark    = Color(0xFFEEEEEE);

  // ── Per-animal colors ──
  static const Color duckPrimary   = Color(0xFFFFD43B);
  static const Color duckSecondary = Color(0xFFFF922B);
  static const Color dogPrimary    = Color(0xFF74C0FC);
  static const Color dogSecondary  = Color(0xFFB197FC);

  // ── Recents card colors ──
  static const Color recentBlue    = Color(0xFFBBDEFB);
  static const Color recentOrange  = Color(0xFFFFE0B2);
  static const Color recentGreen   = Color(0xFFC8E6C9);
  static const Color recentPink    = Color(0xFFF8BBD0);

  // ── UI ──
  static const Color buttonFill    = Color(0xFFFFFFFF);
  static const Color sheetBg       = Color(0xFFFFF8EE);
  static const Color toggleActive  = Color(0xFF4CAF50);
}
