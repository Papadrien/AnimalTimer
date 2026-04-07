import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _tickPlayer = AudioPlayer();
  final AudioPlayer _endPlayer = AudioPlayer();
  bool _isTickPlaying = false;

  Future<void> playAmbient(String assetPath, {double volume = 0.5}) async {
    try {
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(volume);
      await _ambientPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Graceful fallback if audio asset missing
    }
  }

  Future<void> startTickTock({double volume = 0.3}) async {
    if (_isTickPlaying) return;
    _isTickPlaying = true;
    try {
      await _tickPlayer.setReleaseMode(ReleaseMode.loop);
      await _tickPlayer.setVolume(volume);
      await _tickPlayer.play(AssetSource('audio/tick_tock.wav'));
    } catch (_) {
      _isTickPlaying = false;
    }
  }

  Future<void> stopTickTock() async {
    _isTickPlaying = false;
    await _tickPlayer.stop();
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
    await _tickPlayer.stop();
    await _endPlayer.stop();
    _isTickPlaying = false;
  }

  Future<void> setGlobalVolume(double volume) async {
    await _ambientPlayer.setVolume(volume * 0.5);
    await _tickPlayer.setVolume(volume * 0.3);
  }

  void dispose() {
    _ambientPlayer.dispose();
    _tickPlayer.dispose();
    _endPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});
