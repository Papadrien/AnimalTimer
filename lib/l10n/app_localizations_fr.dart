// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'AnimalTimer';

  @override
  String get animalDog => 'Chien';

  @override
  String get animalCat => 'Chat';

  @override
  String get animalCrocodile => 'Crocodile';

  @override
  String get animalPony => 'Poney';

  @override
  String get animalChicken => 'Poule';

  @override
  String get chooseAnimal => 'Choisis ton animal';

  @override
  String get start => 'Démarrer';

  @override
  String get hours => 'Heures';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Secondes';

  @override
  String get recentTimers => 'DERNIERS MINUTEURS';

  @override
  String get cancel => 'Annuler';

  @override
  String get resume => 'Reprendre';

  @override
  String get pause => 'Pause';

  @override
  String get hourUnit => 'h ';

  @override
  String get minuteUnit => 'm ';

  @override
  String get secondUnit => 's';

  @override
  String get finished => 'C\'est fini !';

  @override
  String get stop => 'Arrêter';

  @override
  String get ok => 'OK';

  @override
  String get settingsTimer => 'MINUTEUR';

  @override
  String get showNumbers => 'Afficher les chiffres';

  @override
  String get ambientSound => 'Son du minuteur';

  @override
  String get ambientSoundSub => 'Musique pendant le décompte';

  @override
  String get endSound => 'Son de fin';

  @override
  String get endSoundSub => 'Son quand le minuteur est terminé';

  @override
  String get settingsInfo => 'INFORMATIONS';

  @override
  String get rateApp => 'Laisser un avis';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get searchingPurchases => 'Recherche des achats en cours...';

  @override
  String get policyIntro => 'Introduction';

  @override
  String get policyIntroContent =>
      'AnimalTimer est une application de minuteur visuel conçue pour les enfants. La protection de la vie privée est une priorité.';

  @override
  String get policyData => 'Données collectées';

  @override
  String get policyDataContent =>
      'AnimalTimer ne collecte ni ne stocke directement de données personnelles.\n\nCependant, l\'application utilise des services tiers (comme Google AdMob) susceptibles de collecter certaines informations techniques, telles que :\n• l\'adresse IP\n• le type d\'appareil\n• des données d\'utilisation anonymes\n\nCes données sont utilisées uniquement pour assurer le bon fonctionnement de l\'application et afficher des publicités adaptées aux enfants.';

  @override
  String get policyAds => 'Publicités';

  @override
  String get policyAdsContent =>
      'L\'application peut afficher des publicités via Google AdMob afin de débloquer du contenu (ex : nouveaux animaux).\n\nCes publicités sont configurées pour :\n• être adaptées aux enfants\n• respecter la réglementation COPPA (Children\'s Online Privacy Protection Act)\n• ne pas proposer de publicité comportementale personnalisée';

  @override
  String get policyIAP => 'Achats intégrés';

  @override
  String get policyIAPContent =>
      'L\'application propose un achat unique optionnel permettant de débloquer tous les animaux.\n\nLes paiements sont gérés par Google Play ou l\'App Store et sont sécurisés par les contrôles parentaux du système.';

  @override
  String get policyCOPPA => 'Conformité COPPA';

  @override
  String get policyCOPPAContent =>
      'AnimalTimer est conforme à la loi COPPA. L\'application ne collecte pas sciemment de données personnelles auprès d\'enfants de moins de 13 ans.';

  @override
  String get policyContact => 'Contact';

  @override
  String get policyContactContent =>
      'Pour toute question concernant cette politique de confidentialité :\npapadrien.prepa@gmail.com';

  @override
  String get policyThirdParty => 'Services tiers';

  @override
  String get policyThirdPartyContent =>
      'L\'application utilise les services suivants :\n• Google AdMob (publicités)\n\nPour plus d\'informations :\nhttps://policies.google.com/privacy';

  @override
  String get policyGDPR => 'Droits des utilisateurs (RGPD)';

  @override
  String get policyGDPRContent =>
      'Conformément au Règlement Général sur la Protection des Données (RGPD), vous disposez des droits suivants :\n• Droit d\'accès\n• Droit de rectification\n• Droit à l\'effacement\n• Droit à la limitation du traitement\n\nPour toute demande :\npapadrien.prepa@gmail.com';

  @override
  String get policyUpdate => 'Mise à jour';

  @override
  String get policyUpdateContent => 'Dernière mise à jour : Avril 2026';

  @override
  String get rewardedAdTitle => 'Publicité récompensée';

  @override
  String watchAdToUnlock(String animalName) {
    return 'Regarde une vidéo publicitaire pour débloquer $animalName';
  }

  @override
  String get watchAd => 'Regarder';

  @override
  String get adLoading => 'Chargement de la vidéo…';

  @override
  String animalUnlocked(String animalName) {
    return '$animalName est débloqué ! 🎉';
  }

  @override
  String get unlockAllButton => 'Débloquer tout';

  @override
  String unlockAllButtonWithPrice(String price) {
    return 'Débloquer tout – $price';
  }

  @override
  String get adBadgeLabel => 'PUB';

  @override
  String get unlockAllSuccess => 'Tous les animaux sont débloqués ! 🎉';

  @override
  String get purchaseError => 'L\'achat a échoué. Réessaie.';

  @override
  String get restoreSuccess => 'Achats restaurés !';

  @override
  String get restoreEmpty => 'Aucun achat trouvé.';

  @override
  String get storeNotAvailable =>
      'Boutique indisponible. Vérifie ta connexion.';

  @override
  String get purchaseDialogTitle => 'Tout débloquer';

  @override
  String get purchaseDialogBody =>
      'Débloque tous les animaux actuels et futurs, pour toujours !';

  @override
  String get purchaseDialogOneTime => 'Un seul achat, pas d\'abonnement.';

  @override
  String purchaseDialogBuy(String price) {
    return 'Acheter — $price';
  }

  @override
  String unlockAnimalTitle(String animalName) {
    return 'Débloquer $animalName';
  }

  @override
  String get animalShark => 'Requin';

  @override
  String get animalUnicorn => 'Licorne';

  @override
  String get animalTurtle => 'Tortue';

  @override
  String get animalGiraffe => 'Girafe';

  @override
  String get animalSheep => 'Mouton';

  @override
  String get cancelConfirmTitle => 'Annuler le minuteur ?';

  @override
  String get cancelConfirmBody =>
      'Le minuteur sera arrêté et tu reviendras à l\'écran d\'accueil.';

  @override
  String get continueTimer => 'Continuer';
}
