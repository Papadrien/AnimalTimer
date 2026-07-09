class AppSettings {
  final bool showNumbers;
  final bool ambientSoundEnabled;
  final bool endSoundEnabled;
  final double volume;
  final bool randomAnimalMode;

  const AppSettings({
    this.showNumbers = true,
    this.ambientSoundEnabled = true,
    this.endSoundEnabled = true,
    this.volume = 0.7,
    this.randomAnimalMode = false,
  });

  AppSettings copyWith({
    bool? showNumbers,
    bool? ambientSoundEnabled,
    bool? endSoundEnabled,
    double? volume,
    bool? randomAnimalMode,
  }) {
    return AppSettings(
      showNumbers: showNumbers ?? this.showNumbers,
      ambientSoundEnabled: ambientSoundEnabled ?? this.ambientSoundEnabled,
      endSoundEnabled: endSoundEnabled ?? this.endSoundEnabled,
      volume: volume ?? this.volume,
      randomAnimalMode: randomAnimalMode ?? this.randomAnimalMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'show_numbers': showNumbers,
    'ambient_sound_enabled': ambientSoundEnabled,
    'end_sound_enabled': endSoundEnabled,
    'volume': volume,
    'random_animal_mode': randomAnimalMode,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    showNumbers: json['show_numbers'] ?? true,
    ambientSoundEnabled: json['ambient_sound_enabled'] ?? true,
    endSoundEnabled: json['end_sound_enabled'] ?? true,
    volume: (json['volume'] ?? 0.7).toDouble(),
    randomAnimalMode: json['random_animal_mode'] ?? false,
  );
}
