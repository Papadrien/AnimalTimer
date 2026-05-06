import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  // ── Setup: fond uni couleur animale pâle ──

  // Chien — vert foncé pâle
  static const LinearGradient dogSetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDCE8D5), Color(0xFFCCDEC2), Color(0xFFBCD4AF)],
    stops: [0.0, 0.5, 1.0],
  );

  // Chat — rouge pâle (comme l'ancienne poule)
  static const LinearGradient catSetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2), Color(0xFFEF9A9A)],
    stops: [0.0, 0.5, 1.0],
  );

  // Crocodile — bleu clair pâle (comme l'ancien chien)
  static const LinearGradient crocodileSetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDCEEFF), Color(0xFFCDE5FF), Color(0xFFBEDCFF)],
    stops: [0.0, 0.5, 1.0],
  );

  // Poney — vert pâle (comme l'ancien crocodile)
  static const LinearGradient ponySetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEDF5D6), Color(0xFFE0EDC2), Color(0xFFD3E5AE)],
    stops: [0.0, 0.5, 1.0],
  );

  // Poule — marron pâle / terre
  static const LinearGradient chickenSetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5ECD7), Color(0xFFEBDCC4), Color(0xFFE0CCB0)],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Timer: même fond couleur animale (cohérent) ──

  static const LinearGradient dogTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDCE8D5), Color(0xFFCCDEC2), Color(0xFFBCD4AF)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient catTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2), Color(0xFFEF9A9A)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient crocodileTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDCEEFF), Color(0xFFCDE5FF), Color(0xFFBEDCFF)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient ponyTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEDF5D6), Color(0xFFE0EDC2), Color(0xFFD3E5AE)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient chickenTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5ECD7), Color(0xFFEBDCC4), Color(0xFFE0CCB0)],
    stops: [0.0, 0.5, 1.0],
  );
  // Requin — bleu profond #00608D (thème sombre, texte blanc)
  static const LinearGradient sharkSetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0077B0), Color(0xFF00608D), Color(0xFF004E72)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient sharkTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0077B0), Color(0xFF00608D), Color(0xFF004E72)],
    stops: [0.0, 0.5, 1.0],
  );

  // Licorne — rose magenta pâle
  static const LinearGradient unicornSetup = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD6F9), Color(0xFFFFB3F3), Color(0xFFFF90ED)],
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient unicornTimer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD6F9), Color(0xFFFFB3F3), Color(0xFFFF90ED)],
    stops: [0.0, 0.5, 1.0],
  );
}
