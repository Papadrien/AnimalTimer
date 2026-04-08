import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/settings_provider.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              // Drag handle
              Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pencilFaint.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 20),

              // ── PARAMÈTRES ET OPTIONS ──
              Text('PARAMÈTRES ET OPTIONS',
                style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _NavItem(label: 'À propos', icon: Icons.info_outline, onTap: () {}),
              _NavItem(label: 'Laisser un avis', icon: Icons.star_outline, onTap: () {}),
              _NavItem(label: 'Politique de confidentialité', icon: Icons.privacy_tip_outlined, onTap: () {}),
              _NavItem(label: 'Aide & FAQ', icon: Icons.help_outline, onTap: () {}),
              const SizedBox(height: 20),

              // Separator
              Container(
                height: 1,
                color: AppColors.pencilFaint.withOpacity(0.2),
              ),
              const SizedBox(height: 20),

              // ── MINUTEUR ──
              Text('MINUTEUR', style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _Toggle(
                label: 'Afficher les chiffres',
                value: settings.showNumbers,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleShowNumbers(),
              ),
              _Toggle(
                label: "Afficher l'animal",
                value: settings.showAnimal,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleShowAnimal(),
              ),
              _Toggle(
                label: 'Son tic-tac',
                value: settings.tickTockSound,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleTickTock(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _NavItem({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: AppColors.pencilLight, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.settingItem)),
            Icon(Icons.chevron_right,
              color: AppColors.pencilFaint.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppTextStyles.settingItem)),
          Switch(
            value: value, onChanged: onChanged,
            activeColor: AppColors.toggleActive,
            activeTrackColor: AppColors.toggleActive.withOpacity(0.3),
            inactiveThumbColor: AppColors.pencilFaint,
            inactiveTrackColor: AppColors.pencilFaint.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
