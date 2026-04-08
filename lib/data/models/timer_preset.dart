class TimerPreset {
  final String id;
  final String name;
  final Duration duration;
  final String animalId;
  final DateTime createdAt;

  const TimerPreset({
    required this.id,
    required this.name,
    required this.duration,
    required this.animalId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration_seconds': duration.inSeconds,
    'animal_id': animalId,
    'created_at': createdAt.toIso8601String(),
  };

  factory TimerPreset.fromJson(Map<String, dynamic> json) => TimerPreset(
    id: json['id'],
    name: json['name'],
    duration: Duration(seconds: json['duration_seconds']),
    animalId: json['animal_id'],
    createdAt: DateTime.parse(json['created_at']),
  );

  String get formattedDuration {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0 && s > 0) return '${m}m ${s}s';
    if (m > 0) return '${m}m';
    return '${s}s';
  }
}
