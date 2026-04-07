import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();
  static const LinearGradient setupDefault = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFFB8A832), Color(0xFF5CAF6E), Color(0xFF7ECBA1), Color(0xFFC8E6C9)],
    stops: [0.0, 0.3, 0.6, 1.0],
  );
  static const LinearGradient timerDefault = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFFE8A817), Color(0xFFFFC233), Color(0xFFFFCC55), Color(0xFFEBB87A)],
    stops: [0.0, 0.3, 0.65, 1.0],
  );
  static const LinearGradient duckSetup = setupDefault;
  static const LinearGradient duckTimer = timerDefault;
  static const LinearGradient dogSetup = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF7B8DCC), Color(0xFF93B5E1), Color(0xFFB8D4F0), Color(0xFFDAEAF7)],
  );
  static const LinearGradient dogTimer = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF5C7BBF), Color(0xFF7BA3D9), Color(0xFF9BC0EB), Color(0xFFBDD7F5)],
  );
}
