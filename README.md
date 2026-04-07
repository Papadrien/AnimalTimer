# AnimalTimer

A premium visual timer for kids (3-8 years old), built with Flutter.

## Features
- Gradient UI with glassmorphism
- Robust background timer (timestamp-based, survives background/lock)
- Animated animals: Duck, Dog (extensible via config)
- Ambient sounds per animal + optional tick-tock
- Recent timers saved locally
- Settings bottom sheet

## Quick Start
```bash
flutter pub get
flutter run
```

## Build
```bash
flutter build apk --release
flutter build appbundle --release
flutter build ios --release --no-codesign
```

## CI/CD
Push to `main` or tag `v*` to trigger GitHub Actions builds.

## Assets Required
- `assets/lottie/` : duck_walking.json, duck_idle.json, dog_walking.json, dog_idle.json
- `assets/audio/`  : ambient_water.mp3, ambient_joyful.mp3, tick_tock.mp3, end_duck.mp3, end_dog.mp3
- `assets/fonts/`  : Nunito-Regular.ttf, Nunito-Bold.ttf, Nunito-ExtraBold.ttf, Nunito-Black.ttf
