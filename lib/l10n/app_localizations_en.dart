// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AnimalTimer';

  @override
  String get animalDog => 'Dog';

  @override
  String get animalCat => 'Cat';

  @override
  String get animalCrocodile => 'Crocodile';

  @override
  String get animalPony => 'Pony';

  @override
  String get animalChicken => 'Chicken';

  @override
  String get chooseAnimal => 'Choose your animal';

  @override
  String get start => 'Start';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String get recentTimers => 'RECENT TIMERS';

  @override
  String get cancel => 'Cancel';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get hourUnit => 'h ';

  @override
  String get minuteUnit => 'm ';

  @override
  String get secondUnit => 's';

  @override
  String get finished => 'Time\'s up!';

  @override
  String get stop => 'Stop';

  @override
  String get ok => 'OK';

  @override
  String get settingsTimer => 'TIMER';

  @override
  String get showNumbers => 'Show numbers';

  @override
  String get ambientSound => 'Timer sound';

  @override
  String get ambientSoundSub => 'Music during countdown';

  @override
  String get endSound => 'End sound';

  @override
  String get endSoundSub => 'Sound when timer ends';

  @override
  String get settingsInfo => 'INFORMATION';

  @override
  String get rateApp => 'Rate the app';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get searchingPurchases => 'Searching for purchases...';

  @override
  String get policyIntro => 'Introduction';

  @override
  String get policyIntroContent =>
      'AnimalTimer is a visual timer application designed for children. Protecting privacy is a top priority.';

  @override
  String get policyData => 'Data collected';

  @override
  String get policyDataContent =>
      'AnimalTimer does not directly collect or store personal data.\n\nHowever, the app uses third-party services (such as Google AdMob) that may collect certain technical information, including:\n• IP address\n• device type\n• anonymous usage data\n\nThis data is used solely to ensure proper app functionality and to display child-appropriate advertisements.';

  @override
  String get policyAds => 'Advertising';

  @override
  String get policyAdsContent =>
      'The app may display ads via Google AdMob to unlock content (e.g., new animals).\n\nThese ads are configured to:\n• be suitable for children\n• comply with COPPA (Children\'s Online Privacy Protection Act)\n• not use behavioral or personalized advertising';

  @override
  String get policyIAP => 'In-App Purchases';

  @override
  String get policyIAPContent =>
      'The app offers an optional one-time purchase to unlock all animals.\n\nPayments are handled securely by Google Play or the App Store and are protected by parental controls.';

  @override
  String get policyCOPPA => 'COPPA Compliance';

  @override
  String get policyCOPPAContent =>
      'AnimalTimer complies with COPPA. The app does not knowingly collect personal data from children under 13.';

  @override
  String get policyContact => 'Contact';

  @override
  String get policyContactContent =>
      'For any questions regarding this Privacy Policy:\npapadrien.prepa@gmail.com';

  @override
  String get policyThirdParty => 'Third-Party Services';

  @override
  String get policyThirdPartyContent =>
      'The app uses the following services:\n• Google AdMob (advertising)\n\nMore information:\nhttps://policies.google.com/privacy';

  @override
  String get policyGDPR => 'User Rights (GDPR)';

  @override
  String get policyGDPRContent =>
      'Under the General Data Protection Regulation (GDPR), you have the following rights:\n• Right of access\n• Right to rectification\n• Right to deletion\n• Right to restriction of processing\n\nTo exercise your rights:\npapadrien.prepa@gmail.com';

  @override
  String get policyUpdate => 'Last Update';

  @override
  String get policyUpdateContent => 'Last updated: April 2026';

  @override
  String get rewardedAdTitle => 'Rewarded Ad';

  @override
  String watchAdToUnlock(String animalName) {
    return 'Watch an ad video to unlock $animalName';
  }

  @override
  String get watchAd => 'Watch';

  @override
  String get adLoading => 'Loading video…';

  @override
  String animalUnlocked(String animalName) {
    return '$animalName is unlocked! 🎉';
  }

  @override
  String get unlockAllButton => 'Unlock all';

  @override
  String unlockAllButtonWithPrice(String price) {
    return 'Unlock all – $price';
  }

  @override
  String get adBadgeLabel => 'AD';

  @override
  String get unlockAllSuccess => 'All animals are unlocked! 🎉';

  @override
  String get purchaseError => 'Purchase failed. Please try again.';

  @override
  String get restoreSuccess => 'Purchases restored!';

  @override
  String get restoreEmpty => 'No purchases found.';

  @override
  String get storeNotAvailable => 'Store not available. Check your connection.';

  @override
  String get purchaseDialogTitle => 'Unlock all';

  @override
  String get purchaseDialogBody =>
      'Unlock all current and future animals, forever!';

  @override
  String get purchaseDialogOneTime => 'One-time purchase, no subscription.';

  @override
  String purchaseDialogBuy(String price) {
    return 'Buy — $price';
  }

  @override
  String unlockAnimalTitle(String animalName) {
    return 'Unlock $animalName';
  }

  @override
  String get animalShark => 'Shark';

  @override
  String get animalUnicorn => 'Unicorn';

  @override
  String get animalTurtle => 'Turtle';

  @override
  String get animalGiraffe => 'Giraffe';

  @override
  String get animalSheep => 'Sheep';

  @override
  String get cancelConfirmTitle => 'Cancel the timer?';

  @override
  String get cancelConfirmBody =>
      'The timer will be stopped and you will return to the home screen.';

  @override
  String get continueTimer => 'Continue';
}
