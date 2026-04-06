// lib/features/timer/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_notifier.dart';
import '../providers/animals_provider.dart';
import '../providers/settings_provider.dart';
import '../../data/timer_repository.dart';
import '../../domain/models/models.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/start_button.dart';
import '../widgets/time_picker_widget.dart';
import '../widgets/animal_selector.dart';
import '../widgets/recent_timers_section.dart';
import '../../../../core/theme/app_colors.dart';
import 'timer_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Duration _duration      = const Duration(minutes: 5);
  int      _animalIndex   = 0;
  List<TimerConfig> _recents = [];

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final r = await TimerRepository().getRecentTimers();
    if (mounted) setState(() => _recents = r);
  }

  @override
  Widget build(BuildContext context) {
    final animalsAsync = ref.watch(animalsProvider);

    return animalsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data:  _buildScreen,
    );
  }

  Widget _buildScreen(List<AnimalModel> animals) {
    final animal   = animals[_animalIndex.clamp(0, animals.length - 1)];
    final gradient = animal.id.animalGradient;

    return Scaffold(
      body: GradientBackground(
        animalId: animal.id,
        child: SafeArea(
          child: Stack(
            children: [
              // ── Scrollable content ─────────────────────────────────────
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 148),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(onSettingsTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    )),
                    const SizedBox(height: 28),

                    _Label('Durée'),
                    const SizedBox(height: 8),
                    TimePicker(
                      initialDuration: _duration,
                      onChanged: (d) => setState(() => _duration = d),
                    ),
                    const SizedBox(height: 24),

                    _Label('Compagnon'),
                    const SizedBox(height: 8),
                    AnimalSelector(
                      animals:       animals,
                      selectedIndex: _animalIndex,
                      onChanged: (i) => setState(() => _animalIndex = i),
                    ),
                    const SizedBox(height: 32),

                    RecentTimersSection(
                      recents:  _recents,
                      onSelect: (cfg) {
                        final idx = animals.indexWhere((a) => a.id == cfg.animalId);
                        setState(() {
                          _duration    = cfg.duration;
                          _animalIndex = idx >= 0 ? idx : _animalIndex;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // ── Bouton Start flottant ──────────────────────────────────
              Positioned(
                bottom: 32, left: 0, right: 0,
                child: Center(
                  child: StartButton(
                    gradient: gradient,
                    enabled:  _duration > Duration.zero,
                    onPressed: () => _startTimer(animal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startTimer(AnimalModel animal) async {
    // Sauvegarder dans les récents
    await TimerRepository().saveRecentTimer(
      TimerConfig(duration: _duration, animalId: animal.id),
    );

    await ref.read(timerProvider.notifier).start(
      duration: _duration,
      animalId: animal.id,
    );

    if (!mounted) return;
    await Navigator.push(context, _FadeScale(TimerScreen(animal: animal)));

    // Recharger les récents au retour
    _loadRecents();
  }
}

// ── Sous-widgets locaux ───────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onSettingsTap});
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('AnimalTimer',
                style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800,
                  fontFamily: 'Nunito', color: AppColors.textDark,
                )),
            Text('Combien de temps ?',
                style: TextStyle(
                  fontSize: 14, color: AppColors.textLight, fontFamily: 'Nunito',
                )),
          ],
        ),
        GestureDetector(
          onTap: onSettingsTap,
          child: GlassCard(
            padding: const EdgeInsets.all(10),
            borderRadius: 16,
            shadow: false,
            child: const Icon(Icons.settings_outlined,
                color: AppColors.textMedium, size: 22),
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          letterSpacing: 1.8, color: AppColors.textLight, fontFamily: 'Nunito',
        ),
      );
}

// ── Transition page : fondu + scale ──────────────────────────────────────────

class _FadeScale<T> extends PageRouteBuilder<T> {
  _FadeScale(Widget page)
      : super(
          pageBuilder:             (_, __, ___) => page,
          transitionDuration:      const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (_, anim, __, child) {
            final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: c,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(c),
                child: child,
              ),
            );
          },
        );
}
