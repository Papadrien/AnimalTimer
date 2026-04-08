class AppSettings {
  final bool showNumbers;
  final bool showAnimal;
  final bool tickTockSound;
  final double volume;

  const AppSettings({
    this.showNumbers = true,
    this.showAnimal = true,
    this.tickTockSound = true,
    this.volume = 0.7,
  });

  AppSettings copyWith({bool? showNumbers, bool? showAnimal,
      bool? tickTockSound, double? volume}) {
    return AppSettings(
      showNumbers: showNumbers ?? this.showNumbers,
      showAnimal: showAnimal ?? this.showAnimal,
      tickTockSound: tickTockSound ?? this.tickTockSound,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() => {
    'show_numbers': showNumbers,
    'show_animal': showAnimal,
    'tick_tock_sound': tickTockSound,
    'volume': volume,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    showNumbers: json['show_numbers'] ?? true,
    showAnimal: json['show_animal'] ?? true,
    tickTockSound: json['tick_tock_sound'] ?? true,
    volume: (json['volume'] ?? 0.7).toDouble(),
  );
}
