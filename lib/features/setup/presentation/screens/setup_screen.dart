import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../timer/presentation/screens/timer_screen.dart';
import '../../../settings/presentation/screens/settings_sheet.dart';
import '../../providers/setup_provider.dart';
import '../widgets/time_picker_card.dart';
import '../widgets/animal_selector.dart';
import '../widgets/recents_list.dart';
import '../widgets/start_button.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    return Scaffold(
      body: GradientBackground(
        gradient: setup.selectedAnimal.setupGradient,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => _showSettings(context),
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.settings, color: Colors.white70, size: 24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TimePickerCard(),
            const SizedBox(height: 32),
            const AnimalSelector(),
            const SizedBox(height: 32),
            StartButton(onPressed: () {
              if (!setup.isValid) { HapticFeedback.heavyImpact(); return; }
              HapticFeedback.mediumImpact();
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => const TimerScreen(),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                    child: child)),
                transitionDuration: const Duration(milliseconds: 400),
              ));
            }),
            const SizedBox(height: 40),
            const RecentsSection(),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsSheet());
  }
}
