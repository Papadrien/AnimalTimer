import 'package:flutter/material.dart';
import 'package:animal_timer/l10n/app_localizations.dart';

/// Usage: final l10n = context.l10n;
extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Returns the localized name of an animal given its ID.
String localizedAnimalName(BuildContext context, String animalId) {
  final l10n = AppLocalizations.of(context)!;
  switch (animalId) {
    case 'dog':       return l10n.animalDog;
    case 'cat':       return l10n.animalCat;
    case 'crocodile': return l10n.animalCrocodile;
    case 'pony':      return l10n.animalPony;
    case 'chicken':   return l10n.animalChicken;
    case 'shark':     return l10n.animalShark;
    case 'unicorn':   return l10n.animalUnicorn;
    default:          return animalId;
  }
}
