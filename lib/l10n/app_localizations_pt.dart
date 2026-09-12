// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'AnimalTimer';

  @override
  String get animalDog => 'Cão';

  @override
  String get animalCat => 'Gato';

  @override
  String get animalCrocodile => 'Crocodilo';

  @override
  String get animalPony => 'Pônei';

  @override
  String get animalChicken => 'Galinha';

  @override
  String get chooseAnimal => 'Escolha seu animal';

  @override
  String get start => 'Iniciar';

  @override
  String get hours => 'Horas';

  @override
  String get minutes => 'Minutos';

  @override
  String get seconds => 'Segundos';

  @override
  String get recentTimers => 'TEMPORIZADORES RECENTES';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resume => 'Retomar';

  @override
  String get pause => 'Pausa';

  @override
  String get hourUnit => 'h ';

  @override
  String get minuteUnit => 'm ';

  @override
  String get secondUnit => 's';

  @override
  String get finished => 'Acabou!';

  @override
  String get stop => 'Parar';

  @override
  String get ok => 'OK';

  @override
  String get settingsTimer => 'TEMPORIZADOR';

  @override
  String get showNumbers => 'Mostrar números';

  @override
  String get ambientSound => 'Som do temporizador';

  @override
  String get ambientSoundSub => 'Música durante a contagem regressiva';

  @override
  String get endSound => 'Som final';

  @override
  String get endSoundSub => 'Som quando o temporizador termina';

  @override
  String get randomAnimalMode => 'Animal aleatório';

  @override
  String get randomAnimalModeSub =>
      'Escolhe aleatoriamente um animal desbloqueado toda vez que você inicia o temporizador';

  @override
  String get settingsInfo => 'INFORMAÇÕES';

  @override
  String get rateApp => 'Avaliar o aplicativo';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get searchingPurchases => 'Procurando compras...';

  @override
  String get policyIntro => 'Introdução';

  @override
  String get policyIntroContent =>
      'AnimalTimer é um aplicativo de temporizador visual projetado para crianças. Proteger a privacidade é uma prioridade máxima.';

  @override
  String get policyData => 'Dados coletados';

  @override
  String get policyDataContent =>
      'AnimalTimer não coleta nem armazena diretamente dados pessoais.\n\nNo entanto, o aplicativo usa serviços de terceiros (como o Google AdMob) que podem coletar algumas informações técnicas, incluindo:\n• endereço IP\n• tipo de dispositivo\n• dados de uso anônimos\n\nEsses dados são usados apenas para garantir o bom funcionamento do aplicativo e exibir anúncios adequados para crianças.';

  @override
  String get policyAds => 'Publicidade';

  @override
  String get policyAdsContent =>
      'O aplicativo pode exibir anúncios via Google AdMob para desbloquear conteúdo (por exemplo, novos animais).\n\nEsses anúncios são configurados para:\n• ser adequados para crianças\n• cumprir a COPPA (Children\'s Online Privacy Protection Act)\n• não usar publicidade comportamental ou personalizada';

  @override
  String get policyIAP => 'Compras no aplicativo';

  @override
  String get policyIAPContent =>
      'O aplicativo oferece uma compra única opcional para desbloquear todos os animais.\n\nOs pagamentos são processados com segurança pela Google Play ou pela App Store e protegidos pelo controle parental do sistema.';

  @override
  String get policyCOPPA => 'Conformidade com a COPPA';

  @override
  String get policyCOPPAContent =>
      'AnimalTimer está em conformidade com a COPPA. O aplicativo não coleta intencionalmente dados pessoais de crianças menores de 13 anos.';

  @override
  String get policyContact => 'Contato';

  @override
  String get policyContactContent =>
      'Para qualquer dúvida sobre esta Política de Privacidade:\npapadrien.prepa@gmail.com';

  @override
  String get policyThirdParty => 'Serviços de terceiros';

  @override
  String get policyThirdPartyContent =>
      'O aplicativo usa os seguintes serviços:\n• Google AdMob (publicidade)\n\nMais informações:\nhttps://policies.google.com/privacy';

  @override
  String get policyGDPR => 'Direitos do usuário (RGPD)';

  @override
  String get policyGDPRContent =>
      'De acordo com o Regulamento Geral sobre a Proteção de Dados (RGPD), você tem os seguintes direitos:\n• Direito de acesso\n• Direito de retificação\n• Direito ao apagamento\n• Direito à limitação do tratamento\n\nPara exercer seus direitos:\npapadrien.prepa@gmail.com';

  @override
  String get policyUpdate => 'Última atualização';

  @override
  String get policyUpdateContent => 'Última atualização: abril de 2026';

  @override
  String get rewardedAdTitle => 'Anúncio recompensado';

  @override
  String get watchAd => 'Assistir';

  @override
  String get watchAdToUnlockAll =>
      'Assista a um vídeo publicitário para desbloquear todos os animais por 12h';

  @override
  String get animalsUnlockedByAdSuccess =>
      'Todos os animais desbloqueados por 12h! 🎉';

  @override
  String get adLoading => 'Carregando vídeo…';

  @override
  String get unlockAllButton => 'Desbloquear tudo';

  @override
  String unlockAllButtonWithPrice(String price) {
    return 'Desbloquear tudo – $price';
  }

  @override
  String get unlockAllByAdButton => 'Desbloquear tudo - anúncio';

  @override
  String get adBadgeLabel => 'ANÚNCIO';

  @override
  String get unlockAllSuccess => 'Todos os animais estão desbloqueados! 🎉';

  @override
  String get purchaseError => 'A compra falhou. Tente novamente.';

  @override
  String get restoreSuccess => 'Compras restauradas!';

  @override
  String get restoreEmpty => 'Nenhuma compra encontrada.';

  @override
  String get storeNotAvailable => 'Loja indisponível. Verifique sua conexão.';

  @override
  String get purchaseDialogTitle => 'Desbloquear tudo';

  @override
  String get purchaseDialogBody =>
      'Desbloqueie todos os animais atuais e futuros, para sempre!';

  @override
  String get purchaseDialogOneTime => 'Compra única, sem assinatura.';

  @override
  String purchaseDialogBuy(String price) {
    return 'Comprar — $price';
  }

  @override
  String unlockAnimalTitle(String animalName) {
    return 'Desbloquear $animalName';
  }

  @override
  String get animalShark => 'Tubarão';

  @override
  String get animalUnicorn => 'Unicórnio';

  @override
  String get animalTurtle => 'Tartaruga';

  @override
  String get animalGiraffe => 'Girafa';

  @override
  String get animalSheep => 'Ovelha';

  @override
  String get animalDragon => 'Dragão';

  @override
  String get animalDiplodocus => 'Diplodocus';

  @override
  String get animalTrex => 'T-Rex';

  @override
  String get cancelConfirmTitle => 'Cancelar o temporizador?';

  @override
  String get cancelConfirmBody =>
      'O temporizador será interrompido e você voltará à tela inicial.';

  @override
  String get continueTimer => 'Continuar';

  @override
  String get animalSwitchHint =>
      'Toque aqui para mudar de animal! Você pode até desbloquear novos temporariamente assistindo a um anúncio.';
}
