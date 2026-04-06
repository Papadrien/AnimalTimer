// lib/features/timer/domain/models/animal_model.dart

import 'package:flutter/material.dart';

/// Modèle d'un animal compagnon.
/// Chargé depuis assets/config/animals.json — extensible sans toucher au code.
class AnimalModel {
  const AnimalModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.lottiePath,
    required this.imagePath,
    required this.audioPath,
    this.primaryColor   = const Color(0xFFFDD835),
    this.secondaryColor = const Color(0xFFFF8F00),
  });

  final String id;
  final String name;
  final String emoji;
  final String lottiePath;
  final String imagePath;
  final String audioPath;
  final Color  primaryColor;
  final Color  secondaryColor;

  factory AnimalModel.fromJson(Map<String, dynamic> json) => AnimalModel(
        id:             json['id']          as String,
        name:           json['name']        as String,
        emoji:          json['emoji']       as String,
        lottiePath:     json['lottiePath']  as String,
        imagePath:      json['imagePath']   as String,
        audioPath:      json['audioPath']   as String,
        primaryColor:   Color(json['primaryColor']   as int),
        secondaryColor: Color(json['secondaryColor'] as int),
      );
}

// ─────────────────────────────────────────────────────────────────────────────

/// Configuration d'un timer (durée + animal choisi).
/// Sauvegardé pour la section "Récents".
class TimerConfig {
  const TimerConfig({
    required this.duration,
    required this.animalId,
    this.lastUsed,
  });

  final Duration  duration;
  final String    animalId;
  final DateTime? lastUsed;

  String get formattedDuration {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (duration.inHours > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  Map<String, dynamic> toJson() => {
        'durationSeconds': duration.inSeconds,
        'animalId':        animalId,
        'lastUsed':        lastUsed?.toIso8601String(),
      };

  factory TimerConfig.fromJson(Map<String, dynamic> json) => TimerConfig(
        duration: Duration(seconds: json['durationSeconds'] as int),
        animalId: json['animalId']  as String,
        lastUsed: json['lastUsed'] != null
            ? DateTime.parse(json['lastUsed'] as String)
            : null,
      );
}

// ─────────────────────────────────────────────────────────────────────────────

enum TimerStatus { idle, running, paused, finished }

/// État courant du timer — immuable, mis à jour par le Notifier.
class TimerState {
  const TimerState({
    this.status        = TimerStatus.idle,
    this.totalDuration = Duration.zero,
    this.remaining     = Duration.zero,
    this.animalId,
    this.startTime,
    this.endTime,
    this.pausedAt,
    this.pausedElapsed = Duration.zero,
  });

  final TimerStatus status;
  final Duration    totalDuration;
  final Duration    remaining;
  final String?     animalId;
  final DateTime?   startTime;
  final DateTime?   endTime;
  final DateTime?   pausedAt;
  final Duration    pausedElapsed;

  // ── Dérivés ───────────────────────────────────────────────────────────────

  /// 1.0 = plein (début), 0.0 = vide (fin)
  double get progress {
    if (totalDuration == Duration.zero) return 1.0;
    final ratio = remaining.inMilliseconds / totalDuration.inMilliseconds;
    return ratio.clamp(0.0, 1.0);
  }

  bool get isRunning  => status == TimerStatus.running;
  bool get isPaused   => status == TimerStatus.paused;
  bool get isFinished => status == TimerStatus.finished;
  bool get isIdle     => status == TimerStatus.idle;
  bool get isActive   => isRunning || isPaused;

  // ── copyWith manuel (sans freezed pour simplifier la compile) ─────────────
  TimerState copyWith({
    TimerStatus? status,
    Duration?    totalDuration,
    Duration?    remaining,
    String?      animalId,
    DateTime?    startTime,
    DateTime?    endTime,
    DateTime?    pausedAt,
    Duration?    pausedElapsed,
    bool         clearPausedAt = false,
  }) =>
      TimerState(
        status:        status        ?? this.status,
        totalDuration: totalDuration ?? this.totalDuration,
        remaining:     remaining     ?? this.remaining,
        animalId:      animalId      ?? this.animalId,
        startTime:     startTime     ?? this.startTime,
        endTime:       endTime       ?? this.endTime,
        pausedAt:      clearPausedAt ? null : (pausedAt ?? this.pausedAt),
        pausedElapsed: pausedElapsed ?? this.pausedElapsed,
      );
}
