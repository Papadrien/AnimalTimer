import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        gradient: setup.selectedAnimal.setupGradient,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24, right: 24, bottom: bottomPad + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _showSettings(context),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.paperLight.withOpacity(0.6),
                      border: Border.all(
                        color: AppColors.pencilDark.withOpacity(0.2), width: 1.5),
                    ),
                    child: Icon(Icons.settings,
                      color: AppColors.pencilDark.withOpacity(0.5), size: 22),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(child: AnimalSelector()),
              const SizedBox(height: 28),
              // Time picker FIRST
              const TimePickerCard(),
              const SizedBox(height: 24),
              // Start button
              StartButton(onPressed: () {
                if (!setup.isValid) { HapticFeedback.heavyImpact(); return; }
                HapticFeedback.mediumImpact();
                ref.read(setupProvider.notifier).saveCurrentAsRecent();
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
              const SizedBox(height: 32),
              // Recents AFTER
              const RecentsSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsSheet(),
    );
  }
}
