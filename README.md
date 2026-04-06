# 🦆 AnimalTimer

> Minuteur visuel et ludique pour enfants (3–8 ans)  
> Flutter · Riverpod · Glassmorphism · CodeMagic CI/CD

---

## ⚡ Démarrage rapide

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Générer le code (freezed + riverpod)
dart run build_runner build --delete-conflicting-outputs

# 3. Lancer en debug
flutter run
```

---

## 🏗 Structure du projet

```
animaltimer/
├── codemagic.yaml              ← CI/CD (5 workflows)
├── pubspec.yaml
├── .gitignore
│
├── lib/
│   ├── main.dart               ← Point d'entrée
│   ├── app.dart                ← MaterialApp + ProviderScope
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart      ← Palettes, dégradés, glassmorphism
│   │   │   └── app_theme.dart       ← ThemeData + TextStyles
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   └── utils/
│   │       └── duration_formatter.dart
│   │
│   └── features/timer/
│       ├── domain/models/
│       │   └── models.dart          ← AnimalModel, TimerConfig, TimerState
│       ├── data/
│       │   └── timer_repository.dart ← SharedPrefs (recents + settings)
│       └── presentation/
│           ├── providers/
│           │   ├── timer_notifier.dart    ← ⭐ Timer robuste (ancre DateTime)
│           │   ├── settings_provider.dart ← AppSettings
│           │   └── animals_provider.dart  ← Chargement JSON
│           ├── screens/
│           │   ├── home_screen.dart       ← Setup (durée + animal)
│           │   ├── timer_screen.dart      ← Minuteur actif
│           │   └── settings_screen.dart   ← Paramètres
│           └── widgets/
│               ├── glass_card.dart
│               ├── gradient_background.dart
│               ├── start_button.dart
│               ├── time_picker_widget.dart
│               ├── progress_ring_painter.dart
│               ├── animal_widget.dart
│               ├── animal_selector.dart
│               └── recent_timers_section.dart
│
├── android/                    ← Config Android native
├── ios/                        ← Config iOS native
└── assets/
    ├── config/animals.json     ← ⭐ Ajouter un animal ici
    ├── animations/             ← Fichiers Lottie (.json)
    ├── audio/                  ← Sons ambiants (.mp3)
    ├── images/                 ← Illustrations (.png)
    └── fonts/                  ← Nunito (.ttf)
```

---

## 🚀 CodeMagic — Configuration

### Variables d'environnement à configurer

Ouvrir **CodeMagic → App Settings → Environment variables** :

#### Android
| Variable | Description |
|----------|-------------|
| `CM_KEYSTORE` | Keystore `.jks` encodé en **base64** |
| `CM_KEYSTORE_PASSWORD` | Mot de passe du keystore |
| `CM_KEY_ALIAS` | Alias de la clé |
| `CM_KEY_PASSWORD` | Mot de passe de la clé |
| `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` | JSON du compte de service Google Play |

#### iOS
| Variable | Description |
|----------|-------------|
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID (App Store Connect → Keys) |
| `APP_STORE_CONNECT_KEY_IDENTIFIER` | Key ID |
| `APP_STORE_CONNECT_PRIVATE_KEY` | Contenu du fichier `.p8` |
| `CERTIFICATE_PRIVATE_KEY` | Clé privée du certificat de distribution |

### Générer le keystore Android
```bash
keytool -genkey -v \
  -keystore animaltimer.jks \
  -alias animaltimer \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# Encoder en base64 pour CodeMagic :
base64 -i animaltimer.jks | pbcopy   # macOS
base64 animaltimer.jks              # Linux
```

### Workflows disponibles

| Workflow | Déclencheur | Sortie |
|----------|-------------|--------|
| `android-debug` | push sur `develop` / `feature/*` | APK debug |
| `android-release` | tag `v*` | AAB signé → Google Play internal |
| `ios-debug` | push sur `develop` | App simulateur |
| `ios-release` | tag `v*` | IPA → TestFlight |
| `release-all` | tag `release/v*` | AAB + IPA simultanés |

### Créer une release
```bash
git tag v1.0.0
git push origin v1.0.0
# → Déclenche android-release + ios-release
```

---

## 🐾 Ajouter un animal

Éditer **uniquement** `assets/config/animals.json` :

```json
{
  "id": "cat",
  "name": "Chat",
  "emoji": "🐱",
  "lottiePath": "assets/animations/cat_idle.json",
  "imagePath": "assets/images/cat.png",
  "audioPath": "assets/audio/cat_ambient.mp3",
  "primaryColor": 4294951115,
  "secondaryColor": 4294927549,
  "theme": {
    "gradientStart": "#FFB6C1",
    "gradientEnd": "#FF69B4"
  }
}
```

> ✅ Aucun changement de code Dart nécessaire.

---

## 📱 Assets requis

### Sons (MP3, < 2 Mo, loop-friendly)
```
assets/audio/
├── duck_ambient.mp3   ← Ambiance eau / mare
├── dog_ambient.mp3    ← Ambiance joyeuse douce
├── tick_tock.mp3      ← Battement horloge (optionnel)
└── timer_end.mp3      ← Son de fin (doux, 2–3 s)
```
Source libre recommandée : [freesound.org](https://freesound.org)

### Animations Lottie (JSON)
```
assets/animations/
├── duck_idle.json
└── dog_idle.json
```
Créer sur [lottiefiles.com](https://lottiefiles.com) ou [rive.app](https://rive.app)

### Police Nunito
Télécharger : [fonts.google.com/specimen/Nunito](https://fonts.google.com/specimen/Nunito)
```
assets/fonts/
├── Nunito-Regular.ttf      (400)
├── Nunito-SemiBold.ttf     (600)
├── Nunito-Bold.ttf         (700)
└── Nunito-ExtraBold.ttf    (800)
```

---

## ⏱ Timer robuste — Comment ça marche

```
❌ Compteur décrémental (FRAGILE)
   secondsLeft--  ←  dérive si l'app est suspendue

✅ Ancre temporelle (ROBUSTE)
   endTime = DateTime.now() + duration
   tick toutes les 100ms :
     remaining = endTime - DateTime.now()
   → Toujours exact, même après background / lock / suspend
```

---

## ✅ Checklist avant soumission

- [ ] `flutter pub get` + `build_runner` OK
- [ ] Police Nunito dans `assets/fonts/`
- [ ] Sons MP3 dans `assets/audio/`
- [ ] Animations Lottie dans `assets/animations/`
- [ ] `animals.json` valide (JSON lint)
- [ ] Permissions Android configurées
- [ ] Background modes iOS (`Info.plist`)
- [ ] Test background : app en arrière-plan → timer exact au retour
- [ ] Test lock écran : verrouiller → déverrouiller → timer exact
- [ ] Variables CodeMagic configurées
- [ ] Bundle ID `com.animaltimer.app` partout (Android + iOS)
