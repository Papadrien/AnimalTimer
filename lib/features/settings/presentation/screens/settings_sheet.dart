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
            border: Border(
              top: BorderSide(color: AppColors.pencilDark.withOpacity(0.3), width: 2),
              left: BorderSide(color: AppColors.pencilDark.withOpacity(0.2), width: 1.5),
              right: BorderSide(color: AppColors.pencilDark.withOpacity(0.2), width: 1.5),
            ),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              // Drag handle — petit trait de crayon
              Center(child: Container(
                width: 40, height: 3,
                decoration: BoxDecoration(
                  color: AppColors.pencilFaint,
                  borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 24),
              _NavItem(label: 'About', onTap: () {}),
              _NavItem(label: 'Leave a Review', onTap: () {}),
              _NavItem(label: 'Privacy Policy', onTap: () {}),
              _NavItem(label: 'Help & FAQ', onTap: () {}),
              const SizedBox(height: 24),
              // Ligne de séparation "crayon"
              Container(
                height: 1.5,
                color: AppColors.pencilFaint.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text('TIMER', style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _Toggle(label: 'Show Numbers', value: settings.showNumbers,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleShowNumbers()),
              _Toggle(label: 'Show Animal', value: settings.showAnimal,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleShowAnimal()),
              _Toggle(label: 'Tick-Tock Sound', value: settings.tickTockSound,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleTickTock()),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavItem({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(label, style: AppTextStyles.settingItem),
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
          Text(label, style: AppTextStyles.settingItem),
          Switch(
            value: value, onChanged: onChanged,
            activeColor: AppColors.toggleActive,
            activeTrackColor: AppColors.toggleActive.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
