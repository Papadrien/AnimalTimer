import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/timer_service.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../setup/providers/setup_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../widgets/radial_progress.dart';
import '../widgets/animal_animation.dart';
import '../widgets/timer_display.dart';

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
      ref.read(timerServiceProvider.notifier).start(setup.duration);
      final settings = ref.read(settingsProvider);
      final audio = ref.read(audioServiceProvider);
      audio.playAmbient(setup.selectedAnimal.ambientAudioPath,
        volume: settings.volume * 0.5);
      if (settings.tickTockSound) {
        audio.startTickTock(volume: settings.volume * 0.3);
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
    // Timer stays accurate via DateTime — no action needed.
  }

  @override
  Widget build(BuildContext context) {
    final ts = ref.watch(timerServiceProvider);
    final setup = ref.watch(setupProvider);
    final settings = ref.watch(settingsProvider);
    final animal = setup.selectedAnimal;

    ref.listen<TimerState>(timerServiceProvider, (prev, next) {
      if (next.status == TimerStatus.finished &&
          prev?.status != TimerStatus.finished) {
        HapticFeedback.heavyImpact();
        ref.read(audioServiceProvider).stopAll();
        ref.read(audioServiceProvider)
            .playEndSound(animal.endSoundPath, volume: settings.volume);
        _showFinishDialog();
      }
    });

    return Scaffold(
      body: GradientBackground(
        gradient: animal.timerGradient,
        child: Column(children: [
          const SizedBox(height: 16),
          // Bell icon
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                child: Icon(
                  settings.tickTockSound
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: animal.primaryColor, size: 24),
              ),
            ),
          ),
          const Spacer(),
          // Radial progress + animal + time
          SizedBox(
            width: 300, height: 300,
            child: Stack(alignment: Alignment.center, children: [
              RadialProgress(progress: ts.progress,
                primaryColor: animal.primaryColor,
                secondaryColor: animal.secondaryColor),
              if (settings.showNumbers)
                TimerDisplay(remaining: ts.remaining),
              if (settings.showAnimal)
                Positioned(bottom: 40,
                  child: AnimalAnimation(animal: animal,
                    isRunning: ts.status == TimerStatus.running)),
            ]),
          ),
          const Spacer(),
          // Cancel / Pause buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedButton(label: 'Cancel', icon: Icons.chevron_left,
                  size: 100, onPressed: () {
                    ref.read(timerServiceProvider.notifier).cancel();
                    ref.read(audioServiceProvider).stopAll();
                    Navigator.of(context).pop();
                  }),
                AnimatedButton(
                  label: ts.status == TimerStatus.paused ? 'Play' : 'Pause',
                  icon: ts.status == TimerStatus.paused
                      ? Icons.play_arrow : Icons.pause,
                  size: 100,
                  onPressed: () {
                    final notifier = ref.read(timerServiceProvider.notifier);
                    if (ts.status == TimerStatus.running) {
                      notifier.pause();
                      ref.read(audioServiceProvider).stopAll();
                    } else if (ts.status == TimerStatus.paused) {
                      notifier.resume();
                      final audio = ref.read(audioServiceProvider);
                      audio.playAmbient(animal.ambientAudioPath,
                        volume: settings.volume * 0.5);
                      if (settings.tickTockSound) {
                        audio.startTickTock(volume: settings.volume * 0.3);
                      }
                    }
                  }),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ]),
      ),
    );
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, scale, child) =>
            Transform.scale(scale: scale, child: child),
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.15), blurRadius: 40)],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('\u{1F389}', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text("C'est fini !",
                style: AppTextStyles.buttonLabel.copyWith(fontSize: 28)),
              const SizedBox(height: 24),
              AnimatedButton(label: 'OK', icon: Icons.check, size: 80,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
            ]),
          ),
        ),
      ),
    );
  }
}
