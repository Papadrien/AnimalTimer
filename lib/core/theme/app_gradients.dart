import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  // ── Setup: papier crème → couleur animale pâle ──
  static const LinearGradient duckSetup = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF8EE), Color(0xFFFFF3D6), Color(0xFFFFEDBF)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient dogSetup = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF8EE), Color(0xFFEBF3FF), Color(0xFFD6E8FF)],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Timer: fond charbon sombre (identique pour tous les animaux) ──
  static const LinearGradient duckTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3D4446), Color(0xFF2D3436), Color(0xFF1E2526)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient dogTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3D4446), Color(0xFF2D3436), Color(0xFF1E2526)],
    stops: [0.0, 0.5, 1.0],
  );
}
