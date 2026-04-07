import 'package:flutter/material.dart';

class AnimalModel {
  final String id;
  final String name;
  final String emoji;
  final String lottiePath;
  final String idleLottiePath;
  final String ambientAudioPath;
  final String endSoundPath;
  final LinearGradient setupGradient;
  final LinearGradient timerGradient;
  final Color primaryColor;
  final Color secondaryColor;

  const AnimalModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.lottiePath,
    required this.idleLottiePath,
    required this.ambientAudioPath,
    required this.endSoundPath,
    required this.setupGradient,
    required this.timerGradient,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      lottiePath: json['lottie_path'],
      idleLottiePath: json['idle_lottie_path'],
      ambientAudioPath: json['ambient_audio_path'],
      endSoundPath: json['end_sound_path'],
      setupGradient: _parseGradient(json['setup_gradient']),
      timerGradient: _parseGradient(json['timer_gradient']),
      primaryColor: Color(json['primary_color']),
      secondaryColor: Color(json['secondary_color']),
    );
  }

  static LinearGradient _parseGradient(List<dynamic> colors) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors.map((c) => Color(c as int)).toList(),
    );
  }
}
