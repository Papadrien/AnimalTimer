// lib/features/timer/presentation/widgets/time_picker_widget.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'glass_card.dart';

/// Sélecteur de durée hh : mm : ss — style colonnes scroll iOS.
class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    required this.initialDuration,
    required this.onChanged,
  });

  final Duration              initialDuration;
  final ValueChanged<Duration> onChanged;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late int _h, _m, _s;
  late FixedExtentScrollController _hCtrl, _mCtrl, _sCtrl;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDuration;
    _h = d.inHours.clamp(0, 23);
    _m = (d.inMinutes  % 60).clamp(0, 59);
    _s = (d.inSeconds  % 60).clamp(0, 59);
    _hCtrl = FixedExtentScrollController(initialItem: _h);
    _mCtrl = FixedExtentScrollController(initialItem: _m);
    _sCtrl = FixedExtentScrollController(initialItem: _s);
  }

  @override
  void dispose() {
    _hCtrl.dispose(); _mCtrl.dispose(); _sCtrl.dispose();
    super.dispose();
  }

  void _notify() =>
      widget.onChanged(Duration(hours: _h, minutes: _m, seconds: _s));

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Col(ctrl: _hCtrl, max: 23, label: 'h',   onChanged: (v) { _h = v; _notify(); }),
          _Sep(),
          _Col(ctrl: _mCtrl, max: 59, label: 'min', onChanged: (v) { _m = v; _notify(); }),
          _Sep(),
          _Col(ctrl: _sCtrl, max: 59, label: 'sec', onChanged: (v) { _s = v; _notify(); }),
        ],
      ),
    );
  }
}

// ── Colonne ──────────────────────────────────────────────────────────────────

class _Col extends StatelessWidget {
  const _Col({
    required this.ctrl,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  final FixedExtentScrollController ctrl;
  final int                         max;
  final String                      label;
  final ValueChanged<int>           onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize:    11,
            fontWeight:  FontWeight.w700,
            fontFamily:  'Nunito',
            color:       AppColors.textLight,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 130, width: 62,
          child: CupertinoPicker(
            scrollController: ctrl,
            itemExtent: 42,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: AppColors.duckSecondary.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            onSelectedItemChanged: onChanged,
            children: List.generate(
              max + 1,
              (i) => Center(
                child: Text(
                  i.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize:   28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito',
                    color:      AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(top: 18, left: 2, right: 2),
        child: Text(
          ':',
          style: TextStyle(
            fontSize:   28,
            fontWeight: FontWeight.w800,
            fontFamily: 'Nunito',
            color:      AppColors.textMedium,
          ),
        ),
      );
}
