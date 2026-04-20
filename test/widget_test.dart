import 'package:flutter_test/flutter_test.dart';
import 'package:animal_timer/data/models/app_settings.dart';
import 'package:animal_timer/data/models/timer_preset.dart';
import 'package:animal_timer/data/repositories/animal_repository.dart';
import 'package:animal_timer/core/services/timer_service.dart';

void main() {
  // ── AppSettings tests ──
  group('AppSettings', () {
    test('default values', () {
      const s = AppSettings();
      expect(s.showNumbers, true);
      expect(s.ambientSoundEnabled, true);
      expect(s.endSoundEnabled, true);
      expect(s.volume, 0.7);
    });

    test('copyWith preserves unchanged fields', () {
      const s = AppSettings();
      final s2 = s.copyWith(showNumbers: false);
      expect(s2.showNumbers, false);
      expect(s2.ambientSoundEnabled, true);
      expect(s2.endSoundEnabled, true);
      expect(s2.volume, 0.7);
    });

    test('copyWith can change all fields', () {
      const s = AppSettings();
      final s2 = s.copyWith(
        showNumbers: false,
        ambientSoundEnabled: false,
        endSoundEnabled: false,
        volume: 0.3,
      );
      expect(s2.showNumbers, false);
      expect(s2.ambientSoundEnabled, false);
      expect(s2.endSoundEnabled, false);
      expect(s2.volume, 0.3);
    });

    test('toJson produces correct map', () {
      const s = AppSettings(showNumbers: false, volume: 0.5);
      final json = s.toJson();
      expect(json['show_numbers'], false);
      expect(json['volume'], 0.5);
      expect(json['ambient_sound_enabled'], true);
      expect(json['end_sound_enabled'], true);
    });

    test('fromJson restores correctly', () {
      final json = {
        'show_numbers': false,
        'ambient_sound_enabled': false,
        'end_sound_enabled': true,
        'volume': 0.4,
      };
      final s = AppSettings.fromJson(json);
      expect(s.showNumbers, false);
      expect(s.ambientSoundEnabled, false);
      expect(s.endSoundEnabled, true);
      expect(s.volume, 0.4);
    });

    test('fromJson with missing keys uses defaults', () {
      final s = AppSettings.fromJson({});
      expect(s.showNumbers, true);
      expect(s.ambientSoundEnabled, true);
      expect(s.endSoundEnabled, true);
      expect(s.volume, 0.7);
    });

    test('fromJson backward compat with old sound_enabled key', () {
      final s = AppSettings.fromJson({'sound_enabled': false});
      expect(s.ambientSoundEnabled, false);
      expect(s.endSoundEnabled, false);
    });

    test('json round-trip preserves all fields', () {
      const s = AppSettings(
        showNumbers: false,
        ambientSoundEnabled: false,
        endSoundEnabled: false,
        volume: 0.5,
      );
      final s2 = AppSettings.fromJson(s.toJson());
      expect(s2.showNumbers, s.showNumbers);
      expect(s2.ambientSoundEnabled, s.ambientSoundEnabled);
      expect(s2.endSoundEnabled, s.endSoundEnabled);
      expect(s2.volume, s.volume);
    });
  });

  // ── TimerPreset tests ──
  group('TimerPreset', () {
    test('formattedDuration with minutes and seconds', () {
      final p = TimerPreset(
        id: '1', name: 'Test',
        duration: const Duration(minutes: 2, seconds: 10),
        animalId: 'dog', createdAt: DateTime.now());
      expect(p.formattedDuration, '2m 10s');
    });

    test('formattedDuration with hours', () {
      final p = TimerPreset(
        id: '2', name: 'Test',
        duration: const Duration(hours: 1, minutes: 30),
        animalId: 'cat', createdAt: DateTime.now());
      expect(p.formattedDuration, '1h 30m');
    });

    test('formattedDuration seconds only', () {
      final p = TimerPreset(
        id: '3', name: 'Test',
        duration: const Duration(seconds: 45),
        animalId: 'dog', createdAt: DateTime.now());
      expect(p.formattedDuration, '45s');
    });

    test('formattedDuration minutes only (no seconds)', () {
      final p = TimerPreset(
        id: '4', name: 'Test',
        duration: const Duration(minutes: 5),
        animalId: 'dog', createdAt: DateTime.now());
      expect(p.formattedDuration, '5m');
    });

    test('toJson produces correct map', () {
      final p = TimerPreset(
        id: 'abc', name: 'Timer 1',
        duration: const Duration(minutes: 5, seconds: 30),
        animalId: 'cat',
        createdAt: DateTime(2026, 4, 20));
      final json = p.toJson();
      expect(json['id'], 'abc');
      expect(json['name'], 'Timer 1');
      expect(json['duration_seconds'], 330);
      expect(json['animal_id'], 'cat');
      expect(json['created_at'], '2026-04-20T00:00:00.000');
    });

    test('json round-trip preserves all fields', () {
      final p = TimerPreset(
        id: 'xyz', name: 'My Timer',
        duration: const Duration(hours: 1, minutes: 15, seconds: 45),
        animalId: 'pony',
        createdAt: DateTime(2026, 1, 15, 10, 30));
      final p2 = TimerPreset.fromJson(p.toJson());
      expect(p2.id, p.id);
      expect(p2.name, p.name);
      expect(p2.duration, p.duration);
      expect(p2.animalId, p.animalId);
      expect(p2.createdAt, p.createdAt);
    });
  });

  // ── AnimalRepository tests ──
  group('AnimalRepository', () {
    final repo = AnimalRepository();

    test('contains exactly 5 animals', () {
      expect(repo.getAll().length, 5);
    });

    test('all animals have unique ids', () {
      final ids = repo.getAll().map((a) => a.id).toSet();
      expect(ids.length, 5);
    });

    test('all animals have required assets', () {
      for (final a in repo.getAll()) {
        expect(a.id.isNotEmpty, true);
        expect(a.name.isNotEmpty, true);
        expect(a.emoji.isNotEmpty, true);
        expect(a.imageAsset.contains('assets/images/'), true);
        expect(a.ambientAudioPath.contains('audio/'), true);
        expect(a.endSoundPath.contains('audio/'), true);
      }
    });

    test('all animals have custom audio (no default)', () {
      for (final a in repo.getAll()) {
        expect(a.ambientAudioPath.contains('default'), false,
            reason: '${a.id} still uses default ambient');
        expect(a.endSoundPath.contains('default'), false,
            reason: '${a.id} still uses default end sound');
      }
    });

    test('getById returns correct animal', () {
      expect(repo.getById('dog').name, 'Dog');
      expect(repo.getById('cat').name, 'Cat');
      expect(repo.getById('pony').name, 'Pony');
    });

    test('getById with invalid id returns first animal', () {
      final fallback = repo.getById('invalid_id');
      expect(fallback.id, repo.getAll().first.id);
    });

    test('expected animal ids exist', () {
      final ids = repo.getAll().map((a) => a.id).toList();
      expect(ids.contains('dog'), true);
      expect(ids.contains('cat'), true);
      expect(ids.contains('crocodile'), true);
      expect(ids.contains('pony'), true);
      expect(ids.contains('chicken'), true);
    });
  });

  // ── TimerState tests ──
  group('TimerState', () {
    test('default values', () {
      const s = TimerState();
      expect(s.totalDuration, Duration.zero);
      expect(s.remaining, Duration.zero);
      expect(s.status, TimerStatus.idle);
      expect(s.progress, 1.0);
    });

    test('copyWith preserves unchanged fields', () {
      const s = TimerState(
        totalDuration: Duration(minutes: 5),
        remaining: Duration(minutes: 3),
        status: TimerStatus.running,
        progress: 0.6,
      );
      final s2 = s.copyWith(status: TimerStatus.paused);
      expect(s2.totalDuration, const Duration(minutes: 5));
      expect(s2.remaining, const Duration(minutes: 3));
      expect(s2.status, TimerStatus.paused);
      expect(s2.progress, 0.6);
    });
  });

  // ── TimerService logic tests ──
  group('TimerService', () {
    test('start sets correct initial state', () {
      final service = TimerService();
      service.start(const Duration(minutes: 5));
      expect(service.state.status, TimerStatus.running);
      expect(service.state.totalDuration, const Duration(minutes: 5));
      expect(service.state.progress, 1.0);
      service.dispose();
    });

    test('pause changes status', () {
      final service = TimerService();
      service.start(const Duration(minutes: 5));
      service.pause();
      expect(service.state.status, TimerStatus.paused);
      service.dispose();
    });

    test('resume after pause changes status back', () {
      final service = TimerService();
      service.start(const Duration(minutes: 5));
      service.pause();
      service.resume();
      expect(service.state.status, TimerStatus.running);
      service.dispose();
    });

    test('cancel resets to idle', () {
      final service = TimerService();
      service.start(const Duration(minutes: 5));
      service.cancel();
      expect(service.state.status, TimerStatus.idle);
      expect(service.state.totalDuration, Duration.zero);
      service.dispose();
    });

    test('pause when not running does nothing', () {
      final service = TimerService();
      service.start(const Duration(minutes: 5));
      service.cancel();
      service.pause();
      expect(service.state.status, TimerStatus.idle);
      service.dispose();
    });

    test('resume when not paused does nothing', () {
      final service = TimerService();
      service.start(const Duration(minutes: 5));
      service.resume(); // already running
      expect(service.state.status, TimerStatus.running);
      service.dispose();
    });
  });
}
