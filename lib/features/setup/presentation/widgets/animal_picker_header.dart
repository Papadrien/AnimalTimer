import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';

class AnimalPickerHeader extends StatelessWidget {
  const AnimalPickerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.pencilFaint,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.chooseAnimal,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.pencilDark,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
