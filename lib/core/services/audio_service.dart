import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _endPlayer = AudioPlayer();
  final AudioPlayer _finishPlayer = AudioPlayer();
  bool _isAmbientPlaying = false;

  Future<void> playAmbient(String assetPath, {double volume = 0.5}) async {
    try {
      _isAmbientPlaying = true;
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(volume);
      await _ambientPlayer.play(AssetSource(assetPath));
    } catch (_) {
      _isAmbientPlaying = false;
    }
  }

  Future<void> pauseAmbient() async {
    if (_isAmbientPlaying) {
      await _ambientPlayer.pause();
    }
  }

  Future<void> resumeAmbient() async {
    if (_isAmbientPlaying) {
      await _ambientPlayer.resume();
    }
  }

  Future<void> stopAmbient() async {
    _isAmbientPlaying = false;
    await _ambientPlayer.stop();
  }

  /// Joue le son de fin de minuteur (canon à confettis), commun à tous les animaux.
  /// Attend la fin complète du son via onPlayerComplete.
  Future<void> playFinishSoundAndWait({double volume = 0.7}) async {
    try {
      await _finishPlayer.setVolume(volume);
      await _finishPlayer.play(AssetSource('audio/timer_end.mp3'));
      // Attendre la fin réelle du son
      await _finishPlayer.onPlayerComplete.first;
    } catch (_) {
      // Graceful fallback
    }
  }

  Future<void> playEndSound(String assetPath, {double volume = 0.7}) async {
    try {
      await _endPlayer.setVolume(volume);
      await _endPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Graceful fallback
    }
  }

  Future<void> stopAll() async {
    await _ambientPlayer.stop();
    await _endPlayer.stop();
    await _finishPlayer.stop();
    _isAmbientPlaying = false;
  }

  Future<void> setAmbientVolume(double volume) async {
    await _ambientPlayer.setVolume(volume);
  }

  void dispose() {
    _ambientPlayer.dispose();
    _endPlayer.dispose();
    _finishPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
