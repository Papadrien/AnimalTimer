import 'package:flutter/material.dart';

class AnimalModel {
  final String id;
  final String name;
  final String emoji;
  final String svgAsset;
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
    required this.svgAsset,
    required this.ambientAudioPath,
    required this.endSoundPath,
    required this.setupGradient,
    required this.timerGradient,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
