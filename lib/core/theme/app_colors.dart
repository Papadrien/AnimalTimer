import 'package:flutter/material.dart';

/// Palette AnimalTimer — Design maquette V2
/// Setup: fond uni couleur animale pâle
/// Timer: fond uni couleur animale (cohérent)
class AppColors {
  AppColors._();

  // ── Fond papier (Setup) ──
  static const Color paper         = Color(0xFFFFF8EE);
  static const Color paperLight    = Color(0xFFFFFDF7);

  // ── Couleurs d'accent (Timer buttons) ──
  static const Color accentGreen      = Color(0xFF4CAF50);
  static const Color accentGreenLight = Color(0xFF66BB6A);
  static const Color accentRed        = Color(0xFFE53935);
  static const Color accentOrange     = Color(0xFFFF9800);
  static const Color accentBlue       = Color(0xFF42A5F5);

  // ── Crayons de couleur (Setup) ──
  static const Color crayonYellow  = Color(0xFFFFD43B);
  static const Color crayonOrange  = Color(0xFFFF922B);
  static const Color crayonRed     = Color(0xFFFF6B6B);
  static const Color crayonGreen   = Color(0xFF69DB7C);
  static const Color crayonBlue    = Color(0xFF74C0FC);
  static const Color crayonPurple  = Color(0xFFB197FC);
  static const Color crayonPink    = Color(0xFFF783AC);

  // ── Contours "crayon" ──
  static const Color pencilDark    = Color(0xFF2B2B2B);
  static const Color pencilLight   = Color(0xFF5C5C5C);
  static const Color pencilFaint   = Color(0xFFAAAAAA);

  // ── Texte ──
  static const Color textDark      = Color(0xFF2B2B2B);
  static const Color textOnColor   = Color(0xFFFFFFFF);

  // ── Per-animal colors ──
  static const Color dogPrimary    = Color(0xFF6B8E5A);  // vert foncé
  static const Color dogSecondary  = Color(0xFF3D5E2A);  // vert forêt
  static const Color catPrimary    = Color(0xFFE57373);  // rouge doux
  static const Color catSecondary  = Color(0xFFD32F2F);  // rouge vif
  static const Color crocodilePrimary  = Color(0xFF74C0FC);  // bleu clair
  static const Color crocodileSecondary = Color(0xFF42A5F5);  // bleu moyen
  static const Color ponyPrimary    = Color(0xFFB5CC7A);  // vert olive clair
  static const Color ponySecondary  = Color(0xFF7A9E3A);  // vert olive foncé
  static const Color chickenPrimary = Color(0xFFC2956A);  // marron clair
  static const Color chickenSecondary = Color(0xFF8B5E3C);  // marron foncé
  static const Color sharkPrimary    = Color(0xFF00608D);  // bleu requin
  static const Color sharkSecondary  = Color(0xFF004466);  // bleu requin foncé
  static const Color unicornPrimary   = Color(0xFFFF61E7);  // rose licorne
  static const Color unicornSecondary = Color(0xFFE040CC);  // rose licorne foncé


  // ── Recents card colors ──
  static const Color recentBlue    = Color(0xFFBBDEFB);
  static const Color recentOrange  = Color(0xFFFFE0B2);
  static const Color recentGreen   = Color(0xFFC8E6C9);
  static const Color recentPink    = Color(0xFFF8BBD0);

  // ── UI ──
  static const Color sheetBg       = Color(0xFFFFF8EE);
  static const Color toggleActive  = Color(0xFF4CAF50);
}
