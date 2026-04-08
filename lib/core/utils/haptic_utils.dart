import 'package:flutter/services.dart';

class HapticUtils {
  HapticUtils._();
  static void light()  => HapticFeedback.lightImpact();
  static void medium() => HapticFeedback.mediumImpact();
  static void heavy()  => HapticFeedback.heavyImpact();
  static void select() => HapticFeedback.selectionClick();
}
