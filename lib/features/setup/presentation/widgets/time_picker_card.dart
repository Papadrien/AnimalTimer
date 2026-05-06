import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/localization_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/setup_provider.dart';

class TimePickerCard extends ConsumerWidget {
  /// Conservé pour compat. API, mais la carte garde toujours un fond clair
  /// identique entre tous les thèmes d'animaux (requin compris).
  final bool isDark;
  const TimePickerCard({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    // Thème fixe (clair) pour la roue de sélection du temps, indépendant de
    // l'animal sélectionné — demandé : le requin ne doit pas changer ce fond.
    const borderColor = AppColors.pencilDark;
    final bgColor = AppColors.paperLight.withValues(alpha: 0.8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2.5),
      ),
      child: Row(
        children: [
          _Col(value: setup.hours, label: context.l10n.hours, color: AppColors.crayonBlue,
            max: 23, step: 1, isDark: isDark,
            onChanged: ref.read(setupProvider.notifier).setHours),
          const SizedBox(width: 8),
          _Col(value: setup.minutes, label: context.l10n.minutes, color: AppColors.crayonOrange,
            max: 59, step: 1, isDark: isDark,
            onChanged: ref.read(setupProvider.notifier).setMinutes),
          const SizedBox(width: 8),
          _Col(value: setup.seconds, label: context.l10n.seconds, color: AppColors.crayonRed,
            max: 59, step: 5, isDark: isDark,
            onChanged: ref.read(setupProvider.notifier).setSeconds),
        ],
      ),
    );
  }
}

class _Col extends StatefulWidget {
  final int value;
  final String label;
  final Color color;
  final int max;
  final int step;
  final bool isDark;
  final ValueChanged<int> onChanged;
  const _Col({required this.value, required this.label,
    required this.color, required this.max, required this.step,
    required this.onChanged, this.isDark = false});
  @override
  State<_Col> createState() => _ColState();
}

class _ColState extends State<_Col> {
  late FixedExtentScrollController _ctrl;
  bool _userScrolling = false;

  int _valueToIndex(int value) {
    if (widget.step <= 1) return value;
    return (value ~/ widget.step).clamp(0, _itemCount - 1);
  }

  int get _itemCount => widget.step <= 1 ? widget.max + 1 : (widget.max ~/ widget.step) + 1;

  @override
  void initState() {
    super.initState();
    _ctrl = FixedExtentScrollController(initialItem: _valueToIndex(widget.value));
  }

  @override
  void didUpdateWidget(_Col old) {
    super.didUpdateWidget(old);
    if (!_userScrolling && old.value != widget.value && _ctrl.hasClients) {
      _ctrl.jumpToItem(_valueToIndex(widget.value));
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // Fond/pick bordure fixés en clair : indépendant du thème de l'animal.
    const pickerBorder = AppColors.pencilDark;
    const pickerBg = Colors.white;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 160,
            decoration: BoxDecoration(
              color: pickerBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: pickerBorder, width: 2),
            ),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notif) {
                if (notif is ScrollStartNotification) {
                  _userScrolling = true;
                } else if (notif is ScrollEndNotification) {
                  _userScrolling = false;
                }
                return true;
              },
              child: CupertinoPicker.builder(
                scrollController: _ctrl,
                itemExtent: 52,
                diameterRatio: 1.2,
                squeeze: 1.0,
                useMagnifier: true,
                magnification: 1.15,
                backgroundColor: Colors.transparent,
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: widget.color.withValues(alpha: 0.25),
                        width: 1.5)),
                  ),
                ),
                onSelectedItemChanged: (index) {
                  final realValue = index * widget.step;
                  widget.onChanged(realValue);
                },
                childCount: _itemCount,
                itemBuilder: (context, index) {
                  final displayValue = index * widget.step;
                  final isSelected = displayValue == widget.value;
                  return Center(child: Text(
                    '$displayValue',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? widget.color
                          : AppColors.pencilFaint,
                    ),
                  ));
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 13,
              fontWeight: FontWeight.w700,
              color: widget.color,
              letterSpacing: 0.5,
            ),
            child: Text(widget.label),
          ),
        ],
      ),
    );
  }
}
