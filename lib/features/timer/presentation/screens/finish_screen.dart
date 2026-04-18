import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/gamification_service.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../../../shared/widgets/image_button.dart';
import '../../../setup/providers/setup_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/unlock_dialog.dart';

class FinishScreen extends ConsumerStatefulWidget {
  const FinishScreen({super.key});
  @override
  ConsumerState<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends ConsumerState<FinishScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: -35).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

    // Play end sound
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final animal = ref.read(setupProvider).selectedAnimal;
      final settings = ref.read(settingsProvider);
      if (settings.endSoundEnabled) {
        ref.read(audioServiceProvider)
            .playEndSound(animal.endSoundPath, volume: settings.volume);
      }
    });
  }

  @override
  void dispose() { _bounceCtrl.dispose(); super.dispose(); }

  /// Tente de débloquer un animal, affiche la pop-up si succès,
  /// puis navigue vers l'accueil.
  Future<void> _goHome() async {
    final gamification = ref.read(gamificationServiceProvider);
    final animalRepo = ref.read(animalRepoProvider);

    // Tenter le déblocage
    final unlockedId = await gamification.tryUnlockAnimal();

    if (unlockedId != null && mounted) {
      // Un animal a été débloqué ! Afficher la pop-up
      HapticFeedback.heavyImpact();
      final unlockedAnimal = animalRepo.getById(unlockedId);

      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (dialogContext, _, __) {
          return UnlockDialog(
            animal: unlockedAnimal,
            onDismiss: () => Navigator.of(dialogContext).pop(),
          );
        },
      );
    }

    if (!mounted) return;

    // Retour à l'accueil
    ref.read(audioServiceProvider).stopAll();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final animal = ref.watch(setupProvider).selectedAnimal;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        gradient: animal.setupGradient,
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bouncing animal — always use static image (cat.png, not layers)
                  AnimatedBuilder(
                    animation: _bounce,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _bounce.value),
                      child: AnimalDisplay(
                        animal: animal,
                        size: 180,
                        animate: false,
                        useStaticImage: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // "C'est fini !" text
                  Text(context.l10n.finished, style: TextStyle(
                    fontFamily: 'Nunito', fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pencilDark)),
                  const SizedBox(height: 32),
                  // Bouton Arrêter (icône maison)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: ImageButton(
                      text: context.l10n.stop,
                      icon: Icons.home_rounded,
                      backgroundAsset: ImageButton.greenBg,
                      onPressed: _goHome,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
            // Confetti on top of everything
            const Positioned.fill(
              child: IgnorePointer(child: ConfettiOverlay())),
          ],
        ),
      ),
    );
  }
}
