import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service de gestion des publicités Rewarded (AdMob).
/// Utilisé pour débloquer les animaux verrouillés.
class AdService {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  /// ID du bloc d'annonces Rewarded (test IDs).
  static String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test Android
    } else {
      return 'ca-app-pub-3940256099942544/1712485313'; // Test iOS
    }
  }

  /// Initialise AdMob avec la configuration COPPA (app pour enfants).
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      ),
    );
  }

  /// Pré-charge une pub Rewarded en arrière-plan (non-bloquant).
  Future<void> loadAd() async {
    if (_rewardedAd != null || _isLoading) return; // Déjà prête ou en cours
    _isLoading = true;

    await RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          debugPrint('[AdService] Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isLoading = false;
          debugPrint('[AdService] Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  /// Retourne true si une pub est prête à être affichée.
  bool get isAdReady => _rewardedAd != null;

  /// Affiche la pub Rewarded. Appelle [onReward] si l'utilisateur
  /// regarde la pub jusqu'au bout.
  /// Retourne true si la récompense a été accordée, false sinon.
  Future<bool> showRewardedAd({required VoidCallback onReward}) async {
    if (_rewardedAd == null) return false;

    bool rewarded = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        // Recharger la prochaine pub immédiatement
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        debugPrint('[AdService] Failed to show ad: $error');
        loadAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        onReward();
      },
    );

    return rewarded;
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}

final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  ref.onDispose(service.dispose);
  return service;
});
