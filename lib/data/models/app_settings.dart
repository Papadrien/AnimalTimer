class AppSettings {
  final bool showNumbers;
  final bool ambientSoundEnabled;
  final bool endSoundEnabled;
  final double volume;

  const AppSettings({
    this.showNumbers = true,
    this.ambientSoundEnabled = true,
    this.endSoundEnabled = true,
    this.volume = 0.7,
  });

  AppSettings copyWith({
    bool? showNumbers,
    bool? ambientSoundEnabled,
    bool? endSoundEnabled,
    double? volume,
  }) {
    return AppSettings(
      showNumbers: showNumbers ?? this.showNumbers,
      ambientSoundEnabled: ambientSoundEnabled ?? this.ambientSoundEnabled,
      endSoundEnabled: endSoundEnabled ?? this.endSoundEnabled,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() => {
    'show_numbers': showNumbers,
    'ambient_sound_enabled': ambientSoundEnabled,
    'end_sound_enabled': endSoundEnabled,
    'volume': volume,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    showNumbers: json['show_numbers'] ?? true,
    // Backward compat: old 'sound_enabled' / 'tick_tock_sound' maps to both
    ambientSoundEnabled: json['ambient_sound_enabled']
        ?? json['sound_enabled'] ?? json['tick_tock_sound'] ?? true,
    endSoundEnabled: json['end_sound_enabled']
        ?? json['sound_enabled'] ?? true,
    volume: (json['volume'] ?? 0.7).toDouble(),
  );
}
