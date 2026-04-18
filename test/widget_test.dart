import 'package:flutter_test/flutter_test.dart';
import 'package:animal_timer/data/models/app_settings.dart';
import 'package:animal_timer/data/models/timer_preset.dart';

void main() {
  group('AppSettings', () {
    test('default values', () {
      const s = AppSettings();
      expect(s.showNumbers, true);
      expect(s.ambientSoundEnabled, true);
      expect(s.endSoundEnabled, true);
      expect(s.volume, 0.7);
    });
    test('copyWith works', () {
      const s = AppSettings();
      final s2 = s.copyWith(showNumbers: false);
      expect(s2.showNumbers, false);
      expect(s2.ambientSoundEnabled, true);
    });
    test('json round-trip', () {
      const s = AppSettings(showNumbers: false, volume: 0.5);
      final json = s.toJson();
      final s2 = AppSettings.fromJson(json);
      expect(s2.showNumbers, false);
      expect(s2.volume, 0.5);
    });
  });

  group('TimerPreset', () {
    test('formatted duration with minutes and seconds', () {
      final p = TimerPreset(
        id: '1', name: 'Test', duration: const Duration(minutes: 2, seconds: 10),
        animalId: 'dog', createdAt: DateTime.now());
      expect(p.formattedDuration, '2m 10s');
    });
    test('formatted duration hours', () {
      final p = TimerPreset(
        id: '2', name: 'Test', duration: const Duration(hours: 1, minutes: 30),
        animalId: 'cat', createdAt: DateTime.now());
      expect(p.formattedDuration, '1h 30m');
    });
    test('formatted duration seconds only', () {
      final p = TimerPreset(
        id: '3', name: 'Test', duration: const Duration(seconds: 45),
        animalId: 'dog', createdAt: DateTime.now());
      expect(p.formattedDuration, '45s');
    });
    test('json round-trip', () {
      final p = TimerPreset(
        id: 'abc', name: 'Timer 1', duration: const Duration(minutes: 5),
        animalId: 'dog', createdAt: DateTime(2026, 1, 1));
      final json = p.toJson();
      final p2 = TimerPreset.fromJson(json);
      expect(p2.id, 'abc');
      expect(p2.name, 'Timer 1');
      expect(p2.duration.inMinutes, 5);
      expect(p2.animalId, 'dog');
    });
  });
}
