import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service de gestion des publicités Rewarded (AdMob).
/// Utilisé pour débloquer les animaux verrouillés.
class AdService {
  RewardedAd? _rewardedAd;
  bool _isShowing = false;
  Completer<void>? _loadCompleter;

  /// ID du bloc d'annonces Rewarded.
  /// Debug → IDs de test (fausses pubs), Release → IDs de prod (vraies pubs).
  static String get _adUnitId {
    if (kDebugMode) {
      // IDs de TEST (fausses pubs "Test Ad", aucun revenu)
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    } else {
      // IDs de PRODUCTION (vraies pubs, vrais revenus)
      return Platform.isAndroid
          ? 'ca-app-pub-7203301690798915/7522847549'
          : 'ca-app-pub-7203301690798915/2789170273';
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

  /// Pré-charge une pub Rewarded en arrière-plan.
  /// Le Future retourné se termine seulement quand le chargement est
  /// vraiment fini (succès ou échec) — plusieurs appelants peuvent
  /// attendre le même chargement en cours au lieu de repartir à zéro.
  Future<void> loadAd() {
    if (_rewardedAd != null) return Future.value();
    if (_loadCompleter != null) return _loadCompleter!.future;

    final completer = Completer<void>();
    _loadCompleter = completer;

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _loadCompleter = null;
          debugPrint('[AdService] Rewarded ad loaded');
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _loadCompleter = null;
          debugPrint('[AdService] Failed to load rewarded ad: $error');
          completer.complete();
        },
      ),
    );

    return completer.future;
  }

  /// Retourne true si une pub est prête à être affichée (et qu'aucune
  /// pub n'est déjà en cours d'affichage).
  bool get isAdReady => _rewardedAd != null && !_isShowing;

  /// Affiche la pub Rewarded. Appelle [onReward] si l'utilisateur
  /// regarde la pub jusqu'au bout.
  /// Retourne true si la récompense a été accordée, false sinon.
  ///
  /// Protégé contre le double-appel : si une pub est déjà en cours
  /// d'affichage (ex. double-tap, 2e appel avant le dismiss du 1er),
  /// l'appel est ignoré au lieu de rappeler .show() sur une pub déjà
  /// consommée.
  Future<bool> showRewardedAd({required VoidCallback onReward}) async {
    if (_rewardedAd == null || _isShowing) return false;

    final ad = _rewardedAd!;
    _rewardedAd = null; // consommée immédiatement, plus réutilisable
    _isShowing = true;

    bool rewarded = false;
    final dismissed = Completer<void>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isShowing = false;
        if (!dismissed.isCompleted) dismissed.complete();
        loadAd(); // Recharger la prochaine pub immédiatement
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isShowing = false;
        debugPrint('[AdService] Failed to show ad: $error');
        if (!dismissed.isCompleted) dismissed.complete();
        loadAd();
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        onReward();
      },
    );

    // .show() se résout dès que la pub s'affiche, pas quand l'utilisateur
    // la ferme : on attend le vrai dismiss pour retourner un résultat fiable.
    await dismissed.future;

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
