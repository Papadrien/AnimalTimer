import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/settings_provider.dart';
import '../../../../core/services/purchase_service.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: DraggableScrollableSheet(
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
              Text(context.l10n.settingsTimer, style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _Toggle(
                label: context.l10n.showNumbers,
                icon: Icons.numbers_rounded,
                value: settings.showNumbers,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleShowNumbers(),
              ),
              _Toggle(
                label: context.l10n.ambientSound,
                icon: Icons.music_note_rounded,
                subtitle: context.l10n.ambientSoundSub,
                value: settings.ambientSoundEnabled,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleAmbientSound(),
              ),
              _Toggle(
                label: context.l10n.endSound,
                icon: Icons.notifications_active_rounded,
                subtitle: context.l10n.endSoundSub,
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
              Text(context.l10n.settingsInfo, style: AppTextStyles.settingSectionTitle),
              const SizedBox(height: 16),
              _NavItem(
                label: context.l10n.rateApp,
                icon: Icons.star_outline,
                onTap: () {
                  // TODO: Ajouter in_app_review quand l'app sera sur les stores
                },
              ),
              _NavItem(
                label: context.l10n.privacyPolicy,
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const _PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              _NavItem(
                label: context.l10n.restorePurchases,
                icon: Icons.restore_rounded,
                onTap: () async {
                  final purchaseService = ref.read(purchaseServiceProvider);
                  final messenger = ScaffoldMessenger.of(context);
                  final searchingText = context.l10n.searchingPurchases;
                  final successText = context.l10n.restoreSuccess;
                  // S'assurer que le service est initialisé
                  await purchaseService.initialize();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(searchingText),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  purchaseService.onPurchaseCompleted = () {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(successText),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.accentGreen,
                      ),
                    );
                  };
                  await purchaseService.restorePurchases();
                },
              ),
              const SizedBox(height: 24),

              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.hasData
                      ? 'Version 1.0.${snapshot.data!.buildNumber}'
                      : '';
                  return Center(
                    child: Text(
                      version,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pencilFaint.withValues(alpha: 0.4),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
      ),
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
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
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
            value: value,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
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
        title: Text(
          context.l10n.privacyPolicy,
          style: const TextStyle(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PolicySection(
              title: context.l10n.policyIntro,
              content: context.l10n.policyIntroContent,
            ),
            _PolicySection(
              title: context.l10n.policyData,
              content: context.l10n.policyDataContent,
            ),
            _PolicySection(
              title: context.l10n.policyAds,
              content: context.l10n.policyAdsContent,
            ),
            _PolicySection(
              title: context.l10n.policyIAP,
              content: context.l10n.policyIAPContent,
            ),
            _PolicySection(
              title: context.l10n.policyThirdParty,
              content: context.l10n.policyThirdPartyContent,
            ),
            _PolicySection(
              title: context.l10n.policyCOPPA,
              content: context.l10n.policyCOPPAContent,
            ),
            _PolicySection(
              title: context.l10n.policyGDPR,
              content: context.l10n.policyGDPRContent,
            ),
            _PolicySection(
              title: context.l10n.policyContact,
              content: context.l10n.policyContactContent,
            ),
            _PolicySection(
              title: context.l10n.policyUpdate,
              content: context.l10n.policyUpdateContent,
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
