import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  static const String _ff = 'Nunito';

  // ── Setup: Time Picker (maquette: gros chiffres colorés) ──
  static const TextStyle timePickerValue = TextStyle(
    fontFamily: _ff, fontSize: 44, fontWeight: FontWeight.w900,
    color: AppColors.pencilDark, height: 1.0,
  );

  static const TextStyle timePickerUnit = TextStyle(
    fontFamily: _ff, fontSize: 14, fontWeight: FontWeight.w700,
    color: AppColors.pencilLight,
  );

  static const TextStyle timePickerLabel = TextStyle(
    fontFamily: _ff, fontSize: 11, fontWeight: FontWeight.w600,
    color: AppColors.pencilFaint, letterSpacing: 1,
  );

  // ── Timer: Countdown on dark background (vert maquette) ──
  static const TextStyle timerCountdown = TextStyle(
    fontFamily: _ff, fontSize: 46, fontWeight: FontWeight.w900,
    color: AppColors.accentGreenLight, letterSpacing: 2,
  );

  static const TextStyle timerUnit = TextStyle(
    fontFamily: _ff, fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.accentGreenLight,
  );

  // ── Section titles ──
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w900,
    color: AppColors.pencilDark, letterSpacing: 1,
  );

  // ── Recents ──
  static const TextStyle recentName = TextStyle(
    fontFamily: _ff, fontSize: 16, fontWeight: FontWeight.w700,
    color: AppColors.pencilDark,
  );

  static const TextStyle recentDuration = TextStyle(
    fontFamily: _ff, fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.pencilLight,
  );

  // ── Buttons ──
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w800,
    color: AppColors.textOnColor,
  );

  static const TextStyle startButtonLabel = TextStyle(
    fontFamily: _ff, fontSize: 22, fontWeight: FontWeight.w900,
    color: AppColors.textOnColor, letterSpacing: 1,
  );

  // ── Settings ──
  static const TextStyle settingItem = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.pencilDark,
  );

  static const TextStyle settingSectionTitle = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w900,
    color: AppColors.pencilDark, letterSpacing: 2,
  );
}
