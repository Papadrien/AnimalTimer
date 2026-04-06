import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AnimalTimerApp());
}

class AnimalTimerApp extends StatelessWidget {
  const AnimalTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
