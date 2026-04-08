import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/timer_service.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/animal_display.dart';
import '../../../setup/providers/setup_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../widgets/radial_progress.dart';
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
      final settings = ref.read(settingsProvider);
      ref.read(timerServiceProvider.notifier).start(setup.duration);
      ref.read(notificationServiceProvider).scheduleTimerEnd(
        duration: setup.duration,
        body: "C'est fini ! Le ${setup.selectedAnimal.name} a terminé 🎉",
      );
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
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    final ts = ref.watch(timerServiceProvider);
    final setup = ref.watch(setupProvider);
    final settings = ref.watch(settingsProvider);
    final animal = setup.selectedAnimal;
    final notifications = ref.read(notificationServiceProvider);
    final screenW = MediaQuery.of(context).size.width;
    final circleSize = screenW * 0.78;

    ref.listen<TimerState>(timerServiceProvider, (prev, next) {
      if (next.status == TimerStatus.finished &&
          prev?.status != TimerStatus.finished) {
        HapticFeedback.heavyImpact();
        ref.read(audioServiceProvider).stopAll();
        ref.read(audioServiceProvider)
            .playEndSound(animal.endSoundPath, volume: settings.volume);
        notifications.cancelAll();
        _showFinishDialog();
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
            // Top row: only mute button on the right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Sound toggle button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(settingsProvider.notifier).toggleTickTock();
                      final audio = ref.read(audioServiceProvider);
                      if (settings.tickTockSound) {
                        // Was on, now turning off
                        audio.stopTickTock();
                      } else {
                        // Was off, now turning on
                        if (ts.status == TimerStatus.running) {
                          audio.startTickTock(volume: settings.volume * 0.3);
                        }
                      }
                    },
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.paperLight.withOpacity(0.6),
                        border: Border.all(
                          color: AppColors.pencilDark.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        settings.tickTockSound
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        color: settings.tickTockSound
                            ? AppColors.pencilDark.withOpacity(0.6)
                            : AppColors.accentRed.withOpacity(0.7),
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
                  if (settings.showAnimal)
                    Positioned(
                      bottom: circleSize * 0.12,
                      child: AnimalDisplay(
                        animal: animal,
                        size: circleSize * 0.48,
                        animate: ts.status == TimerStatus.running,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            // Bottom: Cancel (red) + Pause (orange)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ControlPillButton(
                    label: 'Annuler',
                    icon: Icons.chevron_left,
                    color: AppColors.accentRed,
                    onTap: () {
                      ref.read(timerServiceProvider.notifier).cancel();
                      ref.read(audioServiceProvider).stopAll();
                      notifications.cancelAll();
                      Navigator.of(context).pop();
                    },
                  ),
                  _ControlPillButton(
                    label: ts.status == TimerStatus.paused ? 'Play' : 'Pause',
                    icon: ts.status == TimerStatus.paused
                        ? Icons.play_arrow : Icons.pause,
                    color: AppColors.accentOrange,
                    onTap: () {
                      final notifier = ref.read(timerServiceProvider.notifier);
                      if (ts.status == TimerStatus.running) {
                        notifier.pause();
                        ref.read(audioServiceProvider).stopAll();
                        notifications.cancelAll();
                      } else if (ts.status == TimerStatus.paused) {
                        notifier.resume();
                        notifications.scheduleTimerEnd(
                          duration: ts.remaining,
                          body: "C'est fini ! Le ${animal.name} a terminé 🎉",
                        );
                        final audio = ref.read(audioServiceProvider);
                        audio.playAmbient(animal.ambientAudioPath,
                            volume: settings.volume * 0.5);
                        if (settings.tickTockSound) {
                          audio.startTickTock(volume: settings.volume * 0.3);
                        }
                      }
                    },
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
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15), blurRadius: 30)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('\u{1F389}', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text("C'est fini !",
                    style: AppTextStyles.buttonLabelDark.copyWith(fontSize: 28)),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 120, height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Center(
                      child: Text('OK', style: TextStyle(
                        fontFamily: 'Nunito', fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlPillButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ControlPillButton({
    required this.label, required this.icon,
    required this.color, required this.onTap,
  });

  @override
  State<_ControlPillButton> createState() => _ControlPillButtonState();
}

class _ControlPillButtonState extends State<_ControlPillButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { _ctrl.forward(); HapticFeedback.lightImpact(); },
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: widget.color.withOpacity(0.35), blurRadius: 10,
                offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(widget.label, style: const TextStyle(
                fontFamily: 'Nunito', fontSize: 18,
                fontWeight: FontWeight.w800, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
