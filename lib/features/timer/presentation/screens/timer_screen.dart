// lib/features/timer/presentation/screens/timer_screen.dart
//
// ⏳ Écran du minuteur actif.
//    Anneau de progression, animal animé, contrôles pause/cancel, overlay de fin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/models.dart';
import '../providers/timer_notifier.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/progress_ring_painter.dart';
import '../widgets/animal_widget.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key, required this.animal});

  final AnimalModel animal;

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with TickerProviderStateMixin {

  // ── Animation de fin ──────────────────────────────────────────────────────
  late final AnimationController _finishCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _finishScale = Tween<double>(begin: 0.7, end: 1.0)
      .animate(CurvedAnimation(parent: _finishCtrl, curve: Curves.elasticOut));
  late final Animation<double> _finishFade =
      CurvedAnimation(parent: _finishCtrl, curve: Curves.easeIn);

  bool _overlayVisible = false;

  @override
  void dispose() {
    _finishCtrl.dispose();
    super.dispose();
  }

  // ── Écoute de l'état ──────────────────────────────────────────────────────

  void _onStateChanged(TimerState? prev, TimerState next) {
    if (next.isFinished && !(prev?.isFinished ?? false)) {
      setState(() => _overlayVisible = true);
      _finishCtrl.forward(from: 0);
      // Retour auto à l'accueil après 3 s
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(timerProvider);
    final settings = ref.watch(settingsProvider);

    ref.listen<TimerState>(timerProvider, _onStateChanged);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await ref.read(timerProvider.notifier).cancel();
        if (mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: GradientBackground(
          animalId: widget.animal.id,
          child: SafeArea(
            child: Stack(
              children: [
                _buildContent(state, settings),
                if (_overlayVisible) _buildFinishOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Contenu principal ─────────────────────────────────────────────────────

  Widget _buildContent(TimerState state, AppSettings settings) {
    final ringSize = MediaQuery.of(context).size.width * 0.80;

    return Column(
      children: [
        // ── AppBar custom ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              _RoundIconButton(
                icon: Icons.close_rounded,
                onTap: () async {
                  await ref.read(timerProvider.notifier).cancel();
                  if (mounted) Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              Text(
                widget.animal.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 44), // équilibre visuel
            ],
          ),
        ),

        // ── Anneau + Animal + Temps ────────────────────────────────────────
        Expanded(
          child: Center(
            child: ProgressRingWidget(
              progress: state.progress,
              gradient: widget.animal.id.animalGradient,
              size: ringSize,
              strokeWidth: ringSize * 0.065,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animal animé
                  if (settings.showAnimal)
                    AnimalWidget(
                      animal: widget.animal,
                      size: ringSize * 0.30,
                      animate: state.isRunning,
                    ),

                  SizedBox(height: settings.showAnimal ? 10 : 0),

                  // Temps restant
                  if (settings.showTime)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: child,
                      ),
                      child: Text(
                        _formatDuration(state.remaining),
                        key: ValueKey(state.remaining.inSeconds),
                        style: TextStyle(
                          fontSize: ringSize * 0.14,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Nunito',
                          color: AppColors.textDark,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // ── Contrôles ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 48, top: 12),
          child: _buildControls(state),
        ),
      ],
    );
  }

  // ── Boutons Pause / Resume ────────────────────────────────────────────────

  Widget _buildControls(TimerState state) {
    return _PauseResumeButton(
      isRunning: state.isRunning,
      gradient: widget.animal.id.animalGradient,
      glowColor: widget.animal.primaryColor,
      onTap: state.isRunning
          ? () => ref.read(timerProvider.notifier).pause()
          : () => ref.read(timerProvider.notifier).resume(),
    );
  }

  // ── Overlay de fin ────────────────────────────────────────────────────────

  Widget _buildFinishOverlay() {
    return AnimatedBuilder(
      animation: _finishFade,
      builder: (_, __) => Opacity(
        opacity: _finishFade.value,
        child: Container(
          color: Colors.white.withOpacity(0.92),
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _finishScale,
            builder: (_, child) =>
                Transform.scale(scale: _finishScale.value, child: child),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.animal.emoji,
                  style: const TextStyle(fontSize: 88),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => widget.animal.id.animalGradient
                      .createShader(bounds),
                  child: const Text(
                    'Terminé ! 🎉',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Nunito',
                      color: Colors.white,
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatDuration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours.toString().padLeft(2, '0')}'
          ':${(d.inMinutes % 60).toString().padLeft(2, '0')}'
          ':${(d.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${(d.inMinutes % 60).toString().padLeft(2, '0')}'
        ':${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets privés
// ─────────────────────────────────────────────────────────────────────────────

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(10),
        borderRadius: 16,
        shadow: false,
        child: Icon(icon, color: AppColors.textMedium, size: 22),
      ),
    );
  }
}

class _PauseResumeButton extends StatefulWidget {
  const _PauseResumeButton({
    required this.isRunning,
    required this.gradient,
    required this.glowColor,
    required this.onTap,
  });
  final bool isRunning;
  final LinearGradient gradient;
  final Color glowColor;
  final VoidCallback onTap;

  @override
  State<_PauseResumeButton> createState() => _PauseResumeButtonState();
}

class _PauseResumeButtonState extends State<_PauseResumeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );
  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 0.90).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.gradient,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.40),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              widget.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              key: ValueKey(widget.isRunning),
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
