// lib/features/timer/presentation/providers/timer_notifier.dart
//
// ⭐ CŒUR — Timer robuste basé sur DateTime.now().
//    Résiste au background, au lock écran et aux suspensions système.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/models/models.dart';
import 'settings_provider.dart';
import '../../../../core/constants/app_constants.dart';

// ── Provider ─────────────────────────────────────────────────────────────────

final timerProvider =
    StateNotifierProvider<TimerNotifier, TimerState>(TimerNotifier.new);

// ── Notifier ─────────────────────────────────────────────────────────────────

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier(this._ref) : super(const TimerState());

  final Ref _ref;

  Timer?       _ticker;
  AudioPlayer? _ambientPlayer;
  AudioPlayer? _tickPlayer;

  static final _tickInterval =
      Duration(milliseconds: AppConstants.tickIntervalMs);

  // ── Démarrage ─────────────────────────────────────────────────────────────

  Future<void> start({
    required Duration duration,
    required String   animalId,
  }) async {
    _stopTicker();
    await _stopAllAudio();

    final now = DateTime.now();
    state = TimerState(
      status:        TimerStatus.running,
      totalDuration: duration,
      remaining:     duration,
      animalId:      animalId,
      startTime:     now,
      endTime:       now.add(duration),
    );

    _startTicker();
    await _startAudio(animalId);
  }

  // ── Pause ──────────────────────────────────────────────────────────────────

  Future<void> pause() async {
    if (!state.isRunning) return;
    _stopTicker();
    await _ambientPlayer?.pause();
    await _tickPlayer?.pause();
    await HapticFeedback.lightImpact();
    state = state.copyWith(
      status:   TimerStatus.paused,
      pausedAt: DateTime.now(),
    );
  }

  // ── Reprise ────────────────────────────────────────────────────────────────

  Future<void> resume() async {
    if (!state.isPaused || state.pausedAt == null) return;

    // Décaler endTime de la durée de la pause → ancre temporelle toujours juste
    final pauseDuration = DateTime.now().difference(state.pausedAt!);
    final newEnd        = state.endTime!.add(pauseDuration);

    await HapticFeedback.lightImpact();
    state = state.copyWith(
      status:        TimerStatus.running,
      endTime:       newEnd,
      pausedElapsed: state.pausedElapsed + pauseDuration,
      clearPausedAt: true,
    );

    _startTicker();
    await _ambientPlayer?.play();
    await _tickPlayer?.play();
  }

  // ── Annulation ────────────────────────────────────────────────────────────

  Future<void> cancel() async {
    _stopTicker();
    await _stopAllAudio();
    state = const TimerState();
  }

  // ── Tick interne ──────────────────────────────────────────────────────────

  void _startTicker() {
    _ticker = Timer.periodic(_tickInterval, (_) => _tick());
  }

  void _tick() {
    if (!state.isRunning || state.endTime == null) return;

    final remaining = state.endTime!.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _onFinished();
    } else {
      state = state.copyWith(remaining: remaining);
    }
  }

  // ── Fin ───────────────────────────────────────────────────────────────────

  Future<void> _onFinished() async {
    _stopTicker();
    await _stopAllAudio();

    state = state.copyWith(
      status:    TimerStatus.finished,
      remaining: Duration.zero,
    );

    await _playEndSound();
    await HapticFeedback.heavyImpact();

    // Retour auto à l'état idle après le délai configuré
    Future.delayed(
      const Duration(seconds: AppConstants.finishDelayS),
      () { if (state.isFinished) state = const TimerState(); },
    );
  }

  // ── Audio ─────────────────────────────────────────────────────────────────

  Future<void> _startAudio(String animalId) async {
    final settings = _ref.read(settingsProvider);

    // Son ambiant de l'animal
    if (settings.animalSoundEnabled) {
      _ambientPlayer = AudioPlayer();
      try {
        await _ambientPlayer!.setAsset(_audioPathForAnimal(animalId));
        await _ambientPlayer!.setLoopMode(LoopMode.all);
        await _ambientPlayer!.setVolume(settings.volume);
        await _ambientPlayer!.play();
      } catch (e) {
        debugPrint('[AnimalTimer] Ambient audio error: $e');
      }
    }

    // Tick-tock (optionnel)
    if (settings.tickTockEnabled) {
      _tickPlayer = AudioPlayer();
      try {
        await _tickPlayer!.setAsset(AppConstants.audioTickTock);
        await _tickPlayer!.setLoopMode(LoopMode.all);
        await _tickPlayer!.setVolume(settings.volume * AppConstants.tickVolume);
        await _tickPlayer!.play();
      } catch (e) {
        debugPrint('[AnimalTimer] Tick audio error: $e');
      }
    }
  }

  Future<void> _stopAllAudio() async {
    await _ambientPlayer?.stop();
    await _tickPlayer?.stop();
    await _ambientPlayer?.dispose();
    await _tickPlayer?.dispose();
    _ambientPlayer = null;
    _tickPlayer    = null;
  }

  Future<void> _playEndSound() async {
    final end = AudioPlayer();
    try {
      await end.setAsset(AppConstants.audioTimerEnd);
      await end.play();
      end.playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed) end.dispose();
      });
    } catch (e) {
      debugPrint('[AnimalTimer] End sound error: $e');
      end.dispose();
    }
  }

  String _audioPathForAnimal(String id) {
    switch (id) {
      case 'duck': return 'assets/audio/duck_ambient.mp3';
      case 'dog':  return 'assets/audio/dog_ambient.mp3';
      default:     return 'assets/audio/duck_ambient.mp3';
    }
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    _ambientPlayer?.dispose();
    _tickPlayer?.dispose();
    super.dispose();
  }
}
