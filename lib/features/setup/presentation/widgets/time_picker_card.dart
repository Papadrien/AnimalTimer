import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glassmorphic_card.dart';
import '../../providers/setup_provider.dart';

class TimePickerCard extends ConsumerWidget {
  const TimePickerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    return GlassmorphicCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TimeColumn(value: setup.hours, unit: 'h', maxValue: 23,
            onChanged: ref.read(setupProvider.notifier).setHours),
          const SizedBox(width: 8),
          _TimeColumn(value: setup.minutes, unit: 'm', maxValue: 59,
            onChanged: ref.read(setupProvider.notifier).setMinutes),
          const SizedBox(width: 8),
          _TimeColumn(value: setup.seconds, unit: 's', maxValue: 59,
            onChanged: ref.read(setupProvider.notifier).setSeconds),
        ],
      ),
    );
  }
}

class _TimeColumn extends StatefulWidget {
  final int value;
  final String unit;
  final int maxValue;
  final ValueChanged<int> onChanged;
  const _TimeColumn({required this.value, required this.unit,
    required this.maxValue, required this.onChanged});
  @override
  State<_TimeColumn> createState() => _TimeColumnState();
}

class _TimeColumnState extends State<_TimeColumn> {
  late FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = FixedExtentScrollController(initialItem: widget.value);
  }

  @override
  void didUpdateWidget(_TimeColumn old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _ctrl.animateToItem(widget.value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 90, height: 120,
          child: ListWheelScrollView.useDelegate(
            controller: _ctrl,
            itemExtent: 80,
            perspective: 0.003,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: widget.onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.maxValue + 1,
              builder: (context, index) {
                final selected = index == widget.value;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTextStyles.timePickerLarge.copyWith(
                      fontSize: selected ? 72 : 48,
                      color: selected ? Colors.white : Colors.white.withOpacity(0.3)),
                    child: Text('$index'),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(widget.unit, style: AppTextStyles.timePickerUnit),
        ),
      ],
    );
  }
}
