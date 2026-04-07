import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typographie style enfantin.
/// Utilise Nunito (arrondie) mais en fallback la police système marche aussi.
/// Pour un vrai style manuscrit, remplacer par "Patrick Hand", "Gaegu", ou "Coming Soon".
class AppTextStyles {
  AppTextStyles._();
  static const String _ff = 'Nunito';

  static const TextStyle timePickerLarge = TextStyle(
    fontFamily: _ff, fontSize: 72, fontWeight: FontWeight.w900,
    color: AppColors.pencilDark, height: 1.0,
  );

  static TextStyle get timePickerGhost => TextStyle(
    fontFamily: _ff, fontSize: 48, fontWeight: FontWeight.w900,
    color: AppColors.pencilFaint, height: 1.0,
  );

  static const TextStyle timePickerUnit = TextStyle(
    fontFamily: _ff, fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.pencilLight,
  );

  static const TextStyle timerCountdown = TextStyle(
    fontFamily: _ff, fontSize: 52, fontWeight: FontWeight.w900,
    color: AppColors.pencilDark, letterSpacing: 2,
  );

  static const TextStyle timerUnit = TextStyle(
    fontFamily: _ff, fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.pencilLight,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _ff, fontSize: 20, fontWeight: FontWeight.w900,
    color: AppColors.pencilLight, letterSpacing: 3,
  );

  static const TextStyle recentName = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w700,
    color: AppColors.pencilDark,
  );

  static const TextStyle recentDuration = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w800,
    color: AppColors.crayonOrange,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _ff, fontSize: 22, fontWeight: FontWeight.w800,
    color: AppColors.pencilDark,
  );

  static const TextStyle settingItem = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.pencilDark,
  );

  static const TextStyle settingSectionTitle = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w900,
    color: AppColors.pencilDark, letterSpacing: 2,
  );
}
