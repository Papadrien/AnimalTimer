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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pencilFaint.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 20),

              // MINUTEUR
              Text('MINUTEUR', style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _Toggle(
                label: 'Afficher les chiffres',
                icon: Icons.numbers_rounded,
                value: settings.showNumbers,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleShowNumbers(),
              ),
              _Toggle(
                label: 'Son du minuteur',
                icon: Icons.music_note_rounded,
                subtitle: 'Musique pendant le d\u00e9compte',
                value: settings.ambientSoundEnabled,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleAmbientSound(),
              ),
              _Toggle(
                label: 'Son de fin',
                icon: Icons.notifications_active_rounded,
                subtitle: 'Son quand le minuteur est termin\u00e9',
                value: settings.endSoundEnabled,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleEndSound(),
              ),
              const SizedBox(height: 20),

              Container(
                height: 1,
                color: AppColors.pencilFaint.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 20),

              // INFORMATIONS
              Text('INFORMATIONS', style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _NavItem(
                label: 'Laisser un avis',
                icon: Icons.star_outline,
                onTap: () {
                  // TODO: Ajouter in_app_review quand l'app sera sur les stores
                },
              ),
              _NavItem(
                label: 'Politique de confidentialit\u00e9',
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const _PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              _NavItem(
                label: 'Restaurer les achats',
                icon: Icons.restore_rounded,
                onTap: () {
                  // TODO: Brancher sur PurchaseService.restorePurchases()
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recherche des achats en cours...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pencilFaint.withValues(alpha: 0.4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
              color: AppColors.pencilFaint.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({
    required this.label,
    required this.icon,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.pencilLight, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.settingItem),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.pencilFaint.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value, onChanged: onChanged,
            activeColor: AppColors.toggleActive,
            activeTrackColor: AppColors.toggleActive.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.pencilFaint,
            inactiveTrackColor: AppColors.pencilFaint.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

class _PrivacyPolicyScreen extends StatelessWidget {
  const _PrivacyPolicyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Politique de confidentialit\u00e9',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            color: AppColors.pencilDark,
          ),
        ),
        backgroundColor: AppColors.sheetBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.pencilDark),
      ),
      backgroundColor: AppColors.sheetBg,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PolicySection(
              title: 'Introduction',
              content: 'AnimalTimer est une application de minuteur visuel '
                  'con\u00e7ue pour les enfants de 3 \u00e0 8 ans. La protection '
                  'de la vie priv\u00e9e de vos enfants est notre priorit\u00e9 absolue.',
            ),
            _PolicySection(
              title: 'Donn\u00e9es collect\u00e9es',
              content: 'AnimalTimer ne collecte aucune donn\u00e9e personnelle. '
                  'Toutes les pr\u00e9f\u00e9rences (animal s\u00e9lectionn\u00e9, '
                  'r\u00e9glages du son, animaux d\u00e9bloqu\u00e9s) sont '
                  'stock\u00e9es uniquement sur votre appareil et ne sont '
                  'jamais transmises \u00e0 un serveur externe.',
            ),
            _PolicySection(
              title: 'Publicit\u00e9s',
              content: 'L\u2019application peut afficher des publicit\u00e9s '
                  'vid\u00e9o (via Google AdMob) pour d\u00e9bloquer de nouveaux '
                  'animaux. Ces publicit\u00e9s sont conformes \u00e0 la '
                  'r\u00e9glementation COPPA et ne collectent pas de donn\u00e9es '
                  'personnelles sur les enfants. Seules des publicit\u00e9s '
                  'adapt\u00e9es aux enfants sont affich\u00e9es.',
            ),
            _PolicySection(
              title: 'Achats int\u00e9gr\u00e9s',
              content: 'L\u2019application propose un achat unique optionnel '
                  'pour d\u00e9bloquer tous les animaux. Les achats sont '
                  'g\u00e9r\u00e9s par Google Play ou l\u2019App Store et '
                  'sont prot\u00e9g\u00e9s par les contr\u00f4les parentaux '
                  'de votre appareil.',
            ),
            _PolicySection(
              title: 'Conformit\u00e9 COPPA',
              content: 'AnimalTimer est conforme \u00e0 la loi COPPA. Nous ne '
                  'collectons pas sciemment d\u2019informations personnelles '
                  'aupr\u00e8s d\u2019enfants de moins de 13 ans.',
            ),
            _PolicySection(
              title: 'Contact',
              content: 'Pour toute question concernant cette politique de '
                  'confidentialit\u00e9, vous pouvez nous contacter \u00e0 :\n'
                  'contact@animaltimer.app',
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;
  const _PolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.pencilDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.pencilDark.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
