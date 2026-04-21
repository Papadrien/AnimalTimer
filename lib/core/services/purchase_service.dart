import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'gamification_service.dart';

/// Service de gestion des achats in-app.
/// Produit unique "unlock_all_animals" (non-consumable, 0.99€).
class PurchaseService {
  static const String unlockAllId = 'unlock_all_animals';

  final InAppPurchase _iap = InAppPurchase.instance;
  final GamificationService _gamification;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _available = false;
  ProductDetails? _product;

  /// Callback appelé quand l'achat est validé (pour rafraîchir l'UI).
  VoidCallback? onPurchaseCompleted;

  PurchaseService(this._gamification);

  /// Le produit est-il chargé et prêt à l'achat ?
  bool get isProductAvailable => _product != null;

  /// L'utilisateur est-il déjà premium ?
  bool get isPremium => _gamification.isPremiumUnlocked();

  /// Prix localisé du produit (ex: "0,99 €").
  String get localizedPrice => _product?.price ?? '0.99€';

  /// Initialise le service : vérifie la disponibilité et charge le produit.
  Future<void> initialize() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      debugPrint('[PurchaseService] Store not available');
      return;
    }

    // Écouter les mises à jour d'achats
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('[PurchaseService] Purchase stream error: \$error');
      },
    );

    // Charger le produit depuis le store
    final response = await _iap.queryProductDetails({unlockAllId});
    if (response.productDetails.isNotEmpty) {
      _product = response.productDetails.first;
      debugPrint('[PurchaseService] Product loaded: \${_product!.price}');
    } else {
      debugPrint('[PurchaseService] Product not found on store');
      if (response.error != null) {
        debugPrint('[PurchaseService] Error: \${response.error}');
      }
    }
  }

  /// Lance l'achat "Tout débloquer".
  Future<bool> purchaseUnlockAll() async {
    if (_product == null || !_available) return false;

    final purchaseParam = PurchaseParam(productDetails: _product!);
    try {
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('[PurchaseService] Purchase error: \$e');
      return false;
    }
  }

  /// Restaure les achats précédents (obligatoire Apple).
  Future<void> restorePurchases() async {
    if (!_available) return;
    await _iap.restorePurchases();
  }

  /// Gère les mises à jour d'achats (achat, restauration, erreur).
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.productID != unlockAllId) return;

    switch (purchase.status) {
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        // Valider et débloquer
        await _gamification.unlockAllAnimals();
        debugPrint('[PurchaseService] Premium unlocked!');
        onPurchaseCompleted?.call();
        break;
      case PurchaseStatus.error:
        debugPrint('[PurchaseService] Purchase error: \${purchase.error}');
        break;
      case PurchaseStatus.pending:
        debugPrint('[PurchaseService] Purchase pending...');
        break;
      case PurchaseStatus.canceled:
        debugPrint('[PurchaseService] Purchase canceled');
        break;
    }

    // Finaliser l'achat (obligatoire pour les deux stores)
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final gamification = ref.watch(gamificationServiceProvider);
  final service = PurchaseService(gamification);
  ref.onDispose(service.dispose);
  return service;
});
