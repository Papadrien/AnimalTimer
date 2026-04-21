import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/timer_service.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../../../shared/widgets/image_button.dart';
import '../../../setup/providers/setup_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../widgets/radial_progress.dart';
import '../widgets/timer_display.dart';
import 'finish_screen.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});
  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final setup = ref.read(setupProvider);
      final settings = ref.read(settingsProvider);
      ref.read(timerServiceProvider.notifier).start(setup.duration);
      // Only start ambient music if sound is enabled
      if (settings.ambientSoundEnabled) {
        ref.read(audioServiceProvider).playAmbient(
          setup.selectedAnimal.ambientAudioPath,
          volume: settings.volume * 0.5,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = ref.read(settingsProvider);
    final audio = ref.read(audioServiceProvider);
    final ts = ref.read(timerServiceProvider);

    if (state == AppLifecycleState.paused) {
      // App goes to background — pause ambient music
      if (settings.ambientSoundEnabled) {
        audio.pauseAmbient();
      }
    } else if (state == AppLifecycleState.resumed) {
      // App comes back — resume ambient music if timer is running
      if (settings.ambientSoundEnabled && ts.status == TimerStatus.running) {
        audio.resumeAmbient();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ts = ref.watch(timerServiceProvider);
    final setup = ref.watch(setupProvider);
    final settings = ref.watch(settingsProvider);
    final animal = setup.selectedAnimal;
    final screenW = MediaQuery.of(context).size.width;
    final circleSize = screenW * 0.78;

    final isPaused = ts.status == TimerStatus.paused;

    ref.listen<TimerState>(timerServiceProvider, (prev, next) {
      if (next.status == TimerStatus.finished &&
          prev?.status != TimerStatus.finished) {
        HapticFeedback.heavyImpact();
        ref.read(audioServiceProvider).stopAmbient();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const FinishScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        gradient: animal.setupGradient,
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Top row: sound toggle button on the right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      final audio = ref.read(audioServiceProvider);
                      final wasOn = settings.ambientSoundEnabled;
                      ref.read(settingsProvider.notifier).toggleAmbientSound();

                      if (wasOn) {
                        // Turning OFF — stop ambient music
                        audio.stopAmbient();
                      } else {
                        // Turning ON — restart ambient (only if running)
                        if (ts.status == TimerStatus.running) {
                          audio.playAmbient(animal.ambientAudioPath,
                              volume: settings.volume * 0.5);
                        }
                      }
                    },
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.paperLight.withValues(alpha: 0.6),
                        border: Border.all(
                          color: AppColors.pencilDark, width: 2.5),
                      ),
                      child: Icon(
                        settings.ambientSoundEnabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        color: settings.ambientSoundEnabled
                            ? AppColors.pencilDark
                            : AppColors.accentRed,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Central circle
            SizedBox(
              width: circleSize,
              height: circleSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RadialProgress(
                    progress: ts.progress,
                    primaryColor: AppColors.accentGreen,
                    secondaryColor: AppColors.accentGreenLight,
                    size: circleSize,
                  ),
                  if (settings.showNumbers)
                    Positioned(
                      top: circleSize * 0.18,
                      child: TimerDisplay(remaining: ts.remaining),
                    ),
                  if (settings.showNumbers)
                    Positioned(
                      bottom: circleSize * 0.12,
                      child: AnimalDisplay(
                        animal: animal,
                        size: circleSize * 0.48,
                        animate: ts.status == TimerStatus.running,
                      ),
                    )
                  else
                    AnimalDisplay(
                      animal: animal,
                      size: circleSize * 0.48,
                      animate: ts.status == TimerStatus.running,
                    ),
                ],
              ),
            ),
            const Spacer(),
            // Bottom: Cancel (red) + Pause/Reprendre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: ImageButton(
                      text: context.l10n.cancel,
                      icon: Icons.arrow_back_rounded,
                      backgroundAsset: ImageButton.redBg,
                      height: 80,
                      bounce: true,
                      onPressed: () {
                        ref.read(timerServiceProvider.notifier).cancel();
                        ref.read(audioServiceProvider).stopAll();
                                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ImageButton(
                      text: isPaused ? context.l10n.resume : context.l10n.pause,
                      icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      backgroundAsset: isPaused
                          ? ImageButton.greenBg
                          : ImageButton.orangeBg,
                      height: 80,
                      bounce: true,
                      onPressed: () {
                        final notifier =
                            ref.read(timerServiceProvider.notifier);
                        final audio = ref.read(audioServiceProvider);

                        if (ts.status == TimerStatus.running) {
                          // === PAUSE ===
                          notifier.pause();
                                            if (settings.ambientSoundEnabled) {
                            audio.pauseAmbient();
                          }
                        } else if (ts.status == TimerStatus.paused) {
                          // === RESUME ===
                          notifier.resume();
                          if (settings.ambientSoundEnabled) {
                            audio.resumeAmbient();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
          ],
        ),
      ),
    );
  }
}
