import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/purchase_service.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../shared/widgets/image_button.dart';

class UnlockAllAnimalsButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const UnlockAllAnimalsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseService = ref.watch(purchaseServiceProvider);

    return ValueListenableBuilder<String>(
      valueListenable: purchaseService.localizedPriceNotifier,
      builder: (context, price, _) {
        final label = price == '…'
            ? context.l10n.unlockAllButton
            : context.l10n.unlockAllButtonWithPrice(price);

        return ImageButton(
          text: label,
          showLabel: true,
          backgroundAsset: ImageButton.blueBg,
          onPressed: onPressed,
          height: 64,
        );
      },
    );
  }
}

class DebugUnlockAllAnimalsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DebugUnlockAllAnimalsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '[DEBUG] Simuler achat',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
