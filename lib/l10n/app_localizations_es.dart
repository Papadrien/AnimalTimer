// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'AnimalTimer';

  @override
  String get animalDog => 'Perro';

  @override
  String get animalCat => 'Gato';

  @override
  String get animalCrocodile => 'Cocodrilo';

  @override
  String get animalPony => 'Poni';

  @override
  String get animalChicken => 'Gallina';

  @override
  String get chooseAnimal => 'Elige tu animal';

  @override
  String get start => 'Iniciar';

  @override
  String get hours => 'Horas';

  @override
  String get minutes => 'Minutos';

  @override
  String get seconds => 'Segundos';

  @override
  String get recentTimers => 'TEMPORIZADORES RECIENTES';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resume => 'Reanudar';

  @override
  String get pause => 'Pausa';

  @override
  String get hourUnit => 'h ';

  @override
  String get minuteUnit => 'min ';

  @override
  String get secondUnit => 's';

  @override
  String get finished => '¡Se acabó el tiempo!';

  @override
  String get stop => 'Detener';

  @override
  String get ok => 'OK';

  @override
  String get settingsTimer => 'TEMPORIZADOR';

  @override
  String get showNumbers => 'Mostrar números';

  @override
  String get ambientSound => 'Sonido del temporizador';

  @override
  String get ambientSoundSub => 'Música durante la cuenta regresiva';

  @override
  String get endSound => 'Sonido final';

  @override
  String get endSoundSub => 'Sonido cuando termina el temporizador';

  @override
  String get settingsInfo => 'INFORMACIÓN';

  @override
  String get rateApp => 'Calificar la app';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get searchingPurchases => 'Buscando compras...';

  @override
  String get policyIntro => 'Introducción';

  @override
  String get policyIntroContent =>
      'AnimalTimer es una aplicación de temporizador visual diseñada para niños. Proteger la privacidad es una prioridad.';

  @override
  String get policyData => 'Datos recopilados';

  @override
  String get policyDataContent =>
      'AnimalTimer no recopila ni almacena directamente datos personales.\n\nSin embargo, la app utiliza servicios de terceros (como Google AdMob) que pueden recopilar cierta información técnica, por ejemplo:\n• dirección IP\n• tipo de dispositivo\n• datos anónimos de uso\n\nEstos datos se usan únicamente para asegurar el correcto funcionamiento de la app y mostrar anuncios adecuados para niños.';

  @override
  String get policyAds => 'Anuncios';

  @override
  String get policyAdsContent =>
      'La app puede mostrar anuncios mediante Google AdMob para desbloquear contenido (por ejemplo, nuevos animales).\n\nEstos anuncios están configurados para:\n• ser adecuados para niños\n• cumplir con la ley COPPA (Children\'s Online Privacy Protection Act)\n• no usar publicidad personalizada basada en el comportamiento';

  @override
  String get policyIAP => 'Compras dentro de la app';

  @override
  String get policyIAPContent =>
      'La app ofrece una compra única opcional para desbloquear todos los animales.\n\nLos pagos se gestionan de forma segura mediante Google Play o App Store y están protegidos por los controles parentales del sistema.';

  @override
  String get policyCOPPA => 'Cumplimiento de COPPA';

  @override
  String get policyCOPPAContent =>
      'AnimalTimer cumple con COPPA. La app no recopila intencionalmente datos personales de niños menores de 13 años.';

  @override
  String get policyContact => 'Contacto';

  @override
  String get policyContactContent =>
      'Para cualquier pregunta sobre esta Política de privacidad:\npapadrien.prepa@gmail.com';

  @override
  String get policyThirdParty => 'Servicios de terceros';

  @override
  String get policyThirdPartyContent =>
      'La app utiliza los siguientes servicios:\n• Google AdMob (anuncios)\n\nMás información:\nhttps://policies.google.com/privacy';

  @override
  String get policyGDPR => 'Derechos de los usuarios (RGPD)';

  @override
  String get policyGDPRContent =>
      'Según el Reglamento General de Protección de Datos (RGPD), tienes los siguientes derechos:\n• Derecho de acceso\n• Derecho de rectificación\n• Derecho de eliminación\n• Derecho a limitar el tratamiento\n\nPara ejercer tus derechos:\npapadrien.prepa@gmail.com';

  @override
  String get policyUpdate => 'Última actualización';

  @override
  String get policyUpdateContent => 'Última actualización: abril de 2026';

  @override
  String get rewardedAdTitle => 'Anuncio con recompensa';

  @override
  String watchAdToUnlock(String animalName) {
    return 'Mira un video con anuncio para desbloquear $animalName';
  }

  @override
  String get watchAd => 'Ver';

  @override
  String get adLoading => 'Cargando video…';

  @override
  String animalUnlocked(String animalName) {
    return '¡Ya desbloqueaste $animalName! 🎉';
  }

  @override
  String get unlockAllButton => 'Desbloquear todo';

  @override
  String unlockAllButtonWithPrice(String price) {
    return 'Desbloquear todo – $price';
  }

  @override
  String get adBadgeLabel => 'ANUNCIO';

  @override
  String get unlockAllSuccess => '¡Ya desbloqueaste todos los animales! 🎉';

  @override
  String get purchaseError =>
      'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get restoreSuccess => '¡Compras restauradas!';

  @override
  String get restoreEmpty => 'No se encontraron compras.';

  @override
  String get storeNotAvailable =>
      'La tienda no está disponible. Revisa tu conexión.';

  @override
  String get purchaseDialogTitle => 'Desbloquear todo';

  @override
  String get purchaseDialogBody =>
      'Desbloquea todos los animales actuales y futuros, para siempre.';

  @override
  String get purchaseDialogOneTime => 'Un solo pago, sin suscripción.';

  @override
  String purchaseDialogBuy(String price) {
    return 'Comprar — $price';
  }

  @override
  String unlockAnimalTitle(String animalName) {
    return 'Desbloquear $animalName';
  }

  @override
  String get animalShark => 'Tiburón';

  @override
  String get animalUnicorn => 'Unicornio';

  @override
  String get animalTurtle => 'Tortuga';

  @override
  String get animalGiraffe => 'Jirafa';

  @override
  String get animalSheep => 'Oveja';

  @override
  String get cancelConfirmTitle => '¿Cancelar el temporizador?';

  @override
  String get cancelConfirmBody =>
      'El temporizador se detendrá y volverás a la pantalla de inicio.';

  @override
  String get continueTimer => 'Continuar';
}
