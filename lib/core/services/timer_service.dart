import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerStatus { idle, running, paused, finished }

class TimerState {
  final Duration totalDuration;
  final Duration remaining;
  final TimerStatus status;
  final double progress;

  const TimerState({
    this.totalDuration = Duration.zero,
    this.remaining = Duration.zero,
    this.status = TimerStatus.idle,
    this.progress = 1.0,
  });

  TimerState copyWith({Duration? totalDuration, Duration? remaining,
      TimerStatus? status, double? progress}) {
    return TimerState(
      totalDuration: totalDuration ?? this.totalDuration,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}

class TimerService extends StateNotifier<TimerState> {
  Timer? _ticker;
  DateTime? _startTime;
  Duration _totalDuration = Duration.zero;
  Duration _elapsedBeforePause = Duration.zero;

  TimerService() : super(const TimerState());

  void start(Duration duration) {
    _totalDuration = duration;
    _elapsedBeforePause = Duration.zero;
    _startTime = DateTime.now();
    state = TimerState(
      totalDuration: duration, remaining: duration,
      status: TimerStatus.running, progress: 1.0);
    _startTicker();
  }

  void pause() {
    if (state.status != TimerStatus.running) return;
    _elapsedBeforePause += DateTime.now().difference(_startTime!);
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resume() {
    if (state.status != TimerStatus.paused) return;
    _startTime = DateTime.now();
    state = state.copyWith(status: TimerStatus.running);
    _startTicker();
  }

  void cancel() {
    _ticker?.cancel();
    _startTime = null;
    _elapsedBeforePause = Duration.zero;
    state = const TimerState(status: TimerStatus.idle);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) => _update());
  }

  void _update() {
    if (_startTime == null) return;
    final elapsed = _elapsedBeforePause + DateTime.now().difference(_startTime!);
    final remaining = _totalDuration - elapsed;
    if (remaining <= Duration.zero) {
      _ticker?.cancel();
      state = TimerState(totalDuration: _totalDuration, remaining: Duration.zero,
        status: TimerStatus.finished, progress: 0.0);
      return;
    }
    state = TimerState(
      totalDuration: _totalDuration, remaining: remaining,
      status: TimerStatus.running,
      progress: (remaining.inMilliseconds / _totalDuration.inMilliseconds).clamp(0.0, 1.0));
  }

  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }
}

final timerServiceProvider = StateNotifierProvider<TimerService, TimerState>(
  (ref) => TimerService());
