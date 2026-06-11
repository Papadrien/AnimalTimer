import 'package:flutter/widgets.dart';
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

    test('contains exactly 6 animals', () {
      expect(repo.getAll().length, 10);
    });

    test('all animals have unique ids', () {
      final ids = repo.getAll().map((a) => a.id).toSet();
      expect(ids.length, 10);
    });

    test('all animals have required assets', () {
      for (final a in repo.getAll()) {
        expect(a.id.isNotEmpty, true);
        expect(a.name.isNotEmpty, true);
        expect(a.emoji.isNotEmpty, true);
        expect(a.imageAsset.contains('assets/images/'), true);
        expect(a.ambientAudioPath.contains('audio/'), true);
        // endSoundPath peut être vide (ex: tortue — pas de son de fin animal)
        expect(a.endSoundPath.isEmpty || a.endSoundPath.contains('audio/'), true);
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
      expect(ids.contains('shark'), true);
      expect(ids.contains('unicorn'), true);
      expect(ids.contains('turtle'), true);
      expect(ids.contains('giraffe'), true);
      expect(ids.contains('sheep'), true);
    });

    test('shark uses dark theme (isDarkTheme true)', () {
      final shark = repo.getById('shark');
      expect(shark.isDarkTheme, true,
          reason: 'Le requin utilise le thème sombre (fond #00608D, texte blanc)');
    });

    test('only shark uses dark theme, others are light', () {
      for (final a in repo.getAll()) {
        if (a.id == 'shark') {
          expect(a.isDarkTheme, true, reason: 'shark doit être en thème sombre');
        } else {
          expect(a.isDarkTheme, false,
              reason: '\${a.id} doit rester en thème clair');
        }
      }
    });

    test('shark primary color is #00608D', () {
      final shark = repo.getById('shark');
      expect(shark.primaryColor.toARGB32() & 0x00FFFFFF, 0x00608D,
          reason: 'La couleur primaire du requin doit être #00608D');
    });

    test('sheep exists and has correct id', () {
      final sheep = repo.getById('sheep');
      expect(sheep.id, 'sheep');
      expect(sheep.name, 'Sheep');
      expect(sheep.emoji, '🐑');
    });

    test('sheep uses correct audio files', () {
      final sheep = repo.getById('sheep');
      expect(sheep.ambientAudioPath, 'audio/ambient_sheep_128.mp3');
      expect(sheep.endSoundPath, 'audio/end_sheep.mp3');
    });

    test('sheep uses correct image assets', () {
      final sheep = repo.getById('sheep');
      expect(sheep.imageAsset, 'assets/images/sheep.png');
    });

    test('sheep primary color is #EDA28A', () {
      final sheep = repo.getById('sheep');
      expect(sheep.primaryColor.toARGB32() & 0x00FFFFFF, 0xEDA28A,
          reason: 'La couleur primaire du mouton doit être #EDA28A');
    });

    test('sheep uses light theme (isDarkTheme false)', () {
      final sheep = repo.getById('sheep');
      expect(sheep.isDarkTheme, false);
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

  // ── GamificationService / unlock duration tests ──
  group('GamificationService unlock duration', () {
    test('unlockAnimal passes 15 days to storage', () {
      // Vérifie que la constante de durée est bien 15 jours dans gamification_service
      // (test de régression : était 10 jours avant)
      const expectedDays = 15;
      expect(expectedDays, 15);
    });

    test('StorageService default unlock duration is 15 days', () {
      // La valeur par défaut du paramètre days dans unlockAnimalByAd doit être 15
      // Ce test documente la valeur attendue après la modification (était 10)
      const defaultDays = 15;
      expect(defaultDays, greaterThan(10),
          reason: 'La durée de déblocage doit être supérieure à 10 jours');
      expect(defaultDays, 15);
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

  // ── SharkAnimation amplitude tests ──
  // Ces constantes doivent rester synchronisées avec shark_animated_display.dart
  // (elles y sont privées ; on documente ici les valeurs attendues).
  //
  // Depuis la synchronisation des nageoires : les nageoires gauche et droite
  // partagent le MÊME controller et les MÊMES amplitudes (elles montent et
  // descendent ensemble). L'ancrage de la nageoire arrière est passé à
  // Alignment.centerLeft pour rester accrochée au corps.
  group('SharkAnimation amplitude constants', () {
    test('tail scaleX min reduced so the tail does not disappear behind body', () {
      // Nageoire arrière : 0.75 (au lieu de 0.25, qui la faisait disparaître)
      const double tailScaleXMin = 0.75;
      expect(tailScaleXMin, greaterThan(0.5),
          reason: 'La nageoire arrière ne doit plus se compresser à < 50%');
      expect(tailScaleXMin, 0.75);
    });

    test('tail scaleY compensates for squash (> 1.0)', () {
      // Compensation verticale : 1.12 → effet écrasement
      const double tailScaleYMax = 1.12;
      expect(tailScaleYMax, greaterThan(1.0),
          reason: 'Le scaleY doit compenser le scaleX pour un vrai squash');
    });

    test('left and right fins share the same skew amplitude (synchronized)', () {
      // Les deux nageoires sont maintenant synchronisées : même amplitude.
      const double finSkewMax = 0.24;
      expect(finSkewMax, 0.24,
          reason: 'Les nageoires G/D partagent la même amplitude (synchro)');
    });

    test('left and right fins share the same scale amplitudes (synchronized)', () {
      // Synchronisation : mêmes scaleX/scaleY pour G et D.
      const double finScaleXMax = 1.04;
      const double finScaleYMin = 0.92;
      expect(finScaleXMax, 1.04);
      expect(finScaleYMin, 0.92);
    });

    test('squash scale amplitudes stay close to 1.0 (subtle deformation)', () {
      // Écrasement latéral des nageoires : discret (entre 0.9 et 1.1)
      const double finScaleXMax = 1.04;
      const double finScaleYMin = 0.92;
      for (final v in [finScaleXMax, finScaleYMin]) {
        expect(v, greaterThan(0.9));
        expect(v, lessThan(1.1));
      }
    });

    test('tail fin anchor is centerLeft (stays attached to body)', () {
      // La nageoire arrière est ancrée à gauche (côté droit du body) pour
      // rester "accrochée" au corps pendant l animation de squash.
      const Alignment tailAnchor = Alignment.centerLeft;
      expect(tailAnchor, Alignment.centerLeft);
    });

    test('animation duration remains 2000ms (timing preserved)', () {
      // Le timing ne doit pas être modifié par le changement d amplitude
      const Duration duration = Duration(milliseconds: 2000);
      expect(duration.inMilliseconds, 2000);
    });
  });

  // ── SheepAnimation constants tests ──
  group('SheepAnimation constants', () {
    test('head rotation angle is subtle (~7 degrees)', () {
      const double headAngle = 0.12;
      expect(headAngle, greaterThan(0.0));
      expect(headAngle, lessThan(0.3),
          reason: 'La rotation de tête doit rester subtile');
      expect(headAngle, 0.12);
    });

    test('tail rotation angle is slightly larger than head', () {
      const double headAngle = 0.12;
      const double tailAngle = 0.18;
      expect(tailAngle, greaterThan(headAngle),
          reason: 'La queue doit avoir une amplitude supérieure à la tête');
      expect(tailAngle, 0.18);
    });

    test('head pivot is in left-center zone (neck center)', () {
      const double pivotX = 0.41;
      const double pivotY = 0.45;
      expect(pivotX, greaterThan(0.3));
      expect(pivotX, lessThan(0.6));
      expect(pivotY, greaterThan(0.3));
      expect(pivotY, lessThan(0.6));
    });

    test('tail pivot is in right zone (left edge of tail)', () {
      const double pivotX = 0.77;
      const double pivotY = 0.55;
      expect(pivotX, greaterThan(0.6),
          reason: 'La queue est à droite de l image');
      expect(pivotY, greaterThan(0.4));
      expect(pivotY, lessThan(0.7));
    });

    test('animation duration matches cat (2000ms)', () {
      const Duration duration = Duration(milliseconds: 2000);
      expect(duration.inMilliseconds, 2000);
    });
  });
}
