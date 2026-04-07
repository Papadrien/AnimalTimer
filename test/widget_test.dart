import 'package:flutter_test/flutter_test.dart';
import 'package:animal_timer/core/utils/time_formatter.dart';
import 'package:animal_timer/data/models/app_settings.dart';
import 'package:animal_timer/data/models/timer_preset.dart';

void main() {
  group('TimeFormatter', () {
    test('formats hours and minutes', () {
      expect(TimeFormatter.formatDuration(const Duration(hours: 1, minutes: 30)), '1h 30m');
    });
    test('formats minutes and seconds', () {
      expect(TimeFormatter.formatDuration(const Duration(minutes: 2, seconds: 10)), '2m 10s');
    });
    test('formats seconds only', () {
      expect(TimeFormatter.formatDuration(const Duration(seconds: 45)), '45s');
    });
    test('pad2 pads single digit', () {
      expect(TimeFormatter.pad2(5), '05');
      expect(TimeFormatter.pad2(12), '12');
    });
  });

  group('AppSettings', () {
    test('default values', () {
      const s = AppSettings();
      expect(s.showNumbers, true);
      expect(s.showAnimal, true);
      expect(s.tickTockSound, true);
      expect(s.volume, 0.7);
    });
    test('copyWith works', () {
      const s = AppSettings();
      final s2 = s.copyWith(showNumbers: false);
      expect(s2.showNumbers, false);
      expect(s2.showAnimal, true);
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
    test('formatted duration', () {
      final p = TimerPreset(
        id: '1', name: 'Test', duration: const Duration(minutes: 2, seconds: 10),
        animalId: 'duck', createdAt: DateTime.now());
      expect(p.formattedDuration, '2m 10s');
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
