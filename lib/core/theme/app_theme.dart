// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.duckPrimary,
          background: AppColors.backgroundWarm,
          surface: AppColors.backgroundSurface,
        ),
        scaffoldBackgroundColor: AppColors.backgroundWarm,
        fontFamily: 'Nunito',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: AppColors.textDark),
          titleTextStyle: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? AppColors.duckSecondary
                : Colors.white,
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? AppColors.duckPrimary.withOpacity(0.6)
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.duckSecondary,
          thumbColor: AppColors.duckSecondary,
          inactiveTrackColor: AppColors.duckPrimary.withOpacity(0.3),
          overlayColor: AppColors.duckSecondary.withOpacity(0.2),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      );
}

// ── Styles de texte ──────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  static const timerDisplay = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: AppColors.textDark,
    letterSpacing: 2,
  );

  static const heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    fontFamily: 'Nunito',
    color: AppColors.textDark,
  );

  static const subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: AppColors.textMedium,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Nunito',
    color: AppColors.textMedium,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    fontFamily: 'Nunito',
    color: AppColors.textLight,
    letterSpacing: 1.8,
  );

  static const settingTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: 'Nunito',
    color: AppColors.textDark,
  );

  static const settingSubtitle = TextStyle(
    fontSize: 12,
    fontFamily: 'Nunito',
    color: AppColors.textLight,
  );
}
