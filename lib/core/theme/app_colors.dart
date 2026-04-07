import 'package:flutter/material.dart';

/// Palette "crayon de couleur" — couleurs vives mais légèrement
/// désaturées comme des crayons sur papier.
class AppColors {
  AppColors._();

  // ── Fond papier ──
  static const Color paper         = Color(0xFFFFF8EE);  // crème chaud
  static const Color paperLight    = Color(0xFFFFFDF7);  // quasi blanc
  static const Color paperDark     = Color(0xFFF5ECD7);  // beige

  // ── Crayons de couleur principaux ──
  static const Color crayonYellow  = Color(0xFFFFD43B);  // jaune soleil
  static const Color crayonOrange  = Color(0xFFFF922B);  // orange vif
  static const Color crayonRed     = Color(0xFFFF6B6B);  // rouge doux
  static const Color crayonGreen   = Color(0xFF69DB7C);  // vert prairie
  static const Color crayonBlue    = Color(0xFF74C0FC);  // bleu ciel
  static const Color crayonPurple  = Color(0xFFB197FC);  // violet lavande
  static const Color crayonPink    = Color(0xFFF783AC);  // rose bonbon
  static const Color crayonBrown   = Color(0xFFC2956A);  // marron terre

  // ── Contours "crayon noir" ──
  static const Color pencilDark    = Color(0xFF2B2B2B);  // crayon appuyé
  static const Color pencilLight   = Color(0xFF5C5C5C);  // crayon léger
  static const Color pencilFaint   = Color(0xFFAAAAAA);  // très léger

  // ── Texte ──
  static const Color textDark      = Color(0xFF2B2B2B);
  static const Color textMuted     = Color(0xFF888888);
  static const Color textOnColor   = Color(0xFFFFFFFF);

  // ── Per-animal colors ──
  static const Color duckPrimary   = Color(0xFFFFD43B);
  static const Color duckSecondary = Color(0xFFFF922B);
  static const Color dogPrimary    = Color(0xFF74C0FC);
  static const Color dogSecondary  = Color(0xFFB197FC);

  // ── UI ──
  static const Color buttonFill    = Color(0xFFFFFFFF);
  static const Color sheetBg       = Color(0xFFFFF8EE);
  static const Color toggleActive  = Color(0xFFFFD43B);
}
