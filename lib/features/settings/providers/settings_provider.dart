import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void load(AppSettings settings) => state = settings;
  void toggleShowNumbers() => state = state.copyWith(showNumbers: !state.showNumbers);
  void toggleShowAnimal() => state = state.copyWith(showAnimal: !state.showAnimal);
  void toggleTickTock() => state = state.copyWith(tickTockSound: !state.tickTockSound);
  void setVolume(double v) => state = state.copyWith(volume: v);
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier());
