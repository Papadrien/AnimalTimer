import 'package:flutter/material.dart';
import '../../../../shared/widgets/animated_button.dart';

class StartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const StartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedButton(label: 'Start', icon: Icons.chevron_right,
        size: 110, onPressed: onPressed),
    );
  }
}
