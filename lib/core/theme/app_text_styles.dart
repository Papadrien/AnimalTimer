import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  static const String _ff = 'Nunito';

  static const TextStyle timePickerLarge = TextStyle(
    fontFamily: _ff, fontSize: 72, fontWeight: FontWeight.w900,
    color: AppColors.textPrimary, height: 1.0);

  static TextStyle get timePickerGhost => TextStyle(
    fontFamily: _ff, fontSize: 48, fontWeight: FontWeight.w900,
    color: AppColors.textPrimary.withOpacity(0.15), height: 1.0);

  static const TextStyle timePickerUnit = TextStyle(
    fontFamily: _ff, fontSize: 24, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary);

  static const TextStyle timerCountdown = TextStyle(
    fontFamily: _ff, fontSize: 48, fontWeight: FontWeight.w800,
    color: AppColors.textPrimary, letterSpacing: 2);

  static const TextStyle timerUnit = TextStyle(
    fontFamily: _ff, fontSize: 20, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary);

  static TextStyle get sectionTitle => TextStyle(
    fontFamily: _ff, fontSize: 20, fontWeight: FontWeight.w900,
    color: AppColors.textPrimary.withOpacity(0.5), letterSpacing: 3);

  static const TextStyle recentName = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textDark);

  static const TextStyle recentDuration = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w700,
    color: AppColors.accentYellow);

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _ff, fontSize: 22, fontWeight: FontWeight.w800,
    color: AppColors.textDark);

  static const TextStyle settingItem = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textDark);

  static const TextStyle settingSectionTitle = TextStyle(
    fontFamily: _ff, fontSize: 18, fontWeight: FontWeight.w900,
    color: AppColors.textDark, letterSpacing: 2);
}
