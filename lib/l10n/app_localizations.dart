import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AnimalTimer'**
  String get appName;

  /// No description provided for @animalDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get animalDog;

  /// No description provided for @animalCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get animalCat;

  /// No description provided for @animalCrocodile.
  ///
  /// In en, this message translates to:
  /// **'Crocodile'**
  String get animalCrocodile;

  /// No description provided for @animalPony.
  ///
  /// In en, this message translates to:
  /// **'Pony'**
  String get animalPony;

  /// No description provided for @animalChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get animalChicken;

  /// No description provided for @chooseAnimal.
  ///
  /// In en, this message translates to:
  /// **'Choose your animal'**
  String get chooseAnimal;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @recentTimers.
  ///
  /// In en, this message translates to:
  /// **'RECENT TIMERS'**
  String get recentTimers;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @hourUnit.
  ///
  /// In en, this message translates to:
  /// **'h '**
  String get hourUnit;

  /// No description provided for @minuteUnit.
  ///
  /// In en, this message translates to:
  /// **'m '**
  String get minuteUnit;

  /// No description provided for @secondUnit.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondUnit;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get finished;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @settingsTimer.
  ///
  /// In en, this message translates to:
  /// **'TIMER'**
  String get settingsTimer;

  /// No description provided for @showNumbers.
  ///
  /// In en, this message translates to:
  /// **'Show numbers'**
  String get showNumbers;

  /// No description provided for @ambientSound.
  ///
  /// In en, this message translates to:
  /// **'Timer sound'**
  String get ambientSound;

  /// No description provided for @ambientSoundSub.
  ///
  /// In en, this message translates to:
  /// **'Music during countdown'**
  String get ambientSoundSub;

  /// No description provided for @endSound.
  ///
  /// In en, this message translates to:
  /// **'End sound'**
  String get endSound;

  /// No description provided for @endSoundSub.
  ///
  /// In en, this message translates to:
  /// **'Sound when timer ends'**
  String get endSoundSub;

  /// No description provided for @randomAnimalMode.
  ///
  /// In en, this message translates to:
  /// **'Random animal'**
  String get randomAnimalMode;

  /// No description provided for @randomAnimalModeSub.
  ///
  /// In en, this message translates to:
  /// **'Picks a random unlocked animal each time you start the timer'**
  String get randomAnimalModeSub;

  /// No description provided for @settingsInfo.
  ///
  /// In en, this message translates to:
  /// **'INFORMATION'**
  String get settingsInfo;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @searchingPurchases.
  ///
  /// In en, this message translates to:
  /// **'Searching for purchases...'**
  String get searchingPurchases;

  /// No description provided for @policyIntro.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get policyIntro;

  /// No description provided for @policyIntroContent.
  ///
  /// In en, this message translates to:
  /// **'AnimalTimer is a visual timer application designed for children. Protecting privacy is a top priority.'**
  String get policyIntroContent;

  /// No description provided for @policyData.
  ///
  /// In en, this message translates to:
  /// **'Data collected'**
  String get policyData;

  /// No description provided for @policyDataContent.
  ///
  /// In en, this message translates to:
  /// **'AnimalTimer does not directly collect or store personal data.\n\nHowever, the app uses third-party services (such as Google AdMob) that may collect certain technical information, including:\n• IP address\n• device type\n• anonymous usage data\n\nThis data is used solely to ensure proper app functionality and to display child-appropriate advertisements.'**
  String get policyDataContent;

  /// No description provided for @policyAds.
  ///
  /// In en, this message translates to:
  /// **'Advertising'**
  String get policyAds;

  /// No description provided for @policyAdsContent.
  ///
  /// In en, this message translates to:
  /// **'The app may display ads via Google AdMob to unlock content (e.g., new animals).\n\nThese ads are configured to:\n• be suitable for children\n• comply with COPPA (Children\'s Online Privacy Protection Act)\n• not use behavioral or personalized advertising'**
  String get policyAdsContent;

  /// No description provided for @policyIAP.
  ///
  /// In en, this message translates to:
  /// **'In-App Purchases'**
  String get policyIAP;

  /// No description provided for @policyIAPContent.
  ///
  /// In en, this message translates to:
  /// **'The app offers an optional one-time purchase to unlock all animals.\n\nPayments are handled securely by Google Play or the App Store and are protected by parental controls.'**
  String get policyIAPContent;

  /// No description provided for @policyCOPPA.
  ///
  /// In en, this message translates to:
  /// **'COPPA Compliance'**
  String get policyCOPPA;

  /// No description provided for @policyCOPPAContent.
  ///
  /// In en, this message translates to:
  /// **'AnimalTimer complies with COPPA. The app does not knowingly collect personal data from children under 13.'**
  String get policyCOPPAContent;

  /// No description provided for @policyContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get policyContact;

  /// No description provided for @policyContactContent.
  ///
  /// In en, this message translates to:
  /// **'For any questions regarding this Privacy Policy:\npapadrien.prepa@gmail.com'**
  String get policyContactContent;

  /// No description provided for @policyThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get policyThirdParty;

  /// No description provided for @policyThirdPartyContent.
  ///
  /// In en, this message translates to:
  /// **'The app uses the following services:\n• Google AdMob (advertising)\n\nMore information:\nhttps://policies.google.com/privacy'**
  String get policyThirdPartyContent;

  /// No description provided for @policyGDPR.
  ///
  /// In en, this message translates to:
  /// **'User Rights (GDPR)'**
  String get policyGDPR;

  /// No description provided for @policyGDPRContent.
  ///
  /// In en, this message translates to:
  /// **'Under the General Data Protection Regulation (GDPR), you have the following rights:\n• Right of access\n• Right to rectification\n• Right to deletion\n• Right to restriction of processing\n\nTo exercise your rights:\npapadrien.prepa@gmail.com'**
  String get policyGDPRContent;

  /// No description provided for @policyUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get policyUpdate;

  /// No description provided for @policyUpdateContent.
  ///
  /// In en, this message translates to:
  /// **'Last updated: April 2026'**
  String get policyUpdateContent;

  /// No description provided for @rewardedAdTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewarded Ad'**
  String get rewardedAdTitle;

  /// No description provided for @watchAdToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad video to unlock {animalName}'**
  String watchAdToUnlock(String animalName);

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watchAd;

  /// No description provided for @adLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading video…'**
  String get adLoading;

  /// No description provided for @animalUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{animalName} is unlocked! 🎉'**
  String animalUnlocked(String animalName);

  /// No description provided for @unlockAllButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock all'**
  String get unlockAllButton;

  /// No description provided for @unlockAllButtonWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Unlock all – {price}'**
  String unlockAllButtonWithPrice(String price);

  /// No description provided for @adBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'AD'**
  String get adBadgeLabel;

  /// No description provided for @unlockAllSuccess.
  ///
  /// In en, this message translates to:
  /// **'All animals are unlocked! 🎉'**
  String get unlockAllSuccess;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseError;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored!'**
  String get restoreSuccess;

  /// No description provided for @restoreEmpty.
  ///
  /// In en, this message translates to:
  /// **'No purchases found.'**
  String get restoreEmpty;

  /// No description provided for @storeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Store not available. Check your connection.'**
  String get storeNotAvailable;

  /// No description provided for @purchaseDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock all'**
  String get purchaseDialogTitle;

  /// No description provided for @purchaseDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock all current and future animals, forever!'**
  String get purchaseDialogBody;

  /// No description provided for @purchaseDialogOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase, no subscription.'**
  String get purchaseDialogOneTime;

  /// No description provided for @purchaseDialogBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy — {price}'**
  String purchaseDialogBuy(String price);

  /// No description provided for @unlockAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock {animalName}'**
  String unlockAnimalTitle(String animalName);

  /// No description provided for @animalShark.
  ///
  /// In en, this message translates to:
  /// **'Shark'**
  String get animalShark;

  /// No description provided for @animalUnicorn.
  ///
  /// In en, this message translates to:
  /// **'Unicorn'**
  String get animalUnicorn;

  /// No description provided for @animalTurtle.
  ///
  /// In en, this message translates to:
  /// **'Turtle'**
  String get animalTurtle;

  /// No description provided for @animalGiraffe.
  ///
  /// In en, this message translates to:
  /// **'Giraffe'**
  String get animalGiraffe;

  /// No description provided for @animalSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get animalSheep;

  /// No description provided for @animalDragon.
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get animalDragon;

  /// No description provided for @cancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel the timer?'**
  String get cancelConfirmTitle;

  /// No description provided for @cancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The timer will be stopped and you will return to the home screen.'**
  String get cancelConfirmBody;

  /// No description provided for @continueTimer.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
