import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/ad_service.dart';
import '../../../../core/services/gamification_service.dart';
import '../../../../core/services/purchase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../data/models/animal_model.dart';
import 'animal_picker_content.dart';
import 'animal_picker_dialogs.dart';
import 'animal_picker_header.dart';

/// Bottom sheet used to pick, unlock, or purchase animals.
class AnimalPickerSheet extends ConsumerStatefulWidget {
  final String selectedAnimalId;
  final ValueChanged<String> onAnimalSelected;

  const AnimalPickerSheet({
    super.key,
    required this.selectedAnimalId,
    required this.onAnimalSelected,
  });

  @override
  ConsumerState<AnimalPickerSheet> createState() => _AnimalPickerSheetState();
}

class _AnimalPickerSheetState extends ConsumerState<AnimalPickerSheet> {
  @override
  void initState() {
    super.initState();
    _prepareUnlockServices();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxSheetHeight = _maxSheetHeight(mediaQuery);
    final gamif = ref.watch(gamificationServiceProvider);
    final purchaseService = ref.watch(purchaseServiceProvider);
    final hasLockedAnimals = gamif.hasLockedAnimals();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnimalPickerHeader(),
            Flexible(
              child: AnimalPickerContent(
                bottomPadding: mediaQuery.padding.bottom,
                selectedAnimalId: widget.selectedAnimalId,
                showUnlockAllButton:
                    hasLockedAnimals || !purchaseService.isPremium,
                showDebugUnlockButton: hasLockedAnimals,
                onUnlockAllPressed: _showPurchaseConfirmation,
                onLockedAnimalPressed: _showUnlockDialog,
                onUnlockedAnimalPressed: _selectAnimal,
                onDebugUnlockAllPressed: _debugUnlockAllAnimals,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _maxSheetHeight(MediaQueryData mediaQuery) {
    const sheetTopMargin = 50.0;
    return mediaQuery.size.height - mediaQuery.padding.top - sheetTopMargin;
  }

  void _prepareUnlockServices() {
    final gamif = ref.read(gamificationServiceProvider);
    if (!gamif.hasLockedAnimals()) return;

    ref.read(adServiceProvider).loadAd();
    ref.read(purchaseServiceProvider).initialize();
  }

  void _selectAnimal(AnimalModel animal) {
    widget.onAnimalSelected(animal.id);
    Navigator.of(context).pop();
  }

  void _showPurchaseConfirmation() {
    HapticFeedback.mediumImpact();
    final price = ref.read(purchaseServiceProvider).localizedPrice;

    showPurchaseConfirmationDialog(
      context: context,
      price: price,
      onBuyPressed: _handlePurchase,
    );
  }

  Future<void> _handlePurchase() async {
    HapticFeedback.mediumImpact();
    final purchaseService = ref.read(purchaseServiceProvider);

    if (!purchaseService.isProductAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.storeNotAvailable),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    purchaseService.onPurchaseCompleted = () {
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.unlockAllSuccess),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    };

    final launched = await purchaseService.purchaseUnlockAll();
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.purchaseError),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showUnlockDialog(AnimalModel animal) {
    showRewardedUnlockDialog(
      context: context,
      animal: animal,
      onWatchAdPressed: () => _watchAdAndUnlock(animal),
    );
  }

  Future<void> _watchAdAndUnlock(AnimalModel animal) async {
    final adService = ref.read(adServiceProvider);
    final gamif = ref.read(gamificationServiceProvider);

    if (!adService.isAdReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adLoading),
          duration: const Duration(seconds: 2),
        ),
      );
      await adService.loadAd();
      await Future.delayed(const Duration(seconds: 3));
      if (!adService.isAdReady || !mounted) return;
    }

    await adService.showRewardedAd(
      onReward: () async {
        await gamif.unlockAnimal(animal.id);
        if (!mounted) return;

        widget.onAnimalSelected(animal.id);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.animalUnlocked(
                localizedAnimalName(context, animal.id),
              ),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      },
    );
  }

  Future<void> _debugUnlockAllAnimals() async {
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.of(context);

    await ref.read(gamificationServiceProvider).unlockAllAnimals();
    if (!mounted) return;

    setState(() {});
    messenger.showSnackBar(
      const SnackBar(
        content: Text('DEBUG: Tous les animaux debloques !'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
