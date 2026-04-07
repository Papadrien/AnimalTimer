import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;

  const GradientBackground({super.key, required this.gradient, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(child: child),
    );
  }
}
