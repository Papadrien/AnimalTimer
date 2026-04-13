import 'package:flutter/material.dart';
import '../../../../shared/widgets/image_button.dart';

/// Gros bouton "DÉMARRER" avec fond PNG Procreate vert.
class StartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const StartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ImageButton(
      text: 'Démarrer',
      backgroundAsset: ImageButton.greenBg,
      onPressed: onPressed,
      icon: Icons.chevron_right,
      height: 64,
    );
  }
}
