// lib/features/timer/presentation/widgets/start_button.dart

import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../../../../core/constants/app_constants.dart';

/// Gros bouton rond "Démarrer" avec animation scale + haptic.
class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
    required this.onPressed,
    required this.gradient,
    this.label   = 'Démarrer',
    this.enabled = true,
  });

  final VoidCallback    onPressed;
  final LinearGradient  gradient;
  final String          label;
  final bool            enabled;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!widget.enabled) return;
    await HapticFeedback.mediumImpact();
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: AnimatedOpacity(
          opacity:  widget.enabled ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width:  AppConstants.startButtonSize,
            height: AppConstants.startButtonSize,
            decoration: BoxDecoration(
              shape:    BoxShape.circle,
              gradient: widget.gradient,
              boxShadow: [
                BoxShadow(
                  color:       widget.gradient.colors.last.withOpacity(0.45),
                  blurRadius:  28,
                  offset:      const Offset(0, 10),
                  spreadRadius: -6,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:       Colors.white,
                  fontSize:    19,
                  fontWeight:  FontWeight.w800,
                  fontFamily:  'Nunito',
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
