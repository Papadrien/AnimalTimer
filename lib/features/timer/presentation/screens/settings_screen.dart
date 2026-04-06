// lib/features/timer/presentation/screens/settings_screen.dart
//
// ⚙️ Écran des paramètres.
//    Toggles display/son, slider volume, liens infos.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings  = ref.watch(settingsProvider);
    final notifier  = ref.read(settingsProvider.notifier);

    return Scaffold(
      body: GradientBackground(
        animalId: 'duck',
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: GlassCard(
                        padding: const EdgeInsets.all(10),
                        borderRadius: 16,
                        shadow: false,
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Paramètres',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Nunito',
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Liste des réglages ───────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [

                    // ── AFFICHAGE ──────────────────────────────────────────
                    _SectionLabel('Affichage'),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _ToggleTile(
                            title: 'Afficher le temps',
                            subtitle: 'Montrer mm:ss pendant le minuteur',
                            value: settings.showTime,
                            onChanged: notifier.setShowTime,
                          ),
                          _Divider(),
                          _ToggleTile(
                            title: 'Afficher l\'animal',
                            subtitle: 'Montrer l\'animal animé au centre',
                            value: settings.showAnimal,
                            onChanged: notifier.setShowAnimal,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── SONS ───────────────────────────────────────────────
                    _SectionLabel('Sons'),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _ToggleTile(
                            title: 'Sons de l\'animal',
                            subtitle: 'Ambiance douce en boucle',
                            value: settings.animalSoundEnabled,
                            onChanged: notifier.setAnimalSound,
                          ),
                          _Divider(),
                          _ToggleTile(
                            title: 'Tick-tock',
                            subtitle: 'Battement d\'horloge discret',
                            value: settings.tickTockEnabled,
                            onChanged: notifier.setTickTock,
                          ),
                          _Divider(),
                          // Volume slider
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Volume',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Nunito',
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${(settings.volume * 100).round()} %',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textLight,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.duckSecondary,
                                    inactiveTrackColor:
                                        AppColors.duckPrimary.withOpacity(0.25),
                                    thumbColor: AppColors.duckSecondary,
                                    overlayColor: AppColors.duckSecondary
                                        .withOpacity(0.18),
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: settings.volume,
                                    onChanged: notifier.setVolume,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── INFOS ──────────────────────────────────────────────
                    _SectionLabel('Informations'),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _InfoTile(
                            icon: Icons.info_outline_rounded,
                            title: 'À propos',
                            onTap: () => _showAbout(context),
                          ),
                          _Divider(),
                          _InfoTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Confidentialité',
                            onTap: () {},
                          ),
                          _Divider(),
                          _InfoTile(
                            icon: Icons.help_outline_rounded,
                            title: 'FAQ',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Version
                    Center(
                      child: Text(
                        'AnimalTimer v1.0.0',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Row(
          children: [
            Text('🦆', style: TextStyle(fontSize: 28)),
            SizedBox(width: 10),
            Text(
              'AnimalTimer',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: const Text(
          'Un minuteur visuel et ludique pour les enfants de 3 à 8 ans.\n\n'
          'Aucune publicité. Aucun abonnement. Juste du temps qui passe.',
          style: TextStyle(fontFamily: 'Nunito', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Super !',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: AppColors.duckSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets locaux réutilisables
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: AppColors.textLight,
            fontFamily: 'Nunito',
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.glassBorder,
        indent: 16,
        endIndent: 16,
      );
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.duckSecondary,
            ),
          ],
        ),
      );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textMedium, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito',
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ],
          ),
        ),
      );
}
