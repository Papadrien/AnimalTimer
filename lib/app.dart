import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/setup/presentation/screens/setup_screen.dart';

class AnimalTimerApp extends StatelessWidget {
  const AnimalTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimalTimer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SetupScreen(),
    );
  }
}
