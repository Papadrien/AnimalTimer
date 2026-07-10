// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'AnimalTimer';

  @override
  String get animalDog => 'Cane';

  @override
  String get animalCat => 'Gatto';

  @override
  String get animalCrocodile => 'Coccodrillo';

  @override
  String get animalPony => 'Pony';

  @override
  String get animalChicken => 'Pulcino';

  @override
  String get chooseAnimal => 'Scegli il tuo animale';

  @override
  String get start => 'Avvia';

  @override
  String get hours => 'Ore';

  @override
  String get minutes => 'Minuti';

  @override
  String get seconds => 'Secondi';

  @override
  String get recentTimers => 'TIMER RECENTI';

  @override
  String get cancel => 'Annulla';

  @override
  String get resume => 'Riprendi';

  @override
  String get pause => 'Pausa';

  @override
  String get hourUnit => 'h ';

  @override
  String get minuteUnit => 'm ';

  @override
  String get secondUnit => 's';

  @override
  String get finished => 'Tempo scaduto!';

  @override
  String get stop => 'Stop';

  @override
  String get ok => 'OK';

  @override
  String get settingsTimer => 'TIMER';

  @override
  String get showNumbers => 'Mostra i numeri';

  @override
  String get ambientSound => 'Suono del timer';

  @override
  String get ambientSoundSub => 'Musica durante il conto alla rovescia';

  @override
  String get endSound => 'Suono finale';

  @override
  String get endSoundSub => 'Suono alla fine del timer';

  @override
  String get randomAnimalMode => 'Animale casuale';

  @override
  String get randomAnimalModeSub =>
      'Sceglie a caso un animale sbloccato a ogni avvio del timer';

  @override
  String get settingsInfo => 'INFORMAZIONI';

  @override
  String get rateApp => 'Valuta l\'app';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get searchingPurchases => 'Ricerca degli acquisti in corso...';

  @override
  String get policyIntro => 'Introduzione';

  @override
  String get policyIntroContent =>
      'AnimalTimer è un\'applicazione di timer visivo pensata per i bambini. La tutela della privacy è la nostra priorità assoluta.';

  @override
  String get policyData => 'Dati raccolti';

  @override
  String get policyDataContent =>
      'AnimalTimer non raccoglie né conserva direttamente dati personali.\n\nTuttavia, l\'app utilizza servizi di terze parti (come Google AdMob) che possono raccogliere alcune informazioni tecniche, tra cui:\n• indirizzo IP\n• tipo di dispositivo\n• dati di utilizzo anonimi\n\nQuesti dati vengono usati esclusivamente per garantire il corretto funzionamento dell\'app e per mostrare pubblicità adatte ai bambini.';

  @override
  String get policyAds => 'Pubblicità';

  @override
  String get policyAdsContent =>
      'L\'app può mostrare annunci tramite Google AdMob per sbloccare contenuti (ad esempio, nuovi animali).\n\nQuesti annunci sono configurati per:\n• essere adatti ai bambini\n• rispettare il COPPA (Children\'s Online Privacy Protection Act)\n• non utilizzare pubblicità comportamentale o personalizzata';

  @override
  String get policyIAP => 'Acquisti in-app';

  @override
  String get policyIAPContent =>
      'L\'app offre un acquisto opzionale una tantum per sbloccare tutti gli animali.\n\nI pagamenti sono gestiti in modo sicuro da Google Play o dall\'App Store e sono protetti dal controllo genitori.';

  @override
  String get policyCOPPA => 'Conformità COPPA';

  @override
  String get policyCOPPAContent =>
      'AnimalTimer rispetta il COPPA. L\'app non raccoglie consapevolmente dati personali di bambini di età inferiore ai 13 anni.';

  @override
  String get policyContact => 'Contatti';

  @override
  String get policyContactContent =>
      'Per qualsiasi domanda su questa Informativa sulla privacy:\npapadrien.prepa@gmail.com';

  @override
  String get policyThirdParty => 'Servizi di terze parti';

  @override
  String get policyThirdPartyContent =>
      'L\'app utilizza i seguenti servizi:\n• Google AdMob (pubblicità)\n\nPer saperne di più:\nhttps://policies.google.com/privacy';

  @override
  String get policyGDPR => 'Diritti dell\'utente (GDPR)';

  @override
  String get policyGDPRContent =>
      'In base al Regolamento generale sulla protezione dei dati (GDPR), hai i seguenti diritti:\n• Diritto di accesso\n• Diritto di rettifica\n• Diritto alla cancellazione\n• Diritto di limitazione del trattamento\n\nPer esercitare i tuoi diritti:\npapadrien.prepa@gmail.com';

  @override
  String get policyUpdate => 'Ultimo aggiornamento';

  @override
  String get policyUpdateContent => 'Ultimo aggiornamento: aprile 2026';

  @override
  String get rewardedAdTitle => 'Video premiato';

  @override
  String watchAdToUnlock(String animalName) {
    return 'Guarda un video pubblicitario per sbloccare $animalName';
  }

  @override
  String get watchAd => 'Guarda';

  @override
  String get adLoading => 'Caricamento video…';

  @override
  String animalUnlocked(String animalName) {
    return '$animalName è stato sbloccato! 🎉';
  }

  @override
  String get unlockAllButton => 'Sblocca tutto';

  @override
  String unlockAllButtonWithPrice(String price) {
    return 'Sblocca tutto – $price';
  }

  @override
  String get adBadgeLabel => 'PUB';

  @override
  String get unlockAllSuccess => 'Tutti gli animali sono stati sbloccati! 🎉';

  @override
  String get purchaseError => 'Acquisto non riuscito. Riprova.';

  @override
  String get restoreSuccess => 'Acquisti ripristinati!';

  @override
  String get restoreEmpty => 'Nessun acquisto trovato.';

  @override
  String get storeNotAvailable =>
      'Store non disponibile. Controlla la tua connessione.';

  @override
  String get purchaseDialogTitle => 'Sblocca tutto';

  @override
  String get purchaseDialogBody =>
      'Sblocca tutti gli animali attuali e futuri, per sempre!';

  @override
  String get purchaseDialogOneTime => 'Acquisto una tantum, nessun abbonamento.';

  @override
  String purchaseDialogBuy(String price) {
    return 'Acquista — $price';
  }

  @override
  String unlockAnimalTitle(String animalName) {
    return 'Sblocca $animalName';
  }

  @override
  String get animalShark => 'Squalo';

  @override
  String get animalUnicorn => 'Unicorno';

  @override
  String get animalTurtle => 'Tartaruga';

  @override
  String get animalGiraffe => 'Giraffa';

  @override
  String get animalSheep => 'Pecora';

  @override
  String get animalDragon => 'Drago';

  @override
  String get cancelConfirmTitle => 'Annullare il timer?';

  @override
  String get cancelConfirmBody =>
      'Il timer verrà interrotto e tornerai alla schermata principale.';

  @override
  String get continueTimer => 'Continua';

  @override
  String get reviewPromptTitle => 'Ti piace AnimalTimer?';

  @override
  String get reviewPromptMessage => 'Una piccola recensione ci aiuterebbe molto a far conoscere l\'app!';

  @override
  String get reviewPromptRate => 'Lascia una recensione';

  @override
  String get reviewPromptLater => 'Più tardi';
}
