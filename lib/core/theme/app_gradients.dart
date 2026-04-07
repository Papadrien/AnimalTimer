import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Fonds doux style "feuille de papier" — pas de dégradé agressif,
/// juste des transitions très douces entre crème et la couleur de l'animal.
class AppGradients {
  AppGradients._();

  // ── Canard : papier crème → jaune pâle ──
  static const LinearGradient duckSetup = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF8EE), Color(0xFFFFF3D6), Color(0xFFFFEDBF)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient duckTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF3D6), Color(0xFFFFE8A8), Color(0xFFFFDC7A)],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Chien : papier crème → bleu pâle ──
  static const LinearGradient dogSetup = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF8EE), Color(0xFFEBF3FF), Color(0xFFD6E8FF)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient dogTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEBF3FF), Color(0xFFD6E8FF), Color(0xFFC0DBFF)],
    stops: [0.0, 0.5, 1.0],
  );
}
