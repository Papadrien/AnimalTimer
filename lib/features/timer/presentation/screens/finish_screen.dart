import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../../../shared/widgets/image_button.dart';
import '../../../setup/providers/setup_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../widgets/confetti_overlay.dart';

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

  /// Navigate back to setup screen.
  void _goHome() {
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
                  // Bouncing animal
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
                  Text(context.l10n.finished, style: TextStyle(
                    fontFamily: 'Nunito', fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pencilDark)),
                  const SizedBox(height: 32),
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
