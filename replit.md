# AnimalTimer

A visual timer app for children aged 3-8, featuring animal companions, animations, and ambient sounds to make time more engaging for kids.

## Tech Stack

- **Framework**: Flutter (Dart) - runs as a Flutter Web app in Replit
- **State Management**: Riverpod
- **Storage**: Hive + SharedPreferences
- **Audio**: just_audio
- **Animations**: Lottie + flutter_animate
- **Code Generation**: Freezed, json_serializable, riverpod_generator

## Project Structure

```
lib/
├── app.dart              # Root widget
├── main.dart             # Entry point
├── core/
│   ├── constants/        # App-wide constants
│   ├── theme/            # Colors and theming
│   └── utils/            # Helper utilities
└── features/timer/
    ├── data/             # Repositories (Hive/SharedPrefs)
    ├── domain/           # Data models (AnimalModel, TimerState)
    └── presentation/
        ├── providers/    # Riverpod state notifiers
        ├── screens/      # Home, Timer, Settings screens
        └── widgets/      # Reusable UI components

assets/
├── animations/           # Lottie JSON animation files
├── audio/                # MP3 ambient & timer sounds
├── config/               # animals.json configuration
├── fonts/                # Nunito font family
└── images/               # Animal images
```

## Running the App

The workflow builds the Flutter web app and serves it on port 5000:
```bash
bash run.sh
```

This runs `flutter build web --release` then serves `build/web/` via Python HTTP server.

## Development Notes

- **Asset placeholders**: The repo does not include actual Lottie animation files, MP3 audio, or real Nunito fonts. Placeholder stubs were created for the web build to succeed. Replace them with real assets for full functionality.
- **Haptic feedback**: The `haptic_feedback` package was replaced with Flutter's built-in `HapticFeedback` from `services.dart` to support web builds (mobile-only package).
- **Web compatibility**: The `animate:` parameter in `timer_screen.dart` was corrected to `enableBreathing:` to match the `AnimalWidget` API.

## Deployment

Configured as a static site deployment:
- **Build**: `flutter build web --release`
- **Public Dir**: `build/web`
