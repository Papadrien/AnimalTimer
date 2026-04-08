import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/setup_provider.dart';

class TimePickerCard extends ConsumerWidget {
  const TimePickerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.paperLight.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.pencilDark.withOpacity(0.15), width: 1.5),
      ),
      child: Row(
        children: [
          _Col(value: setup.hours, label: 'Heures', color: AppColors.crayonBlue,
            max: 23, onChanged: ref.read(setupProvider.notifier).setHours),
          const SizedBox(width: 8),
          _Col(value: setup.minutes, label: 'Minutes', color: AppColors.crayonOrange,
            max: 59, onChanged: ref.read(setupProvider.notifier).setMinutes),
          const SizedBox(width: 8),
          _Col(value: setup.seconds, label: 'Secondes', color: AppColors.crayonRed,
            max: 59, onChanged: ref.read(setupProvider.notifier).setSeconds),
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
  final ValueChanged<int> onChanged;
  const _Col({required this.value, required this.label,
    required this.color, required this.max, required this.onChanged});
  @override
  State<_Col> createState() => _ColState();
}

class _ColState extends State<_Col> {
  late FixedExtentScrollController _ctrl;
  bool _userScrolling = false;

  @override
  void initState() {
    super.initState();
    _ctrl = FixedExtentScrollController(initialItem: widget.value);
  }

  @override
  void didUpdateWidget(_Col old) {
    super.didUpdateWidget(old);
    // Only programmatically jump if user is NOT actively scrolling
    // (e.g. when loading a preset from recents)
    if (!_userScrolling && old.value != widget.value && _ctrl.hasClients) {
      _ctrl.jumpToItem(widget.value);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.color.withOpacity(0.4), width: 2),
            ),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notif) {
                if (notif is ScrollStartNotification) {
                  _userScrolling = true;
                } else if (notif is ScrollEndNotification) {
                  _userScrolling = false;
                }
                // Return true to stop propagation to parent
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
                        color: widget.color.withOpacity(0.25),
                        width: 1.5)),
                  ),
                ),
                onSelectedItemChanged: widget.onChanged,
                childCount: widget.max + 1,
                itemBuilder: (context, index) {
                  return Center(child: Text(
                    '$index',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: index == widget.value
                          ? widget.color
                          : AppColors.pencilFaint,
                    ),
                  ));
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(widget.label, style: TextStyle(
            fontFamily: 'Nunito', fontSize: 13,
            fontWeight: FontWeight.w700,
            color: widget.color, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
